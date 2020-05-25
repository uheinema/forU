
import forU.I.*;

Slider wi; 

void setup() {
  fullScreen(P3D);
  textSize(32); // Do this ALWAYS just after fullScreen/size
  // or somehow characters start to diappear

  new UI(this, 64); // default text size
  wi= new Slider("Width #   ",200f);
  wi.range(10f,1500f,1f);
  UI
    .add("hello", "world") // just a plain button     
    .add(wi)
    ;
}

void world() { // gets called when the button is pressed
  UI.toast("Hello world!");
}

void draw() {
  // your drawing code here, eg.
  background(55);
  translate(width/2,height/2);
  float t=millis()*0.0002;
  rotateX(t*3);
  rotateY(t*5);
  rotateZ(t*7);
  box(wi.value,400,400);
}


