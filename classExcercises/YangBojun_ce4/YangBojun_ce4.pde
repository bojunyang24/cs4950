import controlP5.*;
import beads.*;
import org.jaudiolibs.beads.*;

//Global vars
ControlP5 p5;
SamplePlayer track;
SamplePlayer go;
SamplePlayer stop;
SamplePlayer fast;
SamplePlayer rewind;
SamplePlayer reset;

Glide musicSpeedGlide;
Glide musicPos;
Bead musicEndListener;
float trackLength;

void setup() {
  size(800,700);
  ac = new AudioContext();
  
  track = getSamplePlayer("chasingclouds.wav");
  go = getSamplePlayer("go.wav");
  go.pause(true);
  stop = getSamplePlayer("stop.wav");
  stop.pause(true);
  fast = getSamplePlayer("fast.wav");
  fast.pause(true);
  rewind = getSamplePlayer("rewind.wav");
  rewind.pause(true);
  reset = getSamplePlayer("reset.wav");
  reset.pause(true);
  
  
  // getting track length
  track.setToEnd();
  trackLength = (float) track.getPosition();
  track.setToLoopStart();
  //print("\n track length: " + trackLength + "\n");
  
  track.setKillOnEnd(false);
  
  p5 = new ControlP5(this);
  
  //music speed glide
  musicSpeedGlide = new Glide(ac, 0, 250);
  track.setRate(musicSpeedGlide);
  
  musicEndListener = new Bead() {
    public void messageReceived(Bead mess) {
      print("HENLO");
      track.setEndListener(null);
      if (musicSpeedGlide.getValue() > 0 && track.getPosition() >= trackLength) {
        musicSpeedGlide.setValueImmediately(0);
        track.setToEnd();
      }
      if (musicSpeedGlide.getValue() < 0 && track.getPosition() <= 0) {
        musicSpeedGlide.setValueImmediately(0);
        track.reset();
      }
    }
  };
  
  p5.addButton("Play")
    .setPosition(width / 2 - 50, 50);
    
  p5.addButton("Stop")
    .setPosition(width / 2 - 50, 80);
  
  p5.addButton("Fast")
    .setPosition(width / 2 - 50, 110)
    .setLabel("Fast Forward");
  
  p5.addButton("Rewind")
    .setPosition(width / 2 - 50, 140);
    
  p5.addButton("Reset")
    .setPosition(width / 2 - 50, 170);
    
  p5.addSlider("playbackPos")
    .setPosition(width /2 - 75, 200)
    .setRange(0, trackLength)
    .setValue((float) track.getPosition())
    .setLabel("Set Track Head Position");
  
  ac.out.addInput(track);
  ac.out.addInput(go);
  ac.out.addInput(stop);
  ac.out.addInput(fast);
  ac.out.addInput(rewind);
  ac.out.addInput(reset);
  
  ac.start();
}

void Play() {
  if (track.getPosition() < trackLength) {
    track.setEndListener(musicEndListener);
    go.setToLoopStart();
    go.pause(false);
    musicSpeedGlide.setValue(1);
  }
  
}

void Stop() {
  stop.setToLoopStart();
  stop.pause(false);
  musicSpeedGlide.setValue(0);
}

void Fast() {
  fast.setToLoopStart();
  fast.pause(false);
  if (musicSpeedGlide.getValue() <= 1) {
    musicSpeedGlide.setValue(1.5);
  } else {
    musicSpeedGlide.setValue(1.5 * musicSpeedGlide.getValue());
  }
}

void Rewind() {
  rewind.setToLoopStart();
  rewind.pause(false);
  if (musicSpeedGlide.getValue() >= 0) {
    musicSpeedGlide.setValue(-1);
  } else {
    musicSpeedGlide.setValue(1.5 * musicSpeedGlide.getValue());
  }
}

void Reset() {
  reset.setToLoopStart();
  reset.pause(false);
  musicSpeedGlide.setValueImmediately(0);
  track.setToLoopStart();
}

public void playbackPos(int pos) {
  track.setPosition(pos);
  println("Track position set to: " + pos);
}

void draw() {
  background(0);
}
