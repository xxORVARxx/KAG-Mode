
#include "/Entities/Common/Attacks/Hitters.as";
//#include "/Entities/Common/Attacks/LimitedAttacks.as";

// Attacks Limited To The One Time Per-Actor Before Reset.
void LimitedAttack_setup(CBlob@ this)
{
	u16[] networkIDs;
	this.set("LimitedActors", networkIDs);
}

bool LimitedAttack_has_hit_actor(CBlob@ this, CBlob@ actor)
{
	u16[]@ networkIDs;
	this.get("LimitedActors", @networkIDs);
	return networkIDs.find(actor.getNetworkID()) >= 0;
}

void LimitedAttack_add_actor(CBlob@ this, CBlob@ actor)
{
	this.push("LimitedActors", actor.getNetworkID());
}

void LimitedAttack_clear(CBlob@ this)
{
	this.clear("LimitedActors");
}
//----------------------------------------------------------------------



#include "xx.as"
/*
const int pierce_amount = 8;

const f32 hit_amount_ground = 0.5f;
const f32 hit_amount_air = 1.0f;
const f32 hit_amount_air_fast = 3.0f;
const f32 hit_amount_cata = 10.0f;
*/


void onInit(CBlob @ this)
{
  // string formatInt(int64 val, const string &in options = '', uint width = 0)
  print( "Hello From Ball!" );
  print( formatInt( this.getNetworkID(), 'l', 20 ));
  print( formatInt( this.getNetworkID() % 4, 'l', 20 ));

		      
  
  
  this.set_u8("launch team", 255);
  this.server_setTeamNum(-1);
  this.Tag("medium weight");

  LimitedAttack_setup(this); // <---------------------------

  this.set_u8("blocks_pierced", 0);
  u32[] tileOffsets;
  this.set("tileOffsets", tileOffsets);
  /*
  // damage
  this.getCurrentScript().runFlags |= Script::tick_not_attached;
  this.getCurrentScript().tickFrequency = 3;
  */
}



void onTick(CBlob@ this)
{ 
   Vec2f vel = this.getVelocity();
   Vec2f oldvel = this.getOldVelocity();
   Vec2f pos = this.getPosition();
   CMap@ map = this.getMap();

   // Map size in pixels:
   float map_right = map.tilesize*map.tilemapwidth;
	
	if ((oldvel.y < 0) && (vel.y > 0)) 
	{
	int rx = XORRandom( 20 ) - 10; 
	int ry = XORRandom( 20 ) - 10;
	vel.x = rx;
	vel.y = ry;
	}
	
 if (pos.x >= map_right - 5 && vel.x > 0)
   {
     print("right map collision detected");
     vel.x = -oldvel.x;
   }

   if (pos.x <= 5 && vel.x < 0)
   {
     print("left map collision detected");
     vel.x = -oldvel.x;
   }  
   this.setVelocity(vel);
   
  /*
  //rock and roll mode
  if (!this.getShape().getConsts().collidable)
    {
      Vec2f vel = this.getVelocity();
      f32 angle = vel.Angle();
      Slam(this, angle, vel, this.getShape().vellen * 1.5f);
    }
  */
}


/*
void onDetach(CBlob@ this, CBlob@ detached, AttachmentPoint@ attachedPoint)
{
  if (detached.getName() == "catapult") // rock n' roll baby
    {
      this.getShape().getConsts().mapCollisions = false;
      this.getShape().getConsts().collidable = false;
      this.getCurrentScript().tickFrequency = 3;
    }
  this.set_u8("launch team", detached.getTeamNum());
}



void onAttach(CBlob@ this, CBlob@ attached, AttachmentPoint @attachedPoint)
{
  if(attached.getPlayer() !is null)
    {
      this.SetDamageOwnerPlayer(attached.getPlayer());
    }

  if (attached.getName() != "catapult") // end of rock and roll
    {
      this.getShape().getConsts().mapCollisions = true;
      this.getShape().getConsts().collidable = true;
      this.getCurrentScript().tickFrequency = 1;
    }
  this.set_u8("launch team", attached.getTeamNum());
}
*/

/*
void Slam(CBlob @this, f32 angle, Vec2f vel, f32 vellen)
{
  if (vellen < 0.1f)
    return;

  CMap@ map = this.getMap();
  Vec2f pos = this.getPosition();
  HitInfo@[] hitInfos;
  u8 team = this.get_u8("launch team");

  if (map.getHitInfosFromArc(pos, -angle, 30, vellen, this, false, @hitInfos))
    {
      for (uint i = 0; i < hitInfos.length; i++)
	{
	  HitInfo@ hi = hitInfos[i];
	  f32 dmg = 2.0f;

	  if (hi.blob is null) // map
	    {
	      if (BoulderHitMap(this, hi.hitpos, hi.tileOffset, vel, dmg, Hitters::cata_boulder))
		return;
	    }
	  else if (team != u8(hi.blob.getTeamNum()))
	    {
	      this.server_Hit(hi.blob, pos, vel, dmg, Hitters::cata_boulder, true);
	      this.setVelocity(vel * 0.9f); //damp

	      // die when hit something large
	      if (hi.blob.getRadius() > 32.0f)
		{
		  this.server_Hit(this, pos, vel, 10, Hitters::cata_boulder, true);
		}
	    }
	}
    }

  // chew through backwalls

  Tile tile = map.getTile(pos);
  if (map.isTileBackgroundNonEmpty(tile))
    {
      if (map.getSectorAtPosition(pos, "no build") !is null)
	{
	  return;
	}
      map.server_DestroyTile(pos + Vec2f(7.0f, 7.0f), 10.0f, this);
      map.server_DestroyTile(pos - Vec2f(7.0f, 7.0f), 10.0f, this);
    }
}
*/

