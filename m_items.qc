void() player_run;
void() Util_Precache = 
{
	precache_sound("utils/send.wav");
	precache_sound("utils/receive.wav");
	precache_sound("utils/hoveron.wav");
	precache_sound("utils/hovrboot.wav");
	precache_sound("utils/hovrjmp8.wav");
	precache_sound("utils/hoveroff.wav");
	precache_sound("utils/paraland.wav");
	precache_sound("utils/pullcord.wav");
	precache_sound("utils/putout.wav");
	precache_model("progs/probe.mdl");
};

void() util_touch = 
{
	local float bit;
	if (other.classname != "player")
	{
		return;
	}
	if (other.tools == (other.tools | self.tools) && self.tools != UT_SCUBA)
	{
		return;
	}
	if (self.tools == UT_BIGASSGUN && other.hover_active == AS_STRAIGHT)
	{
		return;
	}
	if (other.tools == (other.tools | UT_MINISUB))
	{
		return;
	}
	if (other.probe_active == AS_STRAIGHT)
	{
		return;
	}
	if (other.health <= MSG_BROADCAST)
	{
		return;
	}
	if (other.classname == "player")
	{
		sprint(other, self.netname);
		sprint(other, " найден\n");
		stuffcmd(other, "bf\n");
	}
	if (deathmatch && self.netname != "Расщепитель")
	{
		self.mdl = self.model;
		self.nextthink = time + 60;
		self.think = SUB_regen;
	}
	sound(other, CHAN_AUTO, "utils/pickup.wav", AS_STRAIGHT, ATTN_NORM);
	other.tools = other.tools | self.tools;
	if (self.tools == UT_PROBE)
	{
		bit = IT_ARMOR3;
	}
	else
	{
		if (self.tools == UT_HOVER)
		{
			bit = IT_ARMOR2;
		}
		else
		{
			if (self.tools == UT_CHUTE)
			{
				bit = IT_ARMOR1;
			}
			else
			{
				bit = UT_ZIP;
			}
		}
	}
	if (self.tools == UT_SCUBA)
	{
		other.armorvalue = TE_LIGHTNING3;
	}
	else
	{
		if (other.hover_active != AS_STRAIGHT && other.chute_active != AS_STRAIGHT)
		{
			if (self.tools != UT_BIGASSGUN)
			{
				other.items = other.items - (other.items & (IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3)) + bit;
				other.util = self.tools;
			}
			else
			{
				other.modelindex = modelindex_bag;
				if (!(other.speed & CHSCAM_ON))
				{
					other.weaponmodel = "progs/w_bag.mdl";
				}
				other.weaponframe = MSG_BROADCAST;
			}
		}
	}
	if (coop && self.netname != "Расщепитель")
	{
		return;
	}
	self.model = string_null;
	self.solid = SOLID_NOT;
	activator = other;
	SUB_UseTargets();
};

void() utility_parachute = 
{
	self.touch = util_touch;
	precache_model("progs/shute.mdl");
	precache_sound("items/damage.wav");
	setmodel(self, "progs/shute.mdl");
	self.netname = "Парашют";
	self.tools = UT_CHUTE;
	setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
	StartItem();
};

void() utility_probe = 
{
	self.touch = util_touch;
	precache_model("progs/probemod.mdl");
	precache_sound("items/damage.wav");
	setmodel(self, "progs/probemod.mdl");
	self.netname = "Зонд";
	self.tools = UT_PROBE;
	setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
	StartItem();
};

void() utility_hoverboard = 
{
	self.touch = util_touch;
	precache_model("progs/hoverbrd.mdl");
	setmodel(self, "progs/hoverbrd.mdl");
	self.netname = "Ховерборд";
	self.tools = UT_HOVER;
	self.frame = AS_STRAIGHT;
	setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
	StartItem();
};

void() utility_scuba = 
{
	self.touch = util_touch;
	precache_model("progs/scuba.mdl");
	setmodel(self, "progs/scuba.mdl");
	self.netname = "Акваланг";
	self.tools = UT_SCUBA;
	setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
	StartItem();
};

