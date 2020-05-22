
class Scroller3D extends Scroller {

  //  String []txt;
  //  float height;
  //  final int ts=50;
  PShapeCreator3D extruder;
  PShape[] lshapes ;


  Scroller3D(String [] tx, float height) {
    super(tx, height);
    extruder=
      new PShapeCreator3D (g, ts, ts/4);  
    extruder.deltaa=0; // hack..use minimal curve resolution
    lshapes  = new PShape[tx.length];
    createShapes();
  }

  //
  //  float pixofs=0;
  //  int lineofs=0;
  //  float flh=777;

  void advance(float pix) {
    pixofs+=pix;
    if (pixofs>ts) {
      pixofs-=ts;
      lineofs++;
      //  if(lshapes.size()>0) lshapes.remove(0);
    }
  }

  void createShapes() {
    for (int i=0; i<lshapes.length; i++) {
      createShape(i);
    }
  }

  PShape createShape(int dl) {
    PShape s=lshapes[dl];
    if (s==null) {

      String tx=txt[dl];
      s=extruder.text(tx);
      // s.enableStyle();//???
     // s.setTexture(moon);
      lshapes[dl]=s;
      
    }
    return s;
  }

  

  void draw(float outhi) {

    if (!x3D.state) {
      super.draw(outhi);
      return;
    }

    g.pushStyle();
    g.pushMatrix();
    //noStroke();
    rota(outhi);

    float y=1;
    int i=0;

    PShape s;
    for (; y<height&&i<100; i++) {
      int dl =(lineofs+i)%txt.length;
      float t=(y-pixofs)/height;
      color c= visualColor(t);
      s=createShape(dl);
      s.setFill(c);
      g.translate(0, ts, 0);
      s.setFill(c);
      s.setStroke(false);
      s.setAmbient(c);
      s.draw(g);
      y+=ts;
    }
    g.popMatrix();
    g.popStyle();
  }
}
