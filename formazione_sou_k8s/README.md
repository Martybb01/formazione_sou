# Jenkins pipeline to build and push Docker image on DockerHub

#### in progress... (ci saranno ulteriori step x il deploy con Helm e K8s)

**Per il setup iniziale di Vagrant, Ansible, Docker e i due Jenkins node (master e slave) fare riferimento a [Setup iniziale di Vagrant, Ansible, Docker e Jenkins node](https://github.com/Martybb01/formazione_sou/tree/4e9d75bbfd24366d9d26f2ae1b69b90c7c216248/setup_vagrant%2Bdocker%2Bansible)


## Step 2 - Pipeline Jenkins dichiarativa (Groovy) per build immagine Docker
##### **Obiettivo**: Scrivere pipeline dichiarativa Jenkins che effettui una build dell'immagine Docker e che effettui il push sul proprio account DockerHub. Il tag dell'immagine Docker deve essere uguale al tag git se "buildata" da tag git, latest se "buildata" da branch master, uguale  a "develop + sha comit GIT" se "buildata" da branch develop.

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

## Step 3 - Helm Chart custom
##### **Obiettivo:** creare un Helm chart custom che effettui il deploy dell'immagine creata tramite la pipeline flask-app-example-build (in input deve essere possibile specificare quale tag rilasciare)

**Helm è un tool per gestire pacchetti Kubernetes, chiamati charts**

Per il deploy con Helm ho creato prima di tutto la subdir charts tramite il comando `helm create charts`, pulendola poi da vari file e folder che vengono inizializzati di default ma non necessari nel mio caso.
* `values.yaml` --> contiene le configurazioni di default che possono essere personalizzate al momento del deploy dell'Helm chart. In particolare definisce l'immagine Docker, le configurazioni delle risorse e i dettagli delle probe di liveness e readiness.
* `deployment.yaml` --> utilizza i valori definiti in values.yaml per creare un deployment Kubernetes.
* `service.yaml` --> definisce un oggetto di tipo Service in Kubernetes che serve per esporre i pods al traffico interno del cluster. Per adesso è configurato come ClusterIP, ciò significa che il servizio è raggiungibile solo all'interno del cluster (modificabile in futuro x permettere accesso esterno).

## Step 4 - Setup K8s and Helm install
#### **Obiettivo:** Scrivere pipeline dichiarativa Jenkins che prenda da GIT il repo chart versionato in "formazione_sou/formazione_sou_k8s" ed effettui "helm install" sull'instanza K8s locale su namespace "formazione-sou".