/*
bool BoulderHitMap(CBlob@ this, Vec2f worldPoint, int tileOffset, Vec2f velocity, f32 damage, u8 customData)
{
  //check if we've already hit this tile
  u32[]@ offsets;
  this.get("tileOffsets", @offsets);

  if (offsets.find(tileOffset) >= 0) { return false; }

  this.getSprite().PlaySound("ArrowHitGroundFast.ogg");
  f32 angle = velocity.Angle();
  CMap@ map = getMap();
  TileType t = map.getTile(tileOffset).type;
  u8 blocks_pierced = this.get_u8("blocks_pierced");
  bool stuck = false;

  if (map.isTileCastle(t) || map.isTileWood(t))
    {
      Vec2f tpos = this.getMap().getTileWorldPosition(tileOffset);
      if (map.getSectorAtPosition(tpos, "no build") !is null)
	{
	  return false;
	}

      //make a shower of gibs here

      map.server_DestroyTile(tpos, 100.0f, this);
      Vec2f vel = this.getVelocity();
      this.setVelocity(vel * 0.8f); //damp
      this.push("tileOffsets", tileOffset);

      if (blocks_pierced < pierce_amount)
	{
	  blocks_pierced++;
	  this.set_u8("blocks_pierced", blocks_pierced);
	}
      else
	{
	  stuck = true;
	}
    }
  else
    {
      stuck = true;
    }

  if (velocity.LengthSquared() < 5)
    stuck = true;

  if (stuck)
    {
      this.server_Hit( this, worldPoint, velocity, 10, Hitters::crush, true ); // <------ goes to: 'onHit()'.
    }

  return stuck;
}
*/

/*
void onCollision(CBlob@ this, CBlob@ blob, bool solid, Vec2f normal, Vec2f point1)
{
  if (solid && blob !is null)
    {
      Vec2f hitvel = this.getOldVelocity();
      Vec2f hitvec = point1 - this.getPosition();
      f32 coef = hitvec * hitvel;

      if (coef < 0.706f) // check we were flying at it
	{
	  return;
	}

      f32 vellen = hitvel.Length();

      //fast enough
      if (vellen < 1.0f)
	{
	  return;
	}

      u8 tteam = this.get_u8("launch team");
      CPlayer@ damageowner = this.getDamageOwnerPlayer();

      //not teamkilling (except self)
      if (damageowner is null || damageowner !is blob.getPlayer())
	{
	  if (
	      (blob.getName() != this.getName() &&
	       (blob.getTeamNum() == this.getTeamNum() || blob.getTeamNum() == tteam))
	      )
	    {
	      return;
	    }
	}

      //not hitting static stuff
      if (blob.getShape() !is null && blob.getShape().isStatic())
	{
	  return;
	}

      //hitting less or similar mass
      if (this.getMass() < blob.getMass() - 1.0f)
	{
	  return;
	}

      //get the dmg required
      hitvel.Normalize();
      f32 dmg = vellen > 8.0f ? 5.0f : (vellen > 4.0f ? 1.5f : 0.5f);

      //bounce off if not gibbed
      if(dmg < 4.0f)
	{
	  this.setVelocity(blob.getOldVelocity() + hitvec * -Maths::Min(dmg * 0.33f, 1.0f));
	}

      //hurt
      this.server_Hit(blob, point1, hitvel, dmg, Hitters::boulder, true); // <------ goes to: 'onHit()'.

      return;

    }
}
*/


f32 onHit( CBlob@ this, Vec2f worldPoint, Vec2f velocity, f32 damage, CBlob@ hitterBlob, u8 customData )
{
 if (this is null || hitterBlob is null)
 return 0;

  // Spawn A New Ball:
  CMap@ map = getMap();
  if (map !is null)
    {
      f32 borders = 16 * 10;
      f32 map_area = (( map.tilemapwidth * map.tilesize ) - ( borders * 2 ));
      f32 x = borders + XORRandom( map_area );
      Vec2f spawn_pos( x, map.getLandYAtX( s32( x / map.tilesize )) * map.tilesize - (( 16.0f * 5.0f ) + XORRandom( 16 * 5 )));    
      CBlob@ new_ball = server_CreateBlob("ball");
	  if (new_ball is null)
	  return 0;	
      new_ball.setPosition( spawn_pos );
      print("Spawned A New Ball At: "+ xx::Get_vector_as_string( spawn_pos ) +" :)"); 
    }


  
  // Print The Hitter'S Name:
  print( "The Ball Was Hit By "+ xx::Get_hitter_name( customData ) +"!" );
  CPlayer@ hitter_player = hitterBlob.getDamageOwnerPlayer();
  if( @hitter_player != null )
    { 
      hitter_player.setKills( hitter_player.getKills() + 1 );
      print( "Hit By: "+ hitter_player.getUsername() +"!");
    }
  else
    print( "Not Hit By Player?");

  // Arrows Kill It!:
  if( customData == Hitters::arrow || customData == Hitters::bomb_arrow || customData == Hitters::water_stun || customData == Hitters::fire ) {
    return 10;
  }
  return damage * 0.5;
}




/*
// Sprite:
void onInit(CSprite@ this)
{
  this.animation.frame = (this.getBlob().getNetworkID() % 4);
  this.getCurrentScript().runFlags |= Script::remove_after_this;
}
*/
