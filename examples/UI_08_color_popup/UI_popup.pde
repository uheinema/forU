
import forU.I.*;

Slider wi; // box width

Switch lights; // as extrs bonus
//  http://www.sojamo.de/libraries/oscP5
ColorSliders backcol, boxcol;

void setup() {
  fullScreen(P3D);
  textSize(32); // Do this ALWAYS just after fullScreen/size
  // or somehow characters start to diappear

  new UI(this, 80); // default text size
  wi= new Slider("Width #   ",200f);
  wi.range(10f,1500f,1f);
  lights=new Switch("Lights" ,false);
  boxcol=new ColorSliders("box",color(177,188,99),150,400);
  backcol=new ColorSliders("background",color(0x66),50,400);
  backcol.align(BOTTOM);
  UI
    .add(lights)
    .add(wi)
    .add("BackCol","backcol")
    .add("BoxCol","boxcol");
    
}

void backcol(){
  backcol.show();
}

void boxcol(){
  boxcol.show();
}

void dump() { // gets called when the button is pressed
  UI.toast(
  "Hello world!\n"+
  "0x"+hex(boxcol.get()));
}


void draw() {
  // your drawing code here, eg.
  background(backcol.get());
  if(lights.state) lights();
  else noLights();
  translate(width/2,height/2);
  float t=millis()*0.0002;
  rotateX(t*3);
  rotateY(t*5);
  rotateZ(t*7);
  
  fill(boxcol.get());
  box(wi.value,400,400);
  UI.draw();
}

void mousePressed() {
  // UI needs to know
  if (UI.mousePressed()) return ;
  // your code here, if any.
  return;
}


