# Jenkins pipeline to build and push Docker image on DockerHub

#### in progress... (ci saranno ulteriori step x il deploy con Helm e K8s)

**Per il setup iniziale di Vagrant, Ansible, Docker e i due Jenkins node (master e slave) fare riferimento a [Setup iniziale di Vagrant, Ansible, Docker e Jenkins node](https://github.com/Martybb01/formazione_sou/tree/4e9d75bbfd24366d9d26f2ae1b69b90c7c216248/setup_vagrant%2Bdocker%2Bansible)


## Step 2 - Pipeline Jenkins dichiarativa (Groovy) per build immagine Docker
##### **obiettivo**: Scrivere pipeline dichiarativa Jenkins che effettui una build dell'immagine Docker e che effettui il push sul proprio account DockerHub. Il tag dell'immagine Docker deve essere uguale al tag git se "buildata" da tag git, latest se "buildata" da branch master, uguale  a "develop + sha comit GIT" se "buildata" da branch develop.

Inanzitutto ho creato una Dockerfile per una semplice app in Flask che espone una pagina con la classica stringa 'Hello, World!'.
L'obiettivo è proprio quello di scrivere una pipeline dichiarativa Jenkins per buildare l'immagine dell'app e pusharla sul proprio account DockerHub.

### Modifiche al playbook ansible
Ho aggiunto due mount al container jenkins-slave:
* `/var/run/docker.sock:/var/run/docker.sock` --> permette al container di accedere al Docker daemon dell’host ed è quindi il collegamento fondamentale per eseguire comandi Docker dal container.
* `/usr/bin/docker:/usr/bin/docker` -->  permette al container di accedere al comando Docker dell'host, quindi senza necessità di installarlo direttamente dentro.

Inoltre, ho implementato una nuova task che aggiunge l'utente jenkins al gruppo docker nel jenkins-slave per far si che possa eseguire comandi Docker nella pipeline senza problemi.

### Step lato jenkins:
* Aggiunte le credenziali DockerHub (global) su Jenkins accedendo da web browser (http://localhost:8081)
* Configurato la pipeline come multibranch pipeline affinchè rilevi automaticamente i branch presenti nella repo. Particolarmente utile nel mio caso per usare le variabili d'ambiente `env.GIT_BRANCH` e `env.GIT_COMMIT`per impostare dinamicamente i tag Docker.
* Installato il plugin **Docker pipeline** per poter usare i metodi `docker.build` e `docker.withRegistry`
