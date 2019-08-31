

class Player{
  int health_point;

  int get hp{
    return health_point;
  }
  set hp(int value){
    health_point+=value;
  }

  Player(this.health_point);
}

void main(){
  var player = Player(10);

  player.hp = 10;
  print(player.hp);

}