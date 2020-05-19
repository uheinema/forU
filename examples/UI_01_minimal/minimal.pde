
import forU.I.*;

void setup() {
  fullScreen(P3D); // or whatever
  new UI(this, 64); // default text size
  UI.add("hello", "world"); // just a plain button
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

void world() { // gets called when the button is pressed
  println("Hello world!");
  UI.flash("Hi!");
}
