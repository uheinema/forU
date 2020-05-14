# Ttf

`import forU.Ttf ;`


`class Ttf extends TFont`
> Part of [forU](README.md).
The class Ttf is a convenience wrapper of [TTFont](TTFont.md) for use with Processing.

It was developed using APDE on and for an Android phone - useabilty on other platforms is untested.

It shields the user from the `ShapeCreator` interface by providing default implementations for the most common tasks of
- writing to the screen or `PGraphics`
- creating a 2D `PShape`
- extruding to a 3D `PShape`

It also provides a 'nickname' for fonts and keeps a dictionary of them.

The method `mapFile` is overloaded to  enable font loading from Android assets.

All methods from [TTFont](TTFont.md) are still available.

## Initialization

### setup
```Java
 static public void setup(PApplet _me){
 ```
Before any other  methods can be used, Ttf needs to know the context.

It must be initialized in the sketchs `setup()` with

```Java
Ttf.setup(this);
```
The default renderer will be set to draw to  me.g, essentialy
```Java
Ttf.defaultDrawer(new ShapeDrawer(me.g));
```
 
### Alternative constructor

If more convenient, the constructor
```Java
public Ttf(PApplet _me)
```
can be called instead like
```Java
new Ttf(this);
```
## Font creation/loading
  
There are no explicit constructors for a Ttf (ok, there are, for the benefit of.subclasses only)

 Instead, use the following static functions:

### createFont

```Java
  static public Ttf createFont(String nick, String filename) 
  
  static public Ttf createFont(String nick, ByteBuffer buffer)
```
Create the superclass as in the corresponding constructor `new TTFont(filename)` or `new TTFont(buffer)`

.Returns the font registered under `nick`
This font becomes the default font.

## Using fonts with nicknames

### Static methods


### get

```Java
static public Ttf get(String nick)
```
Return the font with this nickname previously loaded with `createFont`
~~If nick is `null`, the default font is returned.~~

```Java
static public Ttf get(String nick)
```
Return the default font.

### remove
```Java
 static public void remove(String nick) {
```
Remove a named font from the dictionary

### textFont

```Java
public static void textFont(String nick) { 
```
Set the default font to `nick`
  
 ```Java
 public static void textFont(Ttf t){
```
Set the default font to `t`

## For other methods see  [TTFont](TTFont.md) .


## Using other ShapeCreator classes

### Extrude text with PShapeCreator3D

Set up a P3D `PGraphics`as desired, eg. `fill(objcol)` etc.
Then 
```Java
PShapeCreator3D extruder=
    new PShapeCreator3D (g,500,100); // size,depth
  noStroke(); // try to deactivate..
  PShape extruded_text =extruder.text(t);
```
The resulting shape can then be manipulated & drawn like any other `PShape` eg.

```Java
  extruded_text setTexture(img);
  extruded_text.draw(g);
```


Testing ttf.md

[Back](README.MD)


