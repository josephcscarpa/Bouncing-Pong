
//Import sound library Minim
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;


//Scene Identification Number
int scene = 1;
//Ball coordinates and speed
float x, y, speedX, speedY;
float x2, y2, speedX2, speedY2;
float x3, y3, speedX3, speedY3;
//How big the ball is
float diam = 17.5;
//Size of Paddle
float rectSize = 200;
//Paddle Positions
float barY = 200;
float barY2 = 200;

//Paddle Gravity/Speed
float barSpeedY;
float barSpeedY2;

//Applies Gravity.
Boolean barJumped= true;
Boolean bar2Jumped = true;
//Note Number
int sound = 0;
//Incremental Sound
int soundSwitch = 1;
//The Score
int score =  0;
//Sound reset booleans
Boolean enterSound = true;
Boolean enterSound2 = true;
Boolean exitSound = true;
//Prevents user from speed clicking through the scenes.
int timerStart = 0;
int timerOver = 0;
//Whether the lava is displayed
Boolean lava = true;
//Starting lava position
int lavaX;
//Animation stepper
int lavaanimationStep = 1;
//Time between frames
int lavaanimationLength = 100;
//Whether  warpPortals are used
Boolean   portal = true;
// warpPortal Coordinates
int px;
int py;
int px2;
int py2;
// warpPortal Diameter of  warpPortal
int pd = 100;
//Stops super spawning
Boolean pWC = false;
//How difficult the game is. 2 is for adults... goes to 5
int difficulty = 2;
//Skins
int skin = 0;
int sBg = 255;
int sLAR = 255;
int sLAG = 49;
int sLAB = 49;
int skinBallColor = 255;
int sBAR = 125;
int sBAG = 125;
int sBAB = 125;
//Sound variables
Minim minim;
AudioOutput out;


void setup() {
  //Uncomment below for full screen
  fullScreen();

  //Reset must be called. Check the docs regarding editing it
  reset();
  //Text Font


  //sounds
  minim = new Minim(this);
  //set up audio output
  out = minim.getLineOut();

  //starts  warpPortal plugin: must be called to put the initial variables
  initwarpPortal();
}

void draw() {
  //This is the ultimate function. Displays which set of functions is used at any given moment
   skinEngine();
  sceneLogic();
}
//Called after changing settings, completing a game, etc...
void reset() {
  //Ball Position Reset
  x = width/2;
  y = height/2;
  x2= width/4;
  y2 = height/3;
    x3= width/4;
  y3 = height/3;
  //Difficulty level 
  if (difficulty ==  0) {
    speedX = random(2, 4);
    speedY = random(1.25, 2);
  } else if (difficulty == 1) {
    speedX = random(3, 6);
    speedY = random(2.5, 3);
  } else if (difficulty == 2) {
    speedX = random(5, 8);
    speedY = random(4, 6);
  } else if (difficulty == 3) {
    speedX = random(7, 11);
    speedY = random(6, 8);
  } else if (difficulty == 4) {
    speedX = random(9, 13);
    speedY = random(9, 11);
  } else if (difficulty == 5) {
    speedX = random(15, 20);
    speedY = random(15, 20);
  }
  //Speed of the other balls are the same as the first
  speedX2 = speedX;
  speedY2 = speedY;
  speedX3 = speedX;
  speedY3 = speedY;
  //Bar Height Reset
  barY = height/2;
  barY2 = height/2;
  //Score reset
  score=0;
  // warpPortal Resets
  px = int(random(200, width/2));
  py = int(random(400, height - 300));
  px2 = int(random(width/2, width - 200));
  py2 = int(random(300, height - 300));
  sound = 0;
  enterSound = true;
  enterSound2 = true;
  exitSound = true;
}

