



import forU.I.*;
import java.net.*;
 

Text tf=new Text("Enter");
///I wtf=new UI(this,56);

ColorPicker bgcolor;
  

String
  q="printer/tool";

void connect() {
  octo.connect();
}

void octo() {
  octo.get(q);
}

Octo octo=new Octo();

void setup()
{
  //println("top setup");
  fullScreen(P3D);
  textSize(32);

  new UI(this, 64);
 
 bgcolor= new ColorPicker(color(230));
  
 // tf=new Text("Enter");
  //Actor a= UI.tos();// new Actor();
  UI.add("choose", "choose")
    .add("simple", "simple").br()
    .add("octo", "octo")
    .add("connect", "connect")
    .add("color","pick")
    .add("synth", "test")
  //  .add(bgcolor)
    .add(tf);
  // addli(a);
  // new DragBack().show();
  //a.show();

}




void pick() {
  bgcolor.show();
}

void choose(int p) {
  //flash("Hi "+p);

  showFileChooser();
}



Synth synth;

void test() {
  if (synth==null)
    synth=new Synth();
  synth.show();
}

void draw() {
  background(bgcolor.get());
  // do your own
  textSize(150);
  text("frame "+frameCount+"\n"+
   tf.get(),
    20,height/2);
 // a.align(CENTER);
  UI.draw();
}

void mousePressed() {
  if (UI.mousePressed()) return ;
  return;
}

void keyPressed() {
  UI.keyPressed(key, keyCode);
}

@Override
  void onBackPressed() {
  flash("ttfn");
  UI.keyPressed((char)CODED, 4);

  handledBackPressed=false;
  // default false terminates
  // true continues!
}


