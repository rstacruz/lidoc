Guides: Makefiles
=================

All of Lidoc's options are passed via the command line: `lidoc *.js --output
docs`. When you have many files, this can get cumbersome and hard to remember.

It may be best to create a `Makefile` to automate documentation generation for
you.

### Creating the Makefile

Create a file called `Makefile`.

    # Makefile
    LIDOC := ./node_modules/lidoc/bin/lidoc
    
    # Define the files you need as input here.
    docs: README.md lib/*.js lib/**/*.js
      rm -rf $@
      $(LIDOC) $^ --output $@

In GNU Make, the `$@` variable refers to the file being built (in this case,
`docs`) and `$^` refers to its dependencies (in this case, `README.md` et al).

### Invoking it

To build your documentation, simply type:

    $ make docs

