
class Player {
  
  final float RUN_ACC = 5;
  final float BRAKE_ACC = 10;
  final float MAX_RUN_SPEED = 10;
  
  final float JUMP_SPEED = 5;
  
  final float SWING_ANGULAR_ACC = 0.5;
  
  PVector position;
  PVector velocity;  
  float angularVelocity = 0;
  
  boolean grappled = false;
  boolean onGround = true;
  
  Player() {
    position = new PVector(0, 0);
    velocity = new PVector(0, 0);
  }
}
