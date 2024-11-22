# Track 3 - Configuration management

L'intero modulo è eseguito su Workstation Mac Intel equipaggiata con Docker e Ansible.

## Step 1 - Set up Docker registry
#### **Obiettivo:** Creare un playbook che configuri un Docker registry

Per questo progetto ho deciso di setuppare tramite *ansible tasks* un **Private Docker registry**, accessibile via <http://localhost:5000/v2/>. 
Quindi dopo essermi assicurata che Docker sia presente sulla macchina e sia in esecuzione, pullo l'immagine del registry direttamente da Docker [registry](https://hub.docker.com/_/registry), creo un nuovo volume per assicurare la persistenza dei dati nel registry e avvio il nuovo container.

### Come interagire con l'API, principali endpoint:
```
curl http://localhost:5000/v2/ --> Verifica lo stato del registry
curl http://localhost:5000/v2/_catalog --> Elenca tutte le repo
curl http://localhost:5000/v2/<repo_name>/tags/list --> Elenca i tag di una repo
curl http://localhost:5000/v2/<repo_name>/manifests/<tag> --> Recupera il manifest di un'immagine
curl http://localhost:5000/v2/<repo_name>/manifests/digest --> Cancella un'immagine
```

## Step 2 - Creare build di container
#### **Obiettivo:** creare dei playbooks che facciano le build di due container con OS differenti e con le seguenti caratteristiche: essere sempre in ascolto sulla porta 22 del container; Avere attivo il servizio ssh; Avere un utente abilitato a collegarsi tramite ssh key e poter fare sudo.

Per gestire le build dei container ho configurato due ansible tasks all'interno di `build-playbook.yml` per ciascun OS **(alpine e rocky)** --> un task per buildare l'immagine da Dockerfile e un task per runnare il container con l'immagine appena creata

### Dockerfile content
* Installa *ssh* per consentire l'accesso remoto e *sudo* per fornire privilegi d'amministrazione all'utente
* Crea la dir `/var/run/sshd` che è necessaria per avviare SSH e setta i permessi
* Crea l'utente *genuser* e la sua homedir, imposta la shell e la password e lo aggiunge al file `sudoers` per usare sudo senza password
* Genera le chiavi host SSH con `ssh-keygen -A`
* Copia la chiave pubblica generata localmente con `ssh-keygen -t rsa -b 4096 -C "genuser@example.com" -f ./id_key_genuser` per consentire l'autenticazione tramite chiave pubblica e setta i permessi
* **Configura l'ssh** --> disabilita il login come root e l'autenticazione tramite password, abilita l'autenticazione tramite public key e limita l'accesso SSH a *genuser*
* Espone la *porta 22* per consentire connessioni esterne
* Configura il container per avviare SSH in modalità daemon al lancio
