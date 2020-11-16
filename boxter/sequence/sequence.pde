// README
// 0 = jab, 1 = cross, 2 = hook, 3 = uppercut
// type in the corresponding numbers and press enter to play
import controlP5.*;
import beads.*;
import org.jaudiolibs.beads.*;

ControlP5 p5;

WavePlayer jab;
WavePlayer cross;
WavePlayer hook;
WavePlayer upper;
WavePlayer improper;

double startTime; // variable for timing when to play each sound
Boolean play;
Boolean nextNote;
ArrayList<String> textSequence = new ArrayList<String>();
String playSeq = "";

int line;


color back = color(100, 100, 100);

void setup() {
  size(600, 600);
  ac = new AudioContext();
  p5 = new ControlP5(this);
  
  //initialize variables
  textSequence.add("");
  play = false;
  nextNote = false;
  
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
  
  //Button for testing
  //p5.addButton("Jab")
  //  .setPosition(width/2 - 50, height/2 - 30)
  //  .setSize(100, 60)
  //  .setLabel("Jab test");
  
  ac.out.addInput(jab);
  ac.out.addInput(cross);
  ac.out.addInput(hook);
  ac.out.addInput(upper);
  ac.start();
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

void Upper() {
  upper.start();
  print("Upper ");
  startTime = ac.getTime();
}

void draw() {
  background(back);
  //if (textSequence != null) {
  //  for (int i = 0; i < textSequence.length; i++) {
  //    text(textSequence[i], 0, i * 20, width, height);
  //  }
  //}
  
  // prints out text on screen
  text("README\n0 = jab, 1 = cross, 2 = hook, 3 = uppercut\ntype in the corresponding numbers and press enter to play", 0, 0, width, height);
  for (int i = 0; i < textSequence.size(); i++) {
    text(textSequence.get(i), 0, (i + 2.5) * 20, width, height);
  }
  
  // play one sequence at a time
  if (play == true && playSeq.length() > 0) {
    if (playSeq.charAt(0) == '0') {
      Jab();
    } else if (playSeq.charAt(0) == '1') {
      Cross();
    } else if (playSeq.charAt(0) == '2') {
      Hook();
    } else if (playSeq.charAt(0) == '3') {
      Upper();
    }
    playSeq = playSeq.substring(1);
    if (playSeq.length() > 0){
      nextNote = true;
    } else {
      nextNote = false;
      play = false;
    }
  }
  // turns of note after set time
  if (ac.getTime() - startTime >= 400.0) {
    jab.pause(true);
    cross.pause(true);
    hook.pause(true);
    upper.pause(true);
  }
  // queues up next note if there is
  if (nextNote && ac.getTime() - startTime < 400.0) {
    play = false;
  } else if (nextNote) {
    play = true;
    nextNote = false;
  }
  
}
  
void keyPressed() {
  if (keyCode == BACKSPACE) {
    if (textSequence.get(line).length() > 0) {
      textSequence.set(line, textSequence.get(line).substring(0, textSequence.get(line).length()-1));
    }
  } else if (keyCode == DELETE) {
    textSequence.set(line, "");
  } else if (keyCode == ENTER) {
    // calls method to prep sequence to play
    playSequence(textSequence.get(line));
    // adds new line
    textSequence.add("");
    line++;
  } else if (key == '0' || key == '1' || key == '2' || key == '3') {
    textSequence.set(line, textSequence.get(line) + key);
  }
}

void playSequence(String seq) {
  playSeq = seq;
  play = true;
  nextNote = true;
}

void nothing() {
  return;
}
