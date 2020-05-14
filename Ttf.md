# Ttf

`import forU.Ttf ;`


`class Ttf extends TFont`

The class Ttf is a convenience wrapper of [TTFont](TTFont.md) for use with Processing.

It was developed using APDE on and for an Android phone - useabilty on other platforms is untested.

It shields the user from the `ShapeCreator` interface by providing default implementations for the most common tasks of
- writing to the screen or `PGraphics`
- creating a 2D `PShape`
- extruding to a 3D `PShape`

It also provides a 'nickname' for fonts and keeps a dictionary of them.

All methods from [TTFont](TTFont.md) are still available.

## Initialization

### setup
```Java
 static public void setup(PApplet _me){
 ```
Before any other (static) methods can be used, Ttf needs to know the context.

It must be initialized in the sketchs `setup()` with

```Java
Ttf.setup(this);
```
 
### Alternative constructor

If more convenient, the constructor
```Java
public Ttf(PApplet _me)
```
can be called like
```Java
new Ttf(this);
```
## Font creation/loading
  
There are no explicit constructors for a Ttf. Instead, use the following static functions:

### createFont

```Java
  static public Ttf createFont(String nick, String filename)
```


#### 







Testing ttf.md

[Back](README.MD)


