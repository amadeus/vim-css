# Vim CSS

The intention of this plugin is create an accurate, modular and easily
extendable CSS syntax foundation.  The currently supported languages are:

* CSS
* [Stylus](http://stylus-lang.com/)
* [Sass](http://sass-lang.com/)
* [Styled Components](https://www.styled-components.com/)

This initial release is most likely far from feature complete, so please post
issues if you find something I have missed.  Other pre-processors should be
fairly trivial to add, so feel free to open up an issue so I can look into it.

I have opted to NOT support pre-processor syntax that is white space dependent.
Learn to love those curly brackets!


## To Do List:

* Add specialized animation and transform support
* Other languages?!


## Why create yet another CSS syntax file for Vim?

CSS and its various pre-processing languages tend to be pretty poorly supported
in Vim.  Many of the existing plugins build off the included syntax file which
is a fairly disorganized mess that is both monolithic and a poor foundation for
extending upon.  Meanwhile, I've spent the last few years contributing to one
of the most widely used Javascript syntax files for Vim
[pangloss/vim-javascript](https://github.com/pangloss/vim-javascript) and have
gained quite a bit of experience in Vim's syntax matching APIs.  Taking what
I've learned, I've created this CSS plugin from scratch in a way that is both
highly accurate and extendable.

Currently I only have support for CSS and two other pre-processors, but the
foundation is in place to quickly and easily add more, as people request them.


## License

[MIT Style License](https://opensource.org/licenses/MIT)
