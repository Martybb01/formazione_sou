#!/usr/local/bin/bash
# fetch_address.sh

declare -A address

address[Charles]="414 W. 10th Ave., Baltimore, MD 21236"
address[John]="202 E. 3rd St., New York, NY 10009"
address[Wilma]="1854 Vermont Ave, Los Angeles, CA 90023"

echo "Charles's address is ${address[Charles]}"
echo "Wilmad's address is ${address[Wilma]}"
echo "John's address is ${address[John]}"

echo

echo "${!address[*]}" # The array indices..

#-------------------------------------------
# Commented Code
#-------------------------------------------
# La riga 4, con la flag -A, dichiara un array associativo chiamato address.
# Un array associativo è un array in cui gli indici non sono numeri, ma stringhe e c'è un assegnazione chiave-valore.
# Le righe 7-9 assegnano gli indirizzi alle chiavi Charles, John e Wilma.
# Gli echo a righe 10-12 stampano gli indirizzi delle chiavi Charles, Wilma e John.
# L'echo a riga 16 stampa gli indici (chiavi) dell'array address --> Wilma Charles John
# N.B è richiesto bash 4.0 o superiore per l'uso degli array associativi.