void() bigassgun = 
{
	if (bigasscheck == MSG_BROADCAST || deathmatch)
	{
		bigasscheck = AS_STRAIGHT;
		self.touch = util_touch;
		precache_model("progs/w_bag.mdl");
		precache_model("progs/m_bag.mdl");
		precache_sound("misc/thud.wav");
		precache_sound("misc/ion.wav");
		precache_sound("misc/intense.wav");
		precache_sound("misc/discharg.wav");
		setmodel(self, "progs/m_bag.mdl");
		self.netname = "Расщепитель";
		self.tools = UT_BIGASSGUN;
		setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
		serverflags = serverflags | 15;
		StartItem();
	}
	else
	{
		remove(self);
	}
};

void() HoverBoard = 
{
	if (self.hover_active == AS_STRAIGHT)
	{
		stuffcmd(self, "v_idlescale 0\n");
		stuffcmd(self, "cl_rollangle 2\n");
		stuffcmd(self, "cl_forwardspeed 360\n");
		self.cl_forwardspeed = CHT_NORMSPEED;
		stuffcmd(self, "cl_bob 0.01\n");
		self.hover_active = MSG_BROADCAST;
		self.angles_x = MSG_BROADCAST;
		self.angles_z = MSG_BROADCAST;
		self.fixangle = 1;
		self.modelindex = modelindex_player;
		sound(self, CHAN_VOICE, "utils/hoveroff.wav", AS_STRAIGHT, ATTN_NORM);
	}
	else
	{
		if (self.tools == (self.tools | UT_BIGASSGUN))
		{
			return;
		}
		stuffcmd(self, "v_idlescale 12\n");
		stuffcmd(self, "cl_rollangle 4\n");
		stuffcmd(self, "cl_forwardspeed 600\n");
		self.cl_forwardspeed = CHT_HOVERSPEED;
		stuffcmd(self, "cl_bob 0\n");
		self.hover_active = AS_STRAIGHT;
		self.modelindex = modelindex_hover;
		self.angles_x = MSG_BROADCAST;
		self.angles_z = MSG_BROADCAST;
		self.fixangle = 1;
		sound(self, CHAN_VOICE, "utils/hoveron.wav", AS_STRAIGHT, ATTN_NORM);
	}
};

void() ParaGlide = 
{
	if (!(self.owner.flags & FL_ONGROUND) && self.owner.chute_active == AS_STRAIGHT)
	{
		makevectors(self.owner.v_angle);
		self.owner.velocity = aim(self.owner, AS_STRAIGHT);
		self.owner.velocity = self.owner.velocity * 200;
		self.owner.velocity_z = -80;
		self.angles = self.owner.angles;
		setorigin(self, self.owner.origin + '0 0 45');
		self.nextthink = time;
		self.think = ParaGlide;
		if (self.frame < AS_MELEE)
		{
			if (self.owner.chute_count < time)
			{
				self.owner.chute_count = time + 0.1;
				self.frame = self.frame + WEAPON_SHOTGUN;
			}
		}
	}
	else
	{
		sound(self, CHAN_ITEM, "utils/paraland.wav", WEAPON_SHOTGUN, ATTN_NORM);
		self.owner.chute_count = MSG_BROADCAST;
		self.owner.chute_active = MSG_BROADCAST;
		self.think = SUB_Null;
		remove(self);
	}
};

void() PullCord = 
{
	local entity chute;
	if (self.chute_active == WEAPON_SHOTGUN)
	{
		return;
	}
	if (self.flags & FL_ONGROUND)
	{
		return;
	}
	player_run();
	self.chute_active = WEAPON_SHOTGUN;
	sound(self, CHAN_VOICE, "utils/pullcord.wav", WEAPON_SHOTGUN, ATTN_NORM);
	chute = spawn();
	chute.movetype = MOVETYPE_NONE;
	chute.owner = self;
	chute.solid = SOLID_NOT;
	chute.nextthink = time;
	chute.think = ParaGlide;
	chute.colormap = self.colormap;
	setmodel(chute, "progs/chute.mdl");
	setsize(chute, VEC_ORIGIN, VEC_ORIGIN);
	makevectors(self.v_angle);
};

void() FireUtil = 
{
	if (self.tools == (self.tools | UT_BIGASSGUN))
	{
		return;
	}
	if (self.tools == (self.tools | UT_MINISUB))
	{
		exit_vehicle();
		return;
	}
	if (self.util == UT_CHUTE)
	{
		if (self.waterlevel > MSG_BROADCAST)
		{
			return;
		}
		else
		{
			PullCord();
		}
	}
	else
	{
		if (self.util == UT_PROBE)
		{
			LaunchProbe();
		}
		else
		{
			if (self.util == UT_HOVER)
			{
				if (self.waterlevel > MSG_BROADCAST && self.hover_active == MSG_BROADCAST)
				{
					return;
				}
				else
				{
					HoverBoard();
				}
			}
		}
	}
};

