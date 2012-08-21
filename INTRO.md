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

Installation
------------

Install [NodeJS](http://nodejs.org) in your preferred manner. Then:

    $ npm install -g lidoc

Usage
-----

Build documentation like so:

    $ lidoc **/*.js --output docs

Or you can view the documentation index as a JSON file like so:

    $ lidoc **/*.js --index

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
