#!/bin/bash

while read USER PASS; do
    if [ -z "$PASS" ]; then
	PASS=$(curl https://frightanic.com/goodies_content/docker-names.php)
    fi
    printf "%s %s\n" "$USER" "$PASS"
done < root/tmp/lab/users.txt > root/tmp/lab/users.txt.tmp
mv root/tmp/lab/users.txt.tmp root/tmp/lab/users.txt
