# assumption, lesson numbers are correct
# assumption, the generic worksheet name is 'worksheet'
# assumption, public key authentiation on github
# assumption, git is not tracking build/

SHELL := /bin/bash
LESSONS := \
    basic-R-lesson

.PHONY: all pre-build $(LESSONS)

all: pre-build $(LESSONS) # could give a recipe to commit and push, if bold
	pushd build && zip -FSr /nfs/public-data/training/data data/ && popd
	rsync -au --delete build/data/ data/

pre-build:
	git checkout latest

$(LESSONS): %: | build/% # static pattern rule with order-only dependency
	$(MAKE) -C $| course
# FIXME add /nfs/public-data/training/README.md to build/data ?

build/%: | data
	git clone "git@github.com:sesync-ci/$(@:build/%=%).git" $@

data:
	mkdir -p build/data

# no make clean solution for worksheets yet
# should make clean remove just build/data or whole build/, probably just build/data
