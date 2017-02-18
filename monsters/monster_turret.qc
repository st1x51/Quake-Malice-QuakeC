void() round = 
{
	local vector scoped;
	local vector dir;
	dir = normalize(self.enemy.origin - self.origin);
	self.angles = vectoangles(dir);
	self.effects = self.effects | EF_MUZZLEFLASH;
	FireBullets(AS_STRAIGHT, dir, '0.1 0.1 0');
	sound(self, CHAN_WEAPON, "misc/turret.wav", AS_STRAIGHT, ATTN_NORM);
};

void() burst1 = [0, burst2]
{
	round();
};

void() burst2 = [1, burst3]
{
	round();
};

void() burst3 = [2, burst4]
{
	round();
};

void() burst4 = [3, burst5]
{
	round();
};

void() burst5 = [4, burst6]
{
	round();
};

void() burst6 = [5, trace_target]
{
	round();
};

void() trace_target = 
{
	local entity being;
	local vector scoped;
	local vector dir;
	being = findradius(self.origin, 600);
	while (being)
	{
		if (being.classname == "player" && visible(being))
		{
			scoped = vectoangles(being.origin - self.origin);
			dir = normalize(being.origin - self.origin);
			self.enemy = being;
			if (random() < 0.060000)
			{
				burst1();
			}
			self.angles = scoped;
		}
		being = being.chain;
	}
	self.nextthink = time + 0.010000;
};

void() dead_tur = 
{
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord(MSG_BROADCAST, self.origin_x);
	WriteCoord(MSG_BROADCAST, self.origin_y);
	WriteCoord(MSG_BROADCAST, self.origin_z);
	sound(self, CHAN_VOICE, "weapons/fuelexp.wav", AS_STRAIGHT, ATTN_NORM);
	BecomeExplosion();
};

void() monster_turret = 
{
	if (deathmatch)
	{
		remove(self);
	}
	precache_model("progs/turret.mdl");
	precache_sound("misc/turret.wav");
	precache_sound("weapons/fuelexp.wav");
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_BBOX;
	self.nextthink = time + AS_STRAIGHT;
	self.classname = "monster_turret";
	self.takedamage = DAMAGE_AIM;
	self.think = trace_target;
	setmodel(self, "progs/turret.mdl");
	setsize(self, '-20 -20 -20', '20 20 20');
	self.health = 50;
	dealwithskill();
	self.th_die = dead_tur;
	droptofloor();
};

