# Vagrant, Docker, Ansible and Jenkins Setup

##### **Obiettivo:** Tramite Ansible, installare e configurare sulla VM Rocky, Docker con un Docker network e Jenkins (Master e slave)

### Step 1 - Creare VM con vagrant e installare Docker tramite Ansible
Nel Vagrantfile usare come provisioner Ansible specificando il file di configurazione, il playbook e il file che contiene la password per accedere al Vault (no Github upload).
Nel playbook runno una serie di task per installare i pacchetti necessari, configurare la repo di Docker e installarlo. Poi un task per farlo partire e un'altro per aggiungere l'utente vagrant al gruppo Docker, per eseguire i comandi senza sudo.
Per entrare nella VM --> `vagrant ssh` oppure `ssh vagrant@192.168.10.11`

### Step 2 - Configurare un Docker network tramite Ansible
Per il network ho usato il modulo Docker fornito da ansible (`community.docker.docker_network`).
Per verificare che sia stato correttamente creato entrare dentro la VM --> `docker network ls` e `docker inspect my_network`

### Step 3 - Installazione di Jenkins (master) in container Docker tramite Ansible, con assegnazione IP statica
Ho usato il modulo `community.docker.docker_container` per creare un container Docker con Jenkins master specificando il network (my_network) e l'IP statico.
Per concludere la configurazione di Jenkins è necessario entrare nella UI sul browser e autenticarsi, quindi per recuperare la password, entrare nella VM e runnare il comando --> `docker exec jenkins-master cat /var/jenkins_home/secrets/initialAdminPassword`

### Step 4 - Installazione di un Jenkins slave in container Docker tramite Ansible, che si collega al master
Per lo slave, è molto importante che sia nello stesso network del master.
Inoltre specifico alcune variabili d'ambiente, tra cui:
* JENKINS_URL --> specifica l'URL del master a cui lo slave deve connettersi
* JENKINS_SECRET --> usata per autenticare lo slave con il master:
	* Da Jenkins UI su browser creare un nuovo nodo (agent)
	* Durante il processo di creazione, verrà fornito un token segreto, appunto il jenkins_agent_secret, che permette allo slave di registrarsi e connettersi con il master
	* Ho usato Ansible Vault per criptare la variabile --> `ansible-vault create main.yml`
	* Nel playbook aggiungo la direttiva per il file criptato --> `vars_files: vars/main.yml`

Per verificare che lo slave si colleghi correttamente al master:
```
docker exec -it jenkins-slave /bin/bash
curl http://192.168.100.42:8080
```
