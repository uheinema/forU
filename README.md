# Work in progress, inconsistent! Do NOT fork (yet).

As of now (14.05.2020) I can't seem to push to a private repository, this is public.
Just working on the docs now, standby

# forU

Assorted Libs for APDE


# forU.Ttf

Read and render Truetype fonts.

  - Can read fonts with CMAP formats
    - 12 - Full UTF-32 coverage ( Yep, linear-b)
    - 4 -:UTF-16
    - 0 - ASCII
 - Base class [TTFont]( TTFont.md ) without dependencies.
- Wapper class [Ttf]( Ttf.md ) for Processing/Android/APDE convenient use. Allows to 
  - Draw to any `PGraphics` (with Glyph outline stroked!)
  - Create a 2D `PShape` 
  - Create a 3D extruded `PShape` 
  
  