//This switches scenes based on the assigned number. You can assign numbers in any manner
void sceneLogic() {
  if (scene == 1) {
    sceneMenu();
  } else if (scene == 2) {
    sceneGame();
  } else if (scene == 3) {
    sceneOver();
  } else if (scene == 4) {
    sceneSettings();
  }
}
//This changes the skin
void skinEngine(){
if(skin == 1){
if(sBg >0){
sBg-=10;
}

if(sBAR > 0){
sBAR--;
sBAG +=5;
sBAB--;

}


sLAR = 255;
sLAG = 0;
sLAB = 0;
  }else{
   if(sBg<255){
   sBg+=10;
   } 

  sBAR = 55;
sBAG = 55;
sBAB = 55;
sLAR = 255;
sLAG = 49;
sLAB = 49;
  }
}
void sceneMenu() {
  
    if (enterSound == true) {
    out.playNote( 0, 1, "C3" );
    out.playNote( 0, 1, "E3" );
    out.playNote( 0, 1, "G3" );
    //Turns off sound after first time. 
    enterSound = false;
  }

  rectMode(CORNER);
  //Stops speed clicking
  timerStart++;
  //Sounds
  
noStroke();
  background(sBg, sBg, sBg);
  //Makes Placing text sooooo much easier
  textAlign(CENTER);
  //Color of Title text
  fill(sBAR, sBAG,sBAB );
  //Text Size
  textSize(100);
  //Text
  text("Federnd Tennis", width/2, height/2-50);
  textSize(35);
  text("Variationen im Pong -- Klicken auf Beginnen", width/2, height/2+100);


  fill(sLAR, sLAG, sLAB);
  rect(0, 0, 50, 50);
}
void sceneGame() {
 if (enterSound2 == true) {
    out.playNote( 0, 0.2, "C3" );
    out.playNote( .2, 0.2, "E3" );
    out.playNote( .4, 0.2, "G3" );
    enterSound2 = false;
  }

  background(sBg, sBg, sBg);
  //Epilepsy Protection
  noStroke();

  //Add lava?
  if (lava == true) {
    showlavas();
  }

  fill(sBAR, sBAG, sBAB);
  textSize(20);
  text(score, 50, 50);

  bar();

  fill(125, 125, 155);
  rect(50, height-rectSize, width-100, 2 );
  motionEngine();

  //Add  warpPortal?
  if (  portal== true) {
      warpPortal();
  }
}
void sceneOver() {
  //Prevent Speed Clicking
  timerOver++;
  //Sounds
    if (exitSound == true) {
    out.playNote( .4, 0.2, "C3" );
    out.playNote( .2, 0.2, "E3" );
    out.playNote( 0, 0.2, "G3" );
    exitSound = false;
  }

  //Draw Game Over Scene
  background(sBg, sBg, sBg);
  textAlign(CENTER);
  //End Screen Content
   fill(sBAR, sBAG, sBAB);
  textSize(70);
  text("Oh nein! Nicht noch einmal", width/2, height/2 - 120);
  textSize(52);
  text("Punkte", width/2, height/2 );
  textSize(130);
  text(score, width/2, height/2+150);
  textSize(25);
  text("Klicken", width/2, height/2+height/4);

  rect(width-50, 0, 50, 50);
}
//Draw Settings Panels
void sceneSettings() {
  stroke(sBAR, sBAG, sBAB);
  background(sBg, sBg, sBg);
  noFill();
  rectMode(CENTER);
  textMode(CENTER);
  //Boxes
  //Column 1
  rect(width/4, height/8, 200, 50);
  rect(width/4, height*2/8, 200, 50);
  rect(width/4, height*3/8, 200, 50);
  rect(width/4, height*4/8, 200, 50);
  rect(width/4, height*5/8, 200, 50);
  rect(width/4, height*6/8, 200, 50);
  rect(width/4, height*7/8, 200, 50);
  //Coluimn 2
  rect(width*2/4, height/8, 200, 50);
  rect(width*2/4, height*2/8, 200, 50);
  rect(width*2/4, height*3/8, 200, 50);
  rect(width*2/4, height*4/8, 200, 50);
  rect(width*2/4, height*5/8, 200, 50);
  rect(width*2/4, height*6/8, 200, 50);
  rect(width*2/4, height*7/8, 200, 50);
  //Coluimn 3
  rect(width*3/4, height/8, 200, 50);
  rect(width*3/4, height*2/8, 200, 50);
  rect(width*3/4, height*3/8, 200, 50);
  rect(width*3/4, height*4/8, 200, 50);
  rect(width*3/4, height*5/8, 200, 50);
  rect(width*3/4, height*6/8, 200, 50);
  rect(width*3/4, height*7/8, 200, 50);
  //Text for boxes
  fill(sBAR, sBAG, sBAB);
  rectMode(CORNER);
  rect(width-50, 0, 50, 50);
  textSize(20);
  //Turn on/off lava
  if (lava == true) {
    //Change setting text
    text("Lava: On", width/4, height/8);
  } else {
    text("Lava: Off", width/4, height/8);
  }
  //Turn on/off  warpPortals
  if (  portal == true) {
    //Change setting text
    text(" Portals: On", width*2/4, height/8);
  } else {
    text(" Portals: Off", width*2/4, height/8);
  }
  if (difficulty == 0) {
    //Change setting text
    text("Baby", width*3/4, height/8);
  } else if (difficulty == 1) {
    //Change setting text
    text("Easy", width*3/4, height/8);
    ;
  } else if (difficulty == 2) {
    //Change setting text
    text("Medium", width*3/4, height/8);
  } else if (difficulty == 3) {
    //Change setting text
    text("Clever", width*3/4, height/8);
  } else if (difficulty == 4) {
    //Change setting text
    text("Genius", width*3/4, height/8);
    ;
  } else if (difficulty == 5) {
    //Change setting text
    text("Impossible", width*3/4, height/8);
  }
  //Skins
  if (skin == 0) {
    //Change setting text
    text("Beautiful", width/4, height*2/8);
  } else if(skin == 1){
    text("Retro", width/4, height*2/8);
  }
}    
void bar() {
  //bar1
  rect(width-30, barY, 2, rectSize);
  //bar2
  rect(30, barY2, 2, rectSize);
}
void motionEngine() {
  //Makes bar move. This is fun to playz with
  barY+= barSpeedY;
  barY2+= barSpeedY2;
  //Applies gravity
  if (barJumped == true) {
    barSpeedY+=0.4;
  }
  if (bar2Jumped == true) {
    barSpeedY2+=0.4;
  }
  //If the bar falls... you die
  if (barY > height-100 || barY2 > height-100) {
    scene = 3;
  }
  //Drawing the ball
  fill(sBAR, sBAG, sBAB);
  ellipse(x, y, diam, diam);
  //Adds balls
  if (score>= 5) {
    //Second ball incrementals
    x2 += speedX2;
    y2 += speedY2;
    ellipse(x2, y2, diam, diam);
  }
  if (score>= 10) {
    //Second ball incrementals
    x3 += speedX3;
    y3 += speedY3;
    ellipse(x3, y3, diam, diam);
  }
  //Moving the ball
  x += speedX;
  y += speedY;

  //If ball passes... you die
  if (x < 0 || x > width) {
    scene = 3;
  }
  if (x2 < 0 || x2 > width) {
    scene = 3;
  }
    if (x3 < 0 || x3 > width) {
    scene = 3;
  }
  //If you hit the ball... +1
  //Right Side
  if ( x > width-30 && x < width -20 && y > barY && y < barY+rectSize ) {
    speedX = speedX * -1;
    //sound  = sound+ soundSwitch;
    score++;
    soundCore();
  } 
  //Left Side
  if ( x > 30 && x < 40 && y > barY2 && y < barY2+rectSize ) {
    speedX = speedX * -1;
    score++;
         soundCore();
  }
  //If you hit the second ball +1
  //Right Side
  if ( x2 > width-30 && x2 < width -20 && y2 > barY && y2 < barY+rectSize ) {
    speedX2 = speedX2* -1;
    //sound  = sound+ soundSwitch;
    score++;
         soundCore();
  } 
  //Left Side
  if ( x2 > 30 && x2 < 40 && y2 > barY && y2 < barY2+rectSize ) {
    speedX2 = speedX2 * -1;
score++;
    soundCore();
     
  }
  
    if ( x3 > width-30 && x3 < width -20 && y3 > barY && y3 < barY+rectSize ) {
    speedX3 = speedX3* -1;
    //sound  = sound+ soundSwitch;
    score++;
         soundCore();
  } 
  //Left Side
  if ( x3 > 30 && x3 < 40 && y3 > barY && y3 < barY2+rectSize ) {
    speedX3 = speedX3 * -1;
    score++;
    soundCore();
     
  }
  // if ball hits up or down, change direction of Y   
  if ( y > height-rectSize || y < 0 ) {
    speedY *= -1;
  }
  // if ball 2  hits up or down, change direction of Y2  
  if ( y2 > height-rectSize || y2 < 0 ) {
    speedY2 *= -1;
  }
  
   if ( y3 > height-rectSize || y3 < 0 ) {
    speedY3 *= -1;
  }
}
//Set the  warpPortal coordinates
void initwarpPortal() {
  px = int(random(200, width/2));
  py = int(random(400, height - 300));
  px2 = int(random(width/2, width - 200));
  py2 = int(random(300, height - 300));
}
//
void  warpPortal() {

  /** px = random(200, width - 200);
   py = random(0, height - 250);
   **/
  //Draw  warpPortals
  fill(150, 150, 150, 90);
  ellipse(px, py, pd, pd);
  ellipse(px2, py2, pd, pd); 
  // warpPortal Logic
  if (x >= px -50 &&  x <= px +50 && y >= py-50 && y <= py+50 && pWC == false ) {
    pWC = true;
    x = px2;
    y = py2;

    px2 = int(random(width/2, width - 200));
    py2 = int(random(300, height - 300));
  } else if (x >= px2 -50 &&  x <= px2 +50 && y >= py2-50 && y <= py2+50 && pWC == false ) {
    pWC = true;

    x = px;
    y = py;
    px = int(random(200, width/2));
    py = int(random(400, height - 300));
  } else {
    pWC = false;
  }
  //ball 2  warpPortal logic
  if (x2 >= px -50 &&  x2 <= px +50 && y2 >= py-50 && y2 <= py+50 && pWC == false ) {
    pWC = true;
    x2 = px2+51;
    y2 = py2+51;

    px2 = int(random(width/2, width - 200));
    py2 = int(random(300, height - 300));
  } else if (x2 >= px2 -50 &&  x2 <= px2 +50 && y2 >= py2-50 && y2 <= py2+50 && pWC == false ) {
    pWC = true;

    x2 = px+51;
    y2 = py+51;
    px = int(random(200, width/2));
    py = int(random(400, height - 300));
  } else {
    pWC = false;
  }
 //ball 2  warpPortal logic
  if (x3 >= px -50 &&  x3 <= px +50 && y3 >= py-50 && y3 <= py+50 && pWC == false ) {
    pWC = true;
    x3 = px2+51;
    y3 = py2+51;

    px2 = int(random(width/2, width - 200));
    py2 = int(random(300, height - 300));
  } else if (x2 >= px2 -50 &&  x2 <= px2 +50 && y2 >= py2-50 && y2 <= py2+50 && pWC == false ) {
    pWC = true;

    x3 = px+51;
    y3 = py+51;
    px = int(random(200, width/2));
    py = int(random(400, height - 300));
  } else {
    pWC = false;
  }
}
                       



