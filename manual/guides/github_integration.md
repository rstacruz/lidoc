Guides: Github integration
==========================

Lidoc can automatically add a *fork me on Github* button on the first page,
and link to Github source files (seen in the lower-left corner).

Just invoke **Lidoc** with `--github`:

    $ lidoc lib/**/*.js --output docs --github rstacruz/lidoc

This links your pages to their corresponding files on Github on the `master`
branch. If you're developing on another branch than `master`, just pass that in:

    $ lidoc lib/**/*.js --output docs --github rstacruz/lidoc --git-branch develop
