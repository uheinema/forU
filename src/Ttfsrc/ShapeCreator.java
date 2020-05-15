/***************************************************************************************
 * forU.Ttf
 * Copyright (c) 2019-2020 by the author
 * @author Ullrich Heinemann , https://github.com/uheinema
 *
 * All rights reserved. 
 * A simple, platform-agnostic library for handling TrueType fonts.
 * Released under the terms of the GPLv3, refer to: http://www.gnu.org/licenses/gpl.html
 ***************************************************************************************/
package forU.Ttf;
// will be called to draw/extrude/..a ttf outline

public interface ShapeCreator {
      void createShape(); // at start of text
      void beginShape(); // for each glyph
      void vertex(float x,float y);
      void endShape(int mode);
      void quadraticVertex(float cx, float cy,
        float x,float y);
      void curveVertex(
        float x,float y);
      void beginContour(); // glyph holes or components,
      void endContour();
    }

