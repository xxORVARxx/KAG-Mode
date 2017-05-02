/*
 *
 */
#include "xxCore_players.as"



namespace RESPAWN {
  shared class c_System {
    c_System() {
      @m_rules = null;
    }
    
    void Update() {
      /* OVERRIDE ME */
    }
    void Add_player_to_spawn( CPlayer@ _player ) {
      /* OVERRIDE ME */
    }
    void Remove_player_from_spawn( CPlayer@ _player ) {
      /* OVERRIDE ME */
    }
    void Set_rules( RULES::c_Core@ _rules ) {
      @m_rules = _rules;
    }

    // The Actual Spawn Functions:
    CBlob@ Spawn_player_into_world( Vec2f _at, PLAYER::c_Player@ _p_info ) {
      CPlayer@ player = getPlayerByUsername( _p_info.m_username );//<-- GLOBAL-FUNCTIONS!
      if( @player != null ) {
	CBlob@ new_blob = server_CreateBlob( _p_info.m_blob_name, _p_info.m_team, _at );//<-- GLOBAL-FUNCTIONS!
	new_blob.server_SetPlayer( player );//<-- MEMBER-FUNCTION!
	player.server_setTeamNum( _p_info.m_team );//<-- MEMBER-FUNCTION!
	return new_blob;
      }
      return null;
    }

    void Do_spawn_player( PLAYER::c_Player@ _p_info ) {
      if( this.Can_spawn_player( _p_info )) {
	// Is Player Still Connected?
	CPlayer@ player = getPlayerByUsername( _p_info.m_username );//<-- GLOBAL-FUNCTIONS!
	if( @player == null )
	  return;
	this.Spawn_player_into_world( this.Get_spawn_location( _p_info ), _p_info );
	this.Remove_player_from_spawn( player );
      }
    }
    bool Can_spawn_player( PLAYER::c_Player@ _p_info ) {
      /* OVERRIDE ME */
      return true;
    }
    Vec2f Get_spawn_location( PLAYER::c_Player@ _p_info ) {
      /* OVERRIDE ME */
      return Vec2f();
    }
    bool Is_spawning( CPlayer@ _player ) {
      /* OVERRIDE ME */
      return false;
    }

    private RULES::c_Core@ m_rules;
  };
}//RESPAWN



/*
shared class RespawnSystem
{

	private RulesCore@ core;

  RespawnSystem() { @core = null; }

  void Update() { // OVERRIDE ME  }

void AddPlayerToSpawn(CPlayer@ player)  { // OVERRIDE ME  }

  void RemovePlayerFromSpawn(CPlayer@ player) { // OVERRIDE ME  }

  void SetCore(RulesCore@ _core) { @core = _core; }

  //the actual spawn functions
  CBlob@ SpawnPlayerIntoWorld(Vec2f at, PlayerInfo@ p_info)
  {
    CPlayer@ player = getPlayerByUsername(p_info.username);

    if (player !is null)
      {
	CBlob @newBlob = server_CreateBlob(p_info.blob_name, p_info.team, at);
	newBlob.server_SetPlayer(player);
	player.server_setTeamNum(p_info.team);
	return newBlob;
      }

    return null;
  }

  //suggested implementation, doesn't have to be used of course
  void DoSpawnPlayer(PlayerInfo@ p_info)
  {
    if (canSpawnPlayer(p_info))
      {
	CPlayer@ player = getPlayerByUsername(p_info.username); // is still connected?

	if (player is null)
	  {
	    return;
	  }

	SpawnPlayerIntoWorld(getSpawnLocation(p_info), p_info);
	RemovePlayerFromSpawn(player);
      }
  }

  bool canSpawnPlayer(PlayerInfo@ p_info)
  {
    // OVERRIDE ME 
    return true;
  }

  Vec2f getSpawnLocation(PlayerInfo@ p_info)
  {
    // OVERRIDE ME 
    return Vec2f();
  }

  
   // Override so rulescore can re-add when appropriate
   
  bool isSpawning(CPlayer@ player)
  {
    return false;
  }


};
*/
