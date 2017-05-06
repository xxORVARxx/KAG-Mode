/*
 *
 */
#include "xxCore_players.as"



namespace RESPAWN {
  const s32 g_spawnspam_limit_time = 10;
}//RESPAWN



namespace RESPAWN {
  shared class c_System {
    c_System() {
      @m_rules = null;
    }
    
    void Update() {
      TEAMS::c_Human@ team = m_rules.m_humans;
      for( uint i = 0 ; i < team.m_spawns.length ; ++i ) {
	PLAYER::c_Player@ p_info = team.m_spawns[i];
	this.Update_spawn_time( p_info, i );
	this.Do_spawn_player( p_info );
      }//for
    }
    void Update_spawn_time( PLAYER::c_Player@ _p_info, int _i ) {
      if( @_p_info != null ) {
	u8 spawn_property = 255;
	if( _p_info.m_can_spawn_time > 0 ) {
	  --_p_info.m_can_spawn_time;
	  spawn_property = u8( Maths::Min( 250, ( _p_info.m_can_spawn_time / 30 )));
	}
	string propname = "TheAnswer spawn time " + _p_info.m_username;
	m_rules.m_rules.set_u8( propname, spawn_property );//<-- MEMBER-FUNCTION!
	m_rules.m_rules.SyncToPlayer( propname, getPlayerByUsername( _p_info.m_username ));//<-- 2 MEMBER-FUNCTION!
      }
    }
    

    
    void Add_player_to_spawn( CPlayer@ _player ) {
      /* OVERRIDE ME */
    }
    void Remove_player_from_spawn( CPlayer@ _player ) {
      /* OVERRIDE ME */
    }
    void Set_rules( RULES::c_Core@ _rules ) {
      @m_rules = _rules;
      m_limit = RESPAWN::g_spawnspam_limit_time;
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
    s32 m_limit;
    bool m_force;
  };
}//RESPAWN
