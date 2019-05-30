#!/bin/sh

# # Useage
#
# This script is intended to be run once, by a container attached to a
# teaching lab network.  The "docker-compose.yml" of the
# sesync-ci/teaching-lab repository includes the directive to run this
# script, but it needs the path to this file set through the HANDOUTS
# environment variable.
#
# ```
# git clone git@github.com:SESYNC-ci/teaching-lab.git $DIR/teaching-lab
# pushd $DIR/teaching-lab docker-compose build
# popd
# HANDOUTS=$PWD docker stack deploy -c $DIR/teaching-lab/docker-compose.yml $NAME
# ```

# # Data Volume (/nfs)
#
# The container maps $HANDOUTS -> /tmp, so use rsync to synchronize
# the nfs volume with the handouts/data folder.

mkdir -p /nfs/public-data
rsync -rt --delete handouts/data/ /nfs/public-data/training
chmod -R +rX /nfs/public-data

# # Database
#
# check if database exists, and populate if false
# so ...

# psql -h postgres -u postgres -qc 'REVOKE ALL ON schema public FROM public'
# createdb portal
# createuser --no-login student
# psql portal -qc 'ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO student'
# psql portal -q < portal.sql
