

class Scroller {
  
  String []txt;
  float height;
  
  Scroller(String [] tx,float height){
    this.txt=tx;
    this.height=height;
  }
  
  float pixofs=0;
  int lineofs=0;
  float flh=777;
  
  void advance(float pix){
    pixofs+=pix;
    if(pixofs>flh) {
      pixofs-=flh;
      lineofs++;
    }
  }
  
  void draw(){
    pushStyle();
    pushMatrix();
    noStroke();
    fill(128);
    translate(200,1000,0);
    rotateX(0.4*PI);
    scale(1,5,1);
    translate(0,-pixofs,0);
    int li=lineofs;
    float y=1;
    Ttf.
    textSize(50);
  //  clip(50,50,600,height-50);
    for(int i=0;y<height&&i<100;i++){
      fill(128+128*(y/height));
      String t=txt[(li+i)%txt.length];
      float h=50;
     h=Ttf.get().
        text(t+"\n"
      // , 0,0
       );
      
      if(i==0) flh=h;
      
      y+=h;
      translate(0,h,0);
    }
    popMatrix();
    popStyle();
  }
}


void segs(){
  //draw();
  //noLoop();
  println("segs:");
  println(fontT.bmap());
  
  for(int i=0;i<fontT.getSegments();i++){
    int ss=(fontT.getSegmentStart(i));
    println("seg "+i+": "+hex(fontT.getSegmentStart(i))+
     " "+(fontT.getSegmentEnd(i)+1-ss)
     );
  }
  
 }
 
 
 





