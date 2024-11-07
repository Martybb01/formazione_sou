# Docker and namespaces

##### **Obiettivo:** Riuscire a lanciare un processo con lo stesso namespace di un container e visualizzare tale processo con una ps dentro al container. 

1. Creare Dockerfile per buildare l'immagine --> `docker built -t my-nginx-img .`

2. Runnare il container con le flag -d e -p per il mapping delle porte --> `docker run -d -p 8080:80 --name my-nginx-cntr my-nginx-img`

3. Ottenere il PID del container --> `docker inspect my-nginx-cntr | grep Pid`

4. Lanciare un altro container con nsenter che si agganci a tutti i namespace del container nginx -->
	`docker run -v /:/host --pid=host --privileged --rm -it jpetazzo/nsenter nsenter --target $PID --mount --uts --ipc --net --pid -- /bin/sh`
	* Spiegazione del comando:
		* `/:/host --pid=host` servono per simulare l'ambiente dell'host all'interno del container (nsenter non disponibile per MacOS)
		* `--privileged` concede al container privilegi necessari per agganciarsi ai namespace del processo di destinazione
		* `jpetazzo/nsenter` è l'immagine Docker che ho usato che contiene il comando nsenter
		* `--target $PID` specifica il PID del processo di destinazione, ossia il processo principale del container con nginx
		* `--mount --uts --ipc --net --pid` sono flag per aggiungere i namespaces al processo target
		* `-- /bin/sh` esegue la shell sh all'interno del container e quindi di fatto avvia un processo

5. Lanciare un altro processo dall'interno del container host (non necessario I know) -->
	`sleep 600 &`

6. Verificare dal container con nginx che il processo sia visibile -->
	`docker exec -it my-nginx-cntr ps aux`

![alt text](image.png)

* **Il PID del processo lanciato è uguale o diverso tra dentro e fuori il  container?**
		Come visibile dall'immagine sopra, il PID del processo lanciato (sleep 600) è lo stesso perchè nsenter si aggancia al namespace
		dei PID del container target (my-nginx-cntr) e dunque il processo è come se fosse eseguito da lì.
		Inoltre anche il processo /bin/sh eseguito dal container host è visibile ed ha lo stesso PID sul container target.

* **Cosa succede se si prova a stoppare il container mentre il processo creato è ancora attivo?**
		Se stoppo il container target a processo attivo, questo viene terminato poichè Docker gestisce i namespace del container e dunque fermandolo,
		libera e termina anche i suoi namespaces, così come tutti i processi associati, inclusi quelli avviati con nsenter (quindi /bin/sh e sleep 600).

* **Cosa succede se si prova a killare il processo da dentro il container?**
		Se killo il processo dal container target questo viene terminato poichè kill invia un segnale al processo attivo nel namespace dei PID del container target, e dunque effettivamente uccide il processo.

----------------------------------------------------------------------------------------------------------------------------------------

## Alternativa 2: Usare VM linux dove è presente nativamente nsenter

Per l'esercizio ho usato una VM con Ubuntu 20.4 installata tramite Multipass

1. Installare docker all'interno della VM -->
```
sudo apt-update
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

sudo apt update
sudo apt install -y docker-ce

sudo systemctl start docker
sudo systemctl enable docker
```

2. Usare il Dockerfile per buildare l'immagine --> ` docker build -t my-nginx.img . `

3. Runnare il container Docker --> ` docker run -d -p 8080:80 --name my-nginx-cntr my-nginx-img `

4. Ottenere il PID del container --> ` docker inspect my-nginx-cntr | grep Pid `

5. Usare nsenter per agganciarsi ai namespace del container e lanciare un processo --> ` sudo nsenter --target $TARGET_PID --mount --uts --ipc --net --pid -- sleep 600 & `

6. Verificare dal container il processo --> ` sudo docker exec -it my-nginx-cntr ps aux `

7. Risultati:
```
ubuntu@sleek-wombat:~$ ps aux | grep sleep
root       46926  0.0  0.0   1604     4 pts/0    S    11:52   0:00 sleep 600

ubuntu@sleek-wombat:~$ sudo docker exec -it my-nginx-cntr ps aux
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root           1  0.0  0.5   9436  5128 ?        Ss   11:40   0:00 nginx: master process nginx -g daemon off;
nginx         29  0.0  0.2   9900  1948 ?        S    11:40   0:00 nginx: worker process
root          64  0.0  0.0   1604     4 pts/0    S+   11:52   0:00 sleep 600
root          70 66.6  0.1   2500  1736 pts/0    Rs+  11:55   0:00 ps aux
```

* **Il PID del processo lanciato è uguale o diverso tra dentro e fuori il  container?** Effettivamente, eseguendo `ps aux` sulla VM host e nel container, i PID differiscono.
Questo perchè Docker isola i processi dei container nel proprio namespace dei PID quindi all'interno del container i PID sono relativi al namespace del container stesso, non all’host. 
Il processo sleep lanciato tramite nsenter condivide il namespace del container, quindi appare con un PID all'interno del container e con un altro PID relativo sul sistema host (VM).

* **Cosa succede se si prova a stoppare il container mentre il processo creato è ancora attivo?** Se il container Docker viene stoppato a processo attivo, questo verrà terminato
perchè quando Docker termina un container, chiude i suoi namespace terminando tutti i processi e dunque dato che il processo sleep esiste nel namespace dei PID del container, verrà killato allo stop del container.

* **Cosa succede se si prova a killare il processo da dentro il container?** Non è possibile killare il processo creato con nsenter da dentro il container target poichè esiste nel namespace dei PID della VM e non è realmente un processo interno al container. Infatti il processo viene eseguito nel namespace della VM e viene agganciato ai namespace del container target e quindi appare come se fosse nel container, ma in verità appartiene al namespace dell'host.

----------------------------------------------------------------------------------------------------------------------------------------
## About Namespaces

I namespaces sono una feature del kernel di Linux che consente di restringere la visibilità di un processo a le varie risorse di sistema.
*Esistono diversi tipi di namespace per ogni tipologia di risorsa:*
* pid: processi
* mnt: mountpoint
* net: interfacce di rete
* user: utenti
* ipc: shared memory e interprocess communication
* time: clock di sistema

I namespaces associati ai vari processi vengono esposti dal kernel attraverso il filesystem /proc `(/proc/<pid>/ns/)`.
