

class Scroller {

  String []txt;
  float height;
  final int ts=80;
  PShapeCreator3D extruder;
  //boolean nati=true;

  Scroller(String [] tx, float height) {
    this.txt=tx;
    this.height=height;
    extruder=
      new PShapeCreator3D (g, ts, ts/4);
  }

  float pixofs=0;
  int lineofs=0;
  float flh=777;

  void advance(float pix) {
    pixofs+=pix;
    if (pixofs>flh) {
      pixofs-=flh;
      lineofs++;
    }
  }

  color visualColor(float t) {
   // return color(255);
    float a;
    a=(t<0.5)?(t*2):1;
    color c=color(255, 255, 155, a*255);
//    if (g.fill)
//      fill(c);
//    if (g.stroke) {
//      stroke(c);
//    }
    return c;
  }

  void rota(float outhi) { // for @Override
    translate(outhi/5, outhi, 0);
    rotateX(0.41*PI);
    scale(0.71, 4.55, 1);
    translate(0, -pixofs, 0);
  }

  void draw(float outhi) {

    pushStyle();
    pushMatrix();
    //noStroke();
    rota(outhi);

    int li=lineofs;
    float y=1;
    if (nati.state) 
      textSize(ts);
    else
      Ttf.textSize(ts);
    for (int i=0; y<height&&i<100; i++) {
      color c=visualColor((y-pixofs)/height);

      //   stroke( 255*(y/height));
      String t=txt[(li+i)%txt.length];
      float h=ts;
      if (nati.state) {
        fill(c);
        noStroke();
        text(t, 0, y);
      }
      else 
      {
        stroke(c);
        noFill();
        Ttf.text(t+"\n", 0, y);
      }
      if (i==0) flh=h;
      y+=h;
      //   translate(0, h, 0);
    }
    popMatrix();
    popStyle();
  }
}
