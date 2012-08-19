Guides: Uploading to Github pages
=================================

If you've done the `Makefile` thing, you can define a task to deploy to Github
pages like so.

### Editing the Makefile

In your `Makefile`, ensure that you already have a directive for `docs` (See
[Makefiles][makefiles.html]). Then let's define a new directive for
`docs.deploy` like so:

    # Makefile
    GITHUB_REPO ?= yourname/project
    
    # Sends the documentation to gh-pages.
    docs.deploy: docs
      cd docs && \
      git init . && \
      git add . && \
      git commit -m "Update documentation."; \
      git push "git@github.com:$(GITHUB_REPO).git" master:gh-pages --force && \
      rm -rf .git
    
    .PHONY: docs.deploy

### Invoking it

You'll then be able to update your Github pages using:

    $ make doc.deploy

This task builds the documentation (see how `docs` is a dependency of the task),
creates a Git repository in `docs/`, and pushes that (by force) into the
`gh-pages` branch.

See Lidoc's own Makefile for a full example.

You may also consider using the
[git-update-ghpages](https://github.com/rstacruz/git-update-ghpages) script.
