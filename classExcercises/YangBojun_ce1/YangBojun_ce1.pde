import controlP5.*;
import beads.*;
import org.jaudiolibs.beads.*;

//declare global variables at the top of your sketch
//AudioContext ac; is declared in helper_functions
Gain g;

ControlP5 p5;

SamplePlayer buttonSound;

Glide gainGlide;
Glide cutoffGlide;

BiquadFilter lpFilter;

//end global variables

//runs once when the Play button above is pressed
void setup() {
  size(800,700);
  //size(320, 240); //size(width, height) must be the first line in setup()
  ac = new AudioContext(); //AudioContext ac; is declared in helper_functions
  p5 = new ControlP5(this);
  
  buttonSound = getSamplePlayer("searching.wav");
  buttonSound.pause(true);
  
  // Create Gain and Glide UGens
  gainGlide = new Glide(ac, 1.0, 50);
  g = new Gain(ac, 1, gainGlide);
  cutoffGlide = new Glide(ac, 200.0, 50);
  
  lpFilter = new BiquadFilter(ac, BiquadFilter.AP, cutoffGlide, 0.5f);
  lpFilter.addInput(buttonSound);
  g.addInput(lpFilter);
  g.addInput(buttonSound);
  ac.out.addInput(g);
  ac.out.addInput(lpFilter);
  
  p5.addSlider("GainSlider")
    .setPosition(20, 20)
    .setSize(20, 200)
    .setRange(0, 100)
    .setValue(50)
    .setLabel("Gain");
  
  p5.addSlider("CutoffSlider")
    .setPosition(70, 20)
    .setSize(20, 200)
    .setRange(0.0, 21150.0)
    .setValue(200.0)
    .setLabel("Cutoff Frequency");
  
  p5.addButton("Play")
    .setPosition(width / 2 - 20, 110)
    .setSize(width / 2 - 20, 20)
    .activateBy((ControlP5.RELEASE));
    
  p5.addButton("NoFilter")
    .setPosition(width / 2 - 20, 160)
    .setSize(width / 2 - 20, 20)
    .setLabel("No Filter");
    
  p5.addButton("HighPassFilter")
    .setPosition(width / 2 - 20, 135)
    .setSize(width / 2 - 20, 20)
    .setLabel("High Pass Filter");
  
  ac.start();
  
}

public void Play(int value) {
  println("play button pressed");
  buttonSound.setToLoopStart();
  buttonSound.start();
}

public void CutoffSlider(float value) {
  cutoffGlide.setValue(value);
}

public void NoFilter() {
  lpFilter.setType(BiquadFilter.AP);
}

public void HighPassFilter() {
  lpFilter.setType(BiquadFilter.HP);
}

public void GainSlider(float value) {
  gainGlide.setValue(value/100.0);
}


void draw() {
  background(0);  //fills the canvas with black (0) each frame
  
}
