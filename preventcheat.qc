//st1x51: or void??
float() preventcheat = 
{
	if (vlen(self.velocity) >= self.cl_forwardspeed)
	{
		if (self.cl_forwardspeed == CHT_NORMSPEED)
		{
			stuffcmd(self, "cl_forwardspeed 360\n");
		}
		else
		{
			if (self.cl_forwardspeed == CHT_SCUBASPEED)
			{
				stuffcmd(self, "cl_forwardspeed 420\n");
			}
			else
			{
				if (self.cl_forwardspeed == CHT_SUBSPEED)
				{
					stuffcmd(self, "cl_forwardspeed 550\n");
				}
				else
				{
					if (self.cl_forwardspeed == CHT_HOVERSPEED)
					{
						stuffcmd(self, "cl_forwardspeed 600\n");
					}
				}
			}
		}
		stuffcmd(self, "cl_backspeed 360\n");
		stuffcmd(self, "cl_sidespeed 360\n");
		return 1;
	}
	else
	{
		return 0;
	}
};

