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

### Installazione k3s su VM:
* Installazione K3s tramite Ansible task --> distribuzione Kubernetes più leggera e perfetta per il mio scopo.
* Tasks ansible per: 
	* Creare la directory `.kube` nella home dell'utente vagrant
	* Copiare dentro la directory creata il kubeconfig di k3s, che contiene tutte le info necessarie per connettersi al cluster Kubernetes 
	* Settare la variabile d'ambiente `KUBECONFIG` di modo che il comando kubectl punti al cluster corretto
* Creazione del namespace *formazione-sou* all'interno del cluster se non esiste già

### Intallazione Helm su jenkins-master:
Ho installato Helm sul nodo jenkins-master tramite Binary release e per farlo ho configurato tre tasks: 
* **1° task** --> esegue il download del pacchetto tar di Helm 
* **2° task** --> estrae il binary di Helm dal file `helm.tar.gz` direttamente nella directory `/var/jenkins_home` 
* **3° task** --> sposta il binary all'interno di `/usr/local/bin` e lo rende eseguibile

### Configurare ambiente Jenkins affinchè interagisca con il cluster K8s:
Ho creato 3 tasks ansible per garantire che Jenkins abbia le configurazioni necessarie per gestire le risorse Kubernetes:
* **1° task** --> crea la directory `.kube` all'interno della home di jenkins-master
* **2° task** --> modifica il file kubeconfig per puntare all'IP corretto del server API di kubernetes. Di default infatti è localhost (127.0.0.1), ma questo non è raggiungibile dal container jenkins a causa dell'isolamento di rete di Docker
* **3° task** --> copia il file kubeconfig nella directory creata al 1° task per permettere a Jenkins di usare `kubectl` per interagire con il cluster

### Pipeline (Jenkinsfile.deploy)
Da web browser ho configurato una nuova multibranch pipeline in modo analogo alla prima specificando come script path il Jenkinsfile di deploy --> disinstalla precedenti versioni deployate dell'app ed effettua un `helm install` con la possibilità di specificare dinamicamente quale versione dell'app deployare in base al tag Docker dell'immagine.

## Step 5 - Check Deployment Best Practices
#### **Obiettivo:** Scrivere script Bash o Python che effettui le seguenti operazioni: Autenticandosi tramite un Service Account di tipo "cluster-reader" esegua un export del Deployment dell'applicazione Flask installata. E' possibile scegliere tra: utilizzo API k8s, wrapping di curl. L'automatismo deve ritornare un errore se non presenti nel Deployment i seguenti attributi: Readiness e Liveness Probles, Limits e Requests

### Helm chart x ServiceAccount
Prima di tutto ho creato un nuovo Helm Chart `serviceaccount.yaml` che definisce una configurazione per creare un ServiceAccount chiamato *cluster-reader* che servirà come identità per accedere alle risorse del cluster -->
* Il ServiceAccount è limitato ai permessi di lettura (watch, get, list) per le risorse specificate all'interno del namespace *formazione-sou* grazie alla definizione di un **Role**.
* Tale Role viene associato al ServiceAccount tramite un **RoleBinding** che consente al ServiceAccount di usare i permessi definiti dal Role all'interno del namespace.
* Viene creato un Secret (*cluster-reader-token*) in cui verrà salvato un token di autenticazione generato da Kubernetes che verrà usato dal ServiceAccount per autenticarsi al cluster e al server API Kubernetes, rispettando i permessi RBAC definiti sopra.

### Bash script
Lo script in Bash automatizza l'esportazione e la validazione di un deployment Kubernetes:
* Estrae il token dal Secret creato in precedenza e recupera l'indirizzo del server API e il certificato di autorità, fondamentali per stabilire una connessione sicura e autorizzata al server API:
	* Il *TOKEN* viene incluso nell'header della richiesta HTTP per dimostrare che il ServiceAccount ha i permessi definiti in RBAC.
	* Il *CA_CERT* verifica che la connessione al server API sia sicura e che il certificato sia autentico
	* Il *SERVER_API* garantisce che la richiesta venga inviata al server corretto
* Usa `kubectl wait` per verificare che il deployment dell'app nel namespace diventi disponibile entro un tempo limite (40s).
* Ottiene il manifest YAML del deployment dell'app con `kubectl get deployment` e lo salva localmente sulla VM.
* Controlla che il manifest esportato contenga gli attributi richiesti, altrimenti ritorna errore ed esce

### Integrazione con Jenkins pipeline
Per consentire che la pipeline abbia successo, come operazioni preliminari ho caricato lo script Bash sull VM da cui verrà eseguito e, dopo aver fatto la stessa cosa anche con la ssh_private_key, ho creato due tasks ansible per copiarla nel nodo Jenkins e settare i permessi.
Infine ho creato un nuovo stage **export deployment** nella pipeline che utilizza `ssh` per collegarsi al server remoto (VM vagrant) e, autenticandosi come utente *vagrant* grazie alla chiave privata, rende eseguibile ed esegue lo script *export-deployment.sh*.

## Step 6 - BONUS ingress
#### **Obiettivo:** Equipaggiare l'istanza Kubernetes di un Ingress Controller Nginx. Fare in modo che l'Helm Chart installi anche l'ingress nginx e fare in modo che, chiamando via http http://formazionesou.local, si ottenga quanto esposto dall'applicazione Flask creata nei punti precedenti.
