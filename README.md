NPM Install
===========

Install Node.js package dependencies one at a time via Ruby.

Examples
--------

* Install the dependencies defined in `package.json` to a local `node_modules`
  directory:

  `ruby npm_install.rb`

* Install the latest version of a package to a local `node_modules` directory:

  `ruby npm_install.rb ember-cli`

* Install a particular version of a package to a local `node_modules` directory:

  `ruby npm_install.rb ember-cli@2.4.1`

* Install the latest version of a package to the global `node_modules`
  directory:

  `ruby npm_install.rb -g ember-cli`

* Install a particular version of a package to the global `node_modules`
  directory:

  `ruby npm_install.rb -g ember-cli@2.4.1`

Why?
----

On slower connections npm will often time out while installing packages that
require a large number of dependencies. By installing each dependency
as a separate operation we reduce the chance of a timeout occurring.

This script was written before the arrival of [Yarn](yarn), an alternative to
npm with greater network resilience. I recommend using Yarn instead of this
script.

[yarn]: https://yarnpkg.com/
