LIDOC ?= ./bin/lidoc
GITHUB_REPO ?= rstacruz/lidoc

docs:
	$(LIDOC) README.md lib/**/*.coffee --output docs

docs-commit: docs
	git add -u docs --force
	git commit -m "Documentation update." --author "Nobody <nobody@nadarei.co>"

docs-deploy: docs
	git-update-ghpages $(GITHUB_REPO) -i docs --force

.PHONY: docs docs-commit docs-deploy
