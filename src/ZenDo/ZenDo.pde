
import forU.ClipDraw.*;
import de.lighti.clipper.* ; // get rid of this...
import forU.I.*;
import forU.Ttf.*;

  int stop=0;

  String tf="thin";
  
  String [] fonts={  
    
  //  "uni", "CODE2001.TTF",////"font.ttf", 
  //  "script","AbrazoScriptSSiNormal.ttf"
   
    };
    
  // full A6
   float a6width=1050  , a6height = 1480, gap=100 ;
  // postcard coding
   float twidth=a6width; // -100
   float theight=a6height;
  // float gap=50,twidth=1050-gap-150, thigh=1480-2*gap;
  //float twidth=1050,thigh=1050,gap =20;
  
void postcard(){
  // min 140 90 max 253 125
  if(true)return ;
  twidth=a6width; // -100
  theight=a6height;
  gap=100;
  noStroke();
  fill(0x77A72F2F);
  rectMode(CORNERS);
  float azone = 550 ; // minimal 470
  rect( a6width-150,0,a6width,-a6height); // reserve markup zone
  rect( 0, azone-a6height , 400 ,-a6height );
  rect( 50,azone-a6height, a6width-150,azone+30-a6height);
}


Paths tile;

//ShapeDrawer dr;
GcodeDrawer drg;
ForZen zen;


boolean saved=false; 


Ttf fonttT ;

ListButton li;
Actor a,b;

String savedir="";
String fontdir=""; // used by ForZen....
    

void setup()
{
  String[] zeninit;
  fullScreen(P3D);
  textSize(32); // default is ???
  savedir=sex(); // trigger permission query
  //listAssets("");
  zeninit=loadLocalStrings("zeninit.txt");
  //if(!hadLocal) 
  {
    //println("copying fonts etc...");
    copyAssets("fonts"); // 
  }
  println("hi "+savedir);
  println(new Date());
  
  Ttf.me=g;
  fontdir=savedir+"fonts/";

  for (int i=0; i<fonts.length-1; i+=2) {
   Ttf.loadFont(fonts[i], fontdir+fonts[i+1]);
  }
  

  drg=new GcodeDrawer();
  
  
  
  zen=new ForZen(drg,twidth,gap);
  //zen.verbose(true);
println("got zen");

  tile=//ClipDrawer.
    makeTile(gap,theight,twidth);
  zen
    .execute(zeninit)
  //  .verbose(true)
    .execute(init);
  ;
  
  fonttT=Ttf.get(tf);
  zen.fonttT=fonttT;
  
  
  /*
  //
  // user interface
  //
  */
  
  new UI(this, 64);
  li= new ListButton( "Defined:", "",
    zen.defined()
    , 10);
  li.collapse(true); // later..
  // Text tf=new Text("bla");
  adjust=new Switch("Pen adjust ",true);
  a= new Actor();
  a.add("Save","saveG").add("world","world");
  //a.add(tf);
   a.add(adjust).add(li);
  //new DragBack().act();
  a.show();
  //a.draw(); // determins initial size, so we can align
  // not needed if aligning later
 // a.align(TOP).align(CENTER);
  println("bot setup");
 //noLoop();
}

void saveG(){
  println("saving...");
  drg.open(sex("out2.gcode")); 
  scene(lastt);
  saved=true;
 
}



void world(){
  println("Hello");
  toast("Hello world!");
}

float lastt=0;

void scene(float t) {
  // postcard reserve
  lastt=t;
  postcard();
  stroke(0);
  strokeWeight(2);
  noFill();
  //fill(color(123,13,12,12));
  ClipDrawer.theClip=tile;
  zen
   .begin(t)
   .execute(testing()) 
   .end(); // finalize ongoing Gcode
  if(--stop==0) noLoop();
}     

void draw() {
  int ts=150;
  //background(
  fill(color(100, saved?100:120, 100));
  rect(0,0,width,height);
  stroke(80);
  strokeWeight(5);
  translate(20, a.height() +a.textHeight() +theight);
  fill(255);
  drg.drawRaw(tile, CLOSE);
  
  pushMatrix();
  translate(0, ts);
  strokeWeight(2);
  stroke(0);
  fonttT.textSize(ts);
  fill(color(123, 45, 7));
 fonttT.text("ÄüMnpαω\n%$@WÄRTZ*;\n0128AaBCbc\n"+"Quick brown");
  popMatrix();
 
  scene(millis());
 // a.align(BOTTOM); // to fix it there
  UI.draw();
  
}


void keyPressed() {
  //handledBackPressed=true; // seems to exist...
  Keyboard.keyPressed(key, keyCode);
}


void mousePressed() {
  if (UI.mousePressed()) return ;
  if (isLooping()) {  
    noLoop();
  } else
    loop();
    
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

  

  public void draw(Path pa, int mode) {

    if (mode==CLOSE) {
      // noFill();
    } else
    {
      // noFill();
    }

    beginShape();
    for (Point.LongPoint pt : pa) {
      vertex((float)pt.y/k1000, -1.0*pt.x/k1000);
    }
    endShape(mode);
  
  }
}
