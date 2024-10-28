# Vagrant Project: ping_pong

Questo progetto Vagrant configura due nodi Linux con Docker installato, ognuno dei quali runna un container `echo-server` usando l'immagine Docker `ealen/echo-server`.
I nodi si alternano nell'esecuzione dell'echo-server ogni 60 sec, garantendo che sia attivo un solo nodo alla volta.

## Project Structure

- `Vagrantfile`: Configura le due VMs (`node1` and `node2`), assegna a ognuna un indirizzo IP unico ed effettua il provisioning di ciascun nodo con Docker.
- `setup.sh`: Rimuove l'echo-server esistente e configura un cron job per alternare l'echo-server ogni minuto.
- `rotate_echo.sh`: Script che controlla il timing e determina quale nodo deve runnare il container con l'echo-server

## Requirements

- **Vagrant**: Assicurati di avere Vagrant installato 
- **VirtualBox**: Questo progetto usa VirtualBox come provider

## Setup and Usage

### 1. Clona la repository ed entra nella cartella del progetto
```bash
git clone <repository-url>
cd <repository-directory> 
```
### 2. Avvia le VM
```bash
vagrant up
```
### 3. Verifica chi sta runnando il container
```bash
docker ps
sul nodo1 --> curl http://192.168.56.10:8080
sul nodo2 --> curl http://192.168.56.11:8080
```
### 4. Stoppa e distruggi le VM
```bash
vagrant halt
vagrant destroy -f
```
