
import forU.I.*;

Slider wi; // box width

Slider cr,cg,cb; // color sliders

Switch follow; // as extrs bonus

// they look alike, so 
Slider createColorSlider(String t,float init){
  return new Slider(t+" # ","colChange",init)
    .range(0,255,1f);
}

color boxcol= 0xffbbbbbb;


void setup() {
  fullScreen(P3D);
  textSize(32); // Do this ALWAYS just after fullScreen/size
  // or somehow characters start to diappear

  new UI(this, 80); // default text size
  wi= new Slider("Width #   ",200f);
  wi.range(10f,1500f,1f);
  cr=createColorSlider("R",red(boxcol));
  cg=createColorSlider("G",green(boxcol));
  cb=createColorSlider("B",blue(boxcol));
  follow=new Switch("Follow" ,false);
  UI
    .add("Hex", "dump") // just a plain button     
    .add(follow)
    .add(wi)
    .add(cr)
    .add(cg)
    .add(cb)
    ;
}

void colChange(){
  boxcol=color(cr.value,cg.value,cb.value);
}


void dump() { // gets called when the button is pressed
  UI.toast(
  "Hello world!\n"+
  "0x"+hex(boxcol));
}


void draw() {
  // your drawing code here, eg.
  background(55);
  translate(width/2,height/2);
  float t=millis()*0.0002;
  rotateX(t*3);
  rotateY(t*5);
  rotateZ(t*7);
  if(follow.state) colChange();
  fill(boxcol);
  box(wi.value,400,400);
  UI.draw();
}

void mousePressed() {
  // UI needs to know
  if (UI.mousePressed()) return ;
  // your code here, if any.
  return;
}


