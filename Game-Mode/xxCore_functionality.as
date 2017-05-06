/*
 *
 */
#ifndef INCLUDED_XXCORE_FUNCTIONALITY_AS
#define INCLUDED_XXCORE_FUNCTIONALITY_AS



namespace FUN {
  namespace Item_flag {
    const u32 BUILDER = 0x01;
    const u32 ARCHER = 0x02;
    const u32 KNIGHT = 0x04;
  }//Item_flag
}//FUN



namespace FUN {
  shared class UI_data {
    UI_data() {
    }
    
    void Add_team( int _team ) {
      for( int i = 0 ; i < m_teams.size() ; ++i ) {
	if( m_teams[i] == _team )
	  return;
      }//for
      m_teams.push_back( _team );
    }
    
    CBitStream Serialize() {
      CBitStream bt;
      // Check Bits:
      bt.write_u16( 0x5afe );
      
      for( int i = 0 ; i < m_teams.size() ; ++i ) {
	bt.write_u8( m_teams[i] );
	string stuff = "";
	for( int j = 0 ; j < m_flag_teams.size() ; ++j ) {
	  if( m_flag_teams[j] == m_teams[i] )
	    stuff += m_flag_states[j];
	}//for
	bt.write_string( stuff );
      }//for
      return bt;
    }
    
    int[] m_teams;
    int[] m_flag_teams;
    int[] m_flag_IDs;
    string[] m_flag_states;
  };
}//FUN



// How Each Team Is Serialised:
namespace FUN {
  shared class CTF_HUD {
    CTF_HUD() {
    }
    CTF_HUD( CBitStream@ _bt ) {
      this.Unserialise( _bt );
    }

    void Serialise( CBitStream@ _bt ) {
      _bt.write_u8( m_team_num );
      _bt.write_string( m_flag_pattern );
    }
    void Unserialise( CBitStream@ _bt ) {
      m_team_num = _bt.read_u8();
      m_flag_pattern = _bt.read_string();
    }

    // Is This Our Team?
    u8 m_team_num;
    // Easy Serial:
    string m_flag_pattern;
  };
}//FUN



#endif
