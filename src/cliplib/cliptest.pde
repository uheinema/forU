
String[] test2={
  // 
  " rect limit frames smallclock ",
  " :blub {!1  x4y4 pcircle } ; ",
  " :blab {!0 y5*0.8 ( 3 ) ppoly  .c } ; ",
     // ( inflatecnt , path )  draw reserve
  " :_grow { $ ( m40 ) $1 er }  ;",
  " :groffffwd ; ",
   " :blubL blub P80 ; :blabL blab P80 ;",
  " :groddddwto3 ( 0  , $ ) _grow ( 1 , $ ) _grow ( 2 , $ ) _grow ;",
  " :3blfxddub { smaller4 $ e reserve ( $ ) growto3 } ;",
  " :bla0 ( 0 , $1 , $ ) bla  ; ",
  " :bla1 ( $1 , $ ) bla0 ( 1 , $1 , $ ) bla ; ",
    " :bla2 ( $1 , $ ) bla1 ( 2 , $1 , $ ) bla ; ",
  " :bla3 ( $1 , $ ) bla2 ( 3 , $1 , $ ) bla ; ",
" :bla ( $2 , $1 ) _grow ( $2 , $ ) _grow ; ",
  //"  ( blubL , blabL ) bla0 ",
  " ( blubL , blabL ) bla3",
 // " ( 2 , blubL , blabL ) bla",
  // " ( 3 , blubL , blabL ) bla",
  "  ( srect ,  circle ) chess ",
""};

String[] test2x={
   //  [ ( ) smci limit $ ] ( ) smci reserve
 // " ( smci , dots&circles ) string",
  " :pol7  (  /1.05>$#second ) central  ( 7 ) poly  ;",
   "  :smci {!3  smaller8 rect $ } ; ",
  " rect limit frames smallclock ",
  
  //" ( >$#second , dart d50ed50e  limit ) rotated ",
  // " smallclock",//
   //"  ( ) ofre [ motiv  ] ",
  " :_ins { d9el",   
"   ( .>10 , dots&circles ) rotated } ;",
 " { flag } ",
 //" ofci{ [ e h64 ] } ",
 "{ x2y4 blob  }",
  
 
 
 
  " { pol7 } [ _ins ]  ",
  "  ( .>65*1.4 , h64 ) rotated ", 
  ""};



Paths tile;

//ShapeDrawer dr;
GcodeDrawer drg;
ForZen zen;

float k10f00=100;

boolean saved=false; 

void mousePressed() {
  if (!saved) drg.open(SD("out2.gcode")); 
  saved=true;
}

void setup()
{

  // listAssets("init");
  println("hi");
  //loadStrings(SD("9.csv"));
  // copyAssets("init.txt");
  // dr=new ShapeDrawer(); // bypass gcode
  drg=new GcodeDrawer();

  zen=new ForZen(drg);
  //zen.verbose(true);

  tile=//ClipDrawer.
  makeTile(50, 800);
  zen
    .execute(loadStrings("init.txt"))
    .verbose(true)
    .execute(test1);
  ;
  println("bot setup");
  //noLoop();
}


String[] test1={
  "  :pround4 {  ./2xy .b ( .{xv}>8 ) 8 ( .{xv}>8 ) 3 } ; ", 
  "  :ofci{ { .>6!1 ./2x2 pround4 .ce    ;", 

 
  " :aurac { smaller2 circle ./8eieieieie } ; "+
  " :blob ofci{ [ ( motiv , srect ) checker ] } ;", 
    ":testc { /9xy*4 pcircle ./8eieieieieie reserve }  ;",
  " :ofre { ./5 .xxxyy .*2  .>5  ( .>3 , $ ) rotated srect } ;  "+
  " :rotated { .x2y2 $1 .>>x2y2>> $ } ; ", 
  ":dots&circles ( ",
  "   { smaller8 dart .m10em10ei10e } reserve  ",
  "   ,",
  "   ",
  "   testc ) chess4 ; ", 

  
  ""
};



void scene() {
  //noLoop();
  stroke(0);
  strokeWeight(2);
  noFill();
 // fill(color(123,13,12,12));
  zen.begin();
  zen

    .execute(test2) 
    //.end();
    ;

  drg.close();
  //noLoop();
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
  translate(100, 100+1000);
  fill(255);
  drg.drawRaw(tile, CLOSE);
  translate(0, 1000);
 // drg.drawRaw(tile, CLOSE);
  translate(0, -1000);
  //scale(3);
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
  
  public void mark(Path pa,int i,float s){
    Point.LongPoint pt = pa.get(i);
    rect((float)pt.y/k1000, -1.0*pt.x/k1000,
    s,s);
  }
  
  void mvertex(float x,float y){
    vertex(x,y);
    float s=7;
    line(x-s,y-s,x+s,y+s);
    line(x+s,y-s,x-s,y-s);
  }

 public void draw(Path pa, int mode) {
  
    if (mode==CLOSE) {
     // noFill();
    } else
    {
      // noFill();
    }
    float sw=1;
    beginShape();
    //Point.LongPoint ptt;
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
