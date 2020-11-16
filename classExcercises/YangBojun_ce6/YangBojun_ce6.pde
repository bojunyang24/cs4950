import controlP5.*;
import beads.*;
import org.jaudiolibs.beads.*;

//Global Vars
ControlP5 p5;
int sineCount = 10;
float baseFrequency = 440.0;
Glide[] sineFrequency = new Glide[sineCount];
Gain[] sineGain = new Gain[sineCount];
Glide sineFrequency1;
WavePlayer sineTone1;
Gain sineGain1;

Gain masterSineGain;
Glide sineGainGlide;
Gain masterSquareGain;
Glide squareGainGlide;
Gain masterTriangleGain;
Glide triangleGainGlide;
Gain masterSawtoothGain;
Glide sawtoothGainGlide;
WavePlayer[] sineTone = new WavePlayer[sineCount];
Glide fundFreqGlide;


void setup() {
  float sineIntensity = 1.0;
  size(800,700);
  ac = new AudioContext();
  p5 = new ControlP5(this);
  
  sineGainGlide = new Glide(ac, .5, 200);  
  masterSineGain = new Gain(ac, 1, sineGainGlide);
  sineGainGlide.setValue(0);
  ac.out.addInput(masterSineGain);
  sineFrequency1 = new Glide(ac, baseFrequency * 1, 200);
  sineTone1 = new WavePlayer(ac, sineFrequency1, Buffer.SINE);
  sineGain1 = new Gain(ac, 1, 1);
  sineGain1.addInput(sineTone1);
  masterSineGain.addInput(sineGain1);
  
  squareGainGlide = new Glide(ac, .5, 200);  
  masterSquareGain = new Gain(ac, 1, squareGainGlide);
  squareGainGlide.setValue(0);
  ac.out.addInput(masterSquareGain);
  
  triangleGainGlide = new Glide(ac, .5, 200);  
  masterTriangleGain = new Gain(ac, 1, triangleGainGlide);
  triangleGainGlide.setValue(0);
  ac.out.addInput(masterTriangleGain);
  
  sawtoothGainGlide = new Glide(ac, .5, 200);  
  masterSawtoothGain = new Gain(ac, 1, sawtoothGainGlide);
  sawtoothGainGlide.setValue(0);
  ac.out.addInput(masterSawtoothGain);
  
  // create a UGen graph to synthesize a square wave from a base/fundamental frequency and 9 odd harmonics with amplitudes = 1/n
  // square wave = base freq. and odd harmonics with intensity decreasing as 1/n
  // square wave = baseFrequency + (1/3)*(baseFrequency*3) + (1/5)*(baseFrequency*5) + ...
  for( int i = 0, n = 1; i < sineCount; i++, n++) {
    // create the glide that will control this WavePlayer's frequency
    // create an array of Glides in anticipation of connecting them with ControlP5 sliders
    sineFrequency[i] = new Glide(ac, baseFrequency * n, 200);
    
    // Create harmonic frequency WavePlayer - i.e. baseFrequency * 3, baseFrequency * 5, ...
    sineTone[i] = new WavePlayer(ac, sineFrequency[i], Buffer.SINE);
    
    // Create gain for each harmonic - i.e. 1/3, 1/5, 1/7, ...
    // For a square wave, we only want odd harmonics, so set all even harmonics to 0 gain/intensity
    sineIntensity = (n % 2 == 1) ? (float) (1.0 / n) : 0;
    println(sineIntensity, " * ", baseFrequency * n);
    sineGain[i] = new Gain(ac, 1, sineIntensity); // create the gain object
    sineGain[i].addInput(sineTone[i]); // then connect the waveplayer to the gain
  
    // finally, connect the gain to the master gain
    // masterGain will sum all of the sine waves, additively synthesizing a square wave tone
    masterSquareGain.addInput(sineGain[i]);
  }
  
  for( int i = 0, n = 1; i < sineCount; i++, n++) {
    // create the glide that will control this WavePlayer's frequency
    // create an array of Glides in anticipation of connecting them with ControlP5 sliders
    sineFrequency[i] = new Glide(ac, baseFrequency * n, 200);
    
    // Create harmonic frequency WavePlayer - i.e. baseFrequency * 3, baseFrequency * 5, ...
    sineTone[i] = new WavePlayer(ac, sineFrequency[i], Buffer.SINE);
    
    // Create gain for each harmonic - i.e. 1/3, 1/5, 1/7, ...
    // For a square wave, we only want odd harmonics, so set all even harmonics to 0 gain/intensity
    sineIntensity = (n % 2 == 1) ? (float) (1.0 / (n*n)) : 0;
    println(sineIntensity, " * ", baseFrequency * n);
    sineGain[i] = new Gain(ac, 1, sineIntensity); // create the gain object
    sineGain[i].addInput(sineTone[i]); // then connect the waveplayer to the gain
  
    // finally, connect the gain to the master gain
    // masterGain will sum all of the sine waves, additively synthesizing a square wave tone
    masterTriangleGain.addInput(sineGain[i]);
  }
  
  for( int i = 0, n = 1; i < sineCount; i++, n++) {
    // create the glide that will control this WavePlayer's frequency
    // create an array of Glides in anticipation of connecting them with ControlP5 sliders
    sineFrequency[i] = new Glide(ac, baseFrequency * n, 200);
    
    // Create harmonic frequency WavePlayer - i.e. baseFrequency * 3, baseFrequency * 5, ...
    sineTone[i] = new WavePlayer(ac, sineFrequency[i], Buffer.SINE);
    
    // Create gain for each harmonic - i.e. 1/3, 1/5, 1/7, ...
    // For a square wave, we only want odd harmonics, so set all even harmonics to 0 gain/intensity
    //sineIntensity = (n % 2 == 1) ? (float) (1.0 / n) : 0;
    sineIntensity = 1.0 / n;
    println(sineIntensity, " * ", baseFrequency * n);
    sineGain[i] = new Gain(ac, 1, sineIntensity); // create the gain object
    sineGain[i].addInput(sineTone[i]); // then connect the waveplayer to the gain
  
    // finally, connect the gain to the master gain
    // masterGain will sum all of the sine waves, additively synthesizing a square wave tone
    masterSawtoothGain.addInput(sineGain[i]);
  }
  
  p5.addButton("Sine")
    .setWidth(110)
    .setPosition(width / 2 - 50, 50)
    .setLabel("Fundamental Sine Wave");
    
  p5.addButton("Square")
    .setWidth(110)
    .setPosition(width / 2 - 50, 80)
    .setLabel("Square Wave");
  
  p5.addButton("Triangle")
    .setWidth(110)
    .setPosition(width / 2 - 50, 110)
    .setLabel("Triangle Wave");
  
  p5.addButton("Sawtooth")
    .setWidth(110)
    .setPosition(width / 2 - 50, 140)
    .setLabel("Sawtooth Wave");
  
  p5.addSlider("freqGlide")
    .setPosition(width /2 - 75, 170)
    .setRange(0.0, 1000.0)
    .setValue(440.0)
    .setLabel("Fundamental Freuquency");
  
  p5.addButton("Pause")
    .setWidth(110)
    .setPosition(width / 2 - 50, 190)
    .setLabel("Stop All");
  
  ac.start();
}

void Sine() {
  triangleGainGlide.setValue(0);
  squareGainGlide.setValue(0);
  sawtoothGainGlide.setValue(0);
  sineGainGlide.setValue(0.5);
}

void Square() {
  sineGainGlide.setValue(0);
  triangleGainGlide.setValue(0);
  sawtoothGainGlide.setValue(0);
  squareGainGlide.setValue(0.5);
}

void Triangle() {
  sineGainGlide.setValue(0);
  sawtoothGainGlide.setValue(0);
  squareGainGlide.setValue(0);
  triangleGainGlide.setValue(0.5);
}

void Sawtooth() {
  sineGainGlide.setValue(0);
  triangleGainGlide.setValue(0);
  squareGainGlide.setValue(0);
  sawtoothGainGlide.setValue(0.5);
}

public void freqGlide(int freq) {
  baseFrequency = freq;
  println("Fundamental frequency set to: " + baseFrequency);
}

void Pause() {
  sineGainGlide.setValue(0);
  sawtoothGainGlide.setValue(0);
  squareGainGlide.setValue(0);
  triangleGainGlide.setValue(0);
}

void draw() {
  background(0);
}
