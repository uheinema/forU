# Ttf

`import forU.Ttf ;`


`class Ttf extends TTFont`
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
in order to be able to access the applications assets (ie. the files stored in your data/ folder) 

The default renderer will be set to draw to  `me.g`, essentialy
```Java
Ttf.defaultDrawer(new ShapeDrawer(me.g));
```

 ---
### Alternative constructor

If more convenient, the constructor
```Java
public Ttf(PApplet _me)
```
can be called instead like
```Java
new Ttf(this);
```

---
## Font creation/loading
  
There are no explicit constructors for a Ttf (ok, there are, but for the benefit of subclasses only)

 Instead, use the following static functions:

---
### createFont

```Java
  static public Ttf createFont(String nick, String filename) 
  
  static public Ttf createFont(String nick, ByteBuffer buffer)
```
Creates the superclass as in the corresponding constructor `new TTFont(filename)` or `new TTFont(buffer)`

Registers the font in the dictionary.

Returns the font registered under `nick`

This font becomes the default font.



## Using fonts with nicknames

### Static methods

---
### get

```Java
static public Ttf get(String nick)
```
Return the font with this nickname previously loaded with `createFont`

If nick is `null`, the default font is returned.

---
```Java
static public Ttf get()
```
Return the default font.

---
### remove
```Java
 static public void remove(String nick) {
```
Remove a named font from the dictionary

---
### textFont

```Java
public static void textFont(String nick) { 
```
Set the default font to `nick`

---
  
 ```Java
 public static void textFont(Ttf t){
```
Set the default font to `t`

---
### text

For rendering the superclass method `text' can be used.
Ttf offers some static helpers for a purely static use, given here as the source:

```Java
   public static float text(Ttf fonttT, String t)
   {
     return fonttT.text(t);
   }
   
   // too bad that static and non-static can not have the same name...
   public static float renderText(String t)
   {
     return get().text(t);
   }
   
   // so back to more processing compatibily
   public static float text(String t,float x,float y)
   { 
     translate(x,y);
     float yex = renderText(t);
     translate(-x,-y); // push/popMatrix are costly
     return yex;
   }
   
   public static float text(String nick, String t)
   {
     return get(nick).text(t);
   }
```

---
### More methods ...
 For other methods see  [TTFont](TTFont.md) .

---

## Using other ShapeCreator classes

### PShapeCreator3D

Extrude text as a 3D `PShape`, texturable.

1. Set up a P3D `PGraphics`as desired, eg. `fill(objcol)` etc.
Then 
```Java
PShapeCreator3D extruder=
    new PShapeCreator3D (g,500,100); // size,depth
  noStroke(); // try to deactivate..
  PShape extruded_text =extruder.text(t);
```
2. The resulting shape can then be manipulated & drawn like any other `PShape` eg.

```Java
  extruded_text.setTexture(img);
  extruded_text.draw(g);
```

---

### PShapeCreator

Creates 2D `PShape`s.
Use like
```Java
PShape getShape(Ttf font, String t, float ts) {
  PShapeCreator sh= new PShapeCreator(g,ts);
  return sh.text(font,t);
}
```
Note that `PShapeCreator` is not part of forU.Ttf, but available as [a normal Processing sketch file PShapeCreator.pde](src/Ttfsrc/PShapeCreator.pde) and extremely verbose.

Use it as an example and base for creating your own `ShapeCreator` subclass.

## Known issues

- [x] Some erratic outlines in 3D shapes
- [ ] Texture mapping for 2D not working (not supported by PGraphics?)
- [ ] Normals for front/back face not ok for some fonts?

## Todo

- [ ] Add textAlign, textWidth,...

---
to be continued 21.05.2020

[Back](README.md)


