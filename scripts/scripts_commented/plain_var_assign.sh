#!/bin/bash
#Naked variables

echo

# When is a variable "naked", i.e., lacking the '$' in front?
# When it is being assigned, rather than referenced.

# Assignment
a=879
echo "The value of \"a\" is $a."

# Assignment using 'let'
let a=16+5
echo "The value of \"a\" is now $a."

echo

# In a 'for' loop:
echo -n "Values of \"a\" in the loop are: "
for a in 7 8 9 11
do
  echo -n "$a "
done

echo
echo

# In a 'read' statement:
echo -n "Enter \"a\": "
read a
echo "The value of \"a\" is now $a."

echo

exit 0

#------------------------------------------
# Commented Code
#------------------------------------------
# La variabile a viene assegnata con il valore 879.
# L'echo a riga 10 stampa il valore della variabile a, con l'escape per "".
# La variabile a viene riassegnata grazie a let con il valore 16+5.
# L'echo a riga 15 stampa il valore della variabile a.
# L'echo a riga 20 stampa la stringa e poi i valori di a nel loop, con l'opzione -n per non andare a capo.
# Il ciclo for assegna ad a i valori 7, 8, 9 e 11.
# L'assegnazione può avvenire anche con un read, come a riga 31, dove è l'user ad inserire il valore di a.
# L'echo a riga 32 stampa il valore di a, che viene nuovamente riassegnato con il valore inserito dall'utente.
