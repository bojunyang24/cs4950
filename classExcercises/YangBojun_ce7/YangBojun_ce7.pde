// FFT_01.pde
// This example is based in part on an example included with
// the Beads download originally written by Beads creator
// Ollie Bown. It draws the frequency information for a
// sound on screen.
import controlP5.*;
import beads.*;
import org.jaudiolibs.beads.*;

ControlP5 p5;
Glide cutoffGlide;
BiquadFilter filter;
UGen micIn;
ShortFrameSegmenter sfs;
ShortFrameSegmenter sfsMic;
SamplePlayer loop;
Reverb r;
//Glide roomSizeGlide;
//Glide dampingGlide;
//Glide lateReverbGlide;

PowerSpectrum ps;
color fore = color(0, 255, 70);
color back = color(0,0,0);
void setup() {
  size(600,600);
  ac = new AudioContext();
  
  //reverb
  r = new Reverb(ac, 1);
  //roomSizeGlide = new Glide(ac, 0.0, 1);
  //dampingGlide = new Glide(ac, 0.0, 1);
  //lateReverbGlide = new Glide(ac, 0.0, 1);
  r.setSize(0);
  r.setDamping(0);
  r.setLateReverbLevel(0);
  
  
  cutoffGlide = new Glide(ac, 200.0, 10);
  filter = new BiquadFilter(ac, BiquadFilter.AP, cutoffGlide, 0.5f);
  //ac.out.addInput(filter);
  // set up a master gain object
  //loop = getSamplePlayer("cloudyday.wav");
  Gain g = new Gain(ac, 2, 0.3);
  ac.out.addInput(g);
  // load up a sample included in code download
  loop = null;
  micIn = ac.getAudioInput();
  micIn.pause(true);
  try {
    // Load up a new SamplePlayer using an included audio
    // file.
    
    loop = getSamplePlayer("cloudyday.wav",false);
    loop.setToLoopStart();
    loop.setLoopType(SamplePlayer.LoopType.LOOP_FORWARDS);
    // connect the SamplePlayer to the master Gain
    filter.addInput(loop);
    filter.addInput(micIn);
    
    g.addInput(filter);
    
    //reverb
    r.addInput(filter);
    g.addInput(r);
    ac.out.addInput(r);
    
  }
  catch(Exception e) {
    // If there is an error, print the steps that got us to
    // that error.
    e.printStackTrace();
  }
  // In this block of code, we build an analysis chain
  // the ShortFrameSegmenter breaks the audio into short,
  // discrete chunks.
  sfs = new ShortFrameSegmenter(ac);
  sfs.addInput(ac.out);
  
  sfsMic = new ShortFrameSegmenter(ac);
  sfsMic.addInput(micIn);
  
  // FFT stands for Fast Fourier Transform
  // all you really need to know about the FFT is that it
  // lets you see what frequencies are present in a sound
  // the waveform we usually look at when we see a sound
  // displayed graphically is time domain sound data
  // the FFT transforms that into frequency domain data
  FFT fft = new FFT();
  // connect the FFT object to the ShortFrameSegmenter
  sfs.addListener(fft);
  sfsMic.addListener(fft);
  
  // the PowerSpectrum pulls the Amplitude information from
  // the FFT calculation (essentially)
  ps = new PowerSpectrum();
  // connect the PowerSpectrum to the FFT
  fft.addListener(ps);
  // list the frame segmenter as a dependent, so that the
  // AudioContext knows when to update it.
  ac.out.addDependent(sfs);
  //ac.out.addDependent(sfsMic);
   
  p5 = new ControlP5(this);
   
  p5.addButton("NoFilter")
    .setPosition(width / 2 + 50, 50)
    .setLabel("No Filter");
   
  p5.addButton("LowPass")
    .setPosition(width / 2 + 50, 70)
    .setLabel("Low Pass Filter");
   
  p5.addButton("HighPass")
    .setPosition(width / 2 + 50, 90)
    .setLabel("High Pass Filter");
   
  p5.addButton("BandPass")
    .setPosition(width / 2 + 50, 110)
    .setLabel("Band Pass Filter");
   
  p5.addSlider("CutoffFreq")
    .setRange(1.0, 2000.0)
    .setPosition(width / 2 + 50, 130)
    .setLabel("Cutoff Frequency");
  
  p5.addButton("ToggleInput")
  .setPosition(width / 2 + 50, 180)
  .setLabel("Toggle Input");
  
  p5.addButton("Reverb")
  .setPosition(width / 2 + 50, 220)
  .setLabel("Toggle Reverb");
  
  p5.addSlider("RoomSize")
    .setRange(0.0, 1.0)
    .setPosition(width / 2 + 50, 240)
    .setLabel("Room Size");
  
  p5.addSlider("Damping")
    .setRange(0.0, 1.0)
    .setPosition(width / 2 + 50, 265)
    .setLabel("Damping");
  
  p5.addSlider("LateReverb")
    .setRange(0.0, 1.0)
    .setPosition(width / 2 + 50, 290)
    .setLabel("Late Reverb Level");
  // start processing audio
  ac.start();
}

