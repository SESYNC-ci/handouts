SHELL := /bin/bash
LESSONS := $(shell ruby -e "require 'yaml';puts YAML.load_file('lessons.yml')['$(TAG)']")

.PHONY: $(LESSONS)

# call make with a TAG found in lessons.yml
build: handouts.zip
	cp $< /nfs/public-data/training/
	touch build
        # use github api to push $< as asset

handouts.zip: $(LESSONS) data.zip
	mv handouts/data data
	ln -s /nfs/public-data/training handouts/data
	zip -FS -r --symlinks handouts handouts
	rm handouts/data
	mv data handouts/data

data.zip: $(LESSONS) | handouts/data
	pushd handouts && zip -FS -r ../data data && popd

handouts/data:
	mkdir handouts/data

$(LESSONS): %: | build/%
	$(MAKE) -C $| course

build/%:
	git clone "git@github.com:sesync-ci/$(@:build/%=%).git" $@
	touch $@/docs/_slides/*

clean:
	mkdir tmp
	mv -t tmp handouts/CONTRIBUTING.md handouts/README.md handouts/handouts.Rproj
	rm -rf handouts build *.zip
	mv tmp handouts
