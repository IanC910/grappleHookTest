
class Game {
  
  char[][] level;
  int LEVEL_WIDTH_BLOCKS = 100;
  int LEVEL_HEIGHT_BLOCKS = 10;
  
  int blockWidthPixels = 40;
  PVector cameraPos = new PVector(0, 0);
  Player player;
  
  long timeOfLastFrameMs = 0;
  
  Game(UserInterface userInterface) {
    this.userInterface = userInterface;
    
    initLevel();
    
    player = new Player();
    player.position = new PVector(1, 1);
  }
  
  void drawFrame() {
    handleUserInput();
    
    doPhysics();
    
    cameraPos = player.position;
    
    drawLevel();
    drawPlayer();
  }
  
  private void handleUserInput() {
    player.velocity.x = 0;
    if(userInterface.isKeyPressed('d')) {
      player.velocity.x += 1;
    }
    if(userInterface.isKeyPressed('a')) {
      player.velocity.x += -1;
    }
  }
  
  private void doPhysics() {
    long currentTimeMs = millis();
    float deltaTimeMs = (float)(currentTimeMs - timeOfLastFrameMs);
    
    player.position.add(PVector.mult(player.velocity, deltaTimeMs / 1000));
    
    timeOfLastFrameMs = currentTimeMs;
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
      width / 2 + (player.position.x  - cameraPos.x) * blockWidthPixels,
      height / 2 - (player.position.y  - cameraPos.y) * blockWidthPixels,
      10,
      10
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
