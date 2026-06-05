/*
  Project – Football Hopper
  Name: Mahraf Mezbah Chowdhury
  Course: COMP1000
  Concept: 
    A human figure "hopper" can move and jump, and kicks a giant football.
    Ball bounces ("hops") toward a large box ("goal post").
    Theme: Inspired by my love for football & Grace Hopper.
    Controls: LEFT/RIGHT/UP/DOWN to move, UP to jump, SPACE to kick, R to restart.
*/

// Declare global game objects
HumanPlayer human;
Football[] footballs;
int ballCount = 3;
HopperBox goalBox;
boolean showMessage = false;
int score = 0;
PImage stadiumBG; // Background image
 
// Constants for size
final float HUMAN_SCALE = 2.2;
final float BALL_DIAMETER = 56;
final float BOX_WIDTH = 160;
final float BOX_HEIGHT = 120;

void setup() {
  size(950, 550);
  human = new HumanPlayer(110, height - BOX_HEIGHT - 46, HUMAN_SCALE);
  goalBox = new HopperBox(width - BOX_WIDTH - 60, height - BOX_HEIGHT - 30, BOX_WIDTH, BOX_HEIGHT);
  footballs = new Football[5];
  resetBalls();
  stadiumBG = createStadiumBG(); // Draw night stadium background
}

void resetBalls() {
  score = 0;
  for (int i = 0; i < footballs.length; i++) {
    float offset = 65 * (i % 2); // Stagger ball positions
    footballs[i] = new Football(human.x + 70 + offset, human.y - 42, BALL_DIAMETER);
    footballs[i].active = (i < ballCount); // Activate only required number
  }
}

void draw() {
  image(stadiumBG, 0, 0); // Draw background
  drawGrass();            // Draw green grass
  goalBox.display();      // Show goal box

  // Update and display footballs
  for (int i = 0; i < footballs.length; i++) {
    if (footballs[i].active) {
      footballs[i].update();
      footballs[i].display();

      // If ball lands inside goal box
      if (goalBox.contains(footballs[i]) && footballs[i].hopping) {
        footballs[i].active = false;
        score++;
      }
    }
  }

  human.display();     // Draw the player
  drawScoreboard();    // Show score

  // Show winning message when all goals are scored
  if (score == ballCount) {
    showMessage = true;
    textSize(38);
    fill(255, 255, 35, 230);
    stroke(0, 120);
    strokeWeight(2);
    textAlign(CENTER, CENTER);
    text("ALL GOALS!\nPress 'R' to Restart", width / 2, 90);
    noStroke();
  }
}

void keyPressed() {
  if (key == 'r' || key == 'R') {
    // Restart game
    showMessage = false;
    resetBalls();
    human.x = 110;
    human.y = height - BOX_HEIGHT - 46;
    human.yVel = 0;
    human.jumping = false;
    return;
  }

  if (!showMessage) {
    // Player movement and jumping
    if (keyCode == LEFT) human.move(-1, 0);
    if (keyCode == RIGHT) human.move(1, 0);
    if (keyCode == UP) human.jump();
    if (keyCode == DOWN) human.move(0, 1);

    // Spacebar to kick
    if (key == ' ') {
      for (int i = 0; i < footballs.length; i++) {
        if (footballs[i].active && !footballs[i].hopping) {
          if (abs(footballs[i].x - human.x) < 120) {
            footballs[i].kick(human.facingRight);
            break;
          }
        }
      }
    }
  }
}

void drawScoreboard() {
  fill(0, 200);
  noStroke();
  rect(20, 20, 150, 45, 10);
  fill(255);
  textSize(20);
  textAlign(LEFT, CENTER);
  text("Score: " + score + " / " + ballCount, 30, 42);
}

void drawGrass() {
  noStroke();
  fill(40, 130, 45);
  rect(0, height - 20, width, 30);
}

PImage createStadiumBG() {
  PGraphics pg = createGraphics(width, height);
  pg.beginDraw();
  pg.background(20, 25, 50); // Night sky
  pg.noStroke();

  // Light ellipses to simulate stadium lights
  for (int i = 0; i < 3; i++) {
    pg.fill(255, 255, 180, 100);
    pg.ellipse(width / 4 * (i + 1), 80, 160, 160);
  }

  pg.endDraw();
  return pg.get();
}
