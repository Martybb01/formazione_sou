#!/bin/bash

# Cleanup
# Run as root, of course.

# Move to the log directory
cd /var/log

# clears the content of messages and wtmp log files, replacing it with nothing (/dev/null)
cat /dev/null > messages
cat /dev/null > wtmp

# Message to the user
echo "Log files cleaned up."

# --------------------------------------
# Commented code
# --------------------------------------
# Innanzitutto eseguire lo script come root perchè stiamo lavorando con file di sistema.
# Con il comando cd /var/log ci spostiamo nella directory dei log.
# Con cat /dev/null > messages svuotiamo il log file messages, sostituendo il suo contenuto con niente.
# Con cat /dev/null > wtmp svuotiamo il log file wtmp, sostituendo il suo contenuto con niente.
# Infine, con echo "Log files cleaned up." comunichiamo all'utente che i log sono stati puliti.
