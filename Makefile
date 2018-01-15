SHELL := /bin/bash
LESSONS := $(shell ruby -e "require 'yaml';puts YAML.load_file('lessons.yml')['$TAG']")

.PHONY: all $(LESSONS) clean

all: release $(LESSONS)
	zip -FSr /nfs/public-data/training/handouts release
	# use github api to push release folder.zip as asset, popssibly in if statement on above doing something

release: worksheet-README.md CONTRIBUTING.md
	mkdir -p release/data
	cp worksheet-README.md release/README.md
	cp CONTRIBUTING.md release/CONTRIBUTING.md

$(LESSONS): %: | build/% # static pattern rule with order-only dependency
	$(MAKE) -C $| course

build/%:
	git clone "git@github.com:sesync-ci/$(@:build/%=%).git" $@

clean:
	rm -rf release build
