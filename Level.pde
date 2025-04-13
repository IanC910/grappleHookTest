
class Level {
  
  char[][] blocks;
  int levelWidth = 10;
  int levelHeight = 10;
  
  Level(String inputPath) throws Exception {
    BufferedReader fileReader = new BufferedReader(new FileReader(inputPath));
    
    LinkedList<String> lines = new LinkedList<>();
    String line = fileReader.readLine();
    levelWidth = line.length();
    
    while(line != null) {
      lines.add(line);
      line = fileReader.readLine();
    }
    
    levelHeight = lines.size();
    blocks = new char[levelHeight][levelWidth];
    
    for(int i = 0; i < levelHeight; i++) {
      line = lines.removeLast();
      
      for(int j = 0; j < levelWidth; j++) {
        blocks[i][j] = (char)(line.charAt(j) == '#' ? 1 : 0);
      }
    }
    
    fileReader.close();
  }
  
  boolean isCoordInBlock(float x, float y) {
    if(!isCoordInLevel(x, y)) {
      return false;
    }
    return (blocks[(int)y][(int)x] == 1);
  }
  
  boolean isCoordInLevel(float x, float y) {
    return x >= 0 && x < levelWidth && y >= 0 && y < levelHeight;
  }
  
  boolean isCoordEmptySpace(float x, float y) {
    if(!isCoordInLevel(x, y)) {
      return false;
    }
    return !isCoordInBlock(x, y);
  }
}
