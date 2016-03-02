NPM Install
===========

Install Node.js package dependencies one at a time via Ruby.

Examples
--------

`ruby npm_install.rb ember-cli`

`ruby npm_install.rb ember-cli@2.4.1`

The specified npm package and its dependencies will be installed globally.

Why?
----

On slower connections `npm` will often time out while installing packages that
require a large number of dependencies. By installing each dependency
as a separate operation we reduce the chance of a timeout occurring.
