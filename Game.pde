
class Game {
  
  char[][] level;
  int LEVEL_WIDTH_BLOCKS = 100;
  int LEVEL_HEIGHT_BLOCKS = 10;
  
  float GRAVITY_ACC = -10;
  
  int blockWidthPixels = 40;
  PVector cameraPos = new PVector(0, 0);
  Player player;
  
  long timeOfLastFrameMs = 0;
  
  Game(UserInterface userInterface) {
    this.userInterface = userInterface;
    
    initLevel();
    
    player = new Player();
    player.position = new PVector(0, 1);
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
    
    if(player.grappled) {
      
      
    }
    
    else if(player.onGround) {
      PVector acceleration = new PVector(0, 0);
      
      int moveRight = userInterface.isKeyPressed('d') ? 1 : 0;
      int moveLeft = userInterface.isKeyPressed('a') ? 1 : 0;
      int moveDirection = moveRight - moveLeft;
      
      if(moveDirection == sign(player.velocity.x) || player.velocity.x == 0) { // Running
        acceleration.x = moveDirection * player.RUN_ACC;
      }
      else { // Braking
        if(abs(player.velocity.x) < 0.1) {
          player.velocity.x = 0;
        }
        else {
          acceleration.x = -player.BRAKE_ACC * sign(player.velocity.x);
        }
      }
      
      if(userInterface.isKeyPressed(' ')) {
        player.velocity.y += player.JUMP_SPEED;
        player.onGround = false;
      }
      
      player.velocity.add(PVector.mult(acceleration, deltaTime));
      player.position.add(PVector.mult(player.velocity, deltaTime));      

      print(acceleration + ", " + player.velocity + "\n");
    }
    
    else { // In air
      PVector acceleration = new PVector(0, GRAVITY_ACC);
      
      player.velocity.add(PVector.mult(acceleration, deltaTime));
      PVector deltaPosition = PVector.mult(player.velocity, deltaTime);
      PVector newPosition = PVector.add(player.position, deltaPosition);
      
      while(level[(int)newPosition.y][(int)newPosition.x] == 1) {
        newPosition.add(player.position);
        newPosition.mult(0.5);
        player.onGround = true;
        player.velocity.y = 0;
      }
      
      player.position = newPosition;
      
      print(acceleration + ", " + player.velocity + "\n");
    }
    
    timeOfLastFrameMs = currentTimeMs;
  }
  
  private int sign(float x) {
    return ((x > 0) ? 1 : 0) - ((x < 0) ? 1 : 0);
  }
  
  private void drawLevel() {
    for(int i = 0; i < LEVEL_HEIGHT_BLOCKS; i++) {
      for(int j = 0; j < LEVEL_WIDTH_BLOCKS; j++) {
        if(level[i][j] == 1) {
          rect(
            width / 2 + (j - cameraPos.x) * blockWidthPixels,
            height / 2 - (i - cameraPos.y) * blockWidthPixels,
            blockWidthPixels,
            blockWidthPixels
          );
        }
      }
    }
  }
  
  private void drawPlayer() {
    rect(
      width / 2 + (player.position.x - cameraPos.x) * blockWidthPixels,
      height / 2 - (player.position.y - cameraPos.y) * blockWidthPixels,
      20,
      20
    );
  }
  
  private void initLevel() {
    level = new char[LEVEL_HEIGHT_BLOCKS][LEVEL_WIDTH_BLOCKS];
    for(int j = 0; j < LEVEL_WIDTH_BLOCKS; j++) {
      level[0][j] = 1;
      level[LEVEL_HEIGHT_BLOCKS - 1][j] = 1;
    }
  }
  
  private UserInterface userInterface = null;
}
