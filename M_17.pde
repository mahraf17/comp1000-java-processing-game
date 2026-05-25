// CLASS DEFINITIONS

class HumanPlayer {
  float x, y, scaleH;
  boolean facingRight;
  float yVel = 0;
  boolean jumping = false;
  final float GRAVITY = 0.8;
  final float MOVE_AMOUNT = 17;

  HumanPlayer(float _x, float _y, float _sc) {
    x = _x;
    y = _y;
    scaleH = _sc;
    facingRight = true;
  }

  void move(int dirX, int dirY) {
    x += dirX * MOVE_AMOUNT;
    facingRight = dirX > 0 || (dirX == 0 && facingRight);
    x = constrain(x, 60, width - 260);
    y = constrain(y + dirY * MOVE_AMOUNT, 0, height - BOX_HEIGHT - 46);
  }

  void jump() {
    if (!jumping) {
      yVel = -17;
      jumping = true;
    }
  }

  void update() {
    if (jumping) {
      y += yVel;
      yVel += GRAVITY;
      if (y > height - BOX_HEIGHT - 46) {
        y = height - BOX_HEIGHT - 46;
        yVel = 0;
        jumping = false;
      }
    }
  }

  void display() {
    update();
    pushMatrix(); // Save current transformation matrix
    translate(x, y); // Move to player location
    scale(scaleH); // Scale the whole human figure

    // Head
    fill(244, 215, 110);
    ellipse(0, -28, 28, 28);
    // Body
    fill(188,66,188);
    rect(-12, -11, 24, 32, 10);
    // Arms
    stroke(115, 90, 34);
    strokeWeight(4);
    if (facingRight) {
      line(12, -2, 28, 20);
      line(-12, -2, -20, 23);
    } else {
      line(-12, -2, -28, 20);
      line(12, -2, 20, 23);
    }
    // Legs
    strokeWeight(7);
    stroke(70, 30, 0);
    line(-5, 22, -8, 45);
    line(7, 22, 32, 46);
    noStroke();
    popMatrix(); 
  }
}

class Football {
  float x, y, d;
  float xVel, yVel;
  boolean hopping;
  boolean active;
  int bounceCount = 0;
  final float G = 1.25;

  Football(float _x, float _y, float _d) {
    x = _x;
    y = _y;
    d = _d;
    xVel = 0;
    yVel = 0;
    hopping = false;
    active = true;
  }

  void kick(boolean rightward) {
    xVel = rightward ? random(11, 14) : random(-14, -11);
    yVel = random(-17, -15);
    hopping = true;
    bounceCount = 0;
  }

  void update() {
    if (hopping) {
      x += xVel;
      y += yVel;
      yVel += G;

      float ground = height - d / 2 - 16;
      if (y > ground) {
        y = ground;
        yVel *= -0.60;
        bounceCount++;
        if (abs(yVel) < 2.7 || bounceCount > 8) {
          yVel = 0;
          hopping = false;
        }
      }
      if (!hopping && abs(xVel) > 0.7) {
        xVel *= 0.93;
      }
      x = constrain(x, d / 2, width - d / 2);
    } else {
      y = height - d / 2 - 16;
      xVel = 0;
      yVel = 0;
    }
  }

  void display() {
    pushMatrix();
    translate(x, y);
    fill(255);
    stroke(60);
    strokeWeight(2);
    ellipse(0, 0, d, d);

    // Hexagon-style spots
    fill(20, 20, 20, 160);
    noStroke();
    for (int i = 0; i < 6; i++) {
      float angle = (TWO_PI / 6) * i + 0.2;
      ellipse(0.30 * d * cos(angle), 0.30 * d * sin(angle), 0.14 * d, 0.14 * d);
    }

    // Shadow when ball is in air
    if (hopping) {
      fill(0, 60);
      ellipse(0, height - y - 20, d * 1.07, d * 0.19);
    }
    popMatrix();
  }
}

class HopperBox {
  float x, y, w, h;

  HopperBox(float _x, float _y, float _w, float _h) {
    x = _x;
    y = _y;
    w = _w;
    h = _h;
  }

  void display() {
    stroke(160, 100, 30, 220);
    strokeWeight(10);
    fill(230, 230, 72, 60);
    rect(x, y, w, h, 18);
    fill(46, 79, 210);
    textSize(24);
    textAlign(CENTER, CENTER);
    text("GOAL BOX", x + w / 2, y - 22);
  }

  boolean contains(Football b) {
    return (b.x > x && b.x < x + w && b.y > y && b.y < y + h);
  }
}
