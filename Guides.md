Guides
======

Because I'm helpful tool.

Makefiles
---------

All of Lidoc's options are passed via the command line: `lidoc *.js --output
docs`. When you have many files, this can get cumbersome and hard to remember.

It may be best to create a `Makefile` to automate documentation generation for
you.

#### Creating the makefile

Create a file called `Makefile`.

    # Makefile
    LIDOC := ./node_modules/lidoc/bin/lidoc
    
    # Define the files you need as input here.
    docs: README.md lib/*.js lib/**/*.js
      rm -rf $@
      $(LIDOC) $^ --output $@

In GNU Make, the `$@` variable refers to the file being built (in this case,
`docs`) and `$^` refers to its dependencies (in this case, `README.md` et al).

#### Invoking it

To build your documentation, simply type:

    $ make docs

Working with Git
----------------

Some people like to commit their generated documentation in their project
repositories. However, if you're a fan of Github's graphs (or any repository
analysis tool for that matter), this will pollute your statistics and
unnecessarily bloat up the number of commits you do.

#### Committing with a different author

The solution is to commit with a different author.

    lidoc lib/**/*.js --output docs
    git add docs
    git commit -m "Update documentation." --author "Nobody <nobody@localhost>"

#### Integrating with `make`

In fact, you may want to integrate this into your Makefile.

    # Makefile
    NOBODY := "Nobody <nobody@localhost>"
    
    docs-commit: docs
      git add docs
      git commit -m "Update documentation." --author "$(NOBODY)"

    .PHONY: docs-commit

This way, you can just type:

    $ make docs-commit

This builds your documentation (because `docs-commit` depends on `docs`) then
commits it under a different author.
