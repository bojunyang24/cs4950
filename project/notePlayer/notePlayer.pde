import controlP5.*;
import beads.*;
import org.jaudiolibs.beads.*;

ControlP5 p5;

WavePlayer wp;


DelayTrigger delay;

void setup() {
  size(320, 240);
  ac = new AudioContext();
  p5 = new ControlP5(this);
  
  //329.63 E
  //493.88 B
  //554.37 C#
  //440.0  A

  wp = new WavePlayer(ac, 440.0, Buffer.SINE);

  wp.pause(true);
  
  ac.out.addInput(wp);
  
  p5.addButton("playE")
    .setPosition(width/2 - 80, height/2)
    .setLabel("Jab");
  p5.addButton("playB")
    .setPosition(width/2, height/2)
    .setLabel("Hook");
  p5.addButton("playCSharp")
    .setPosition(width/2 - 80, height/2 + 30)
    .setLabel("Cross");
  p5.addButton("playA")
    .setPosition(width/2, height/2 + 30)
    .setLabel("Uppercut");
    ac.start();
}

void draw() {
  background(0);
  if (ac.getTime() >= 50.0) {
    wp.pause(true);
    ac.reset();
  }
}

public void playE(int value) {
  wp.setFrequency(329.63);
  wp.pause(false);

  
}

public void playB(int value) {
  wp.setFrequency(493.88);
  wp.pause(false);

}

public void playCSharp(int value) {
  wp.setFrequency(554.37);
  wp.pause(false);

}

public void playA(int value) {
  wp.setFrequency(440.0);
  wp.pause(false);

}
