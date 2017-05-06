/*
 *
 */
#ifndef INCLUDED_XXCORE_PLAYER_AS
#define INCLUDED_XXCORE_PLAYER_AS

#include "xxCore_functionality.as"



namespace PLAYER {
  shared class c_Player {
    c_Player() {
      this.Setup("", 0, "");
    }
    c_Player( string _name, u8 _team, string _default_config ) {
      this.Setup(_name, _team, _default_config);
    }

    void Setup( string _name, u8 _team, string _default_config ) {
      m_username = _name;
      m_team = _team;
      m_blob_name = _default_config;
      m_spawns_count = 0;
      m_last_spawn_request = 0;

      m_can_spawn_time = 0;
      m_flag_captures = 0;
      m_spawn_point = 0;
      m_items_collected = 0;
    }

    void Set_team( int _team ) {
      m_team = _team;
    }

    // Pure Reference Equality:
    bool opEquals( const PLAYER::c_Player&in _other ) const {
      return( this is _other );
    }

    // Pass Off To String's Comparision:
    int opCmp( const PLAYER::c_Player&in _other ) const {
      return( m_username.opCmp( _other.m_username ));
    }

    string m_username; // Used To Get The Player.
    u8 m_team;
    string m_blob_name;
    int m_spawns_count;
    int m_last_spawn_request;

    u32 m_can_spawn_time;
    u32 m_flag_captures;
    u32 m_spawn_point;
    u32 m_items_collected;
  };
}//PLAYER



#endif
