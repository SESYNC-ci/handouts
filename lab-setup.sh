## NOTES ABOUT matching to branch swarm in teaching-lab

# users are going to be in LDAP or something self-servicable (not added by instructor)
# data is going to added after swarm is deployed, but persists in volumes (nfs, postgres)

# get lab running or started
COMPOSE=${1:-docker-compose.yml}
STACK=${2:-lab}
docker stack deploy -c "$COMPOSE" $STACK

# update the data volume
mkdir -p ${NFS}/public-data
rsync --update handouts/data ${NFS}/public-data/training






## none of the below


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