//Lava function
void showlavas() {
  //animater
  if (lavaanimationStep < lavaanimationLength/2) { 
    for (int lavaX = 0; lavaX < width; lavaX +=50) {
      fill(sLAR,sLAG,sLAB);
      if(skin == 1){
      triangle(lavaX, height, lavaX+50, height, lavaX+25, height-100);
      }else{
      rect(lavaX, height-100, 50, 100);
      }
    }
  }
  if (lavaanimationStep >= lavaanimationLength/2) { 
    for (int lavaX = 0; lavaX < width; lavaX +=50) {
      fill(sLAR,sLAG+49,sLAB);
         if(skin == 1){
      triangle(lavaX, height, lavaX+50, height, lavaX+25, height-100);
      }else{
      rect(lavaX, height-100, 50, 100);
      }
    }
  }
  lavaanimationStep = lavaanimationStep + 1;
  if (lavaanimationStep == lavaanimationLength) {
    lavaanimationStep = 0;
  }
}
//Mouse (Scene Changes)
void mousePressed() {

  //Scene 2(Doesn't need to be in an if because it gets reset anyway
  //Jump Lift
  barSpeedY = -10; 
  barSpeedY2 = -10; 

  //Gravity so that the bars don't fly away 
  barJumped = true;
  bar2Jumped = true;

  //Scene 1 Mouse Actions
  if (scene ==1) {
    if (mouseX <=50 && mouseY <= 50) {
      //Settings
      scene =4;
    } else if (timerStart > 150) {
      //Game
      scene = 2;
    }
  }


  //Scene 3 Mouse Actions
  if (scene == 3) {
    if (mouseX >= width - 50 && mouseY <= 50 && timerOver>100) {
      //Main Screen
      scene =1;
      reset();
         exitSound = true;
          enterSound2 = true;
           enterSound = true;
           timerStart =0;
    } else if (timerOver > 100) {
      //Game Screen
      reset();
      exitSound = true;
      scene = 2;
      //resets timer
      timerOver = 0;
      enterSound2 = true;
    }
  }
  //Scene 4 Mouse Actions
  if (scene == 4) {
    if (mouseX >= width-50 && mouseY <= 50) {
      //main Screen
      scene = 1;
      //Apply settings
      reset();
      enterSound = true;
    }
  }
}
void mouseClicked() {

  //Lava Toggle
  if (mouseX > width/4 - 100 && mouseX<width/4 + 100) {
    if (mouseY > height/8-25 && mouseY < height/8 +25) {
      if (lava == true) {
        lava = false;
        print(lava);
      } else {
        lava = true;
        print(lava);
      }
    }
  }
  // warpPortal Toggle
  if (mouseX > width*2/4 - 100 && mouseX<width*2/4 + 100) {
    if (mouseY > height/8-25 && mouseY < height/8 +25) {
      if (portal == true) {
          portal = false;
      
      } else {
          portal = true;
        print( portal);
      }
    }
  }
  //Difficulty Toggle
      if (mouseX > width*3/4 - 100 && mouseX<width*3/4 + 100) {
    if (mouseY > height/8-25 && mouseY < height/8 +25) {
      if (difficulty == 0) {
        difficulty = 1;
         
      } else if (difficulty == 1) {
        difficulty = 2;
        ;
      }else if (difficulty == 2) {
        difficulty = 3;
       
      }else if (difficulty == 3) {
        difficulty = 4;
         
      }else if (difficulty == 4) {
        difficulty = 5;
   
      }else if (difficulty == 5) {
        difficulty = 0;
         
      }
    }
  }
  //Skin
  if (mouseX> width/4 - 100 && mouseX<width/4 + 100) {
    if (mouseY > height*2/8-25 && mouseY < height*2/8 +25) {
      if (skin == 0) {
        skin =1;
      }else if(skin ==1){
      skin =0;
      }
    }
  }
  //
  
}
void soundCore() {
  //This powers sound
  //Incremental decider
  sound  = sound+ soundSwitch;
  //Sound cues
  if (sound == 1) {
    out.playNote( 0, 0.5, "C3" );
  } else if (sound == 2) {
    out.playNote( 0, 0.5, "C#3" );
  } else if (sound == 3) {
    out.playNote( 0, 0.5, "D3" );
  } else if (sound == 4) {
    out.playNote( 0, 0.5, "D#3" );
    ;
  } else if (sound == 5) {
    out.playNote( 0, 0.5, "E3" );
  } else if (sound == 6) {
    out.playNote( 0, 0.5, "F3" );
  } else if (sound == 7) {
    out.playNote( 0, 0.5, "F#3" );
  } else if (sound == 8) {
    out.playNote( 0, 0.5, "G3" );
  } else if (sound == 9) {
    out.playNote( 0, 0.5, "G#3" );
  } else if (sound == 10) {
    out.playNote( 0, 0.5, "A3" );
  } else if (sound == 11) {
    out.playNote( 0, 0.5, "A#3" );
  } else if (sound == 12) {
    out.playNote( 0, 0.5, "B3" );
  } else if (sound == 13) {
    out.playNote( 0, 0.2, "C4" );
    ;
    out.playNote( .2, 0.2, "E4" );
    out.playNote( .4, 0.2, "G4" );
  }

  //Change incremental
  if (sound>12) {
    soundSwitch = -1;
  }
  if (sound<2) {
    soundSwitch = 1;
  }
}