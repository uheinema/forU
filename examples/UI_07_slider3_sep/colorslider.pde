
import forU.I.*;



Slider cr,cg,cb; // color sliders


// they look alike, so 
Slider createColorSlider(String t){
  return new Slider(t+" # ","colChange",0f)
    .range(0,255,1f);
}

color boxcol= 0xffbbbbbb;

void setupColorSliders(color bc){
  createColorSliders();
  addColorSliders();
  setColorSliders(bc);
}

void setColorSliders(color bc) {
  boxcol=bc;
  cr.value=red(bc);
  cg.value=green(bc);
  cb.value=blue(bc);
}

void createColorSliders() {
  // fullScreen(P3D);
  cr=createColorSlider("R");
  cg=createColorSlider("G");
  cb=createColorSlider("B");
}

void addColorSliders(){
  UI
    .add(cr)
    .add(cg)
    .add(cb)
    ;
}

void colChange(){
  boxcol=color(cr.value,cg.value,cb.value);
}




