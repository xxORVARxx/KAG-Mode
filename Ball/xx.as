
#include "/Entities/Common/Attacks/Hitters.as";



namespace xx {
  string Get_hitter_name( int _id ) {  
    switch( _id ) {
    case Hitters::nothing :
      return "nothing";
      // Env:
    case Hitters::crush :
      return "crush"; 
    case Hitters::fall :
      return "fall"; 
    case Hitters::water :
      return "water"; 
    case Hitters::water_stun :
      return "water_stun";  
    case Hitters::water_stun_force :
      return "water_stun_force";  
    case Hitters::drown :
      return "drown"; 
    case Hitters::fire :
      return "fire";  
    case Hitters::burn :
      return "burn";   
    case Hitters::flying :
      return "flying"; 
      // Common Actor:
    case Hitters::stomp :
      return "stomp"; 
    case Hitters::suicide :
      return "suicide"; 
      // Natural:
    case Hitters::bite :
      return "bite"; 
      // Builders:
    case Hitters::builder :
      return "builder"; 
      // Knight:
    case Hitters::sword :
      return "sword"; 
    case Hitters::shield :
      return "shield"; 
    case Hitters::bomb :
      return "bomb"; 
      // Archer:
    case Hitters::stab :
      return "stab"; 
      // Arrows And Similar Projectiles:
    case Hitters::arrow :
      return "arrow"; 
    case Hitters::bomb_arrow :
      return "bomb_arrow"; 
    case Hitters::ballista :
      return "ballista"; 
      // Cata:
    case Hitters::cata_stones :
      return "cata_stones"; 
    case Hitters::cata_boulder :
      return "cata_boulder"; 
    case Hitters::boulder :
      return "boulder"; 
      // Siege:
    case Hitters::ram :
      return "ram"; 
      // Explosion:
    case Hitters::explosion :
      return "explosion"; 
    case Hitters::keg :
      return "keg"; 
    case Hitters::mine :
      return "mine"; 
    case Hitters::mine_special :
      return "mine_special"; 
      // Traps:
    case Hitters::spikes :
      return "spikes"; 
      // Machinery:
    case Hitters::saw :
      return "saw"; 
    case Hitters::drill :
      return "drill"; 
      // Barbarian:
    case Hitters::muscles :
      return "muscles";  
      // Scrolls:
    case Hitters::suddengib :
      return "suddengib"; 
    }//switch
    return "n/a" ;
  }
}//xx


namespace xx {
  string Get_vector_as_string( Vec2f _vec ) {    
    string x = formatInt( _vec.x, 'l', 15 );
    x.resize( x.findFirst( " ", 0 ));
    string y = formatInt( _vec.y, 'l', 15 );
    y.resize( y.findFirst( " ", 0 ));
    return "( "+ x +", "+ y +" )";
  }
}//xx
