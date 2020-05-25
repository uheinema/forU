
// slap on some UI to a minimal sketch

import forU.I.*;

void setup() {
  fullScreen(P3D); 
  new UI(this, 64); // default text size
  UI.add("Hello", "world"); // just a plain button
}

void draw() {
  // your drawing code here, eg.
  background(frameCount%255);
}



void world() { // gets called when the button is pressed
  println("Hello world!");
  UI.flash("Hi!");
}
