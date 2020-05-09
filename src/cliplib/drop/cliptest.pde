

Paths tile;

 //ShapeDrawer dr;
GcodeDrawer drg;
ForZen zen;

float k1000=100;

boolean saved=false; 

void mousePressed(){
  if(!saved) drg.open(SD("out.gcode")); 
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

  tile=makeTile(50, 800);
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
  "  :ofci { .>6!1 ./2x2 pround4 .ce $  } ;",

  " :dart { ./3 .b .yvxxv<xv>xyy2v .>xx2yv>yvxxv>xv } .e  ;",
  " :tri { ./2b{vxxyv}{yyv}v } ; ",
  " :aura ./8ie*8 ; ",
  " :aurac { smaller2 circle ./8eieieieie } ; "+
  " :blob (  ( motiv , srect ) checker , ofci ) subpic ;",
  
  " :ofre { ./5 .xxxyy .*2  .>5  ( .>3 , $ ) rotated rect ./4d } ;  "+
  " :rotated { .x2y2 $1 .>>x2y2>> $ } ; ",
  ":dots&circles ( .>6 ( .>16!2 ,  dart /* ./8ededede*5 */ aura aura aura ( ) reserve ) rotated ,  aurac ( ) reserve ) chess ; ",
  ":hatch  { ( .{bvyvx8/6e} ( $ ) .x$ ) $ } ;",
   ":hand { .*$ .bvxv} .L20e ; ",
   " :60 ( $ $ $ $ $ $ ) 10 ;",
   " :tick { .x/13bvx-1ve } ; ",
   " :hatched [ $ limit ( $1 ) hatch ] $ ; ", // again, so we can .e it
   
   ":qmark { x>>/3Y0.5y-2 ( 4 , tri ) hatched .e reserve } ; ",
   ":hmark { x>>/6Y0.5y-2 rect reserve } ;",
   
   ":clock // ( face ) limit and rotate for screen ",
   " {  [ .b  circle limit  center .< ",
   // draw hands
   " { .>$#second   .Y0.2y-2 dart reserve } ",
  " { .>$#minute ( 0.9 ) hand reserve } ",
  " { .>$#hourhand ( 0.7 ) hand reserve } ",
   " { .>$#millis  .x1.2/8  tri  .e reserve } ",
  // hour markers
   "{ ( qmark .>4 ) 4 }",
     "{ ( hmark .>12 ) 12 } ",
   //  "{ ( tick .>60 ) 60 } ",
     " { rim $ } // the face",
   //{ .!0 { .x-1y-1 .*3 rect ( 64 ) hatch } ",
  //  "  .>7 .*2 rim ",
  // "  {  rect ( 7 ) hatch } ",
   "  } ]  circle .e reserve ;",
   ""
};


String[] test2={
  "  rect limit ",
 "  ( *0.4 motiv ,  ofre ) subpic ",
  
   //" dots&circles ",
  
   " :rcirxxxcle {  ( 3 ) cpoly  .ed40 limit } ; ",
  "  { smaller6 ./3!0 (",
 // "       center .>180 rim sboard",
  "        ) clock }", // { .x3y3/3 rect ( 7 ) cpoly .ei58e } ",
  // " dots&circles ",
   " flag ( 10 ) hatch ",
  ""};

void scene() {
  //noLoop();
  stroke(0);
  strokeWeight(3);

  zen.begin();
  zen
 
   .execute(test2) 
   //.end();
   ;
  
    drg.close();
   // zen.dude.setDrawer(dr); // hack
  //  drg=null;
    //noLoop();
  
}     

void draw() {
  background(color(100,saved?100:120,100));
  // translate(100, 100);
  theClip.clear();
 // theClip.add(tile); // it is just an arraylist
  theClip=inflate(tile, -10*k1000); // dont draw on the boarder
  //theClip.add(inflate(tile,-300*k1000));
  fill(200);
  stroke(80);
  strokeWeight(5);
  translate(100, 100);
  fill(255);
  drg.drawRaw(tile, CLOSE);
  translate(0, 1000);
  drg.drawRaw(tile, CLOSE);
  translate(0, -1000);
  scene();
}


class ShapeDrawer implements PathDrawer {
  ShapeDrawer () {
    ;
  };

  void close() {
  };

  void draw(Paths p, int mode) {
    
    if (p.size()>1) {
      println("path: "+p); // never...
      // noLoop();
    }
    for (Path so : p) {
      draw(so, mode);
    }
  }

  void draw(Path pa, int mode) {
    // pushStyle();
    if (mode==CLOSE) {
      //noFill();
    } else
    {
      // noFill();
    }

    beginShape();
    //Point.LongPoint ptt;
    for (Point.LongPoint pt : pa) {
      vertex(pt.x/k1000, pt.y/k1000);
    }
    endShape(mode);

    // popStyle();
  }
}
