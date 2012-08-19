LIDOC := ./bin/lidoc
VOWS  := ./node_modules/vows/bin/vows

LIDOC_OPTS  ?= --github $(GITHUB_REPO) --git-branch master
GITHUB_REPO ?= rstacruz/lidoc

FILES := \
	README.md \
	TODO.md \
	manual/*.md \
	lib/*.coffee \
	lib/**/*.coffee \
	test/*.coffee

lidoc.json: $(FILES)
	$(LIDOC) $(LIDOC_OPTS) $^ --index $@

docs: lidoc.json
	rm -rf $@
	$(LIDOC) $(LIDOC_OPTS) --import $^ --output $@

docs.debug: $(FILES)
	$(LIDOC) $(LIDOC_OPTS) $^ --index

# Commit the documentation to the repo under a different author.
# This way, it will not pollute statistics like Github's graphs.
docs.commit: docs
	git add docs --force
	git commit -m "Update documentation." --author "Nobody <nobody@nadarei.co>"

docs.deploy: docs
	git-update-ghpages $(GITHUB_REPO) -i docs --force

test:
	$(VOWS) test/*_test.* --dot-matrix

test.spec:
	$(VOWS) test/*_test.* --spec

.PHONY: docs.commit docs.deploy docs.debug test
