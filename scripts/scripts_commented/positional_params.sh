#!/bin/bash

# Call this script with at least 10 parameters, for example
# ./scriptname 1 2 3 4 5 6 7 8 9 10

MINPARAMS=10

echo

echo "The name of this script is \"$0\"."
# Adds ./ for the current directory
echo "The name of this script is \"`basename $0`\"."
# Strips out path name info

echo

if [ -n "$1" ]              # Tested variable is quoted.
then
  echo "Parameter #1 is $1"  # Need quotes to escape #
fi

if [ -n "$2" ]
then
  echo "Parameter #2 is $2"
fi

if [ -n "$3" ]
then
  echo "Parameter #3 is $3"
fi

# ...

if [ -n "${10}" ]  # Parameters > $9 must be enclosed in {brackets}.
then
  echo "Parameter #10 is ${10}"
fi

echo "-----------------------------------"
echo "All the command-line parameters are: "$*"" 
# $* is all the command-line parameters

# $# is the number of command-line parameters that has to be at least 10 (-lt is less than)
if [ $# -lt "$MINPARAMS" ]
then
  echo
  echo "This script needs at least $MINPARAMS command-line arguments!"
fi

echo

exit 0


#------------------------------------------
# Commented Code
#------------------------------------------
# La prima riga dello script assegna 10 alla variabile MINPARAMS (assegnazione semplice).
# L'echo senza argomenti stampa una nuova riga.
# L'echo a riga 10 stampa il nome dello script con il percorso completo.
# L'echo a riga 12 stampa il nome dello script senza il percorso.
# L'if statement a riga 17 controlla se il primo parametro è stato passato.
# In generale il check viene ripetuto per i primi 3 parametri + il decimo.
# Se l'if statement è vero, lo script stampa il parametro corrispondente, altrimenti non fa nulla.
# L'echo a riga 40 stampa tutti i parametri passati allo script.
# L'if statement a riga 44 controlla se il numero di parametri passati è minore di 10 (MINPARAMS).
# Se l'if statement è vero, lo script stampa un messaggio di errore.


