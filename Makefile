# assumption, lesson numbers are correct
# assumption, the generic worksheet name is 'worksheet'
# assumption, public key authentiation on github
# assumption, git is not tracking build/

SHELL := /bin/bash
LESSONS := \
    basic-R-lesson

.PHONY: all build $(LESSONS) clean

all: build $(LESSONS) # could give a recipe to commit and push, if bold
	rsync -au --delete build/data/ data/
	cp /nfs/public-data/training/README.md data/
	zip -FSr /nfs/public-data/training/data data/

build: | build/data
	git checkout latest

build/data:
	mkdir -p build/data

$(LESSONS): %: | build/% # static pattern rule with order-only dependency
	$(MAKE) -C $| course

build/%:
	git clone "git@github.com:sesync-ci/$(@:build/%=%).git" $@

clean:
	git checkout latest
	git reset --hard clean
	git checkout master
	rm -rf build/data

# FIXME
# no make clean solution for worksheets yet
# should make clean remove just build/data or whole build/, probably just build/data
