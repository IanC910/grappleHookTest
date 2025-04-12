
class Player {
  
  Player() {
    position = new PVector(0, 0);
    velocity = new PVector(0, 0);
  }
  
  PVector position;
  PVector velocity;
  final float MAX_RUN_SPEED = 5;
  final float JUMP_SPEED = 5;
  final float RUN_ACC = 5;
  boolean grappled = false;
  boolean onGround = true;
}
