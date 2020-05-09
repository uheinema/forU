
import processing.sound.*;

import com.jsyn.*;

class Synth extends Actor {
  Slider pitch, att;
  Oscillator<?> osc;
  //Filter<?> fil;
  Env env=new Env(me);
  Slider attackTime ;
  Slider sustainTime ;
  Slider sustainLevel ;
  Slider releaseTime ;

  Synth() {
    super(100, 100, 55, 55);
    autoClose=true;
    // Button b= new Button("test","it",this);
    //bind(this);
    pitch=new Slider("p #   ", "set", 400f);
    pitch.range(100f, 4000f).bind(this);

    pitch.logarithmic=true;
    attackTime=getS("at #   ", 0.0400f, 0.001, 0.6);
    releaseTime=getS("re #   ", 0.100f, 0.001, 2.6);
    sustainTime=getS("su #   ", 0.0400f, 0.001, 2.6);
    sustainLevel=getS("le #   ", 0.800f, 0.001, 1);

    add(pitch)
      .add(attackTime)
      .add(sustainTime)
      .add(sustainLevel)
      .add(releaseTime)
      //.add(b)
      .add("on", "on", this)
      .add("off", "off", this)
      ;
    osc=new TriOsc(me);
    osc.freq(pitch.value);
  }

  Slider getS(String n, float v, float l, float h) {
    Slider nn=new Slider(n, "set", v);
    nn.range(l, h);
    nn.bind(this);
    return nn;
  }

  void set() {
    osc.freq(pitch.value);
    //osc.play();
  }

  void on() {
    // flash("on");
    osc.play();
    env.play(osc, attackTime.value, 
      sustainTime.value, 
      sustainLevel.value, 
      releaseTime.value);
  }

  void off() {
    flash("off");
    osc.stop();
  }
}



