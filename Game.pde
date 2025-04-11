
class Game {
  
  char[][] level;
  int LEVEL_WIDTH_BLOCKS = 100;
  int LEVEL_HEIGHT_BLOCKS = 20;
  
  double zoom = 50;
  PVector cameraPos = new PVector(0, 0);
  
  Game(UserInterface userInterface) {
    this.userInterface = userInterface;
    
    level = new char[LEVEL_HEIGHT_BLOCKS][LEVEL_WIDTH_BLOCKS];
  }
  
  void executeFrame() {
    rect(1, 1, 2, 2);
    int numPixelsPerBlock = (int)zoom;
    for(int i = 0; i < LEVEL_HEIGHT_BLOCKS; i++) {
      for(int j = 0; j < LEVEL_WIDTH_BLOCKS; j++) {
        rect(
          j * numPixelsPerBlock - cameraPos.x + width / 2,
          height - (i * numPixelsPerBlock - cameraPos.y + height / 2),
          numPixelsPerBlock,
          numPixelsPerBlock
        );
      }
    }
  }
  
  private UserInterface userInterface = null;
}
