void() CN_Client_Init_Think = 
{
};

string() choosename = 
{
	if (cbotnum == MSG_BROADCAST)
	{
		return "One";
	}
	else
	{
		if (cbotnum == AS_STRAIGHT)
		{
			return "Two";
		}
		else
		{
			if (cbotnum == SEARCH)
			{
				return "Three";
			}
			else
			{
				return;
			}
		}
	}
};

