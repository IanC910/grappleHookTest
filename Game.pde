
class Game {
  
  char[][] level;
  int LEVEL_WIDTH = 100;
  int LEVEL_HEIGHT = 10;
  
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
    else {
      PVector acceleration = new PVector(0, 0);
      
      if(player.onGround) {
        int moveRight = userInterface.isKeyPressed('d') ? 1 : 0;
        int moveLeft = userInterface.isKeyPressed('a') ? 1 : 0;
        int moveDirection = moveRight - moveLeft;
        
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
        
        if(userInterface.isKeyPressed(' ')) {
          player.velocity.y += player.JUMP_SPEED;
          player.onGround = false;
        }
      }
      else { // In air
        acceleration = new PVector(0, GRAVITY_ACC);
      }
      
      player.velocity.add(PVector.mult(acceleration, deltaTime));
      PVector deltaPosition = PVector.mult(player.velocity, deltaTime);
      PVector newPosition = PVector.add(player.position, deltaPosition);
      
      while(!isCoordEmptySpace(newPosition)) {
        newPosition.add(player.position);
        newPosition.mult(0.5);
      }
      
      player.position = newPosition;
      
      print(acceleration + ", " + player.velocity + "\n");
    }
    
    timeOfLastFrameMs = currentTimeMs;
  }
  
  private boolean isCoordInBlock(PVector coord) {
    return (level[(int)coord.y][(int)coord.x] == 1);
  }
  
  private boolean isCoordInLevel(PVector coord) {
    return coord.x >= 0 && coord.x < LEVEL_WIDTH && coord.y >= 0 && coord.y < LEVEL_HEIGHT;
  }
  
  private boolean isCoordEmptySpace(PVector coord) {
    if(!isCoordInLevel(coord)) {
      return false;
    }
    return !isCoordInBlock(coord);
  }
  
  private int sign(float x) {
    return ((x > 0) ? 1 : 0) - ((x < 0) ? 1 : 0);
  }
  
  private void drawLevel() {
    for(int i = 0; i < LEVEL_HEIGHT; i++) {
      for(int j = 0; j < LEVEL_WIDTH; j++) {
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
    level = new char[LEVEL_HEIGHT][LEVEL_WIDTH];
    for(int j = 0; j < LEVEL_WIDTH; j++) {
      level[0][j] = 1;
      level[LEVEL_HEIGHT - 1][j] = 1;
    }
  }
  
  private UserInterface userInterface = null;
}
