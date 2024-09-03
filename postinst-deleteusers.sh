#!/bin/bash

source "postinst-yad.sh"

BACKUP_DATE=$(date +%Y%m%d)

(
echo "Moving user homes and deleting users..."
for user in $(awk -F: '$3 >= 1000 {print $1}' /etc/passwd); do
    if [ "$user" != "nobody" ]; then
        #mv /home/$user /home/${user}-${BACKUP_DATE}-presetup
        #userdel -r $user
        echo "$user"
    fi
done
# We don't want to delete anything yet as it'll make early debugging a pain, so we'll just run a loop that only updates the gui.
echo "simuating user deletion for early debugging purposes."
for i in $(seq 1 100); 
do 
    echo "$i"; 
    sleep 0.05; 
done
) | yad_progress "Post Install" "Deleting existing user data." "clock"