import controlP5.*;
import beads.*;
import org.jaudiolibs.beads.*;

SamplePlayer sp;
ControlP5 p5;

WavePlayer wp;
Gain g;

Glide gainGlide;
Glide frequencyGlide;



void setup() {
  size(500, 400); 
  ac = new AudioContext(); 
  p5 = new ControlP5(this);
  sp = getSamplePlayer("sound.wav");

  gainGlide = new Glide(ac, 1.0, 50);
  frequencyGlide = new Glide(ac, 440.0, 50);
  
  //create waveplayer with frequencyglide
  wp = new WavePlayer(ac, frequencyGlide, Buffer.SINE);
  
  //create gain object
  g = new Gain(ac, 1, gainGlide);
  
  //connect waveplayer to gain input
  g.addInput(wp);
  
  //connect correct sound to gain
  g.addInput(sp);
  
  sp.pause(true);
  wp.pause(true);

  ac.out.addInput(g);


  //create buttons and sliders
  p5.addButton("jab")
    .setPosition(width/2 - 80, height/2)
    .setLabel("Assess Jab");
    
  p5.addButton("hook")
    .setPosition(width/2, height/2)
    .setLabel("Assess Hook");

  p5.addButton("crosses")
    .setPosition(width/2-80, height/2 + 30)
    .setLabel("Assess Cross");
    
  p5.addButton("uppercut")
    .setPosition(width/2, height/2 + 30)
    .setLabel("Assess Uppercut");
    
  p5.addSlider("gainSlider")
    .setPosition(width / 2 - 50, 50)
    .setWidth(100)
    .setHeight(20)
    .setRange(0, 100)
    .setValue(50)
    .setLabel("Power");
  
  p5.addSlider("freqSlider")
    .setPosition(width / 2 - 50, 80)
    .setWidth(100)
    .setHeight(20)
    .setRange(20, 1000)
    .setValue(440.0)
    .setLabel("Speed");
    
}


void draw() {
  background(0);
  //make waveplayer stop after 1.5 seconds
  if (ac.getTime() >= 1500.0) {
    ac.stop();
    sp.reset();
    ac.reset();
  }
}

//jab function
//if gain(power) is greater than 0.4 and frequency(speed) is over 500, play good sound
//if not, then play waveplayer with corresponding frequency and gain
public void jab(int value) {
  println("jab");
  println(gainGlide.getValue());
  println(wp.getFrequency());
  if (g.getGain() >= 0.4 && wp.getFrequency() >= 900) {
    sp.pause(false);
    wp.pause(true);
  } else {
    sp.pause(true);
    wp.pause(false);
  }
  ac.start();
}

//hook function
//if gain(power) is greater than 0.8 and frequency(speed) is over 300, play good sound
//if not, then play waveplayer with corresponding frequency and gain
public void hook(int value) {
  println("hook");
  if (g.getGain() >= 0.8 && wp.getFrequency() >= 500) {
    sp.pause(false);
    wp.pause(true);
  } else {
    sp.pause(true);
    wp.pause(false);
  }
  ac.start();
}

//cross function
//if gain(power) is greater than 0.6 and frequency(speed) is over 400, play good sound
//if not, then play waveplayer with corresponding frequency and gain
public void crosses(int value) {
  println("cross");
  if (g.getGain() >= 0.6 && wp.getFrequency() >= 700) {
    sp.pause(false);
    wp.pause(true);
  } else {
    sp.pause(true);
    wp.pause(false);
  }
  ac.start();
}

//uppercut function
//if gain(power) is greater than 0.8 and frequency(speed) is over 300, play good sound
//if not, then play waveplayer with corresponding frequency and gain
public void uppercut(int value) {
  println("uppercut");
  if (g.getGain() >= 0.8 && wp.getFrequency() >= 500) {
    sp.pause(false);
    wp.pause(true);
  } else {
    sp.pause(true);
    wp.pause(false);
  }
  ac.start();
}

//functions for sliders
public void gainSlider(float value){
  gainGlide.setValue(value/100.0);
  g.setGain(value/100.0);
}

public void freqSlider(float value){
  frequencyGlide.setValue(value);
  wp.setFrequency(value);
}
