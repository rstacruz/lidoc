#Welcome to Lidoc

**Lidoc** generates literate programming documentation from your code
painlessly.

It takes any code project, parses its inline comments, and and generates
documentation in the form of a gorgeous-looking, standalone HTML package like
this one.

Lidoc is code-agnostic; it doesn't care about your code at all, just the
comments.  As a result, it supports Python, PHP, Ruby, CoffeeScript, JavaScript,
and just about anything that supports comments.

Heavily inspired by [jashkenas/docco](https://github.com/jashkenas/docco), which
this project actually takes code from.

Usage
-----

Build documentation like so:

    $ lidoc **/*.js --output docs

Or you can view the documentation index as a JSON file like so:

    $ lidoc **/*.js --index

The lidoc standard
------------------

The lidoc standard is extremely simple and doesn't prescribe any way for you to
define methods or arguments or anything.

It is aimed to be primarily human-readable; machine-parsability is of a lesser
concern.

This documentation assumes CoffeeScript for examples. However, the standard can
apply to any code language that can support comments.

#### Add Markdown comments to your project files in single-line comments.

You can use all supported Markdown on comments. These comments will be the
documentation.

These should be done with single-line comments.

 * This is `//` in JavaScript, C, PHP, and others.
 * This is `#` in Python, CoffeeScript, Ruby, and so on.

#### Any H1 block signifies a page.

Any first H1 encounted in a file will be counted as a 'page'. Any content under
it, until a new H1 is found, or until the end of file is reached, is counted as
content of that page.

This is done by the markdown instruction `#`.

    # # Parser
    
    # This is the parser.
    # It gets a bunch of things and outputs a bunch of stuff.
    
    class Parser
    
      # ### parse()
    
      # Performs parsing on the given string.
    
      parse: (string) ->

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

Acknowledgements
----------------

© 2012, Rico Sta. Cruz. Released under the [MIT 
License](http://www.opensource.org/licenses/mit-license.php).

**Lidoc** is authored and maintained by [Rico Sta. Cruz](http://ricostacruz.com)
with help from its [contributors](http://github.com/rstacruz/lidoc/contributors).
It is sponsored by my startup, [Nadarei, Inc](http://nadarei.co).

 * [My website](http://ricostacruz.com) (ricostacruz.com)
 * [Nadarei, Inc.](http://nadarei.co) (nadarei.co)
 * [Github](http://github.com/rstacruz) (@rstacruz)
 * [Twitter](http://twitter.com/rstacruz) (@rstacruz)
