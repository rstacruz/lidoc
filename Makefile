LIDOC ?= ./bin/lidoc
GITHUB_REPO ?= rstacruz/lidoc

FILES := README.md lib/*.coffee lib/**/*.coffee

docs: $(FILES)
	$(LIDOC) $^ --output docs

docs-debug: $(FILES)
	$(LIDOC) $^ --index

# Commit the documentation to the repo under a different author.
# This way, it will not pollute statistics like Github's graphs.
docs-commit: docs
	git add docs --force
	git commit -m "Update documentation." --author "Nobody <nobody@nadarei.co>"

docs-deploy: docs
	git-update-ghpages $(GITHUB_REPO) -i docs --force

.PHONY: docs docs-commit docs-deploy docs-debug
