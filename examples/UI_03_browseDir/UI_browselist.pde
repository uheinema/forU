
import forU.I.*;

ListButton li; 
Switch sorted;
String path="";

String [] slist;

Label label;

void setup() {
  fullScreen(P3D);
  textSize(32);

  new UI(this, 70); // default text size
  // create ui elements only after UI is initialized!
  //
  li=new ListButton(
   path, // title
   "listSelect");
  li.setLines(14).extend=false;
  sorted=new Switch("sorted","sorted",false);
  label=new Label(path);
  home();
  UI.add(label).br()
    .add("Home", "home") // just a plain button       
    .add(sorted)
    .add(li)  ;
}

void home() { // gets called when the button is pressed
  setPath(sketchPath(""));
}

void sorted(){
  setPath(path);
}


void listSelect (int row) {
  if(row<1)
  { // naive
    int ld=path.lastIndexOf("/");
    setPath(path.substring(0,ld));
  }
  else {
    // as this is sorted, we need to
    // get the original index
    // just sorting thr String[] before
    // setDict is much easier, but for demonstration:
    // indices start at 1!
    setPath(path+"/"+slist[li.get(row-1)-1]);   
    }
}

void setPath(String s){
  path=s;
  label.setText(path);
  slist=listFiles(path,0);
  li.setDict(slist);
  // we could have sorted slist beforehand, but...
  if(sorted.state) li.getDict().sortKeys(); // sort it
  li.txt="..";
  UI.flash(path);
}


void draw() {
  // your drawing code here, eg.
  background(13); // this gets annoying ...frameCount%255);
}



