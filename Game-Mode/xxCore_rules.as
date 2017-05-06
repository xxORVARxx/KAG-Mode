/*
 *
 */
#define SERVER_ONLY

#include "xxCore_players.as";
#include "xxCore_teams.as";


namespace RULES {
  // Simple Config Function. Edit The Variables Below To Change The Basics:
  void Config( RULES::c_Core@ _this ) {
    string configstr = "Game-Mode/Rules/TheAnswer_variables.cfg";
    if( getRules().exists("TheAnswer_config"))
      configstr = getRules().get_string("TheAnswer_config");
    ConfigFile cfg = ConfigFile( configstr );
    // How Long For The Game To Play Out?:
    s32 game_duration_minutes = cfg.read_s32("game_time", -1 );
    if( game_duration_minutes <= 0 ) {
      _this.m_game_duration = 0;
      getRules().set_bool("no timer", true );
    }
    else
      _this.m_game_duration = ( getTicksASecond() * 60 * game_duration_minutes );//<-- GLOBAL-FUNCTIONS!
    // Spawn After Death Time:
    _this.m_spawn_time = ( getTicksASecond() * cfg.read_s32("spawn_time", 15 ));//<-- GLOBAL-FUNCTIONS!
  }
}//RULES



namespace RULES {
  shared class c_Core {
    c_Core() {
      error("DO NOT DO THIS! INITIALISE WITH RULES::c_Core(RULES,RESPAWNS)");
    }
    c_Core( CRules@ _rules, RESPAWN::c_System@ _respawns ) {
      Setup( _rules, _respawns );
    }
    c_Core( bool delay_setup ) {
      if( delay_setup == false )
	error("xxCORE-RULES: Delayed setup used incorrectly");
    }

    void Setup( CRules@ _rules = null, RESPAWN::c_System@ _respawns = null ) {
      @m_rules = _rules;
      @m_respawns = _respawns;
      if( @m_respawns != null )
	m_respawns.Set_rules( this );
      this.Setup_teams();
      this.Setup_players();
      this.Add_all_players_to_spawn();
    }
    void Update() {
      if( @m_respawns != null )
	m_respawns.Update();
    }

    // Working With Teams:
    void Setup_teams() {
      if( m_rules.getTeamsCount() != 1 )//<-- MEMBER-FUNCTION!
	error("xxCORE-RULES: Expected Exactly One Team!");      
    }
    void Change_team_player_count( int _amount ) {
      if( @m_humans != null )
	m_humans.m_players_count += _amount;
    }
    
    // Working With Players:
    void Setup_players() {
      m_players.clear();
      for( int i = 0 ; i < getPlayersCount() ; ++i )//<-- GLOBAL-FUNCTIONS!
	this.Add_player( getPlayer( i ));//<-- GLOBAL-FUNCTIONS!
    }
    PLAYER::c_Player@ Get_player( string _username ) {
      for( int i = 0 ; i < m_players.length ; ++i ) {
	if( m_players[i].m_username == _username)
	  return m_players[i];
      }
      return null;
    }
    PLAYER::c_Player@ Get_player( CPlayer@ _player ) {
      if( @_player == null )
	return null;	
      return this.Get_player( _player.getUsername());//<-- MEMBER-FUNCTION!
    }
    void Add_player( CPlayer@ _player, u8 _team = 0, string _default_config = "" ) {
      PLAYER::c_Player@ check = this.Get_player( _player.getUsername());//<-- MEMBER-FUNCTION!
      if( @check == null ) {
	PLAYER::c_Player p_info( _player.getUsername(), _team, _default_config );//<-- MEMBER-FUNCTION!
	m_players.push_back( @p_info );
	this.Change_team_player_count( 1 );
      }
    }
    void Remove_player( CPlayer@ _player ) {
      PLAYER::c_Player@ p_info = this.Get_player( _player.getUsername());//<-- MEMBER-FUNCTION!
      if( @p_info != null ) {
	if( @m_respawns != null )// Remove Any Spawns.
	  m_respawns.Remove_player_from_spawn( _player );
	int arr_pos = m_players.find( p_info );
	if( arr_pos != -1 )
	  m_players.erase( arr_pos );
	this.Change_team_player_count( -1 );
      }
    }
    void Add_player_spawn( CPlayer@ _player ) {
      PLAYER::c_Player@ p_info = this.Get_player( _player.getUsername());//<-- MEMBER-FUNCTION!
      if( @p_info == null )
	this.Add_player( _player );
      else {
	// Safety - We Dont Want Too Much Requests:
	if(( p_info.m_last_spawn_request != 0 )&&(( p_info.m_last_spawn_request + 5 ) > getGameTime())) {//<-- GLOBAL-FUNCTIONS!
	  //printf("too many spawn requests "+ p.lastSpawnRequest +" "+ getGameTime());
	  return;
	}
	// Kill Old Player:
	this.Remove_player_blob( _player );
      }
      if(( _player.lastBlobName.length() > 0 )&&( @p_info != null ))//<-- MEMBER-FUNCTION!
	p_info.m_blob_name = this.Filter_blob_name_to_spawn( _player.lastBlobName, _player );//<-- MEMBER-FUNCTION!
      if( @m_respawns != null ) {
	m_respawns.Remove_player_from_spawn( _player );
	m_respawns.Add_player_to_spawn( _player );
	if( @p_info != null )
	  p_info.m_last_spawn_request = getGameTime();//<-- GLOBAL-FUNCTIONS!
      }
    }
    void on_Player_die( CPlayer@ _victim, CPlayer@ _killer, u8 _customData ) {
    }
    void on_Set_player( CBlob@ _blob, CPlayer@ _player ) {
    }	 
    string Filter_blob_name_to_spawn( string _proposed, CPlayer@ _player ) {
      // Overload This To Apply Some Filtering To What Blobs Players Are Allowed To Respawn As:
      return _proposed;
    }
    void Add_all_players_to_spawn() {
      uint len = m_players.length;
      uint salt = XORRandom( len );
      for( int i = 0 ; i < len ; i++ ) {
        PLAYER::c_Player@ p_info = m_players[(( i + salt ) * 997 ) % len ];
	p_info.m_last_spawn_request = 0;
	CPlayer@ player = getPlayerByUsername( p_info.m_username );//<-- MEMBER-FUNCTION!
	this.Add_player_spawn( player );
      }
    }
    void Remove_player_blob( CPlayer@ _player ) {
      if( @_player == null )
	return;
      // Remove Previous Players Blob:
      CBlob@ blob = _player.getBlob();//<-- MEMBER-FUNCTION!
      if(( @blob != null )&&( ! blob.hasTag("dead"))) {//<-- MEMBER-FUNCTION!
	blob.server_SetPlayer( null );//<-- MEMBER-FUNCTION!
	if( blob.getHealth() > 0.0f )//<-- MEMBER-FUNCTION!
	  blob.server_Die();//<-- MEMBER-FUNCTION!
      }
    }
    
    CRules@ m_rules;
    PLAYER::c_Player@[] m_players;
    TEAMS::c_Human@ m_humans;
    TEAMS::c_Zef@ m_zefs;
    RESPAWN::c_System@ m_respawns;

    s32 m_warm_up_time;
    s32 m_game_duration;
    s32 m_spawn_time;
  };
}//RULES
