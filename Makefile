SHELL := /bin/bash
TAG ?= $(shell head -n1 lessons.yml | cut -d: -f1)
LESSONS := $(shell ruby -e "require 'yaml';puts YAML.load_file('lessons.yml')['$(TAG)']")
SLIDES := $(addsuffix /docs/_slides,$(LESSONS))
PREVIEW := $(addsuffix /docs/_site,$(LESSONS))

.PHONY: $(LESSONS) all slides lab

# call make with a TAG found in lessons.yml
all: handouts.zip
	cp $< /nfs/public-data/training/
        # use github api to push $< as asset?

handouts.zip: $(LESSONS) data.zip
	mv handouts/data data
#	ln -s /nfs/public-data/training handouts/data
	zip -FS -r --symlinks handouts handouts
#	rm handouts/data
	mv data handouts/data

data.zip: $(LESSONS) | handouts/data
	pushd handouts && zip -FS -r ../data data && popd

slides: $(addprefix build/,$(SLIDES))

%/docs/_slides: %
	$(MAKE) -C $< slides

preview: $(addprefix build/,$(PREVIEW))

%/docs/_site: %
	$(MAKE) -C $< preview BASEURL=/rstudio/

handouts/data:
	mkdir handouts/data

$(LESSONS): %: | build/%
	$(MAKE) -C $| course

build/%:
	git clone "git@github.com:sesync-ci/$(@:build/%=%).git" $@

lab:
	docker stack deploy -c docker-compose.yml test

clean:
	mkdir tmp
	mv -t tmp handouts/CONTRIBUTING.md handouts/README.md handouts/handouts.Rproj
	rm -rf handouts build *.zip
	mv tmp handouts
