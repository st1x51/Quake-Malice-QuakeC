void() cheeky_rat;
void(entity place) single_rat;
void() rat_idle = [0, rat_idle]
{
	ai_stand();
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
};

void() rat_run1 = [1, rat_run2]
{
	ai_walk(15);
};

void() rat_run2 = [2, rat_run3]
{
	ai_walk(15);
};

void() rat_run3 = 
{
	self.frame = AS_MELEE;
	ai_walk(SVC_SETVIEWANGLES);
	if (random() < SERV_VOL)
	{
		cheeky_rat();
	}
	else
	{
		rat_run1();
	}
};

void() rat_retreat1 = [4, rat_retreat2]
{
	ai_walk(-20);
};

void() rat_retreat2 = [5, rat_retreat3]
{
	ai_walk(-20);
};

void() rat_retreat3 = [6, cheeky_rat]
{
	ai_walk(-20);
};

void() cheeky_rat = 
{
	local float delta;
	local vector temp;
	local vector dirtoplayer;
	local vector angtoplayer;
	local float x;
	temp = self.enemy.origin - self.origin;
	angtoplayer = vectoangles(temp);
	delta = angtoplayer_y - self.enemy.v_angle_y;
	if (delta < -135 && delta > -215 || (delta > 135 && delta < 215))
	{
		rat_retreat1();
		x = random();
		if (x < 0.025)
		{
			sound(self, CHAN_WEAPON, "rat/eep1.wav", 0.6, ATTN_NORM);
		}
		else
		{
			if (x < 0.05)
			{
				sound(self, CHAN_WEAPON, "rat/eep2.wav", 0.6, ATTN_NORM);
			}
		}
	}
	else
	{
		rat_run1();
		x = random();
		if (x < 0.025)
		{
			sound(self, CHAN_WEAPON, "rat/eep1.wav", 0.6, ATTN_NORM);
		}
		else
		{
			if (x < 0.05)
			{
				sound(self, CHAN_WEAPON, "rat/eep2.wav", 0.6, ATTN_NORM);
			}
		}
	}
};

void() squish = 
{
	if (other == world)
	{
		return;
	}
	if (other.classname == "player")
	{
		self.movetype = MOVETYPE_NONE;
		self.solid = SOLID_SLIDEBOX;
		setsize(self, VEC_ORIGIN, VEC_ORIGIN);
		self.skin = self.skin + AS_MELEE;
		if (self.frame > AS_MELEE)
		{
			self.frame = SECRET_NO_SHOOT;
		}
		else
		{
			self.frame = TE_WIZSPIKE;
		}
		self.think = SUB_Null;
		self.touch = SUB_Null;
		if (random() < SERV_VOL)
		{
			sound(self, CHAN_WEAPON, "rat/squish1.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
		}
		else
		{
			sound(self, CHAN_WEAPON, "rat/squish2.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
		}
		killed_monsters = killed_monsters + SPAWNFLAG_SUPERSPIKE;
		WriteByte(MSG_ALL, SVC_KILLEDMONSTER);
	}
};

void() rat_gibs = 
{
	ThrowGib("progs/gib1.mdl", -20);
	self.think = SUB_Null;
	remove(self);
};

void() monster_rats = 
{
	if (!deathmatch)
	{
		precache_model("progs/rat.mdl");
		precache_sound("rat/eep1.wav");
		precache_sound("rat/eep2.wav");
		precache_sound("rat/squish1.wav");
		precache_sound("rat/squish2.wav");
		single_rat(self);
		single_rat(self);
		single_rat(self);
		single_rat(self);
		single_rat(self);
	}
	else
	{
		remove(self);
	}
};

void(entity place) single_rat = 
{
	local float x;
	local entity critter;
	x = random() * 2.99;
	critter = spawn();
	critter.solid = SOLID_NOT;
	critter.movetype = MOVETYPE_STEP;
	setmodel(critter, "progs/rat.mdl");
	setsize(critter, '-5 -5 -24', '5 5 5');
	setorigin(critter, place.origin);
	critter.velocity_z = 200;
	critter.velocity_y = random() * 200;
	critter.velocity_x = random() * 200;
	critter.health = SPAWNFLAG_SUPERSPIKE;
	critter.classname = "monster_bigfuckinrat";
	critter.classname = "monster_rat";
	critter.takedamage = DAMAGE_YES;
	critter.th_stand = rat_idle;
	critter.th_walk = rat_run1;
	critter.th_run = rat_run1;
	critter.th_die = rat_gibs;
	critter.th_missile = rat_idle;
	critter.th_melee = rat_idle;
	critter.touch = squish;
	critter.skin = floor(x);
	critter.think = walkmonster_start;
	critter.nextthink = time + 0.1 + random() * 0.1;
};

