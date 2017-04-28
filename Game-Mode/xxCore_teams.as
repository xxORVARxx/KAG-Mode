/*
 *
 */
#ifndef INCLUDED_XXCORE_TEAMS_AS
#define INCLUDED_XXCORE_TEAMS_AS



namespace TEAMS {
  shared class c_Human {
    c_Human() {
      index = 0;
      name = "";
      this.Reset();
    }
    c_Human( int _index, string _name ) {
      m_index = _index;
      m_name = _name;
      this.Reset();
    }
  
    void Reset() {
      m_players_count = 0;
      m_alive_count = 0;
      m_lost = false;
    }

    int m_index;
    string m_name;
    int m_players_count;
    int m_alive_count;
    bool m_lost;
  };
}//TEAMS



namespace TEAMS {
  shared class c_Zef {
    c_Zef() {
      index = 0;
      name = "";
      this.Reset();
    }
    c_Zef( int _index, string _name ) {
      m_index = _index;
      m_name = _name;
      this.Reset();
    }
  
    void Reset() {
      m_zef_count = 0;
      m_alive_count = 0;
      m_lost = false;
    }

    int m_index;
    string m_name;
    int m_zef_count;
    int m_alive_count;
    bool m_lost;
  };
}//TEAMS



#endif
/*
namespace TEAMS {
  shared s32 Get_team_size( TEAMS::c_People@[]@ teams, int team )
  {
    if (team >= 0 && team < teams.length)
      {
	return teams[team].players_count;
      }

    return 0;
  }
}//TEAMS



shared s32 getSmallestTeam(BaseTeamInfo@[]@ teams)
{
	s32 lowestTeam = (XORRandom(512) % teams.length);
	s32 lowestCount = teams[lowestTeam].players_count;

	for (uint i = 0; i < teams.length; i++)
	{
		int size = getTeamSize(teams, i);
		if (size < lowestCount)
		{
			lowestCount = size;
			lowestTeam = i;
		}
	}

	return lowestTeam;
}

shared int getLargestTeam(BaseTeamInfo@[]@ teams)
{
	s32 largestTeam = (XORRandom(512) % teams.length);
	s32 largestCount = teams[largestTeam].players_count;

	for (uint i = 0; i < teams.length; i++)
	{
		s32 size = getTeamSize(teams, i);
		if (size > largestCount)
		{
			largestCount = size;
			largestTeam = i;
		}
	}

	return largestTeam;
}

shared int getTeamDifference(BaseTeamInfo@[]@ teams)
{
	s32 lowestCount = getTeamSize(teams, getSmallestTeam(teams));
	s32 highestCount = getTeamSize(teams, getLargestTeam(teams));

	return (highestCount - lowestCount);
}

