NPM Install
===========

Install Node.js package dependencies one at a time via Ruby.

Examples
--------

Install the latest version of a package to the local `node_modules` directory:

`ruby npm_install.rb ember-cli`

Install a particular version of a package to the local `node_modules` directory:

`ruby npm_install.rb ember-cli@2.4.1`

Install the latest version of a package to the global `node_modules` directory:

`ruby npm_install.rb -g ember-cli`

Install a particular version of a package to the global `node_modules`
directory:

`ruby npm_install.rb -g ember-cli@2.4.1`

Why?
----

On slower connections `npm` will often time out while installing packages that
require a large number of dependencies. By installing each dependency
as a separate operation we reduce the chance of a timeout occurring.
