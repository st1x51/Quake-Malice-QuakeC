void() f_turbine1 = [0, f_turbine2]
{
	sound(self, CHAN_VOICE, "turbine/fanblow.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
};

void() f_turbine2 = [1, f_turbine3]
{
};

void() f_turbine3 = [2, f_turbine4]
{
};

void() f_turbine4 = [3, f_turbine5]
{
};

void() f_turbine5 = [0, f_turbine6]
{
	sound(self, CHAN_VOICE, "turbine/fanblow.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
};

void() f_turbine6 = [1, f_turbine7]
{
};

void() f_turbine7 = [2, f_turbine8]
{
};

void() f_turbine8 = [3, f_turbine1]
{
};

void() fan_turbine = 
{
	precache_model("progs/turbine.mdl");
	precache_sound("turbine/fanblow.wav");
	setmodel(self, "progs/turbine.mdl");
	self.classname = "turbine";
	self.movetype = MOVETYPE_NONE;
	f_turbine1();
};

void() fan_turbine2 = 
{
	precache_model("progs/turbine.mdl");
	precache_sound("turbine/fanblow.wav");
	setmodel(self, "progs/turbine.mdl");
	self.classname = "turbine";
	self.movetype = MOVETYPE_NONE;
	self.angles_x = 90;
	f_turbine1();
};

void() plantouch = 
{
	if (other.classname == "player")
	{
		remove(self);
	}
};

void() the_plans = 
{
	precache_model("progs/plans.mdl");
	setmodel(self, "progs/plans.mdl");
	self.classname = "plans";
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_BBOX;
	setsize(self, '-5 -5 -5', '5 5 5');
	self.touch = plantouch;
};

void() blowball = 
{
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord(MSG_BROADCAST, self.origin_x);
	WriteCoord(MSG_BROADCAST, self.origin_y);
	WriteCoord(MSG_BROADCAST, self.origin_z);
	self.takedamage = DAMAGE_NO;
	self.frame = SPAWNFLAG_SUPERSPIKE;
	self.solid = SOLID_NOT;
};

void() disco_ball = 
{
	precache_model("progs/discob.mdl");
	setmodel(self, "progs/discob.mdl");
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_BBOX;
	setsize(self, '-25 -25 -25', '25 25 25');
	self.avelocity = '100 0 0';
	self.takedamage = DAMAGE_YES;
	self.health = 60;
	self.th_die = blowball;
};

