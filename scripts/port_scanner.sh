#!/bin/bash

if [ $# -ne 2 ]; then
	echo "Usage: $0 <ip> <port_range>"
	exit 1
fi

IP=$1
PORT_RANGE=$2

START_PORT=$(echo $PORT_RANGE | cut -d'-' -f1)
END_PORT=$(echo $PORT_RANGE | cut -d'-' -f2)

for port in $(seq $START_PORT $END_PORT); do
	result=$(nc -v -w 1 $IP $port 2>&1)

	if echo "$result" | grep -q "open"; then
		service=$(echo $result | awk -F '[()]' '{print $4}' || echo "Unknown")
		echo "Port $port is open on $IP (Service: $service)"
	fi
done
echo "Scan completed!"
exit 0


# -----------Spiegazione-----------
# Script di port scanning che accetta due argomenti: un indirizzo IP e un intervallo di porte.
# Ciclo for che esegue il comando nc per ogni porta nell'intervallo specificato dall'utente.
# parametri di nc: -v (verbose), -w 1 (timeout di 1 secondo).
# Il risultato di nc viene memorizzato nella variabile result, così da poter controllare se la porta è "open".
# awk viene utilizzato per estrarre il nome del servizio dall'output di nc, dividendo la riga in base ai caratteri '()'.
# Se la porta è aperta, viene stampato un messaggio con il numero di porta e il servizio corrispondente.
