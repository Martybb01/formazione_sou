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
