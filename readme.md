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

A basic overview can be found in `src/main.scss`. 

### Image

This represents an unpacked image structure with a pallete and dimension values.

#### Image API

**image.create( $width, $height, $num-colors )**

Returns a new image spanning (width, height) pixels and with the specified number of color slots. Max color slots is currently `256`.

**image.set-palette-color( $image, $color-index, $color )**

Sets a color in the image's color palette from any valid CSS color value. Palette index 0 is used as the background color. Returns the modified image struct.

**image.set-pixel( $image, $x, $y, $color-index )**

Sets a pixel at (x, y) to $color-index. Returns the modified image struct.

### Drawing Context

This is used for drawing basic things into an image structure, it can be used with a number of functions that can modify a drawing context to draw stuff into it. They will return the new modified drawing context.

So for example, to create a context, update colors, and then draw a line:

```
// Create 64x64 drawing context w/ 16 colors
$ctx: ctx.create(64, 64, 16);

// Set up palette
$ctx: ctx.set-palette-color($ctx, 0, #fff);
$ctx: ctx.set-palette-color($ctx, 1, #000);

// Set the active color index to use when drawing the line
$ctx: ctx.set-active-color($ctx, 1);

// Draw a line
$ctx: ctx.line($ctx, 0, 0, 20, 20);
```

#### Drawing Context API

**ctx.create( $width, $height, $num-colors )**

Creates a drawing context and a backing image spanning (width, height) pixels and with the specified number of color slots. Max color slots is currently `256`.

**ctx.from-image( $image )**

Creates a drawing context from a given image.

**ctx.to-image( $ctx )**

Returns an image struct from a given drawing context.

**ctx.set-palette-color( $ctx, $color-index, $color )**

Sets a color in the image's color palette from any valid CSS color value. Palette index 0 is used as the background color.

**ctx.set-active-color( $color-index )**

Sets the color to use in subsequent drawing commands. Color index 1 is used by default.

**ctx.line( $ctx, $x0, $y0, $x1, $y1 )**

Draws a line from (x0, y0) to (x1, y1).

**ctx.rect( $ctx, $x0, $y0, $width, $height )**

Draws a rectangle spanning (width, height) pixels using (x0, y0) as the top-left corner.

**ctx.circle( $ctx, $cx, $cy, $radius )**

Draws a circle with the defined radius using (cx, cy) as the midpoint.

### Bitmap Encoder

The bitmap encoder takes an image struct and returns packed .bmp data. 

#### Bitmap Encoder API

**bitmap.encode( $image )**

Encodes an image struct into a bitmap file, and returns the bytearray for the image file.

**bitmap.encode-to-dataurl( $image )**

Encodes an image struct into a bitmap file, and returns a base64-encoded data URL that can be used as a CSS background image.