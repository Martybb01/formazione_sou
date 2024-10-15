#!/bin/bash

echo hello
echo $?    # Exit status 0 returned because command executed successfully.

lskdf      # Unrecognized command.
echo $?    # Non-zero exit status returned because command failed to execute.

echo

exit 113   # Will return 113 to shell.

#  By convention, an 'exit 0' indicates success,
#+ while a non-zero exit value means an error or anomalous condition.

#-------------------------------------------
# Commented Code
#-------------------------------------------
# L'echo a riga 3 stampa "hello".
# L'echo a riga 4 stampa il valore di $? che è 0, poiché il comando è stato eseguito con successo.
# Il comando lskdf non esiste e quindi $? a riga 7 restituirà un valore diverso da 0 per indicare un errore.
# L'exit (shell built-in) 113 a riga 11 restituirà 113 al terminale.

