#!/bin/bash

interval=1
long_interval=10

{
	trap "exit" SIGUSR1
	sleep $interval; sleep $interval
	while true
	do
		echo -n "."		# Use dots.
		sleep $interval
	done; } &			# Start a progress bar as a background process.

pid=$!
trap "echo !; kill -USR1 $pid; wait $pid" EXIT	# To handle ^C.

echo -n "Long running process "
sleep $long_interval
echo "Finished!"

kill -USR1 $pid
wait $pid		# Stop the progress bar.
trap EXIT

exit $?

#------------------------------------------
# Commented Code
#------------------------------------------
# La variabile interval viene assegnata con il valore 1.
# La variabile long_interval viene assegnata con il valore 10.

# Il blocco di codice tra le parentesi graffe a righe righe 8-15 avvia un processo in background che simula una barra di progresso stampando un punto (.) ogni secondo ($interval).
# Il comando trap (builtin) a riga 7 fa sì che il processo venga terminato quando riceve il segnale SIGUSR1.
# Il comando sleep a riga 8 attende interval secondi e poi ne attende altri interval.
# Il ciclo while stampa un punto ogni interval secondi.
# la & a riga 13 fa partire il progress bar come processo in background.

# La variabile pid viene assegnata con il PID del processo in background ($! è il PID dell'ultimo processo eseguito in background).

# Il comando trap a riga 16 fa sì che il processo venga terminato quando riceve il segnale EXIT.
# TRAP imposta una trappola cioè esegue il codice specificato tra " " quando riceve il segnale
# In particolare: stampa ! (ultimo cmd), invia il segnale USR1 al processo in background e attende che il processo termini.

# Righe 18-19 viene simulato un processo a lungo termine (sleep $long_interval) che dura long_interval secondi.
# A riga 22 viene inviato un segnale SIGUSR1 al processo in background per fermare la barra progresso.
# Il comando wait a riga 23 attende che il processo in background termini.
# A riga 24 viene rimossa la trappola EXIT.

# Lo script termina restituendo lo status di uscita dell'ultimo processo (ultimo comando eseguito) con exit $?.
