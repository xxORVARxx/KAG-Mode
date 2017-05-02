 /*
 *  ./dedicatedserver.sh
 *  ./nolauncher.sh
 *  ./runlocalhost.sh 
 */
#define SERVER_ONLY

#include "xxCore_rules.as"
#include "xxCore_respawn.as";



void onInit( CRules@ _this ) {
  if( ! _this.exists("default class"))
    _this.set_string("default class", "archer");
}



void onPlayerRequestSpawn( CRules@ _this, CPlayer@ _player ) {
  Respawn( _this, _player );
}



CBlob@ Respawn( CRules@ _this, CPlayer@ _player ) {
  if( @_player != null ) {
    // Remove Previous Players Blob:
    CBlob@ blob = _player.getBlob();
    if( @blob != null ) {
      CBlob@ blob = _player.getBlob();
      blob.server_SetPlayer( null );
      blob.server_Die();
    }
    CBlob@ newBlob = server_CreateBlob( _this.get_string("default class"), 0, getSpawnLocation());
    newBlob.server_SetPlayer( _player );
    return newBlob;
  }
  return null;
}



Vec2f getSpawnLocation() {
  CMap@ map = getMap();
  if( @map != null ) {
    f32 x = XORRandom( 2 ) == 0 ? 32.0f : map.tilemapwidth * map.tilesize - 32.0f;
    return Vec2f( x, map.getLandYAtX( s32( x / map.tilesize )) * map.tilesize - 16.0f );
  }
  return Vec2f( 0, 0 );
}


