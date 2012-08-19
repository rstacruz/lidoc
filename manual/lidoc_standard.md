Documentation: Lidoc standard
=============================

The lidoc standard is extremely simple and doesn't prescribe any way for you to
define methods or arguments or anything.

It is aimed to be primarily human-readable; machine-parsability is of a lesser
concern.

This documentation assumes CoffeeScript for examples. However, the standard can
apply to any code language that can support comments.

## Documenting files

Files are documented through Markdown comments.

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
