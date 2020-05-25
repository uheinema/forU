
import forU.I.*;

Slider wi,he; // box width,height

Switch follow,lights; // as extrs bonus

color backcol=0xff444444;

void setup() {
  fullScreen(P3D);
  textSize(32); // Do this ALWAYS just after fullScreen/size
  // or somehow characters start to diappear

  new UI(this, 80); // default text size
  wi= new Slider("Width #   ",200f);
  wi.range(10f,1500f,1f);
  lights=new Switch("Lights" ,false);
  follow=new Switch("Follow" ,false);
  UI
    .add("Hex", "dump") .br()// just a plain button     
    .add(follow).add(lights)
    .add(wi);
  setupColorSliders(color(77,88,99));
}




void dump() { // gets called when the button is pressed
  UI.toast(
  "Hello world!\n"+
  "0x"+hex(boxcol));
}


void draw() {
  // your drawing code here, eg.
  background(backcol);
  if(lights.state) lights();
  else noLights();
  translate(width/2,height/2);
  float t=millis()*0.0002;
  rotateX(t*3);
  rotateY(t*5);
  rotateZ(t*7);
  if(follow.state) colChange();
  fill(boxcol);
  box(wi.value,400,400);
}




