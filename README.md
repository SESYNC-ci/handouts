# Handouts

## About

The purpose of this repository is to assemble handouts for distribution during SESYNC training events. The content of the [latest] branch changes between short courses, but it typically includes the worksheets and data for several lessons. Trainees will [download] the archive (zip) of that branch during a short course.

## Use

Modify the `LESSONS` array in the Makefile to include only the desired lessons and execute `make course`. Make will prepare the latest branch with the necessary worksheets and data. Make does not push the branch to GitHub.

## Past Events

**Following** a short course, the worksheets and data should be archived as a [release]. Configure a new release so the worksheets are downloaded as `Source code (zip)` and accompanying data as `data.zip`.

[latest]: ../../tree/latest
[release]: ../../releases
[download]: ../../archive/latest.zip
