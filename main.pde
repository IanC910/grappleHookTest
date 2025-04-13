import java.util.LinkedList;
import java.io.FileReader;

UserInterface userInterface;
Game game;

void setup() {
  size(1280, 720);
  userInterface = new UserInterface();
  game = new Game(userInterface);
}

void draw() {
  background(0);
  game.drawFrame();
  
}

void keyPressed() {
  userInterface.keyPressed();
}

void keyReleased() {
  userInterface.keyReleased();
}

void mousePressed() {
  userInterface.mousePressed();
}

void mouseReleased() {
  userInterface.mouseReleased();
}
  
