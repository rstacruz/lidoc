LIDOC := ./bin/lidoc
VOWS  := ./node_modules/vows/bin/vows

LIDOC_OPTS  ?= --github $(GITHUB_REPO) --git-branch master
GITHUB_REPO ?= rstacruz/lidoc

FILES := \
	INTRO.md \
	manual/*.md \
	manual/**/*.md \
	lib/*.coffee \
	lib/lidoc/*.coffee \
	lib/lidoc/models/*.coffee \
	lib/*.js \
	test/*.coffee \
	TODO.md \

lidoc.json: $(FILES)
	$(LIDOC) $(LIDOC_OPTS) $^ --index $@

docs: lidoc.json
	rm -rf $@
	$(LIDOC) $(LIDOC_OPTS) --import $^ --output $@

# Commit the documentation to the repo under a different author.
# This way, it will not pollute statistics like Github's graphs.
docs.commit: docs
	git add docs --force
	git commit -m "Update documentation." --author "Nobody <nobody@nadarei.co>"

# Sends the documentation to gh-pages.
docs.deploy: docs
	cd docs && \
	git init . && \
	git add . && \
	git commit -m "Update documentation."; \
	git push "git@github.com:$(GITHUB_REPO).git" master:gh-pages --force && \
	rm -rf .git

# Remove generated files so we can generate again.
# (make clean docs)
clean:
	rm -rf lidoc.json docs

test:
	$(VOWS) test/*_test.* --dot-matrix

test.spec:
	$(VOWS) test/*_test.* -i --spec

.PHONY: docs.commit docs.deploy test test.spec clean
