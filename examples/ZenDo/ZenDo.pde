

  int stop=0;

  String tf="slogan";
  
  String [] fonts={  
    
  //  "uni", "CODE2001.TTF",////"font.ttf", 
  //  "script","AbrazoScriptSSiNormal.ttf"
   
    };
    
  // full A6
  // float twidth=1050  , thigh = 1480, gap=50 ;
  // postcard coding
   float gap=50,twidth=1050-gap-150, thigh=1480-2*gap;
  // float twidth=1050,thigh=1050,gap =20;

Paths tile;

//ShapeDrawer dr;
GcodeDrawer drg;
ForZen zen;


boolean saved=false; 

void mousePressed() {
  if (!saved) drg.open(SD("out2.gcode")); 
  saved=true;
}

Ttf fonttT ;

String savedir="";
String fontdir=""; // used by ForZen....
    

void setup()
{
  String[] zeninit;
  fullScreen(P3D);
  savedir=SD("")+"/"; // trigger permission query
  //listAssets("");
  zeninit=loadLocalStrings("zeninit.txt");
  if(!hadLocal) {
    println("copying fonts etc...");
    copyAssets(savedir,"fonts");
   
  }
  println("hi "+savedir);
  println(new Date());
  
  
 /*
  PrintWriter log=createWriter(savedir+"log.txt");
  log.println("test "+new Date());
  log.close();
  */
  //copyAssets(savedir,"init.txt");
  // dr=new ShapeDrawer(); // bypass gcode
  Ttf.me=this;
  fontdir=savedir+"fonts/";

  for (int i=0; i<fonts.length-1; i+=2) {
   Ttf.loadFont(fonts[i], fontdir+fonts[i+1]);
  }
  

  drg=new GcodeDrawer();

  zen=new ForZen(drg,twidth,gap);
  //zen.verbose(true);
println("got zen");

  tile=//ClipDrawer.
    makeTile(gap,thigh,twidth);
  zen
    .execute(zeninit)
  //  .verbose(true)
    .execute(init);
  ;
  
  fonttT=Ttf.get(tf);
  zen.fonttT=fonttT;
  println("bot setup");
  //noLoop();
}




void scene() {
  //noLoop();
  stroke(0);
  strokeWeight(2);
  noFill();
  //fill(color(123,13,12,12));
  zen.begin();
  zen .execute(testing()) ;
  zen.end(); // finalize ongoing Gcode
  if(--stop==0) noLoop();
}     

void draw() {
  background(color(100, saved?100:120, 100));
  //tile=//ClipDrawer.
  //makeTile(50, 800);
  // theClip.add(tile); // it is just an arraylist
  ClipDrawer.theClip=tile;
  //(ClipDrawer.inflate(tile, -100*k1000)); // dont draw on the boarder
  //theClip.add(inflate(tile,-300*k1000));
  fill(200);
  stroke(80);
  strokeWeight(5);
  translate(20, 20+thigh);
  fill(255);
  drg.drawRaw(tile, CLOSE);
  pushMatrix();
  translate(0, 300);
  strokeWeight(2);
  stroke(0);
  fonttT.textSize(150);
  fill(color(123, 45, 7));
  fonttT.text("ÄüMnpαω\n%$@WÄRTZ*;\n0128AaBCbc\n"+
  "Quick brown");
  popMatrix();
  
  scene();
}



public class ShapeDrawer 
  implements PathDrawer
{
  ShapeDrawer () {
    ;
  };

  public void close() {
    // noLoop();
  };

  public void draw(Paths p, int mode) {  
    for (Path so : p) {
      draw(so, mode);
    }
  }

  public void mark(Path pa, int i, float s) {
    Point.LongPoint pt = pa.get(i);
    rect((float)pt.y/k1000, -1.0*pt.x/k1000, 
      s, s);
  }

  void mvertex(float x, float y) {
    vertex(x, y);
    float s=7;
    line(x-s, y-s, x+s, y+s);
    line(x+s, y-s, x-s, y-s);
  }

  public void draw(Path pa, int mode) {

    if (mode==CLOSE) {
      // noFill();
    } else
    {
      // noFill();
    }

    beginShape();
    for (Point.LongPoint pt : pa) {
      //strokeWeight(sw+=0.5);
      vertex((float)pt.y/k1000, -1.0*pt.x/k1000);
    }
    //  strokeWeight(1);
    endShape(mode);
    // mark(pa,0,60);
    // mark(pa,pa.size()-1,35);
  }
}
