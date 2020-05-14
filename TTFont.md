

## TTFont

`import forU.Ttf.TTFont ;`

- Loads fonts from .ttf files or Bytebuffers.
- Draws their path outlines to an arbitrary [target](#rendering).
- Has no dependencies except `java.util.*`,  `java.io.*` and `java.nio.*` and should be useable on any platform! 
- Supports [ UTF32 ](#utf) 𐂂

## Constructors

### TTFont direct constructors
```Java
TTFont(ByteBuffer buffer) 
TTFont(InputStream imp)
```
Load the header information for this font from the supplied buffer or stream.
Glyphs are loaded on demand, so these must persist unmodifiied as long as the font is used.

### TTFont delayed constructor
```Java
TTFont(String name) 
```
Register a file source for loading.
The file must exist and mappable to a `ByteBuffer`.
The actual loading is postponed until the font is  used for the first time.
This can be used to preload a font library.

Subclasses may 
```Java 
@Override public  ByteBuffer mapFile(String name)
```
to implement other sources.

## Rendering

### text
```Java
public float text(String t) 
```
Render the passed text to the current `ShapeCreator` as a sequence of shape commands like `beginShape` , `vertex` etc. 
~~CodePoints not in the BMP have to be encoded as surrogates according to....[this](http://www.unicode.org/faq//utf_bom.html#utf16-3).~~
Simplified: If you want to display characters with codes that have more than 16 bits (like linear-b DEER 0x10082 𐂂), they have to be represented as two characters in a Java `String` , like 16-bit chars become 2 (or more) in UTF-8.
The utility function  [`utf()`](#utf) will do that for you.


### setSize
```Java
public static float textSize(float t)
```
Set the global text size. Fonts are rendered at this size if no individual `fontSize` was specified.
Returms the previous value.

```Java
public float fontSize(float t)
```
Set the font size. Overrides the global font size.
Returns the previous value.

### utf
```Java
public static String utf(int C)
```
Return a `String` for codepoints beyond 0x10000

```Java
utf(0x10082)   - \uD800\uDC82 𐂂
utf(0x10A20) - \uD802\uDE20
```

## Glyphs

Todo

## Renderers

As TFont is independend and agnostic of an actual graphics environment, an `interface` is needed.

### ShapeCreator
```Java
public interface ShapeCreator {
      void createShape(); // at start of text
      void beginShape(); // for each glyph
      void vertex(float x,float y);
      void endShape(int mode);
      void quadraticVertex(float cx, float cy,  float x,float y);
      void curveVertex(float x,float y); // not called
      void beginContour(); // glyph holes or components,
      void endContour();
    }
```
In the most simple case, just pass them on to whatever ' canvas' or ' graphics context' or..
[PGraphics](src/TrueWords/ShapeDrawer.java)

See the  [Ttf wrapper class for Processing](Ttf.md) for examples.

### writeTo
It is set by
```Java
public ShapeCreator writeTo(ShapeCreator s) 
```
Set the `ShapeCreator` for this font. 
Returns the previous value.

### defaultDrawer
```Java
public static void defaultDrawer(ShapeCreator s)
```
  Set the default `ShapeCreator` . This is used if no individual `ShapeCreator` was specified or is `null`
Returns the previous value.
  
## Credits

  Based on the fantastic work of 
  
#### Steve Hanov:

 
 [Let's read a Truetype font file from scratch](http://stevehanov.ca/blog/?id=143)

 [TrueType.ts]( https://gist.github.com/smhanov/f009a02c00eb27d99479a1e37c1b3354)
 > By Steve Hanov
>  Released to the public domain on April 18, 2020

#### Apple

 [TrueType Reference Manual](
https://developer.apple.com/fonts/TrueType-Reference-Manual/)

#### Unicode
Also the really precise [Unicode FAQ on surrogate encoding]( http://www.unicode.org/faq//utf_bom.html#utf16-3)
 
## Todo
 
 - Kerning
 - Metrics in general
 - Handling of some BIG fonts.
 - Documentation .
 - Examples



