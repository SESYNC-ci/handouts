SHELL := /bin/bash
LESSONS := $(shell ruby -e "require 'yaml';puts YAML.load_file('lessons.yml')['$(TAG)']")

.PHONY: $(LESSONS)

# call make with a TAG found in lessons.yml
build: handouts.zip
	cp $< /nfs/public-data/training/
        # use github api to push $< as asset

handouts.zip: release/data $(LESSONS)
	pushd release && zip -FSr ../handouts * && popd

release/data:
	mkdir release/data

$(LESSONS): %: | build/%
	$(MAKE) -C $| course

build/%:
	git clone "git@github.com:sesync-ci/$(@:build/%=%).git" $@

clean:
	mkdir tmp
	mv -t tmp release/CONTRIBUTING.md release/README.md
	rm -rf release build handouts.zip
	mv tmp release
