// FFT_01.pde
// This example is based in part on an example included with
// the Beads download originally written by Beads creator
// Ollie Bown. It draws the frequency information for a
// sound on screen.
import controlP5.*;
import beads.*;
import org.jaudiolibs.beads.*;

ControlP5 p5;

//SamplePlayer hook;
//SamplePlayer cross;
//SamplePlayer jab;
SamplePlayer improper;
WavePlayer jab;
WavePlayer cross;
WavePlayer hook;
WavePlayer upper;
//WavePlayer improper;
double startTime; // variable for timing when to play each sound
Boolean play;

Table table;
color fore = color(0, 255, 70);
color back = color(0, 0, 0);
TableRow row;
int i = 0;
int maxRows;
String punchType;
int speed;
int power;

void setup() {
  size(600, 600);
  ac = new AudioContext();
  p5 = new ControlP5(this);

  //hook = getSamplePlayer("positive1.wav");
  //hook.pause(true);
  //cross = getSamplePlayer("positive2.wav");
  //cross.pause(true);
  //jab = getSamplePlayer("positive3.wav");
  //jab.pause(true);
  improper = getSamplePlayer("negative3.wav");
  improper.pause(true);
  
  // jab = E = 329.63
  jab = new WavePlayer(ac, 329.63, Buffer.SINE);
  jab.pause(true);
  // cross = B - 493.88
  cross = new WavePlayer(ac, 493.88, Buffer.SINE);
  cross.pause(true);
  // hook = C# = 554.37
  hook = new WavePlayer(ac, 554.37, Buffer.SINE);
  hook.pause(true);
  // upper = A = 440.0
  upper = new WavePlayer(ac, 440.0, Buffer.SINE);
  upper.pause(true);
  
  //ac.out.addInput(jab);
  //ac.out.addInput(hook);
  //ac.out.addInput(cross);
  ac.out.addInput(improper);
  ac.out.addInput(jab);
  ac.out.addInput(cross);
  ac.out.addInput(hook);
  ac.out.addInput(upper);

  table = loadTable("finaldeliverabledata.csv", "header");
  maxRows = table.getRowCount() -1;
  row = table.getRow(i);
  punchType = row.getString("Type");
  //speed = row.getInt("Speed(mph)");
  //power = row.getInt("Power (lbs/f)");
  //for (int i = 0; i < maxRows; i++) {
  //  row = table.getRow(i);
  //  jabType = row.getString("Type");
  //  speed = row.getInt("Speed(mph)");
  //  power = row.getInt("Power (lbs/f)");
  //}
  
  p5.addButton("NextPunch")
    .setPosition(width/2 - 50, height/2 - 30)
    .setSize(100, 60)
    .setLabel("Next Punch");
  
  p5.addButton("Hook")
    .setPosition(width/4 - 125, height/4 - 30)
    .setSize(100, 60)
    .setLabel("Hook Sound");
  
  p5.addButton("Jab")
    .setPosition(width/4 + 25, height/4 - 30)
    .setSize(100, 60)
    .setLabel("Jab Sound");
    
  p5.addButton("Cross")
    .setPosition(width/4*3 - 125, height/4 - 30)
    .setSize(100, 60)
    .setLabel("Cross Sound");
  
  p5.addButton("Uppercut")
    .setPosition(width/4*3 + 25, height/4 - 30)
    .setSize(100, 60)
    .setLabel("Uppercut Sound");
    
  p5.addButton("Improper")
    .setPosition(width/2 - 50, height/4*3 - 30)
    .setSize(100, 60)
    .setLabel("Improper Sound");
  
  ac.start();
}

// reads next row and plays sound accordingly
void NextPunch() {
  print((i+1) + " ");
  if (i >= maxRows) {
    return;
  } else {
    if (punchType.equals("Improper")) {
      Improper();
    } else if (punchType.equals("Jab")) {
      Jab();
    } else if (punchType.equals("Hook")) {
      Hook();
    } else if (punchType.equals("Cross")) {
      Cross();
    } else if (punchType.equals("Uppercut")) {
      Uppercut();
    }
    i++;
    row = table.getRow(i);
    punchType = row.getString("Type");
  }
}

void Jab() {
  jab.start();
  print("Jab ");
  startTime = ac.getTime();
}

void Cross() {
  cross.start();
  print("Cross ");
  startTime = ac.getTime();
}

void Hook() {
  hook.start();
  print("Hook ");
  startTime = ac.getTime();
}

void Uppercut() {
  upper.start();
  print("Upper ");
  startTime = ac.getTime();
}


//void Cross() {
//  cross.setToLoopStart();
//  cross.start();
//}

//void Jab() {
//  jab.setToLoopStart();
//  jab.start();
//}

//void Hook() {
//  hook.setToLoopStart();
//  hook.start();
//}

void Improper() {
  print("Improper ");
  improper.setToLoopStart();
  improper.start();
}

//void SonifyPunch(int punchType) {
//  if (punchType > 0) {
//    success.setToLoopStart();
//    success.start();
//  } else {
//    fail.setToLoopStart();
//    fail.start();
//  }
//}

void draw() {
  background(back);
  stroke(fore);
  // turns of note after set time
  if (ac.getTime() - startTime >= 400.0) {
    jab.pause(true);
    cross.pause(true);
    hook.pause(true);
    upper.pause(true);
  }
}
