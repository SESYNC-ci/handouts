# assumption, lesson numbers are correct
# assumption, the generic worksheet name is 'worksheet'
# assumption, public key authentiation on github
# assumption, git is not tracking build/

LESSONS := \
    basic-R-lesson

.PHONY: all pre-build $(LESSONS)

all: pre-build $(LESSONS) # could give a recipe to commit and push, if bold
	pushd build && zip -FSr /nfs/public-data/training/data data/ && popd

pre-build:
	git checkout latest

$(LESSONS): %: | build/% # static pattern rule with order-only dependency
	$(MAKE) -C $| course

build/%: | data
	git clone "git@github.com:sesync-ci/$(@:build/%=%).git" $@

data:
	mkdir -p build/data

# could have lessons put data into build/data, then let rsync take care of syncing to delete non-needed data
# no solution for worksheets though
# maybe that should be a `make clean` rule
