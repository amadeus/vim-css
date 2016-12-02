# Vim CSS

The intention of this plugin is create an accurat, modular and easily
extendable CSS syntax foundation.  Currently this library support basic **CSS**,
**Stylus** and **Sass**. Other languages should be fairly trivial to add, so
feel free to open up an issue so I can look into it.

I have opted to NOT attempt support for CSS style syntax that is whitespace
dependent.  Learn to love those curly brackets!

Things to do

* Add specialized animation and transform support
* Improve function arguments handling

## Why create yet another CSS syntax file for vim?

I am pretty particular about how my development environment is setup, and I got
tired of having to jump around to various derivative CSS languages and always
having to install a new plugin or get inconsistent support/highlighting.  Most
existing syntax files out there build off the baked in css syntax file which is
a pretty garbage foundation.  I decided to do something about it.  This is a
syntax file written entirely from scratch in a way to enable easy customization
for derivative CSS languages.  I've also made a good attempt to support every
property and value.  However, there's still a chance I've forgotten some, so
please open up an issue if you find a CSS feature not supported!
