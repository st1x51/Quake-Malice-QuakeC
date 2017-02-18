float() CheckStartDemos = 
{
	local entity sucka;
	if (coop || deathmatch)
	{
		if (world.model == "maps/d6.bsp")
		{
			nextmap = "d7";
		}
		else
		{
			if (world.model == "maps/d9.bsp")
			{
				nextmap = "d12";
			}
			else
			{
				if (world.model == "maps/d12.bsp")
				{
					nextmap = "d13";
				}
			}
		}
		return 0;
	}
	sucka = find(world, classname, "player");
	if (cvar("developer") != AS_STRAIGHT)
	{
		stuffcmd(sucka, "clear\n");
	}
	stuffcmd(sucka, "v_cshift 0 0 0 255\n");
	if (world.model == "maps/start.bsp")
	{
		stuffcmd(sucka, "playdemo cuts/cut0\n");
		return 1;
	}
	else
	{
		if (world.model == "maps/d2.bsp")
		{
			stuffcmd(sucka, "playdemo cuts/cut3\n");
			return 1;
		}
		else
		{
			if (world.model == "maps/d6.bsp")
			{
				stuffcmd(sucka, "playdemo cuts/cut4\n");
				return 1;
			}
			else
			{
				if (world.model == "maps/d9.bsp")
				{
					stuffcmd(sucka, "playdemo cuts/cut5\n");
					return 1;
				}
				else
				{
					if (world.model == "maps/d12.bsp")
					{
						stuffcmd(sucka, "playdemo cuts/cut6\n");
						return 1;
					}
					else
					{
						if (world.model == "maps/d13.bsp")
						{
							stuffcmd(sucka, "playdemo cuts/cut7\n");
							return 1;
						}
						else
						{
							if (world.model == "maps/d15.bsp")
							{
								stuffcmd(sucka, "playdemo cuts/cut8\n");
								return 1;
							}
							else
							{
								return 0;
							}
						}
					}
				}
			}
		}
	}
};

