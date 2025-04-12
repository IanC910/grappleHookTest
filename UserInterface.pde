
class UserInterface { 
  
  UserInterface() {
    keyStatus = new boolean[256];
    mouseButtonStatus = new boolean[40];
    reset();
  }  
  
  void reset() {
    for(int i = 0; i < keyStatus.length; i++) {
      keyStatus[i] = false;
    }
    
    for(int i = 0; i < mouseButtonStatus.length; i++) {
      mouseButtonStatus[i] = false;
    }
  }
  
  void keyPressed() {
    keyStatus[key] = true;
  }
    
  void keyReleased() {
    keyStatus[key] = false;
  }
  
  void mousePressed() {
    mouseButtonStatus[mouseButton] = true;
  }
  
  void mouseReleased() {
    mouseButtonStatus[mouseButton] = false;
  }
  
  boolean isKeyPressed(char k) {
    return keyStatus[k];
  }
  
  boolean isMouseButtonPressed(int mb) {
    return mouseButtonStatus[mb]; 
  }
  
  private boolean[] keyStatus;
  private boolean[] mouseButtonStatus;
}
