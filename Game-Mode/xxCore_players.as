/*
 *
 */
#ifndef INCLUDED_XXCORE_PLAYER_AS
#define INCLUDED_XXCORE_PLAYER_AS



namespace PLAYER {
  shared class c_Player_info
  {
    Player_info() {
      this.Setup("", 0, "");
    }
    Player_info( string _name, int _team, string _default_config ) {
      this.Setup(_name, _team, _default_config);
    }

    void Setup( string _name, int _team, string _default_config ) {
      m_username = _name;
      m_team = _team;
      m_blob_name = _default_config;
      m_spawns_count = 0;
      m_last_spawn_request = 0;
    }

    void Set_team( int _team ) {
      m_team = _team;
    }

    // Pure Reference Equality:
    bool opEquals( const PLAYER::c_Player_info &in _other ) const {
      return( this is _other );
    }

    // Pass Off To String's Comparision:
    int opCmp( const PLAYER::c_Player_info &in _other ) const {
      return( m_username.opCmp( _other.m_username ));
    }

    string m_username; // Used To Get The Player.
    int m_team;
    string m_blob_name;
    int m_spawns_count;
    int m_last_Spawn_request;
  };
}//PLAYER



#endif
