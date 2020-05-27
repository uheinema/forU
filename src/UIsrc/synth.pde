
import processing.sound.*;

// for real synth, use jsyn directly,
// eg. LFO, envelope on a filter...

import com.jsyn.*;


class MidiPlayer extends Button {

// This is an octave in MIDI notes.
int[] seq = { 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72 }; 

// Play a new note every 200ms
int duration = 200;

// This variable stores the point in time when the next note should be triggered
int trigger = 9999999;//millis(); 

// An index to count up the notes
int note = 999; 
boolean repeat=false;
  Synth synth;
  
  public MidiPlayer(Synth synth){
    super();
    w=0;
    this.synth=synth;
  };
  
  public void play(){
    note=-1;
    trigger=0;
  }
  
  public void draw(){
    // tick...
    if(millis()>duration+trigger){
      // nrw note
      trigger=millis();
      note++;
      if(note>=seq.length){
        if(repeat) note=0;
        else return;
      }
      synth.trigger(seq[note]);
    }
  }
}

// Oscillator<?> osc;
LowPass lp;
class Synth extends Actor {
  Slider pitch, att;
  
  
  //Filter<?> fil;
  FreqReceiver hack;
  
  Env env=new Env(me);
  Slider attackTime ;
  Slider sustainTime ;
  Slider sustainLevel ;
  Slider releaseTime ;
  Slider freqLow;
  
  MidiPlayer midi;

  public void trigger(int note){
    hack.freq(midiToFreq(note));
    trigger();
  }
  
  Synth() {
    super(100, 200, 55, 55);
    autoClose=true;
    // Button b= new Button("test","it",this);
    //bind(this);
    pitch=new Slider("p #   ", "set", 400f);
    pitch.range(100f, 4000f).bind(this);
    pitch.logarithmic=true;
//    freqLow=new Slider("p #   ", "set", 400f);
//    freqLow.range(100f, 4000f).bind(this);
//    freqLow.logarithmic=true;
    freqLow=getS("lp #   ", 400f, 100.0, 4000f);
    
    attackTime=getS("at #   ", 0.0400f, 0.001, 0.6);
    releaseTime=getS("re #   ", 0.100f, 0.001, 2.6);
    sustainTime=getS("su #   ", 0.0400f, 0.001, 2.6);
    sustainLevel=getS("le #   ", 0.800f, 0.001, 1);
    midi= new MidiPlayer(this);
    add(midi); // so draw gets called
    label("processing.sound.* demo").
    add(pitch)
      .add(attackTime)
    
      .add(sustainTime)
      .add(sustainLevel)
      .add(releaseTime)
      .add(freqLow)
      //.add(b)
      .add("on", "on", this)
      .add("off", "off", this)
      .add("midi","midi",this)
      ;
    lp=new LowPass(me);
   // osc=new TriOsc(me);
  //  osc.freq(pitch.value);
    lp.freq(freqLow.value);   
    
    
    hack=new FreqReceiver(lp);
    lp.process(hack);
    on();
  }

  void midi(){
    midi.play();    
  }
  
  Slider getS(String name, float v, float l, float h) {
    Slider nn=new Slider(name, "set", v);
    nn.range(l, h);
    nn.bind(this);
    return nn;
  }
   /// https://material.io/resources/icons/?icon=pause&style=round
  void set() {
   // hack.freq(pitch.value);
   lp.freq(freqLow.value);
    //osc.play();
    hack.freq=freqLow.value;
  }

  
  void on() {
    // flash("on");
   // osc.play();
    hack.freq(pitch.value);
    trigger();
  }
  
  void trigger(){
    hack.play();
    env.play(hack, attackTime.value, 
      sustainTime.value, 
      sustainLevel.value, 
      releaseTime.value);
      
  }

  void off() {
    UI.flash("off");
  //  osc.stop();
  }
  

// This helper function calculates the respective frequency of a MIDI note
float midiToFreq(int note) {
  return (pow(2, ((note-69)/12.0))) * 440;
}


}

class FreqReceiver extends TriOsc  {
  // so it is a soundobject...
  LowPass filter;
  float freq=100;
  FreqReceiver(LowPass lp){
    super(UI.me);
    this.filter=lp;
   // super(me);
  }
  //
/*

  @Override public void amp(float amp) {
   // this.amplitude.set(0);
   // stop();
   ampp=amp;
   // osc.amp(amp);
 // filter
  //lp.freq(//UI.me.map(amp,0,1,100,
    // freq);
 //println("amp "+amp);
   super.amp(amp);
  }
*/

/*
		if (Engine.checkAmp(amp)) {

			this.amp = amp;

			if (this.isPlaying()) {

				this.setAmplitude();

			}

		}

	}

 
*/


  
}
