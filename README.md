Lidoc
=====

Literate programming documentation generator.

Lidoc takes any code project and generates documentation from its comments.

Lidoc is code-agnostic; it doesn't care about your code at all, just the
comments.  As a result, it supports Python, PHP, Ruby, CoffeeScript, JavaScript,
and just about anything that supports comments.

Heavily inspired by [jashkenas/docco](https://github.com/jashkenas/docco), which
this project actually takes code from.

Usage
-----

Build documentation like so:

    $ lidoc **/*.js --output docs

Or

    $ lidoc **/*.js --debug

The lidoc standard
------------------

The lidoc standard is extremely simple and doesn't prescribe any way for you to
define methods or arguments or anything.

It is aimed to be primarily human-readable; machine-parsability is of a lesser
concern.

#### Add Markdown comments to your project files in single-line comments.

You can use all supported Markdown on comments. These comments will be the
documentation.

These should be done with single-line comments. In JavaScript/C/PHP, this is 
`//`, in Python/CoffeeScript/Ruby/etc, it's `#`.

#### Add H1 at the beginning of a file to signify a page.

Any first H1 encounted in a file will be counted as a 'page'.

This is done by the markdown instruction `#`.

    # # Parser
    # This is the parser.

    class Parser

      parse: ->
        ...

#### Each file can have up to one H1 heading maximum.

Yeah. Totally.

Any subsequent H1s found in the file will not be treated as a page.

#### Use H2 and H3 headings for sections.

H3's are recommended for methods.

    # ### getDiscountedPrice()

    # Applies merchant-specific discounts to the product and
    # returns the discounted price as a number.
    #
    #     product.setPrice(20.00);
    #     merchant.setDiscount(0.10);
    #
    #     product.getDiscountedPrice();
    #     //=> 18.00
    #
    getDiscountedPrice: ->
      @price * (1.00 - @merchant.discount)

Todo
----

 * Linking of `{Foo}` references
 * Sorting of pages
 * JS searching
