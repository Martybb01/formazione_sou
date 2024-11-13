# Ansible: Liste e Dictionaries

#### **OBIETTIVO**: Creare un Playbook ansible che installi/disinstalli una lista di pacchetti in base a quanto definito in un apposito dictionary. Inoltre creare un Playbook ansible che crei una lista di utenti usando le specifiche contenute in una lista di dictionary (ad es. gruppo, home dir, shell etc...)

* `install_pkgs_playbook.yml` --> questo playbook definisce un dictionary *(packages)* che contiene due chiavi: install e uninstall, ognuna con una lista di pacchetti. Il primo task itera sulla lista dei pacchetti da installare mentre il secondo itera sulla lista dei pacchetti da disinstallare. 

* `create_users_playbook.yml` --> questo playbook configura una lista di utenti basandosi su una lista di dictionary *(users)*, dove ciascun dictionary rappresenta un utente con le sue info. Il primo task itera sulla lista users assicurandosi che siano presenti i gruppi specificati, altrimenti li crea. Il secondo task itera sempre su users creando e configurando un account per ogni utente definito.

La variabile ***item*** viene definita implicitamente quando si usa il modulo `loop`. Quindi ogni volta che il loop itera sugli elementi di una lista (es. install), item assume il valore dell'elemento corrente, e `item.` è il modo per accedere al valore associato a quella chiave nel dictionary.
La clausola ***when*** è una condizione che determina se un certo task debba essere eseguito o meno, per evitare errori di esecuzione.

#### Test the project:
`vagrant up --provision` per startare la VM e runnare i playbook.

----------------------------------------------------------------------------------------------------------------------------------------

## About lists and dictionaries
I playbook Ansible sono in grado di manipolare strutture dati complesse come liste o dizionari.

*Esempio di lista*:
```
vars:
	fruits:
		- banana
		- apple
		- watermelon
```
*I dizionari invece sono un'insieme di coppie chiave-valore*:
```
vars:
	fruits:
		banana: yellow
		apple: red
		watermelon: green
```
*Possiamo anche combinare diverse strutture di dati (es. lista di dizionari)*:
```
vars:
	fruits:
		- name: banana
		  color: yellow
		  price: 2
		- name: apple
		  color: red
		  price: 1
		- name: watermelon
		  color: green
		  price: 3
```
