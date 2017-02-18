void() Hmmm_something_burning;
void(entity head7) Enolagay = 
{
	local entity bomby;
	bomby = spawn();
	bomby.owner = head7;
	setorigin(bomby, head7.origin);
	bomby.think = Hmmm_something_burning;
	bomby.nextthink = time;
};

void() Hmmm_something_burning = 
{
	if (self.owner.classname != "player")
	{
		return;
	}
	if (self.owner.warp_factor == WEAPON_SHOTGUN)
	{
		stuffcmd(self.owner, "fov 180\n");
	}
	else
	{
		if (self.owner.warp_factor == WEAPON_ROCKET)
		{
			stuffcmd(self.owner, "fov 175\n");
		}
		else
		{
			if (self.owner.warp_factor == AS_MELEE)
			{
				stuffcmd(self.owner, "fov 165\n");
			}
			else
			{
				if (self.owner.warp_factor == WEAPON_SPIKES)
				{
					stuffcmd(self.owner, "fov 150\n");
				}
				else
				{
					if (self.owner.warp_factor == 5)
					{
						stuffcmd(self.owner, "fov 130\n");
					}
					else
					{
						if (self.owner.warp_factor == TE_LIGHTNING2)
						{
							stuffcmd(self.owner, "fov 110\n");
						}
						else
						{
							if (self.owner.warp_factor == TE_WIZSPIKE)
							{
								stuffcmd(self.owner, "fov 90\n");
							}
							else
							{
								if (self.owner.warp_factor == WEAPON_BIG)
								{
									stuffcmd(self.owner, "fov 80\n");
								}
								else
								{
									if (self.owner.warp_factor == TE_LIGHTNING3)
									{
										stuffcmd(self.owner, "fov 75\n");
									}
									else
									{
										if (self.owner.warp_factor == 10)
										{
											stuffcmd(self.owner, "fov 70\n");
										}
										else
										{
											if (self.owner.warp_factor == TE_TELEPORT)
											{
												stuffcmd(self.owner, "fov 75\n");
											}
											else
											{
												if (self.owner.warp_factor == 12)
												{
													stuffcmd(self.owner, "fov 80\n");
												}
												else
												{
													if (self.owner.warp_factor == 13)
													{
														stuffcmd(self.owner, "fov 85\n");
													}
													else
													{
														stuffcmd(self.owner, "fov 90\n");
														self.think = SUB_Null;
														return;
													}
												}
											}
										}
									}
								}
							}
						}
					}
				}
			}
		}
	}
	self.owner.warp_factor = self.owner.warp_factor + WEAPON_SHOTGUN;
	self.think = Hmmm_something_burning;
	self.nextthink = time + 0.05;
};

void() UpdateAmmoBars = 
{
	local float bar;
	local float percent;
	local float special_happy_count;
	special_happy_count = MSG_BROADCAST;
	percent = self.ammo_shells2;
	while (special_happy_count < WEAPON_SPIKES)
	{
		if (special_happy_count == WEAPON_SHOTGUN)
		{
			percent = self.ammo_nails2 / WEAPON_ROCKET;
		}
		else
		{
			if (special_happy_count == WEAPON_ROCKET)
			{
				percent = self.ammo_rockets2;
			}
			else
			{
				if (special_happy_count == AS_MELEE)
				{
					percent = self.ammo_cells2;
				}
			}
		}
		if (percent > 90)
		{
			percent = rint((100 - percent) / 10);
			bar = (WEAPON_SHOTGUN - percent) * 100 + 99;
		}
		else
		{
			if (percent > 45)
			{
				percent = rint((90 - percent) * TE_LIGHTNING3 / 45);
				bar = (TE_LIGHTNING3 - percent) * 10 + TE_LIGHTNING3;
			}
			else
			{
				percent = rint((45 - percent) * TE_LIGHTNING3 / 45);
				bar = TE_LIGHTNING3 - percent;
			}
		}
		if (special_happy_count == MSG_BROADCAST)
		{
			self.ammo_shells = bar;
		}
		else
		{
			if (special_happy_count == WEAPON_SHOTGUN)
			{
				self.ammo_nails = bar;
			}
			else
			{
				if (special_happy_count == WEAPON_ROCKET)
				{
					self.ammo_rockets = bar;
				}
				else
				{
					if (special_happy_count == AS_MELEE)
					{
						self.ammo_cells = bar;
					}
				}
			}
		}
		special_happy_count = special_happy_count + WEAPON_SHOTGUN;
	}
};

