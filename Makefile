SHELL := /bin/bash
LESSONS := $(shell ruby -e "require 'yaml';puts YAML.load_file('lessons.yml')['$TAG']")

.PHONY: $(LESSONS)

build: handouts.zip
	cp $< /nfs/public-data/training/
        # use github api to push $< as asset

handouts.zip: $(LESSONS)
	pushd release && zip -FSr ../handouts * && popd

$(LESSONS): %: | build/% release/data
	$(MAKE) -C $@ course

build/%:
	git clone "git@github.com:sesync-ci/$(@:build/%=%).git" $@

release/data:
	mkdir release/data

clean:
	mkdir tmp
	mv -t tmp release/CONTRIBUTING.md release/README.md
	rm -rf release build 
	mv tmp release
