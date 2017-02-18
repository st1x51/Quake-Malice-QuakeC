void() dofade;
void() fadein = 
{
	local entity fadeboy;
	fadeboy = spawn();
	fadeboy.owner = self;
	fadeboy.think = dofade;
	fadeboy.nextthink = time;
	fadeboy.warp_factor = SECRET_NO_SHOOT;
	return;
};

void() dofade = 
{
	if (self.warp_factor == MSG_BROADCAST)
	{
		remove(self);
	}
	else
	{
		if (self.warp_factor == SPAWNFLAG_SUPERSPIKE)
		{
			stuffcmd(self.owner, "v_cshift 0 0 0 0");
		}
		else
		{
			if (self.warp_factor == SPAWNFLAG_LASER)
			{
				stuffcmd(self.owner, "v_cshift 0 0 0 40");
			}
			else
			{
				if (self.warp_factor == AS_MELEE)
				{
					stuffcmd(self.owner, "v_cshift 0 0 0 80");
				}
				else
				{
					if (self.warp_factor == SECRET_1ST_DOWN)
					{
						stuffcmd(self.owner, "v_cshift 0 0 0 120");
					}
					else
					{
						if (self.warp_factor == SVC_SETVIEWPORT)
						{
							stuffcmd(self.owner, "v_cshift 0 0 0 160");
						}
						else
						{
							if (self.warp_factor == TE_LIGHTNING2)
							{
								stuffcmd(self.owner, "v_cshift 0 0 0 200");
							}
							else
							{
								if (self.warp_factor == TE_WIZSPIKE)
								{
									stuffcmd(self.owner, "v_cshift 0 0 0 240");
								}
								else
								{
									if (self.warp_factor == SECRET_NO_SHOOT)
									{
										stuffcmd(self.owner, "v_cshift 0 0 0 256");
									}
								}
							}
						}
					}
				}
			}
		}
	}
	self.warp_factor = self.warp_factor - SPAWNFLAG_SUPERSPIKE;
	self.nextthink = time + 0.05;
};

