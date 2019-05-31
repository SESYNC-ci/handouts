#!/bin/sh

# # Data Volume (/nfs)
#
# The container maps ./handouts -> /handouts, so use rsync to synchronize
# the nfs volume with the handouts/data folder.

mkdir -p /nfs/public-data
rsync -rt --delete /handouts/data/ /nfs/public-data/training
chmod -R +rX /nfs/public-data
