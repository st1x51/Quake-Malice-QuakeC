void() rain_splash = 
{
	local float x;
	if (other.classname == "player" && other.burning == WEAPON_SHOTGUN)
	{
		other.burning = MSG_BROADCAST;
		other.extinguished = WEAPON_SHOTGUN;
		other.effects = other.effects - (other.effects & EF_DIMLIGHT);
	}
	x = 35 + random() * SVC_SETVIEWANGLES;
	particle(self.origin + '0 0 -15', VEC_ORIGIN, x, SVC_SETVIEWANGLES);
	remove(self);
};

void() rain_fall = 
{
	local entity rain;
	rain = spawn();
	rain.owner = self;
	rain.movetype = MOVETYPE_FLY;
	rain.solid = SOLID_TRIGGER;
	setmodel(rain, "progs/rain.mdl");
	setsize(rain, '0 0 -20', '0 0 -10');
	rain.velocity_z = -800;
	rain.touch = rain_splash;
	rain.nextthink = time + WEAPON_SHOTGUN;
	rain.think = SUB_Remove;
	rain.origin_x = self.absmin_x + random() * self.size_x;
	rain.origin_y = self.absmin_y + random() * self.size_y;
	rain.origin_z = self.absmin_z + random() * self.size_z;
};

void() makerain = 
{
	local float temp;
	temp = self.health / 20;
	while (temp >= MSG_BROADCAST)
	{
		rain_fall();
		temp = temp - WEAPON_SHOTGUN;
	}
	self.nextthink = time + 0.07;
	self.think = makerain;
};

void() rain = 
{
	precache_model("progs/rain.mdl");
	setsize(self, VEC_ORIGIN, VEC_ORIGIN);
	setmodel(self, self.model);
	self.model = string_null;
	self.nextthink = time + 0.5;
	self.think = makerain;
	precache_sound("ambience/stormy1.wav");
	ambientsound(self.origin, "ambience/stormy1.wav", WEAPON_SHOTGUN, ATTN_NORM);
};

void() splash1 = [0, splash2]
{
};

void() splash2 = [1, splash3]
{
};

void() splash3 = [2, splash4]
{
};

void() splash4 = [3, splash5]
{
};

void() splash5 = [4, splash6]
{
};

void() splash6 = [5, SUB_Remove]
{
};

void(float number, entity where) WaterSplash = 
{
	local entity splash;
	local float k;
	while (k < number)
	{
		splash = spawn();
		splash.movetype = MOVETYPE_NONE;
		splash.solid = SOLID_NOT;
		setmodel(splash, "progs/s_splash.spr");
		setorigin(splash, where.origin + random() * '30 30 0');
		splash.nextthink = time;
		splash.think = splash1;
		k = k + WEAPON_SHOTGUN;
	}
};

