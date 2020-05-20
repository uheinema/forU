

## TTFont

`import forU.Ttf.TTFont ;`
> Part of [forU](README.md).
- Loads fonts from .ttf files or Bytebuffers.
- Draws their path outlines to an arbitrary [target](#renderers).
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

---

### TTFont delayed constructor
```Java
TTFont(String name) 
```
Register a file source for loading.
The file must exist and memory-mappable to a `ByteBuffer`.
The actual loading is postponed until the font is  used for the first time.
This can be used to preload a font library.
This is the preferred constructor.

Subclasses may 
```Java 
@Override public  ByteBuffer mapFile(String name)
```
to implement other sources (eg. Android assets).

## Rendering


### text
```Java
public float text(String t) 
```
Render the passed text to the current `ShapeCreator` as a sequence of [shape commands](#shapecreator) like `beginShape` , `vertex` etc. 

`"\n"` starts a new line.

 See [textSize and fontSize](#textsize)

~~CodePoints not in the BMP have to be encoded as surrogates according to....[this](http://www.unicode.org/faq//utf_bom.html#utf16-3).~~
Simplified: If you want to display characters with codes that have more than 16 bits (like linear-b DEER 0x10082 𐂂), they have to be represented as two characters in a Java `String` , like 16-bit chars become 2 (or more) in UTF-8.
The utility function  [`utf()`](#utf) will do that for you.
```Java
   myFont.text("linear-b DEER "+utf( 0x10082)+" 0x10082");
```

---
### textSize
```Java
public static float textSize(float t)
```
Set the global text size. Fonts are rendered at this size if no individual `fontSize` was specified.
Returns the previous value.

---
### fontSize
```Java
public float fontSize(float t)
```
Set the font size. Overrides the global font size.
Returns the previous value.

---
### lineFactor

The line gap for a font might not suit your needs.
It can be adjusted by assigning to
```Java
public float lineFactor= 1.0f;
```
Subclasses can also `@Override`
```Java
  public float lineHeight() 
    return 
      (ascent
      - descent // is negative (and too large?!
      +lineGap ) * lineFactor;
  
  }
```

---
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

Individual Glyphs can be  accessed by

---
### size

```Java
public int size() 
```
Returns the number of glyphs in this font.

---
### getGlyph

```Java
public Glyph getGlyph(int index)
```

Return the `Glyph` at `index`.
See [getGlyphIndex](#getglyphindex)

---
### class Glyph methods

### draw

#### Default `ShapeCreator`drawers

```Java
public void draw() // x=0=0
      
    public void draw(float x, float y, float factor) 
      

    public void draw(float x, float y) // factor= 1.0f
    
```

---
#### Specific drawer

```Java
   
    public void draw(ShapeCreator cr, float x, float y, float scale) 
```

Render the Glyph.

### Glyph metrics

Tbw
````
public int xMin, xMax, yMax, yMin;
    
    
    public float hMetrics;
````


## Character to Glyph mapping

Character (or codepoint) mapping to actual glyphs and information about available mappings are obtained through the `interface`

```Java
interface Cmap {
  int format();
  int getGlyphIndex(int i);
  int getSegments();
  int getSegmentStart(int i);
  int getSegmentEnd(int i);
}
```
implemented by TTFont. This will use the 'best' mapping the font suports, in the order 12, then 4, and 0 as last resort.

Used for eg. creating a character table of a given .ttf file. See [here](#apple).

---
### getGlyphIndex

```Java
int getGlyphIndex(int codepoint);
```
Returns the glyph index for the parameter codepoint.
Return 0 if not resolveable.

---

### format

```Java
int format();
```
Returns the type of mapping table

---
### getSegments

```Java
  int getSegments();
```
 
 ---
### getSegmentStart

```Java
int getSegmentStart(int i);
```

---
### getSegmentEnd
 
 ```Java
  int getSegmentEnd(int i);
```



## Renderers

As TFont is independend and agnostic of an actual graphics environment, an `interface` is needed. 

---
### ShapeCreator
```Java
public interface ShapeCreator {
      void createShape(); // at start of text
      void beginShape(); // for each glyph
      void vertex(float x,float y);
      void endShape(int mode); // always CLOSE==2
      void quadraticVertex(float cx, float cy, float x,float y);
      void curveVertex(float x,float y); // not used by ttf
      void beginContour(); // glyph holes or components,
      void endContour();
    }
```
In the most simple case, just pass them on to whatever ' canvas' or ' graphics context' or..
[PGraphics](src/Ttfsrc/ShapeDrawer.java)

See the  [Ttf wrapper class for Processing](Ttf.md) for examples.

---
### writeTo
The rendering targets is set by
```Java
public ShapeCreator writeTo(ShapeCreator s) 
```
Set the `ShapeCreator` for this font.  
Returns the previous value.

---

### defaultDrawer
```Java
public static void defaultDrawer(ShapeCreator s)
```
  Set the default `ShapeCreator` . This is used if no individual `ShapeCreator` for a font was specified or is `null`.  
Returns the previous value.

 
## Credits

  Based on the work of 
  
#### Steve Hanov

 
 [Let's read a Truetype font file from scratch](http://stevehanov.ca/blog/?id=143)

 [TrueType.ts]( https://gist.github.com/smhanov/f009a02c00eb27d99479a1e37c1b3354)
 > By Steve Hanov  
>  Released to the public domain on April 18, 2020

which has been expanded for OTF by now. 

#### Apple

 [TrueType Reference Manual](
https://developer.apple.com/fonts/TrueType-Reference-Manual/)

#### Unicode
Also the really precise [Unicode FAQ on surrogate encoding]( http://www.unicode.org/faq//utf_bom.html#utf16-3)

#### Sample Fonts

The fonts used in the examples were found flying around on my phone or downloaded from
> This font was downloaded from  
Free Fonts Download 
> http://www.freefontsdownload.net   
> Thank you for download
 
 A treasure trove.
 
## Todo
 
 - [ ] Kerning
 - [ ] Metrics in general
 - [x] Handling of some BIG fonts. (that worked before , fixed)
 - [ ] Some erratic outlines on overlapping round glyphs ( a [Ttf](Ttf.md) issue, actually)
 - [x] Documentation (mostly)
 - [ ] Document logging & other internals
 - [x] Cleanup library & source (ongoing)
 - [x] Examples (very basic)
 - [ ] Example documentation/Tutorial



