#!/bin/bash
# am-i-root.sh:   Am I root or not?

ROOT_UID=0         # Root has $UID 0.

# $UID if u are root will be 0 so if $UID is equal to $ROOT_UID then you are root
if [ "$UID" -eq "$ROOT_UID" ]
then
  echo "You are root."
else
  echo "You are just an ordinary user (but mom loves you just the same)."
fi

exit 0

# ============================================================= #
# Code below will not execute, because the script already exited.
# An alternate method of getting to the root of matters:

ROOTUSER_NAME=root
username=`id -nu`   # or username=`whoami` or username=$USER

if [ "$username" = "$ROOTUSER_NAME" ]
then
  echo "Rooty, toot, toot. You are root."
else
  echo "You are just a regular fella."
fi

# --------------------------------------------------
# Commented code
# --------------------------------------------------

# 1st method:
# La prima riga dello script assegna 0 alla variabile ROOT_UID (assegnazione semplice), che rappresenta l'UID di root.
# L'if statement controlla se il valore della variabile UID è uguale al valore della variabile ROOT_UID.
# Se la condizione è vera, lo script stampa "You are root."


# 2nd method:
# La prima riga dello script assegna la stringa "root" alla variabile ROOTUSER_NAME (assegnazione semplice).
# La variabile username viene assegnata con il comando id -nu, che restituisce il nome utente corrente.
# L'if statement controlla se il valore della variabile username è uguale al valore della variabile ROOTUSER_NAME.
# Se la condizione è vera, lo script stampa "Rooty, toot, toot. You are root."
