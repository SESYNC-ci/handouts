# Handouts

## About

The purpose of this repository is to 1) assemble handouts for distribution during SESYNC training events, and 2) launch the teaching-lab Docker stack confiured with these handouts. Trainees will [download] the handouts.zip file, containing worksheets but not data, at the time of a short course. The data
can be provided as a separate data.zip or by linking to shared data within the teachng-lab container (see the Docker section below).

## Use

To assemble the handouts for all lesson from a specific list in the `lessons.yml` file, call `make TAG=<NAME>`. Simply calling `make` uses the first list of courses found rather than one specified by its tag.

## Past Events

**Following** a short course, the worksheets and data should be archived as a [release]. Configure a new release so the assets are a complete archive of the worksheets and data. The syllabus should be updated to point the handouts link to this release.

[release]: ../../releases
[download]: ../../archive/latest.zip

## Docker

This repository works in conjunction with the SESYNC-ci/teaching-lab to provision a containerized, cloud platform providing software to participants during a workshop or short course.

1. Build the the docker images defined by the Dockerfiles in the teaching-lab repo. Use `docker rmi <NAME>` and `docker image prune` to clean out existing images as needed before building.
```
icarroll@docker01:teaching-lab$ make 
```
1. One side effect of running `make` in the handouts repository is the creation of a data.zip, whose contents need to be made available to the `docker-entrypoint.sh` script
that initializes the docker containers. First run `make` on a server that can access /nfs to get the data. A second side effect is processing the root/tmp/lab/users.txt file
if it exits.
```
icarroll@sshgw01:handouts$ make
```
1. Now, create a different clone of the handouts repo so the docker daemon will be able to mount folders within it.
```
icarroll@docker01:srv$ pwd
/srv
icarroll@docker01:srv$ sudo git clone https://github.com/SESYNC-ci/handouts.git
```
1. Unzip the data to that clone, so the docker daemon will be able to mount it.
```
icarroll@docker01:srv$ cd handouts
icarroll@docker01:handouts$ cp ~/path/to/handouts/data.zip /tmp
icarroll@docker01:handouts$ sudo unzip /tmp/data.zip -d root/tmp/lab
```
1. Copy the user and group information to the same location
```
icarroll@docker01:handouts$ cp ~/path/to/handouts/root/tmp/lab/*.txt /tmp
icarroll@docker01:handouts$ sudo cp /tmp/*.txt root/tmp/lab/
```
1. Now start the lab
```
icarroll@docker01:handouts$ make lab
```

Why is this so complicated. Well, there are some gotcha's having to do with the SESYNC cyberinfrastrucutre:
- The docker server does not have access to /nfs.
- The docker container cannot mount to folders in  /nfs or /research-home, so the `make lab` target must be run from a clone of the repository in a local folder, e.g. /srv.
