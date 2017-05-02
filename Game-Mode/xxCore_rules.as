/*
 *
 */
#include "xxCore_players.as";
#include "xxCore_teams.as";



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
      //this.Setup_players();------------------------------------------------------
      //this.Add_all_players_to_spawn();--------------------------------------------
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

    CRules@ m_rules;
    PLAYER::c_Player@[] m_players;
    TEAMS::c_Human@ m_humans;
    TEAMS::c_Zef@ m_zefs;
    RESPAWN::c_System@ m_respawns;
  };
}//RULES



/*
shared class RulesCore
{

	CRules@ rules;

	PlayerInfo@[] players;
	BaseTeamInfo@[] teams;

	RespawnSystem@ respawns;

	//default
	RulesCore() { error("DO NOT DO THIS! INITIALISE WITH RULESCORE(RULES,RESPAWNS)"); }

	//intended constructor, doesn't yell at you
	RulesCore(CRules@ _rules, RespawnSystem@ _respawns) { Setup(_rules, _respawns); }

	//delay setup
	RulesCore(bool delay_setup) { if (delay_setup == false) error("RULESCORE: Delayed setup used incorrectly"); }

	void Setup(CRules@ _rules = null, RespawnSystem@ _respawns = null)
	{
		@rules = _rules;
		@respawns = _respawns;

		if (respawns !is null)
		{
			respawns.SetCore(this);
		}

		SetupTeams();
		SetupPlayers();
		AddAllPlayersToSpawn();
	}

	void Update()
	{
		if (respawns !is null)
		{
			respawns.Update();
		}
	}

	//working with teams

	void SetupTeams()
	{
		teams.clear();

		for (int team_step = 0; team_step < rules.getTeamsCount(); ++team_step)
		{
			AddTeam(rules.getTeam(team_step));
		}
	}

	void AddTeam(CTeam@ team)
	{
		BaseTeamInfo t(teams.length, team.getName());
		teams.push_back(@t);
	}

	BaseTeamInfo@ getTeam(int teamNum)
	{
		if (teamNum < 0 || teamNum >= int(teams.length))
		{
			return null;
		}

		return teams[teamNum];
	}

	void ChangeTeamPlayerCount(int teamNum, int amountBy)
	{
		BaseTeamInfo@ t = getTeam(teamNum);

		if (t !is null) { t.players_count += amountBy; }
	}

	//working with players

	void SetupPlayers()
	{
		players.clear();
		for (int player_step = 0; player_step < getPlayersCount(); ++player_step)
		{
			AddPlayer(getPlayer(player_step));
		}
	}

	PlayerInfo@ getInfoFromName(string username)
	{
		for (uint k = 0; k < players.length; k++)
		{
			if (players[k].username == username)
			{
				return players[k];
			}
		}

		return null;
	}

	PlayerInfo@ getInfoFromPlayer(CPlayer@ player)
	{
		if (player !is null)
		{
			return getInfoFromName(player.getUsername());
		}
		else
		{
			return null;
		}
	}

	void AddPlayer(CPlayer@ player, u8 team = 0, string default_config = "")
	{
		PlayerInfo@ check = getInfoFromName(player.getUsername());
		if (check is null)
		{
			PlayerInfo p(player.getUsername(), team, default_config);
			players.push_back(@p);
			ChangeTeamPlayerCount(p.team, 1);
		}
	}

	void RemovePlayer(CPlayer@ player)
	{
		PlayerInfo@ p = getInfoFromName(player.getUsername());

		if (p !is null)
		{
			if (respawns !is null) //remove any spawns
			{
				respawns.RemovePlayerFromSpawn(player);
			}

			int pos = players.find(p);

			if (pos != -1)
			{
				players.erase(pos);
			}

			ChangeTeamPlayerCount(p.team, -1);
		}
	}

	void ChangePlayerTeam(CPlayer@ player, int newTeamNum)
	{
		PlayerInfo@ p = getInfoFromName(player.getUsername());

		if (p.team != newTeamNum)
		{
			if (g_debug > 0)
				print("CHANGING PLAYER TEAM FROM " + p.team + " to " + newTeamNum);
		}
		else
		{
			return;
		}

		bool is_spawning = false;
		if (respawns !is null && respawns.isSpawning(player))
		{
			is_spawning = true;
			respawns.RemovePlayerFromSpawn(player);
		}

		ChangeTeamPlayerCount(p.team, -1);
		ChangeTeamPlayerCount(newTeamNum, 1);

		RemovePlayerBlob(player);

		u8 oldteam = player.getTeamNum();
		p.setTeam(newTeamNum);
		player.server_setTeamNum(newTeamNum);

		// vvv this breaks spawning on team change ~~~Norill
		//if(is_spawning || oldteam == rules.getSpectatorTeamNum())
		{
			respawns.AddPlayerToSpawn(player);
		}

	}

	void AddPlayerSpawn(CPlayer@ player)
	{

		PlayerInfo@ p = getInfoFromName(player.getUsername());
		if (p is null)
		{
			AddPlayer(player);
		}
		else
		{
			if (p.lastSpawnRequest != 0 && p.lastSpawnRequest + 5 > getGameTime()) // safety - we dont want too much requests
			{
				//  printf("too many spawn requests " + p.lastSpawnRequest + " " + getGameTime());
				return;
			}

			// kill old player
			RemovePlayerBlob(player);
		}

		if (player.lastBlobName.length() > 0 && p !is null)
		{
			p.blob_name = filterBlobNameToSpawn(player.lastBlobName, player);
		}

		if (respawns !is null)
		{
			respawns.RemovePlayerFromSpawn(player);
			respawns.AddPlayerToSpawn(player);
			if (p !is null)
			{
				p.lastSpawnRequest = getGameTime();
			}
		}
	}

	void onPlayerDie(CPlayer@ victim, CPlayer@ killer, u8 customData)
	{

	}

	void onSetPlayer(CBlob@ blob, CPlayer@ player)
	{

	}

	
	 // Overload this to apply some filtering to what blobs
	 // players are allowed to respawn as.
	 
	string filterBlobNameToSpawn(string proposed, CPlayer@ player)
	{
		return proposed;
	}

	void AddAllPlayersToSpawn()
	{
		uint len = players.length;
		uint salt = XORRandom(len);
		for (uint k = 0; k < len; k++)
		{
			PlayerInfo@ p = players[((k + salt) * 997) % len];
			p.lastSpawnRequest = 0;
			CPlayer@ player = getPlayerByUsername(p.username);
			AddPlayerSpawn(player);
		}
	}


	void RemovePlayerBlob(CPlayer@ player)
	{
		if (player is null)
			return;

		// remove previous players blob
		CBlob @blob = player.getBlob();
		if (blob !is null && !blob.hasTag("dead"))
		{
			blob.server_SetPlayer(null);

			if (blob.getHealth() > 0.0f)
				blob.server_Die();
		}
	}

};
*/
