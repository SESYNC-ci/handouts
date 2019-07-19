#!/bin/bash

# # Users and Group Setup
#
# The instructor must create a list of users and optionall, gorup assignments.
# Create a /tmp/lab-users.txt file with usernames, one per line.
# Optionally create a /tmp/lab-groups.txt file a groupname followed by the member usernames,
# separated by spaces, one per line.
#
# Add all the users from the /tmp/lab-users.txt file
if [ -f "/tmp/lab-users.txt" ]; then
   
    let N=999
    while read USER PASS; do
	let N++
	if [ $(id "$USER") ]; then
	    continue
	fi
	if [ -d "/home/$USER" ]; then
	    useradd -p $(openssl passwd -1 "$PASS") -u "$N" --no-create-home --home-dir "/home/$USER" "$USER"
	else
	    useradd -m -p $(openssl passwd -1 "$PASS") "$USER"
	fi
    done < "/tmp/lab-users.txt"
fi

# add all the users to groups from the /tmp/lab-groups.txt file
if [ -f "/tmp/lab-groups.txt" ]; then
    
    # this script assumes no more than 1000 users
    let N=1999
    while read GROUP USERS; do
	let N++
	if [ $(getent group "$GROUP") ]; then
	    continue
	fi
	groupadd -g "$N" "$GROUP"
	IFS=','
	gpasswd -M "$USERS" "$GROUP"
	DATA="/nfs/$GROUP-data"
	if [! -d "$DATA" ]; then
	    mkdir "$DATA"
	    chgrp "$GROUP" "$DATA"
	    chmod g+swrx,o-rx "$DATA"
	fi
    done < /tmp/lab-groups.txt
fi

# # Data Volume (/nfs)
#
# The container maps ./handouts -> /handouts, so use rsync to synchronize
# the nfs volume with the handouts/data folder. Doesn't matter if run
# by multiple containers.

mkdir -p /nfs/public-data
rsync -rt --delete /handouts/data/ /nfs/public-data/training
chmod -R +rX /nfs/public-data

# # Docker CMD
#
# run the docker cmd as specified in exec form
exec "$@"