void NoFilter() {
  filter.setType(BiquadFilter.AP);
}

void LowPass() {
  filter.setType(BiquadFilter.LP);
}

void HighPass() {
  filter.setType(BiquadFilter.HP);
}

void BandPass() {
  filter.setType(BiquadFilter.BP_SKIRT);
}

void CutoffFreq(float value) {
  cutoffGlide.setValue(value);
  println("Set cutoff frequency to: " + value);
}

void ToggleInput() {
  if (micIn.isPaused() == true) {
    ac.out.removeDependent(sfs);
    ac.out.addDependent(sfsMic);
    loop.pause(true);
    micIn.pause(false);
    println("turn on mic");
  } else {
    ac.out.removeDependent(sfsMic);
    ac.out.addDependent(sfs);
    loop.pause(false);
    micIn.pause(true);
    println("turn off mic");
  }
}

void Reverb() {
  println("size: " + r.getSize() + " damping: " + r.getDamping() + " reverb level: " + r.getLateReverbLevel());
  if (r.getSize() > 0.01 || r.getDamping() > 0.0 || r.getLateReverbLevel() > 0.0) {
    r.setSize(0.0);
    r.setDamping(0.0);
    r.setLateReverbLevel(0.0);
  } else {
    r.setSize(0.5);
    r.setDamping(0.5);
    r.setLateReverbLevel(0.5);
  }
  println("set to");
  println("size: " + r.getSize() + " damping: " + r.getDamping() + " reverb level: " + r.getLateReverbLevel());
}

void RoomSize(float value) {
  r.setSize(value);
}

void Damping(float value) {
  r.setDamping(value);
}

void LateReverb(float value) {
  r.setLateReverbLevel(value);
}
// In the draw routine, we will interpret the FFT results and
// draw them on screen.

void draw() {
  background(back);
  stroke(fore);
  
  // The getFeatures() function is a key part of the Beads
  // analysis library. It returns an array of floats
  // how this array of floats is defined (1 dimension, 2
  // dimensions ... etc) is based on the calling unit
  // generator. In this case, the PowerSpectrum returns an
  // array with the power of 256 spectral bands.
  float[] features = ps.getFeatures();
  
  // if any features are returned
  if(features != null) {
    // for each x coordinate in the Processing window
    for(int x = 0; x < width; x++) {
      // figure out which featureIndex corresponds to this x-
      // position
      int featureIndex = (x * features.length) / width;
      // calculate the bar height for this feature
      int barHeight = Math.min((int)(features[featureIndex] * height), height - 1);
      // draw a vertical line corresponding to the frequency
      // represented by this x-position
      line(x, height, x, height - barHeight);
    }
  }
}
