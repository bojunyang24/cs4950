import controlP5.*;
import beads.*;
import org.jaudiolibs.beads.*;

//global vars
ControlP5 p5;
SamplePlayer loop;
SamplePlayer v1;
SamplePlayer v2;


Glide gainGlide;
Gain gain;

BiquadFilter filter;
float FREQ = 600.0;
Glide filterGlide;
float filterLevel;

Glide duckGainGlide;
float duckGainLevel = 0.3;
Gain duckGain;
//end global vars

void setup() {
  size(800,700);
  ac = new AudioContext();
  
  loop = getSamplePlayer("cloudyday.wav");
  loop.setToLoopStart();
  loop.setLoopType(SamplePlayer.LoopType.LOOP_FORWARDS);
  
  v1 = getSamplePlayer("v1.wav");
  v1.pause(true);
  v1.setEndListener(
    new Bead() {
      public void messageReceived(Bead mess) {
        v1.setToLoopStart();
        v1.pause(true);
        filterLevel = determineFilterFreq();
        filterGlide.setValue(filterLevel);
        duckGainGlide.setValue(1.0);
      }
    }
  );
  
  v2 = getSamplePlayer("v2.wav");
  v2.pause(true);
  v2.setEndListener(
    new Bead() {
      public void messageReceived(Bead mess) {
        v2.setToLoopStart();
        v2.pause(true);
        filterLevel = determineFilterFreq();
        filterGlide.setValue(filterLevel);
        duckGainGlide.setValue(1.0);
      }
    }
  );
  
  p5 = new ControlP5(this);
  
  //gain ugen
  gainGlide = new Glide(ac, 0, 250);
  gain = new Gain(ac, 1, gainGlide);
  
  //duck gain ugen
  duckGainGlide = new Glide(ac, 1, 1000);
  duckGain = new Gain(ac, 1, duckGainGlide);
  
  //filter ugen
  filterGlide = new Glide(ac, 0, 250);
  filter = new BiquadFilter(ac, BiquadFilter.Type.HP, filterGlide, 0.8f);
  
  filter.addInput(loop);
  duckGain.addInput(filter);
  gain.addInput(duckGain);
  gain.addInput(v1);
  gain.addInput(v2);
  
  //ControlP5 stuff
  p5.addButton("voice1")
    .setPosition(width / 2 - 50, 80);
  
  p5.addButton("voice2")
    .setPosition(width / 2 - 50, 100);
  
  p5.addSlider("gainSlider")
    .setPosition(width /2 - 75, 50)
    .setWidth(150)
    .setHeight(20)
    .setRange(0,100)
    .setValue(50)
    .setLabel("Master Gain");
  
  ac.out.addInput(gain);
  ac.start();
}

void play(SamplePlayer sp) {
  sp.setToLoopStart();
  sp.start();
}

void voice1() {
  v2.pause(true);
  play(v1);
  
  filterLevel = determineFilterFreq();
  filterGlide.setValue(filterLevel);
  duckGainGlide.setValue(duckGainLevel);
}

void voice2() {
  v1.pause(true);
  play(v2);
  
  filterLevel = determineFilterFreq();
  filterGlide.setValue(filterLevel);
  duckGainGlide.setValue(duckGainLevel);
}

boolean isVoicePlaying() {
  return !v1.isPaused() || !v2.isPaused();
}

float determineFilterFreq() {
  if (isVoicePlaying()) {
    return FREQ;
  } else {
    return 0.1;
  }
}

public void gainSlider(int newGain) {
  gainGlide.setValue(newGain/100.0);
  println("Master Gain set to: " + newGain);
}

void draw() {
  background(0);
}
