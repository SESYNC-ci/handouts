# Handouts

## About

The purpose of this repository is to distribute handouts during a SESYNC training event. The content of the handouts branch changes between short courses, but it typically includes the worksheets and data for several lessons. Most trainees will [download] the archive (zip) of the handouts branch during a short course.

## Use

Modify the `LESSONS` array in the Makefile to include only the desired lessons and execute `make course`. Make will prepare the handouts branch with the necessary worksheets and data. Make does not push the branch to GitHub.

## Past Events

**Following** a short course, the worksheets and data should be archived as a [release]. Configure a new release so the worksheets are downloaded as `Source code (zip)` and accompanying data as `data.zip`.

[releases]: /releases
[download]: https://github.com/SESYNC-ci/handouts/archive/handouts.zip
