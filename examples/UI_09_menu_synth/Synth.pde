
import processing.sound.*;

// for real synth, use jsyn directly,
// eg. LFO, envelope on a filter...

/// import com.jsyn.*;


class MidiPlayer extends Button {
  // extending button so we get a draw() on each frame
  // This is an octave in MIDI notes.
  int[] seq = { 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72 }; 

  // Play a new note every 200ms
  int duration = 200;

  // This variable stores the point in time when the next note should be triggered
  int trigger = 9999999;//millis(); 
  // after 16 minutes, sound off :-)
  // An index to count up the notes
  int note = 9999999; 
  boolean repeat=false;
  Synth synth;

  public MidiPlayer(Synth synth) {
    super();
    w=0;
    this.synth=synth;
  };

  public void play() {
    note=-1;
    trigger=0;
  }

  public void stop() {
    trigger=millis()+999; // ;-) not dead, yet
  }

  public boolean isPlaying(){
   return note<seq.length;
  }
  
  public void draw() {
    // tick...
    if (millis()>duration+trigger) {
      // next note
      trigger=millis();
      note++;
      if (note>=seq.length) {
        if (repeat) note=0;
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

  // I tried to apply an envelope to a filter by suclassing this and that..
  // that's what creates a '70s Moog sound..
  // All to no avail..p.sound. is just not designed for that,
  // it just obscures jsyn and adds stereo stuff 
  // As a luxury class beep generator or wav player 
  // it may have its use, though.
  // So design your own beep:
  Oscillator<?> hack; //  just a TriOsc..

  Env env=new Env(me);
  Slider attackTime ;
  Slider sustainTime ;
  Slider sustainLevel ;
  Slider releaseTime ;
  Slider freqLow;

  MidiPlayer midi;

  public void trigger(int note) {
    hack.freq(midiToFreq(note));
    trigger();
  }

  Synth() {
    super(100, 200, 55, 55);
    autoClose=true;

    freqLow=getS("lowP #   ", 400f, 100.0, 4000f);
    pitch=getS("pitch #   ", 400f, 100.0, 4000f);
    pitch.logarithmic=true; // all should be, just as a demo
    attackTime=getS("att #   ", 0.0400f, 0.001, 0.6);
    releaseTime=getS("rel #   ", 0.100f, 0.001, 2.6);
    sustainTime=getS("sus #   ", 0.0400f, 0.001, 2.6);
    sustainLevel=getS("sle #   ", 0.800f, 0.001, 1);
    midi= new MidiPlayer(this);
    add(midi); // so draw gets called
    label("processing.sound.* BeepMaker").
      add(pitch)
      .add(attackTime)

      .add(sustainTime)
      .add(sustainLevel)
      .add(releaseTime)
      .add(freqLow)
      //.add(b)
      .add("Beep", "on", this)
      .add("Sh.t .p!", "off", this)
      .add("Play", "midi", this)
      ;
    lp=new LowPass(me);
    lp.freq(freqLow.value);   

    hack=new TriOsc(me);
    lp.process(hack);
    // on();
  }

  void midi() {
    midi.play();
  }

  Slider getS(String name, float v, float l, float h) {
    Slider nn=new Slider(name, "set", v);
    nn.range(l, h);
    nn.bind(this);
    return nn;
  }

  void draw(){
    super.draw();
    set();
  }


  void set() {
    if(!midi.isPlaying()) hack.freq(pitch.value);
    lp.freq(freqLow.value);
  }


  void on() {
    hack.freq(pitch.value);
    trigger();
  }

  void trigger() {
    hack.play();
    env.play(hack, attackTime.value, 
      sustainTime.value, 
      sustainLevel.value, 
      releaseTime.value);
  }

  void off() {
    UI.flash("off");
    midi.stop();
    hack.stop();
  }


  // This helper function calculates the respective frequency of a MIDI note
  float midiToFreq(int note) {
    return (pow(2, ((note-69)/12.0))) * 440;
  }
}
