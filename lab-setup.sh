# MANUALLY update lab-users.txt and lab-groups.txt

# get lab running or started
IMG=lab
#CONTAINER=demo
#CONTAINER=si
CONTAINER=geo
docker start "$CONTAINER"
if [ "$?" -gt 0 ]; then
    docker run -d -p80:80 \
	   --mount type=volume,source="$CONTAINER"-home,destination=/home \
	   --mount type=volume,source="$CONTAINER"-nfs,destination=/nfs \
	   --name="$CONTAINER" "$IMG"
fi

# unarchive data.zip to /nfs/public-data/training/
if [ -f "data.zip" ]; then
  docker cp data.zip "$CONTAINER":/tmp/
  docker exec "$CONTAINER" mkdir -p /nfs/public-data
  docker exec "$CONTAINER" rm -rf /nfs/public-data/training
  docker exec "$CONTAINER" unzip -o /tmp/data.zip "data/*" -d /nfs/public-data
  docker exec "$CONTAINER" mv /nfs/public-data/data /nfs/public-data/training
  docker exec "$CONTAINER" rm /tmp/data.zip
fi

# if needed, place a lab-users.txt file in this directory with one username per line
if [ -f "lab-users.txt" ]; then

    # generate missing passwords
    while read USER PASS; do
	if [ -z "$PASS" ]; then
	    PASS=$(curl https://frightanic.com/goodies_content/docker-names.php)
	fi
	printf "%s %s\n" "$USER" "$PASS"
    done < lab-users.txt > lab-users.txt.tmp && mv lab-users.txt.tmp lab-users.txt

    # add all the users
    let N=1000
    while read USER PASS; do
	docker exec "$CONTAINER" labuseradd "$USER" "$PASS" $N
	let N++
    done < lab-users.txt

    # if needed, place a lab-groups.txt file in this directory with one
    # groupname followed by at least one username per line
    if [ -f "lab-groups.txt" ]; then
	let N=2000
	while read GROUP USERS; do
	    docker exec "$CONTAINER" labgroupadd "$GROUP" $N $USERS
	    let N++
	done < lab-groups.txt
    fi
fi
