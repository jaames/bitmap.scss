# bitmap.scss

[.bmp](https://en.wikipedia.org/wiki/BMP_file_format) image encoder (plus a 2d raster drawing API!) implemented entirely in SCSS/SASS.

## Huh?

[SCSS](https://sass-lang.com/) (actually called SASS, but who uses that syntax?) is a preprocessor for CSS stylesheets. It's meant to add useful things like variables, imports and mixins to make it easier to compose large CSS rulesets for big serious :tm: websites for big serious :tm: businesses. In fairness it's actually fairly robust at what it does, and could be considered turing complete if you look at it from a distance and squint really hard.

Naturally, I wanted to do something a bit stupid and decided that I was going to implement a working [.bmp](https://en.wikipedia.org/wiki/BMP_file_format) image encoder, with some basic 2D raster drawing functions for drawing lines, circles, rectangles, hyperboloids, yadda yadda yadda. My end goal is to one day make a working SCSS file parser and renderer for [Flipnote Studio's animation format](https://github.com/jaames/flipnote.js), so this is my first (incredibly misguided) step.

If you're familiar with SCSS or still possess several working braincells, you might be thinking to yourself "Hey James, that sounds worse than being roasted over the eternal buring fires of hell". And you'd be 100% right. No I am not okay. 

Along the way there were a number of fun roadblocks which had to be hacked around:

* SCSS doesn't have byte buffers, so lists are used to represent these instead.
* SCSS doesn't have low level data types, so packing values as uint32, int16, etc had to be implemented manually.
* SCSS doesn't have bitwise ops, so those also had to be implemented using equivalent arithmetic.
* SCSS can't write abritrary files to disk, which means encoded images can only be viewed as base64-encoded background images... and of course SCSS doesn't have built-in base64 encoding either, so this also had to be implemented manually.

In addition -- and this should go without saying, but I know what r/webdev brodudes are like -- this is a dumb experiment to see how far I can push a silly CSS preprocessor tool. If I catch you using this in production I will absolutely hunt you down and throw you headfirst into a bathtub full of live, incredibly deadly jellyfish before dousing you in concentrated lemon juice. That is to say, please kindly consider not taking this seriously.

## Usage

hey don't