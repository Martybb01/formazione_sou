#!/bin/bash

if [ $# -ne 2 ]; then
	echo "Usage: $0 <ip> <port_range>"
	exit 1
fi

IP=$1
PORT_RANGE=$2

if ! echo "$IP" | grep -qE "^((25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\.){3}(25[0-5]|2[0-4][0-9]|[1-9]?[0-9])$"; then
	echo "Invalid IP address"
	exit 1
fi

START_PORT=$(echo $PORT_RANGE | cut -d'-' -f1)
END_PORT=$(echo $PORT_RANGE | cut -d'-' -f2)

check_port() {
    local port=$1
    if ! [[ $port =~ ^[0-9]+$ ]] || ((port <= 0 || port > 65535)); then
        echo "Port $port is out of range (1-65535)"
        exit 1
    fi
}

check_port $START_PORT
check_port $END_PORT

if [ $START_PORT -gt $END_PORT ]; then
	TEMP=$START_PORT
	START_PORT=$END_PORT
	END_PORT=$TEMP
fi

echo "Scanning ports $START_PORT-$END_PORT on $IP..."

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

# Regex x validazione porte --> "^(6553[0-5]|655[0-2][0-9]|65[0-4][0-9]{2}|6[0-4][0-9]{3}|[1-5][0-9]{4}|[1-9][0-9]{0,3})(-(6553[0-5]|655[0-2][0-9]|65[0-4][0-9]{2}|6[0-4][0-9]{3}|[1-5][0-9]{4}|[1-9][0-9]{0,3}))?$"
