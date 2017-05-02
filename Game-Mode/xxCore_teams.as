/*
 *
 */
#ifndef INCLUDED_XXCORE_TEAMS_AS
#define INCLUDED_XXCORE_TEAMS_AS



namespace TEAMS {
  shared class c_Human {
    c_Human() {
      this.Reset();
    }
  
    void Reset() {
      m_players_count = 0;
      m_alive_count = 0;
      m_lost = false;
    }

    int m_players_count;
    int m_alive_count;
    bool m_lost;
  };
}//TEAMS



namespace TEAMS {
  shared class c_Zef {
    c_Zef() {
      this.Reset();
    }
  
    void Reset() {
      m_zef_count = 0;
      m_alive_count = 0;
      m_lost = false;
    }

    int m_zef_count;
    int m_alive_count;
    bool m_lost;
  };
}//TEAMS



#endif
