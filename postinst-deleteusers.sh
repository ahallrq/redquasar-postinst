#!/bin/bash

source "postinst-yad.sh"

BACKUP_DATE=$(date +%Y%m%d)

(
echo "Moving user homes and deleting users..."
for user in $(awk -F: '$3 >= 1000 {print $1}' /etc/passwd); do
    if [ "$user" != "nobody" ]; then
        #mv /home/$user /home/${user}-${BACKUP_DATE}-presetup
        #userdel -r $user
        sleep 1
        echo "simuating user deletion for early debugging purposes."
    fi
done
) | yad_progress_pulsate "Post Install" "Deleting existing user data." "clock"