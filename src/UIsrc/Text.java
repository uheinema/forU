
package forU.I;

import processing.core.PApplet;

public class Text extends Button implements Keyboard.KeyConsumer {
  int cursor;
 
  public  Text(String _txt){
    super(_txt);
    backcolor=200;
    w=PApplet.max(w,600);
    cursor=txt.length();
  }
  
  public void consumeChar(char c)
  {
    switch(c){     
      case '\b': // backspace
         if(cursor==0) return;
         if(txt.length()==0) return; // never..
         txt=txt.substring(0,cursor-1)+
              txt.substring(cursor);
         cursor--;
         break;
      case '\n':
         Keyboard.hide();
         //keyTarget=null; // we are done, for now
         super.mousePressed();
         break;
      default: // insert at cursor
        String t=txt.substring(0,cursor);
        t+=c;
        txt=t+txt.substring(cursor++);
    }
  }
    
   @Override
  public boolean mousePressed(){
    Keyboard.show(this);
    
    int rp=me.mouseX-(x +ts/2);
    // how far into the text?
  // println("click "+rp);
    prepTextStyle();
    int to;
    float last=0;
    for(to=1;to<txt.length()+1;to++){
      float tw=g.textWidth(txt.substring(0,to));
      float twh=(tw-last)/2;   
      if(last+twh>rp)
        break;
      last=tw;
    }  
    
     cursor=to-1;
    return true;
  }
  
  @Override
  public void draw(){
    g.pushMatrix();
    super.draw();
    g.popMatrix();
    //act(x,y);
    if(!Keyboard.hasFocus(this)) return;
    if((me.frameCount/10)%2==0) return;
    // display a blinking cursor
    // g is set for text output
    prepTextStyle();
    String s=txt;
    int tl=s.length();
    if(cursor>tl) cursor=tl;
    float tw=g.textWidth(s.substring(0,cursor));
    g.stroke(textcol);
    g.strokeWeight(PApplet.max(6,ts/10));
    
    float cx=x+tw+ts/2;
    g.line(cx,y+ts/4,cx,y+h-ts/2);    //g.line(x,y,x+100,y+100);
  }
  
  public String get(){return txt;};
  public void set(String s){txt=s;};
   
 } // class textfield
 

