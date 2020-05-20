
import forU.I.*;

ListButton li; 
String path="shaders"; // should always be there
// try path= "" 
String [] slist;

void setup() {
  fullScreen(P3D);
  textSize(32); // Do this ALWAYS just after fullScreen/size
  // or somehow characters start to diappear

  new UI(this, 80); // default text size
  slist=listAssets(path,NODIRS);
  // create ui elements only after UI is initialized!
  li=new ListButton(
    "--- Fold/unfold ---", // title
   "liSelect",  // action
    slist, // content
    20); // number of lines
  UI
    .add("close", "world") // just a plain button     
    .add(li)
    ;
}

void liSelect (int row) {
  
  UI.flash("selected "+row+"\n"+
    ((row>=1) ?slist[row-1]:"Title"));
  li.txt="-- selected "+row+" --";
}

void world() { // gets called when the button is pressed
  UI.toast("Hello world!");
  li.collapse(true);
  li.txt="Tap to reopen...";
}


void draw() {
  // your drawing code here, eg.
  background(frameCount%255);
  UI.draw();
}

void mousePressed() {
  // UI needs to know
  if (UI.mousePressed()) return ;
  // your code here, if any.
  return;
}


