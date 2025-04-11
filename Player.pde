
class Player {
  
  Player() {
    position = new PVector(0, 0);
    velocity = new PVector(0, 0);
  }
  
  PVector position;
  PVector velocity;
  boolean isGrappled = false;
  boolean onGround = true;
}
