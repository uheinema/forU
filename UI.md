

# forU.I





`import forU.I.* ;`

> Part of [forU](README.md).

Tbw.

For now, have a look at the 

# Examples

## UI_01_minimal

Minimal UI.
Just a ~~Butter~~ `Button` (and toast)

## UI_02_listAssets

UI with a `ListButton` showing a subdirectory of your assets, in this case `shaders`, as it always exists.
For fun, look at "" instead...on my phone dozens of files show up, probably somehow injected by Huawei...
And note that in Preview you will NOT find your own assets this way.  
See TTF_UI_04_selectfont.

## UI_03_browseDir

Previous example expanded, shows the internal storage aka. `sketchPath()` directories you can access.
Not so interesting as an app, but try it in Preview...

Introduces 
- an optionally sorted `ListButton` with changing contents.
- a `Switch` to control sorting
- your first example subclass of `Button`, a Label to display longish pathes (feel free to find a more reasonable way to display/split it.(class File?) Let me know.)


## TTF_01_minimal

Demonstrates a minimal environment for using Ttf.
Displays a static text with outlines.
Uses stencil.ttf

## TTF_02_glyphs

Demonstrates individual glyph access.
Displays the glyphs (fast!  change frameRate(()  
Pause and continue by tapping.

Uses damase_v.2.ttf, which has 2895 glyphs.


## TTF_03_PShape3D

Demonstrates creation of 3D shapes and texturing them.

Displays rotating "Hello World"

![shape3d](shape3d.jpg)

Uses Arkhip_font.ttf and jupiter.jpg as texture.

## TTF_UI_04_selectfont

Brings together Ttf and UI with a font selectable from a simple list.

Demonstrates consistently listing & loading fonts (or other data) from an asset subdirectory  in APDE Preview and APP.

Be warned:
 - In Preview, you will see (and  use (and crash if no font or not readable by TTFont)) all/many of the files you ever had in data/fonts since last reinstall.  
 Call it a feature, and/or praise/blame Calsign  
  (@Calsign: It should delete these each start, or at least the docs/comments say so? They for sure get overwritten. Not important...)  
 Maybe I will write some cleanup tool sometimes.  
 Remove the filter and see.
 
 - As an app, we go directly to the assets...it's the law, it's OK, it is inefficient.

Includes (and needs)  FixApplet.pde, read it.

Also provides `listAsset.pde` and `listFiles.pde` to get the contents list of an asset or normal subfolder, respectively, and
`listAssetsX() // in FixApplet.pde`
which will sort that out for you .

Demonstrates an easier way to sort (and filter) 
`ListButton` contents, see UI_03_browseDir.

## UI_05_slider1

Shows a rotating box.
Introduces a `Slider`  to control the width of one dimension.

## UI_06_slider2

Adds
- Three more sliders to control the RGB color of the box.
- A `Switch`  'Follow' controling when the change is applied.

Demonstrates interaction and accessing the values of `Switch` ( `mySwitch.state` ) and `Slider` (  `mySlider.value` ).

## UI_07_slider3_sep

Builds on the above, separeted into two files:

- `UI_slider3.pde` - 
- `colorsliders.pde`

in preparation for

## UI_08_color_popup

If we want to control more than one color things get ugly, and our UI gets crowded, so:

- Demonstrates easy  conversion of a group of controls into a popup dialog.
 - As a bonus, copies the color definition to the Android clipboard  
Thanks to
 https://github.com/EmmanuelPil/Android-java-code-utilities-widgets-for-Processing-for-Android

---

TBC....



