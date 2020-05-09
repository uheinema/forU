
// will be called to draw/extrude/..a ttf outline

interface ShapeCreator {
      void createShape(); // at start of text
      void beginShape(); // for each glyph
      void vertex(float x,float y);
      void endShape(int mode);
      void quadraticVertex(float cx, float cy,
        float x,float y);
      void curveVertex(
        float x,float y);
      void beginContour(); // glyph holes
      void endContour();
    }

