
class Game {
  
  float GRAVITY_ACC = -10;
  
  int blockWidthPixels = 40;
  
  Player player = new Player();
  PVector cameraPos = new PVector();
  PVector grapplePosition = new PVector();
  Level level = null;
  
  long timeOfLastFrameMs = 0;
  
  Game(UserInterface userInterface) {
    this.userInterface = userInterface;
    
    player.position = new PVector(1, 1);
    grapplePosition = new PVector(0, 0);
    
    try {
      level = new Level("C:/Users/Ian/Projects/grappleHookTest/levels/level0.lvl");
    }
    catch(Exception e) {
      print(e.toString());
      exit();
    }
  }
  
  void drawFrame() {
    doLogic();
    
    cameraPos = player.position;
    
    drawLevel();
    drawPlayer();
  }
  
  private void doLogic() {
    long currentTimeMs = millis();
    float deltaTime = (float)(currentTimeMs - timeOfLastFrameMs) / 1000;
    
    int moveRight = userInterface.isKeyPressed('d') ? 1 : 0;
    int moveLeft = userInterface.isKeyPressed('a') ? 1 : 0;
    int moveDirection = moveRight - moveLeft;
    
    // Grapple
    if(userInterface.isMouseButtonPressed(LEFT) && !player.grappled) {      
      grapplePosition.x = (float)(mouseX - width / 2) / blockWidthPixels + cameraPos.x;
      grapplePosition.y = (float)(height / 2 - mouseY) / blockWidthPixels + cameraPos.y;
      
      if(level.isCoordInBlock(grapplePosition.x, grapplePosition.y)) {
        player.grappled = true;
        
        PVector ropeVector = PVector.sub(player.position, grapplePosition);
        PVector directionOfVelocity = ropeVector.copy().rotate(HALF_PI).normalize();
        
        float radialVelocityMagnitude = player.velocity.dot(directionOfVelocity);
        player.angularVelocity = radialVelocityMagnitude / ropeVector.mag();
      }
    }
    else if(!userInterface.isMouseButtonPressed(LEFT) && player.grappled) {
      player.grappled = false;
    }
    
    // Physics
    if(player.grappled) {
      PVector ropeVector = PVector.sub(player.position, grapplePosition);
      
      float angularAcc = ropeVector.x * GRAVITY_ACC / ropeVector.magSq();
      angularAcc += moveDirection * player.SWING_ANGULAR_ACC;
      
      player.angularVelocity += angularAcc * deltaTime;
      
      float deltaAngle = player.angularVelocity * deltaTime;
      ropeVector.rotate(deltaAngle);
      player.position = PVector.add(grapplePosition, ropeVector);
      
      PVector directionOfVelocity = ropeVector.copy().rotate(HALF_PI).normalize();
      float velocityMagnitude = ropeVector.mag() * player.angularVelocity;
      player.velocity = PVector.mult(directionOfVelocity, velocityMagnitude);
    }
    else {
      PVector acceleration = new PVector(0, GRAVITY_ACC);
      
      if(player.onGround) {        
        // Running
        if(moveDirection == sign(player.velocity.x) || player.velocity.x == 0) {
          acceleration.x = moveDirection * player.RUN_ACC;
        }
        // Braking
        else {
          if(abs(player.velocity.x) < 0.1) {
            player.velocity.x = 0;
          }
          else {
            acceleration.x = -player.BRAKE_ACC * sign(player.velocity.x);
          }
        }
        
        // Jumping
        if(userInterface.isKeyPressed(' ')) {
          player.velocity.y += player.JUMP_SPEED;
          player.onGround = false;
        }
      }
      
      player.velocity.add(PVector.mult(acceleration, deltaTime));
      if(player.onGround && abs(player.velocity.x) > player.MAX_RUN_SPEED) {
        player.velocity.x = player.MAX_RUN_SPEED * sign(player.velocity.x);
      }
      
      PVector deltaPosition = PVector.mult(player.velocity, deltaTime);
      PVector newPosition = PVector.add(player.position, deltaPosition);
      
      // Side collisions
      if(!level.isCoordEmptySpace(newPosition.x, player.position.y)) {
        player.velocity.x = 0;
        
        while(!level.isCoordEmptySpace(newPosition.x, player.position.y)) {
          newPosition.x = 0.5 * (newPosition.x + player.position.x);
        }
      }
      
      // Veritcal collisions
      if(!level.isCoordEmptySpace(player.position.x, newPosition.y)) {
        player.velocity.y = 0;
        if((int)newPosition.y < (int)player.position.y) {
          player.onGround = true;
        }
        
        while(!level.isCoordEmptySpace(player.position.x, newPosition.y)) {
          newPosition.y = 0.5 * (newPosition.y + player.position.y);
        }
      }
      
      player.position = newPosition;
    }
    
    timeOfLastFrameMs = currentTimeMs;
  }
  
  private int sign(float x) {
    return ((x > 0) ? 1 : 0) - ((x < 0) ? 1 : 0);
  }
  
  private void drawLevel() {
    stroke(0);
    for(int i = 0; i < level.levelHeight; i++) {
      for(int j = 0; j < level.levelWidth; j++) {
        if(level.blocks[i][j] == 1) {
          rect(
            width / 2 + (j - cameraPos.x) * blockWidthPixels,
            height / 2 - (i + 1 - cameraPos.y) * blockWidthPixels,
            blockWidthPixels,
            blockWidthPixels
          );
        }
      }
    } 
  }
  
  private void drawPlayer() {
    rect(
      width / 2 + (player.position.x - cameraPos.x) * blockWidthPixels - 10,
      height / 2 - (player.position.y + 1 - cameraPos.y) * blockWidthPixels,
      20,
      40
    );
    
    if(player.grappled) {
      strokeWeight(2);
      stroke(128);
      line(
        width / 2 + (player.position.x - cameraPos.x) * blockWidthPixels,
        height / 2 - (player.position.y - cameraPos.y) * blockWidthPixels - 30,
        width / 2 + (grapplePosition.x - cameraPos.x) * blockWidthPixels,
        height / 2 - (grapplePosition.y - cameraPos.y) * blockWidthPixels
      );
    }
  }
  
  private UserInterface userInterface = null;
}
