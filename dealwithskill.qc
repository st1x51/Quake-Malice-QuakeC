void() dealwithskill = 
{
	local float sk;
	sk = cvar("skill");
	if (sk == MSG_BROADCAST)
	{
		self.health = self.health * 0.5;
	}
	else
	{
		if (sk == AS_STRAIGHT)
		{
			self.health = self.health;
		}
		else
		{
			if (sk == H_MEGA)
			{
				self.health = self.health * 2.5;
			}
			else
			{
				if (sk == AS_MELEE)
				{
					self.health = AS_STRAIGHT;
				}
			}
		}
	}
};