void() CycleUtil = 
{
	local float bit;
	if (self.chute_active == WEAPON_SHOTGUN || self.probe_active == WEAPON_SHOTGUN || self.hover_active == WEAPON_SHOTGUN)
	{
		return;
	}
	if (self.util == UT_CHUTE)
	{
		self.util = UT_PROBE;
		bit = IT_ARMOR3;
	}
	else
	{
		if (self.util == UT_PROBE)
		{
			self.util = UT_HOVER;
			bit = IT_ARMOR2;
		}
		else
		{
			if (self.util == UT_HOVER)
			{
				self.util = UT_CHUTE;
				bit = IT_ARMOR1;
			}
		}
	}
	self.items = self.items - (self.items & (IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3)) + bit;
	if (!(self.tools == (self.tools | self.util)))
	{
		CycleUtil();
	}
};

void() eco1 = [0, eco2]
{
};

void() eco2 = [1, eco3]
{
};

void() eco3 = [2, eco4]
{
};

void() eco4 = [3, eco5]
{
};

void() eco5 = [4, SUB_Remove]
{
};

void() Douse_Flame = 
{
	if (other.health <= MSG_BROADCAST)
	{
		return;
	}
	if (other.classname != "player")
	{
		return;
	}
	other.burning = MSG_BROADCAST;
	other.extinguished = WEAPON_SHOTGUN;
	other.effects = other.effects - (other.effects & EF_DIMLIGHT);
};

void() WhoFarted = 
{
	local entity co2;
	co2 = spawn();
	co2.movetype = MOVETYPE_NOCLIP;
	co2.solid = SOLID_TRIGGER;
	makevectors(self.angles);
	setorigin(co2, self.origin + v_forward * 19 + '0 0 18');
	co2.velocity = v_forward * 200;
	co2.velocity_z = -60;
	co2.nextthink = time;
	co2.touch = Douse_Flame;
	co2.think = eco1;
	setmodel(co2, "progs/s_co2.spr");
	setsize(co2, VEC_ORIGIN, VEC_ORIGIN);
};

void() extinguisher_touch = 
{
	if (other.health <= MSG_BROADCAST)
	{
		return;
	}
	if (other.classname != "player")
	{
		return;
	}
	if (co2_spread < time)
	{
		co2_spread = time + 0.1;
		WhoFarted();
	}
	if (self.co2_flag < time)
	{
		self.co2_flag = time + 0.3;
		sound(self, CHAN_AUTO, "utils/putout.wav", WEAPON_SHOTGUN, ATTN_NORM);
	}
	droptofloor(0,0); //st1x51: shut up compiler
};

void() fire_extinguisher = 
{
	precache_model("progs/extngshr.mdl");
	precache_model("progs/s_co2.spr");
	setmodel(self, "progs/extngshr.mdl");
	self.solid = SOLID_BBOX;
	self.classname = "ext_1";
	setsize(self, '-16 -16 0', '16 16 60');
	self.touch = extinguisher_touch;
	StartItem();
};

void() fire_extinguisher2 = 
{
	precache_model("progs/extngshr.mdl");
	precache_model("progs/s_co2.spr");
	setmodel(self, "progs/extngshr.mdl");
	self.solid = SOLID_BBOX;
	self.classname = "ext_2";
	setsize(self, '-16 -16 0', '16 16 60');
	self.touch = extinguisher_touch;
	self.angles_y = self.angles_y + 180;
	self.fixangle = 1;
	StartItem();
};

void() compresser_touch = 
{
	if (other.health <= MSG_BROADCAST)
	{
		return;
	}
	if (other.classname != "player")
	{
		return;
	}
	if (!(other.tools == (other.tools | UT_SCUBA)))
	{
		return;
	}
	if (other.armorvalue < TE_LIGHTNING3)
	{
		other.armorvalue = other.armorvalue + WEAPON_SHOTGUN;
	}
};

void() air_compresser = 
{
	precache_model("progs/extngshr.mdl");
	precache_model("progs/s_co2.spr");
	setmodel(self, "progs/extngshr.mdl");
	self.solid = SOLID_BBOX;
	setsize(self, '-16 -16 0', '16 16 60');
	self.touch = compresser_touch;
	StartItem();
};

