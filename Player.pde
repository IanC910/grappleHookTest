
class Player {
  
  final float MAX_RUN_SPEED = 10;
  final float RUN_ACC = 5;
  final float BRAKE_ACC = 10;
  
  final float JUMP_SPEED = 5;
  
  PVector position;
  PVector velocity;
  
  boolean grappled = false;
  boolean onGround = true;
  
  Player() {
    position = new PVector(0, 0);
    velocity = new PVector(0, 0);
  }
}
