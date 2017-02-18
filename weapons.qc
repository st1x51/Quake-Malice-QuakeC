void() spike_touch;
void() superspike_touch;
void() player_run;
void() player_shot1;
void() player_hellfire1;
void() player_blast1;
void() player_oozi1;
void() player_morter1;
void() player_rocket1;
void() player_rail1;
void() player_railb1;
void() open_rocket1;
void() loadwep;
void() player_bag1;

void() W_Precache = 
{
	precache_sound("weapons/sgun1.wav");
	precache_sound("weapons/r_exp3.wav");
	precache_sound("weapons/ric1.wav");
	precache_sound("weapons/ric2.wav");
	precache_sound("weapons/ric3.wav");
	precache_sound("weapons/tink1.wav");
	precache_sound("weapons/plasma.wav");
	precache_sound("weapons/hellfire.wav");
	precache_sound("weapons/shot1.wav");
	precache_sound("weapons/shot1b.wav");
	precache_sound("weapons/shell1.wav");
	precache_sound("weapons/shell2.wav");
	precache_sound("weapons/shell3.wav");
	precache_sound("weapons/casehit1.wav");
	precache_sound("weapons/casehit2.wav");
	precache_sound("weapons/casehit3.wav");
	precache_sound("weapons/morter1.wav");
	precache_sound("weapons/shot2.wav");
	precache_sound("weapons/mini1.wav");
	precache_sound("weapons/mini2.wav");
	precache_sound("weapons/mini3.wav");
	precache_sound("weapons/uzim.wav");
	precache_sound("weapons/punish2.wav");
	precache_sound("weapons/punish4.wav");
	precache_sound("weapons/reload11.wav");
	precache_sound("weapons/reload1.wav");
	precache_sound("weapons/reload2.wav");
	precache_sound("weapons/reload3.wav");
	precache_sound("weapons/reload4.wav");
	precache_sound("weapons/misfire1.wav");
	precache_sound("weapons/misfire2.wav");
	precache_sound("weapons/torpedo.wav");
	precache_sound("misc/warning.wav");
	precache_sound("misc/hiss.wav");
	precache_sound("weapons/morthit.wav");
	precache_sound("weapons/loadrock.wav");
	precache_sound("weapons/minidown.wav");
};

void() NormalVars = 
{
	self.hover_active = MSG_BROADCAST;
	self.chute_active = MSG_BROADCAST;
	self.probe_active = MSG_BROADCAST;
	stuffcmd(self, "fov 90\n");
	stuffcmd(self, "viewsize 100\n");
	stuffcmd(self, "r_drawviewmodel 1\n");
	stuffcmd(self, "cl_rollangle 2\n");
	stuffcmd(self, "cl_forwardspeed 360\n");
	self.cl_forwardspeed = CHT_NORMSPEED;
	stuffcmd(self, "cl_backspeed 360\n");
	stuffcmd(self, "cl_sidespeed 360\n");
	stuffcmd(self, "cl_bob 0.01\n");
	stuffcmd(self, "cl_bobup 0.5\n");
	stuffcmd(self, "cl_bobcycle 0.4\n");
	stuffcmd(self, "r_waterwarp 0\n");
	stuffcmd(self, "cl_movespeedkey 0.5\n");
	stuffcmd(self, "v_idlescale 0\n");
	stuffcmd(self, "v_kickpitch 1\n");
	stuffcmd(self, "v_kickroll 1\n");
	stuffcmd(self, "-right\n");
	stuffcmd(self, "-left\n");
	stuffcmd(self, "-lookup\n");
	stuffcmd(self, "-lookdown\n");
	stuffcmd(self, "cl_yawspeed 140\n");
	stuffcmd(self, "cl_pitchspeed 150\n");
	self.vars_flag = AS_STRAIGHT;
};

float() crandom = 
{
	return H_MEGA * (random() - 0.5);
};
void() s_sparked1;
void(vector org, vector dir) Spark = 
{
	newmis = spawn();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_BOUNCE;
	newmis.solid = SOLID_BBOX;
	newmis.angles = vectoangles(dir);
	setmodel(newmis, "progs/s_spark.spr");
	setsize(newmis, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(newmis, org);
	makevectors(self.v_angle);
	newmis.velocity_x = random() * 100;
	newmis.velocity_y = random() * 100;
	newmis.velocity_z = random() * 200;
	newmis.think = s_sparked1;
	newmis.nextthink = time;
};
void() shell1;
void(vector org, vector dir) ExplodeTip = 
{
	local float x;
	newmis = spawn();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_FLYMISSILE;
	newmis.solid = SOLID_BBOX;
	newmis.angles = vectoangles(dir);
	if (random() > 0.5)
	{
		x = CONTENT_EMPTY;
	}
	else
	{
		x = AS_STRAIGHT;
	}
	newmis.velocity_x = random() * 60 * x;
	newmis.velocity_y = random() * 60 * x;
	newmis.velocity_z = random() * 100 * x;
	setmodel(newmis, "progs/s_expshl.spr");
	setsize(newmis, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(newmis, org);
	makevectors(self.v_angle);
	newmis.think = shell1;
	newmis.nextthink = time;
};

vector() wall_velocity = 
{
	local vector vel;
	vel = normalize(self.velocity);
	vel = normalize(vel + v_up * (random() - 0.5) + v_right * (random() - 0.5));
	vel = vel + H_MEGA * trace_plane_normal;
	vel = vel * 200;
	return vel; //st1x51: little issue(vel_x)
};

void(vector org, vector vel) SpawnMeatSpray = 
{
	local entity missile;
	local entity mpuff;
	missile = spawn();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_NOT;
	makevectors(self.angles);
	missile.velocity = vel;
	missile.velocity_z = missile.velocity_z + 250 + 50 * random();
	missile.avelocity = '3000 1000 2000';
	missile.nextthink = time + AS_STRAIGHT;
	missile.think = SUB_Remove;
	setmodel(missile, "progs/zom_gib.mdl");
	setsize(missile, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(missile, org);
};

void(vector org, vector vel, float damage, entity vic) SpawnBlood = 
{
	if (deathmatch)
	{
		particle(org, vel * 0.1, 73, damage * H_MEGA);
		return;
	}
	if (vic.classname == "monster_probe")
	{
		particle(org, vel * 0.1, 104, damage);
	}
	else
	{
		if (vic.classname == "monster_rider")
		{
			particle(org, vel * 0.1, 104, damage);
		}
		else
		{
			if (vic.classname == "monster_hunter")
			{
				particle(org, vel * 0.1, 104, damage);
			}
			else
			{
				if (vic.classname == "monster_banshee")
				{
					particle(org, vel * 0.1, 104, damage);
				}
				else
				{
					if (vic.classname == "monster_bossman")
					{
						particle(org, vel * 0.1, 176, damage);
					}
					else
					{
						if (vic.classname == "monster_turret")
						{
							particle(org, vel * 0.1, 104, damage);
						}
						else
						{
							if (vic.classname == "e_oj")
							{
								particle(org, vel * 0.1, ATTACK, damage);
							}
							else
							{
								if (vic.classname == "barrel")
								{
									particle(org, vel * 0.1, TE_LIGHTNING3, damage);
								}
								else
								{
									if (vic.classname == "breakable_bulb")
									{
										particle(org, vel * 0.1, TE_LIGHTNING3, damage);
									}
									else
									{
										if (vic.classname == "the_plant")
										{
											particle(org, vel * 0.1, 56, damage);
										}
										else
										{
											particle(org, vel * 0.1, 73, damage * H_MEGA);
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
};

void(float damage, entity vic) spawn_touchblood = 
{
	local vector vel;
	vel = wall_velocity() * 0.2;
	SpawnBlood(self.origin + vel * 0.010000, vel, damage, vic);
};

void(vector org, vector vel) SpawnChunk = 
{
	particle(org, vel * 0.020000, MSG_BROADCAST, TE_LAVASPLASH);
};

void() ClearMultiDamage = 
{
	multi_ent = world;
	multi_damage = MSG_BROADCAST;
};

void() ApplyMultiDamage = 
{
	if (!multi_ent)
	{
		return;
	}
	T_Damage(multi_ent, self, self, multi_damage);
};

void(entity hit, float damage) AddMultiDamage = 
{
	if (!hit)
	{
		return;
	}
	if (hit != multi_ent)
	{
		ApplyMultiDamage();
		multi_damage = damage;
		multi_ent = hit;
	}
	else
	{
		multi_damage = multi_damage + damage;
	}
};

void(float damage, vector dir) TraceAttack = 
{
	local vector vel;
	local vector org;
	local vector impact;
	local float dist;
	vel = normalize(dir + v_up * crandom() + v_right * crandom());
	vel = vel + H_MEGA * trace_plane_normal;
	vel = vel * 200;
	org = trace_endpos - dir * WEAPON_SPIKES;
	if (trace_ent.takedamage)
	{
		if (trace_ent.tools == (trace_ent.tools | UT_MINISUB))
		{
			impact = normalize(org - trace_ent.origin);
			makevectors(trace_ent.v_angle);
			dist = vlen(impact - v_forward);
			if (dist < 0.8)
			{
				damage = damage;
				particle(org, vel * 0.1, 73, damage * H_MEGA);
			}
			else
			{
				damage = damage / WEAPON_SPIKES;
				particle(org, vel * 0.1, 104, damage * H_MEGA);
			}
		}
		else
		{
			SpawnBlood(org, vel * 0.2, damage, trace_ent);
		}
		AddMultiDamage(trace_ent, damage);
		if (self.weapon == IT_SHOT)
		{
			if (random() > 0.85)
			{
				ExplodeTip(trace_endpos, dir);
			}
		}
	}
	else
	{
		if (self.weapon == IT_SHOT)
		{
			if (random() > 0.85)
			{
				ExplodeTip(trace_endpos, dir);
			}
		}
		else
		{
			if (random() < 0.25)
			{
				Spark(trace_endpos, dir);
			}
		}
		WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte(MSG_BROADCAST, TE_GUNSHOT);
		WriteCoord(MSG_BROADCAST, org_x);
		WriteCoord(MSG_BROADCAST, org_y);
		WriteCoord(MSG_BROADCAST, org_z);
	}
};

void(float shotcount, vector dir, vector spread) FireBullets = 
{
	local vector direction;
	local vector src;
	makevectors(self.v_angle);
	src = self.origin + v_forward * SVC_SETVIEWANGLES;
	src_z = self.absmin_z + self.size_z * 0.7;
	ClearMultiDamage();
	while (shotcount > MSG_BROADCAST)
	{
		direction = dir + crandom() * spread_x * v_right + crandom() * spread_y * v_up;
		traceline(src, src + direction * IT_CELLS, 0, self);
		if (trace_fraction != AS_STRAIGHT)
		{
			TraceAttack(WEAPON_SPIKES, direction);
		}
		shotcount = shotcount - AS_STRAIGHT;
	}
	ApplyMultiDamage();
};

void() ShellTouch = 
{
	self.angles_x = MSG_BROADCAST;
	if (random() < 0.33)
	{
		sound(self, CHAN_WEAPON, "weapons/shell1.wav", AS_STRAIGHT, ATTN_NORM);
	}
	else
	{
		if (random() < 0.66)
		{
			sound(self, CHAN_WEAPON, "weapons/shell2.wav", AS_STRAIGHT, ATTN_NORM);
		}
		else
		{
			sound(self, CHAN_WEAPON, "weapons/shell3.wav", AS_STRAIGHT, ATTN_NORM);
		}
	}
};

void() CaseTouch = 
{
	if (other.classname == "player")
	{
		remove(self);
	}
	if (self.classname == "celshel")
	{
		self.frame = AS_STRAIGHT;
	}
	self.angles_x = MSG_BROADCAST;
	if (self.classname == "mortshell")
	{
		sound(self, CHAN_WEAPON, "weapons/morthit.wav", AS_STRAIGHT, ATTN_NORM);
	}
	else
	{
		if (random() < 0.33)
		{
			sound(self, CHAN_WEAPON, "weapons/casehit1.wav", AS_STRAIGHT, ATTN_NORM);
		}
		else
		{
			if (random() < 0.66)
			{
				sound(self, CHAN_WEAPON, "weapons/casehit2.wav", AS_STRAIGHT, ATTN_NORM);
			}
			else
			{
				sound(self, CHAN_WEAPON, "weapons/casehit3.wav", AS_STRAIGHT, ATTN_NORM);
			}
		}
	}
};

void() BlowShell = 
{
	local entity missile;
	missile = spawn();
	missile.enemy = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_TRIGGER; //st1x51: player could touch case and its stopped him (was SOLID_BBOX)
	makevectors(self.v_angle);
	missile.velocity = aim(self, AS_STRAIGHT);
	missile.avelocity = random() * '1000 0 0';
	missile.angles = vectoangles(missile.velocity);
	missile.touch = ShellTouch;
	missile.nextthink = time + AS_STRAIGHT;
	missile.think = SUB_Remove;
	setmodel(missile, "progs/bshell1.mdl");
	setsize(missile, VEC_ORIGIN, VEC_ORIGIN);
	if (self.weapon == IT_UZI)
	{
		missile.velocity = v_right * (-130 + random() * -50) + v_forward * (70 + random() * 50) + v_up * (100 + random() * 100);
		setorigin(missile, self.origin + v_right * TE_WIZSPIKE + v_forward * 14 + '0 0 14');
	}
	else
	{
		missile.velocity = v_right * (-120 + random() * -50) + v_forward * (80 + random() * 50) + v_up * (50 + random() * 200);
		setorigin(missile, self.origin + v_right * TE_WIZSPIKE + v_forward * WEAPON_BIG + '0 0 11');
	}
};

void() BlowCase = 
{
	local entity missile;
	missile = spawn();
	missile.enemy = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_TRIGGER; //st1x51: player could touch case and its stopped him (was SOLID_BBOX)
	makevectors(self.v_angle);
	missile.velocity = aim(self, AS_STRAIGHT);
	missile.avelocity = '200 0 0' + random() * '800 0 0';
	missile.angles = vectoangles(missile.velocity);
	missile.think = SUB_Remove;
	if (self.weapon == IT_MORTER)
	{
		missile.velocity = v_right * (-20 + random() * -30) + v_forward * (random() * 150) + v_up * (400 + random() * 200);
		setmodel(missile, "progs/mortshel.mdl");
		setsize(missile, '0 0 -4', '0 0 4');
		setorigin(missile, self.origin + v_forward * 20 + v_right * TE_LIGHTNING3 + '0 0 10');
		missile.nextthink = time + WEAPON_SPIKES;
		missile.classname = "mortshell";
	}
	else
	{
		if (self.weapon == IT_PUNISHER)
		{
			missile.velocity = v_right * (20 + random() * 50) + v_forward * (random() * 100) + v_up * (100 + random() * 200);
			setmodel(missile, "progs/celshel.mdl");
			setsize(missile, '0 0 -4', '0 0 4');
			setorigin(missile, self.origin + v_forward * 20 + v_right * TE_LIGHTNING3 + '0 0 10');
			missile.nextthink = time + OTFATTACK;
			missile.avelocity = '0 0 500' + random() * '0 0 1000';
			missile.classname = "celshel";
		}
		else
		{
			if (self.weapon == IT_SHOT2)
			{
				missile.velocity = v_right * (50 + random() * 50) + v_forward * (random() * 150) + v_up * (random() * 300);
				setorigin(missile, self.origin + v_forward * 24 + v_right * WEAPON_BIG + '0 0 10');
				setmodel(missile, "progs/shelcase.mdl");
			}
			else
			{
				if (self.weapon == IT_44)
				{
					missile.velocity = v_right * (-50 + random() * -50) + v_forward * (random() * 150) + v_up * (random() * 300);
					setorigin(missile, self.origin + v_forward * 24 + v_right * -8 + '0 0 10');
					setmodel(missile, "progs/bulcase.mdl");
					missile.touch = ShellTouch;
					missile.nextthink = time + H_MEGA;
					setsize(missile, VEC_ORIGIN, VEC_ORIGIN);
					return;
				}
				else
				{
					missile.velocity = v_right * (-50 + random() * -50) + v_forward * (random() * 150) + v_up * (random() * 300);
					setorigin(missile, self.origin + v_forward * 24 + v_right * -8 + '0 0 10');
					setmodel(missile, "progs/shelcase.mdl");
				}
			}
			missile.nextthink = time + H_MEGA;
			setsize(missile, VEC_ORIGIN, VEC_ORIGIN);
		}
	}
	missile.touch = CaseTouch;
};

void() PlasTouch = 
{
	local float amount;
	if (other == self.owner)
	{
		return;
	}
	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	amount = SVC_SETVIEWANGLES + random() * SVC_SETVIEWANGLES;
	if (other.health)
	{
		T_Damage(other, self, self.owner, amount);
	}
	remove(self);
};

void() W_DeathFire = 
{
	local entity plasma;
	sound(self, CHAN_WEAPON, "weapons/plasma.wav", AS_STRAIGHT, ATTN_NORM);
	plasma = spawn();
	plasma.owner = self;
	plasma.movetype = MOVETYPE_FLYMISSILE;
	plasma.solid = SOLID_BBOX;
	makevectors(self.v_angle);
	plasma.velocity = aim(self, AS_STRAIGHT);
	plasma.velocity = plasma.velocity * 1500;
	plasma.angles = vectoangles(plasma.velocity);
	plasma.touch = PlasTouch;
	setmodel(plasma, "progs/comet.mdl");
	setsize(plasma, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(plasma, self.origin + v_forward * 20 + '0 0 18');
};

void() W_FireShotgun = 
{
	local vector dir;
	self.count_shot_idle = 40;
	self.punchangle_x = CONTENT_SOLID;
	dir = aim(self, 100000);
	if (self.weapon == IT_SHOT)
	{
		sound(self, CHAN_WEAPON, "weapons/shot1b.wav", AS_STRAIGHT, ATTN_NORM);
		self.currentammo = self.ammo_shells2 = self.ammo_shells2 - H_MEGA;
		FireBullets(12, dir, '0.040000 0.040000 0');
		BlowCase();
	}
	else
	{
		sound(self, CHAN_WEAPON, "weapons/shot1.wav", AS_STRAIGHT, ATTN_NORM);
		FireBullets(TE_LIGHTNING2, dir, '0.040000 0.040000 0');
		BlowCase();
	}
};

void() W_FireOozi = 
{
	local vector dir;
	if (self.mini_flag < time)
	{
		sound(self, CHAN_WEAPON, "weapons/uzim.wav", AS_STRAIGHT, ATTN_NORM);
		self.mini_flag = time + 0.097000;
	}
	self.punchangle_x = CONTENT_SOLID;
	self.currentammo = self.ammo_nails2 = self.ammo_nails2 - AS_STRAIGHT;
	dir = aim(self, 100000);
	FireBullets(TE_LIGHTNING2, dir, '0.001000 0.001000 0');
};

void() W_FireSuperShotgun = 
{
	local vector dir;
	sound(self, CHAN_WEAPON, "weapons/shot2.wav", AS_STRAIGHT, ATTN_NORM);
	self.currentammo = self.ammo_shells2 = self.ammo_shells2 - WEAPON_SPIKES;
	self.punchangle_x = CONTENT_SLIME;
	dir = aim(self, 100000);
	FireBullets(SVC_KILLEDMONSTER, dir, '0.14 0.080000 0');
	BlowCase();
	BlowCase();
};

void() s_explode1 = [0, s_explode2]
{
};

void() s_explode2 = [1, s_explode3]
{
};

void() s_explode3 = [2, s_explode4]
{
};

void() s_explode4 = [3, s_explode5]
{
};

void() s_explode5 = [4, s_explode6]
{
};

void() s_explode6 = [5, s_explode7]
{
};

void() s_explode7 = [6, s_explode8]
{
};

void() s_explode8 = [7, s_explode9]
{
};

void() s_explode9 = [8, s_explode10]
{
};

void() s_explode10 = [9, s_explode11]
{
};

void() s_explode11 = [10, SUB_Remove]
{
};

void() s_sparked1 = [0, s_sparked2]
{
};

void() s_sparked2 = [1, s_sparked3]
{
};

void() s_sparked3 = [2, s_sparked4]
{
};

void() s_sparked4 = [3, s_sparked5]
{
};

void() s_sparked5 = [4, s_sparked6]
{
};

void() s_sparked6 = [5, SUB_Remove]
{
};

void() plasma1 = [0, plasma2]
{
};

void() plasma2 = [1, plasma3]
{
};

void() plasma3 = [2, plasma4]
{
};

void() plasma4 = [3, plasma5]
{
};

void() plasma5 = [4, plasma6]
{
};

void() plasma6 = [5, SUB_Remove]
{
};

void() trail1 = [0, trail2]
{
};

void() trail2 = [1, trail3]
{
};

void() trail3 = [2, trail4]
{
};

void() trail4 = [3, trail5]
{
};

void() trail5 = [4, trail6]
{
};

void() trail6 = [5, trail7]
{
};

void() trail7 = [6, trail8]
{
};

void() trail8 = [7, SUB_Remove]
{
};

void() shell1 = [0, shell2]
{
};

void() shell2 = [1, shell3]
{
};

void() shell3 = [2, shell4]
{
};

void() shell4 = [3, shell5]
{
};

void() shell5 = [4, shell6]
{
};

void() shell6 = [5, shell7]
{
};

void() shell7 = [6, shell8]
{
};

void() shell8 = [7, SUB_Remove]
{
};

void() BecomeExplosion = 
{
	self.movetype = MOVETYPE_NOCLIP;
	self.velocity = '0 0 60';
	self.touch = SUB_Null;
	self.think = SUB_Null;
	self.solid = SOLID_NOT;
	setmodel(self, "progs/s_explod.spr");
	s_explode1();
};

void() RailExplosion = 
{
	self.movetype = MOVETYPE_NONE;
	self.velocity = VEC_ORIGIN;
	self.touch = SUB_Null;
	self.solid = SOLID_NOT;
	setmodel(self, "progs/s_punish.spr");
	plasma1();
};

void() T_MissileTouch = 
{
	local float damg;
	if (other == self.owner)
	{
		return;
	}
	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	damg = 200 + random() * 20;
	if (other.health)
	{
		T_Damage(other, self, self.owner, damg);
	}
	T_RadiusDamage(self, self.owner, 140, other);
	self.origin = self.origin - WEAPON_BIG * normalize(self.velocity);
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord(MSG_BROADCAST, self.origin_x);
	WriteCoord(MSG_BROADCAST, self.origin_y);
	WriteCoord(MSG_BROADCAST, self.origin_z);
	BecomeExplosion();
};

void() T_TorpTouch = 
{
	local float damg;
	self.owner.tube_wing = self.owner.tube_wing - AS_STRAIGHT;
	if (other == self.owner)
	{
		return;
	}
	damg = 200 + random() * 50;
	if (other.health)
	{
		T_Damage(other, self, self.owner, damg);
	}
	T_RadiusDamage(self, self.owner, 200, other);
	self.origin = self.origin - WEAPON_BIG * normalize(self.velocity);
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord(MSG_BROADCAST, self.origin_x);
	WriteCoord(MSG_BROADCAST, self.origin_y);
	WriteCoord(MSG_BROADCAST, self.origin_z);
	BecomeExplosion();
};

void() T_RailTouch = 
{
	local float damg;
	if (other == self.owner)
	{
		return;
	}
	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	if (other.health)
	{
		T_Damage(other, self, self.owner, 60);
	}
	T_RadiusDamage(self, self.owner, 90, other);
	sound(self, CHAN_WEAPON, "weapons/punish4.wav", AS_STRAIGHT, ATTN_NORM);
	self.origin = self.origin - WEAPON_BIG * normalize(self.velocity);
	RailExplosion();
};

void() w_firemini = 
{
	local vector dir;
	if (self.mini_flag < time)
	{
		if (random() < 0.33)
		{
			sound(self, CHAN_WEAPON, "weapons/mini1.wav", AS_STRAIGHT, ATTN_NORM);
			self.mini_flag = time + 0.55;
		}
		else
		{
			if (random() < 0.66)
			{
				sound(self, CHAN_WEAPON, "weapons/mini2.wav", AS_STRAIGHT, ATTN_NORM);
				self.mini_flag = time + 0.5;
			}
			else
			{
				sound(self, CHAN_WEAPON, "weapons/mini3.wav", AS_STRAIGHT, ATTN_NORM);
				self.mini_flag = time + 0.2;
			}
		}
	}
	self.punchangle_x = CONTENT_SOLID;
	self.currentammo = self.ammo_nails2 = self.ammo_nails2 - AS_STRAIGHT;
	dir = aim(self, 100000);
	FireBullets(WEAPON_SPIKES, dir, '0.002000 0.002000 0');
};

void() MorterExplode = 
{
	local vector dir;
	local vector org;
	makevectors(self.angles);
	dir = vectoangles(v_forward);
	dir_x = MSG_BROADCAST;
	dir_z = MSG_BROADCAST;
	org = self.origin + v_forward * -10;
	sound(self, CHAN_WEAPON, "weapons/r_exp3.wav", AS_STRAIGHT, ATTN_NORM);
	self.effects = self.effects | EF_DIMLIGHT;
	BecomeExplosion();
	if (pointcontents(self.origin) == CONTENT_WATER)
	{
		return;
	}
	Flame_bomb(org, dir + '0 45 0');
	Flame_bomb(org, dir + '0 135 0');
	Flame_bomb(org, dir + '0 225 0');
	Flame_bomb(org, dir + '0 315 0');
	if (deathmatch)
	{
		Flame_bomb(org, '0 1 0' * random() * 360);
		Flame_bomb(org, '0 1 0' * random() * 360);
		return;
	}
	Flame_bomb(org, dir);
	Flame_bomb(org, dir + '0 90 0');
	Flame_bomb(org, dir + '0 180 0');
	Flame_bomb(org, dir + '0 270 0');
};

void() MorterTouch = 
{
	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	MorterExplode();
	T_RadiusDamage(self, self.owner, 90, other);
	if (other == self.owner)
	{
		return;
	}
	if (other.health)
	{
		T_Damage(other, self, self.owner, 60);
		CheckTouch();
	}
};

void() blowupinface = 
{
	MorterExplode();
	T_RadiusDamage(self, self.owner, 40, world);
};

void() BecomeReal = 
{
	self.movetype = MOVETYPE_BOUNCE;
};

void() morter_misfire = 
{
	local entity missile;
	sound(self, CHAN_BODY, "damage/pain1.wav", AS_STRAIGHT, ATTN_NORM);
	missile = spawn();
	missile.owner = self;
	missile.movetype = MOVETYPE_NOCLIP;
	missile.solid = SOLID_NOT;
	missile.classname = "grenade";
	makevectors(self.v_angle);
	missile.nextthink = time;
	missile.think = blowupinface;
	setmodel(missile, "progs/null.spr");
	setsize(missile, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(missile, self.origin + v_right * 12 + '0 0 18');
	BlowCase();
};

void() W_FireMorter = 
{
	local entity missile;
	self.currentammo = self.ammo_rockets2 = self.ammo_rockets2 - H_MEGA;
	sound(self, CHAN_WEAPON, "weapons/morter1.wav", AS_STRAIGHT, ATTN_NORM);
	self.punchangle_x = CONTENT_SOLID;
	if (time > self.mortmf_time + 3.5)
	{
		self.mortmf_count = MSG_BROADCAST;
	}
	else
	{
		self.mortmf_count = self.mortmf_count + AS_STRAIGHT;
	}
	self.mortmf_time = time;
	if (self.mortmf_count >= TE_WIZSPIKE && self.count == MSG_BROADCAST && random() < 0.6)
	{
		self.mortmf_count = MSG_BROADCAST;
		morter_misfire();
		return;
	}
	missile = spawn();
	missile.owner = self;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;
	missile.classname = "grenade";
	makevectors(self.v_angle);
	if (self.v_angle_x)
	{
		if (self.waterlevel >= H_MEGA)
		{
			missile.velocity = v_forward * 600 + v_up * 50 + crandom() * v_right * SVC_SETVIEWANGLES + crandom() * v_up * SVC_SETVIEWANGLES;
		}
		else
		{
			missile.velocity = v_forward * 1200 + v_up * 50 + crandom() * v_right * SVC_SETVIEWANGLES + crandom() * v_up * SVC_SETVIEWANGLES;
		}
	}
	else
	{
		missile.velocity = aim(self, AS_STRAIGHT);
		if (self.waterlevel >= H_MEGA)
		{
			missile.velocity = missile.velocity * 500;
		}
		else
		{
			missile.velocity = missile.velocity * 1000;
		}
		missile.velocity_z = 50;
	}
	missile.angles = vectoangles(missile.velocity);
	missile.touch = MorterTouch;
	missile.nextthink = time + 0.5;
	missile.think = BecomeReal;
	setmodel(missile, "progs/morter.mdl");
	setsize(missile, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(missile, self.origin + v_right * 12 + '0 0 18');
	BlowCase();
};

void() ChangeMotion = 
{
	local entity smoke;
	local entity angle;
	self.think = ChangeMotion;
	self.nextthink = time + 0.1;
	smoke = spawn();
	smoke.movetype = MOVETYPE_NONE;
	smoke.solid = SOLID_NOT;
	smoke.angles_x = self.angles_x * CONTENT_EMPTY;
	smoke.angles_y = self.angles_y;
	setmodel(smoke, "progs/s_plas.spr");
	setsize(smoke, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(smoke, self.origin);
	smoke.nextthink = time;
	smoke.think = trail1;
};

void() W_FireRail = 
{
	local entity missile;
	self.currentammo = self.ammo_cells2 = self.ammo_cells2 - AS_STRAIGHT;
	sound(self, CHAN_WEAPON, "weapons/punish2.wav", AS_STRAIGHT, ATTN_NORM);
	self.punchangle_x = CONTENT_SOLID;
	missile = spawn();
	missile.owner = self;
	missile.classname = "punisher";
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;
	makevectors(self.v_angle);
	missile.velocity = aim(self, 1000);
	if (self.waterlevel >= H_MEGA)
	{
		missile.velocity = missile.velocity * 1100;
	}
	else
	{
		missile.velocity = missile.velocity * 2200;
	}
	missile.angles = vectoangles(missile.velocity);
	missile.touch = T_RailTouch;
	missile.nextthink = time + 0.1;
	missile.think = ChangeMotion;
	setmodel(missile, "progs/comet.mdl");
	setsize(missile, VEC_ORIGIN, VEC_ORIGIN);
	if (self.barrel2 == AS_STRAIGHT)
	{
		setorigin(missile, self.origin + v_right * WEAPON_BIG + v_forward * 20 + '0 0 4');
	}
	else
	{
		setorigin(missile, self.origin + v_right * 18 + v_forward * 20 + '0 0 4');
	}
	if (self.punish_eject > H_MEGA)
	{
		BlowCase();
		self.punish_eject = MSG_BROADCAST;
	}
	else
	{
		self.punish_eject = self.punish_eject + AS_STRAIGHT;
	}
};

void() W_FireRocket = 
{
	local entity missile;
	self.currentammo = self.ammo_rockets2 = self.ammo_rockets2 - AS_STRAIGHT;
	self.punchangle_x = CONTENT_SOLID;
	missile = spawn();
	missile.owner = self;
	missile.classname = "stinger";
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;
	makevectors(self.v_angle);
	missile.velocity = aim(self, AS_STRAIGHT);
	if (self.waterlevel >= H_MEGA)
	{
		missile.velocity = missile.velocity * 450;
	}
	else
	{
		missile.velocity = missile.velocity * 650;
	}
	missile.angles = vectoangles(missile.velocity);
	missile.touch = T_MissileTouch;
	missile.avelocity = '0 0 600';
	setmodel(missile, "progs/rocket.mdl");
	setsize(missile, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(missile, self.origin + v_forward * WEAPON_BIG + v_right * 4.4 + '0 0 18.3');
};

void(vector org, vector dir) launch_spike = 
{
	newmis = spawn();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_FLYMISSILE;
	newmis.solid = SOLID_BBOX;
	newmis.angles = vectoangles(dir);
	newmis.touch = spike_touch;
	newmis.classname = "spike";
	newmis.think = SUB_Remove;
	newmis.nextthink = time + TE_LIGHTNING2;
	setmodel(newmis, "progs/spike.mdl");
	setsize(newmis, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(newmis, org);
	newmis.velocity = dir * 1000;
};

void() W_FireSuperSpikes = 
{
	local vector dir;
	local entity old;
	sound(self, CHAN_WEAPON, "weapons/spike2.wav", AS_STRAIGHT, ATTN_NORM);
	self.attack_finished = time + 0.2;
	self.currentammo = self.ammo_nails2 = self.ammo_nails2 - H_MEGA;
	dir = aim(self, 1000);
	launch_spike(self.origin + '0 0 16', dir);
	newmis.touch = superspike_touch;
	setmodel(newmis, "progs/s_spike.mdl");
	setsize(newmis, VEC_ORIGIN, VEC_ORIGIN);
	self.punchangle_x = CONTENT_SOLID;
};

void() spike_touch = 
{
	local float rand;
	if (other == self.owner)
	{
		return;
	}
	if (other.solid == SOLID_TRIGGER)
	{
		return;
	}
	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	if (other.takedamage)
	{
		spawn_touchblood(TE_LIGHTNING3, other);
		T_Damage(other, self, self.owner, TE_LIGHTNING3);
	}
	else
	{
		WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
		if (self.classname == "wizspike")
		{
			WriteByte(MSG_BROADCAST, TE_WIZSPIKE);
		}
		else
		{
			if (self.classname == "knightspike")
			{
				WriteByte(MSG_BROADCAST, TE_KNIGHTSPIKE);
			}
			else
			{
				WriteByte(MSG_BROADCAST, TE_SPIKE);
			}
		}
		WriteCoord(MSG_BROADCAST, self.origin_x);
		WriteCoord(MSG_BROADCAST, self.origin_y);
		WriteCoord(MSG_BROADCAST, self.origin_z);
	}
	remove(self);
};

void() superspike_touch = 
{
	local float rand;
	if (other == self.owner)
	{
		return;
	}
	if (other.solid == SOLID_TRIGGER)
	{
		return;
	}
	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	if (other.takedamage)
	{
		spawn_touchblood(18, other);
		T_Damage(other, self, self.owner, 18);
	}
	else
	{
		WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte(MSG_BROADCAST, TE_SUPERSPIKE);
		WriteCoord(MSG_BROADCAST, self.origin_x);
		WriteCoord(MSG_BROADCAST, self.origin_y);
		WriteCoord(MSG_BROADCAST, self.origin_z);
	}
	remove(self);
};

void() W_SetCurrentAmmo = 
{
	UpdateAmmoBars();
	if (self.tools == (self.tools | UT_BIGASSGUN))
	{
		if (self.speed & CHSCAM_ON)
		{
			self.weaponmodel = "";
			self.weaponframe = MSG_BROADCAST;
			return;
		}
		else
		{
			self.weaponmodel = "progs/w_bag.mdl";
			return;
		}
	}
	if (self.weapon != IT_ROCKET)
	{
		player_run();
	}
	if (self.tools == (self.tools | UT_MINISUB))
	{
		if (self.speed & CHSCAM_ON)
		{
			self.weaponmodel = "";
			self.weaponframe = MSG_BROADCAST;
		}
		return;
	}
	self.items = self.items - (self.items & (IT_SHELLS | IT_NAILS | IT_ROCKETS | IT_CELLS));
	if (self.weapon == IT_SHOT)
	{
		self.currentammo = self.ammo_shells2;
		self.weaponmodel = "progs/w_shot.mdl";
		self.weaponframe = MSG_BROADCAST;
		self.items = self.items | IT_SHELLS;
		self.count = MSG_BROADCAST;
	}
	else
	{
		if (self.weapon == IT_SHOT2)
		{
			self.currentammo = self.ammo_shells2;
			self.weaponmodel = "progs/w_shot2.mdl";
			self.weaponframe = MSG_BROADCAST;
			self.items = self.items | IT_SHELLS;
			self.count = MSG_BROADCAST;
		}
		else
		{
			if (self.weapon == IT_UZI)
			{
				self.currentammo = self.ammo_nails2;
				self.weaponmodel = "progs/w_uzi.mdl";
				self.weaponframe = MSG_BROADCAST;
				self.items = self.items | IT_NAILS;
				self.count = MSG_BROADCAST;
			}
			else
			{
				if (self.weapon == IT_ROCKET)
				{
					self.currentammo = self.ammo_rockets2;
					self.weaponmodel = "progs/w_rocket.mdl";
					self.items = self.items | IT_ROCKETS;
				}
				else
				{
					if (self.weapon == IT_MORTER)
					{
						self.currentammo = self.ammo_rockets2;
						self.weaponmodel = "progs/w_morter.mdl";
						self.weaponframe = MSG_BROADCAST;
						self.items = self.items | IT_ROCKETS;
						self.count = MSG_BROADCAST;
					}
					else
					{
						if (self.weapon == IT_MINI)
						{
							self.currentammo = self.ammo_nails2;
							self.weaponmodel = "progs/w_mini.mdl";
							self.weaponframe = MSG_BROADCAST;
							self.items = self.items | IT_NAILS;
							self.count = MSG_BROADCAST;
						}
						else
						{
							if (self.weapon == IT_PUNISHER)
							{
								self.currentammo = self.ammo_cells2;
								self.weaponmodel = "progs/w_punish.mdl";
								self.weaponframe = MSG_BROADCAST;
								self.items = self.items | IT_CELLS;
							}
							else
							{
								if (self.weapon == IT_44)
								{
									self.currentammo = MSG_BROADCAST;
									self.weaponmodel = "progs/w_44.mdl";
									self.count = MSG_BROADCAST;
								}
								else
								{
									sprint(self, "W_Setcurrentammo\n");
								}
							}
						}
					}
				}
			}
		}
	}
	if (self.speed & CHSCAM_ON)
	{
		self.weaponmodel = "";
		self.weaponframe = MSG_BROADCAST;
	}
};

float() W_BestWeapon = 
{
	local float it;
	it = self.items;
	if (self.ammo_cells2 >= AS_STRAIGHT && (it & IT_PUNISHER))
	{
		return IT_PUNISHER;
	}
	else
	{
		if (self.ammo_rockets2 >= AS_STRAIGHT && (it & IT_ROCKET))
		{
			return IT_ROCKET;
		}
		else
		{
			if (self.ammo_rockets2 >= H_MEGA && (it & IT_MORTER))
			{
				return IT_MORTER;
			}
			else
			{
				if (self.ammo_nails2 >= AS_STRAIGHT && (it & IT_MINI))
				{
					return IT_MINI;
				}
				else
				{
					if (self.ammo_nails2 >= AS_STRAIGHT && (it & IT_UZI))
					{
						return IT_UZI;
					}
					else
					{
						if (self.ammo_shells2 >= WEAPON_SPIKES && (it & IT_SHOT2))
						{
							return IT_SHOT2;
						}
						else
						{
							if (self.ammo_shells2 >= H_MEGA && (it & IT_SHOT))
							{
								return IT_SHOT;
							}
							else
							{
								return IT_44;
							}
						}
					}
				}
			}
		}
	}
};

float() W_CheckNoAmmo = 
{
	if (self.currentammo > MSG_BROADCAST)
	{
		return 1;
	}
	if (self.weapon == IT_44)
	{
		return 1;
	}
	self.weapon = W_BestWeapon();
	W_SetCurrentAmmo();
	return 0;
};

void() WeaponReload = 
{
	if (self.attack_finished > time || self.button0 || self.tools == (self.tools | UT_MINISUB))
	{
		return;
	}
	if (self.tools == (self.tools | UT_BIGASSGUN))
	{
		return;
	}
	if (self.probe_active == AS_STRAIGHT)
	{
		return;
	}
	if (self.weapon == IT_44)
	{
		if (!(self.speed & CHSCAM_ON))
		{
			self.weaponmodel = "progs/w_44.mdl";
		}
		self.count_shot_idle = 40;
		self.weaponframe = TE_LIGHTNING2;
		loadwep();
		sound(self, CHAN_WEAPON, "weapons/reload1.wav", AS_STRAIGHT, ATTN_NORM);
		self.attack_finished = time + 0.8;
	}
	if (self.weapon == IT_SHOT)
	{
		sound(self, CHAN_WEAPON, "weapons/reload11.wav", AS_STRAIGHT, ATTN_NORM);
		self.weaponframe = 29;
		loadwep();
		self.attack_finished = time + 0.4;
	}
	else
	{
		if (self.weapon == IT_SHOT2)
		{
			sound(self, CHAN_WEAPON, "weapons/reload2.wav", AS_STRAIGHT, ATTN_NORM);
			self.weaponframe = TE_LIGHTNING2;
			loadwep();
			self.attack_finished = time + 0.8;
		}
		else
		{
			if (self.weapon == IT_UZI)
			{
				sound(self, CHAN_WEAPON, "weapons/reload3.wav", AS_STRAIGHT, ATTN_NORM);
				self.weaponframe = SVC_SETVIEWANGLES;
				loadwep();
				self.attack_finished = time + 0.5;
			}
			else
			{
				if (self.weapon == IT_MORTER)
				{
					sound(self, CHAN_WEAPON, "weapons/reload4.wav", AS_STRAIGHT, ATTN_NORM);
					self.weaponframe = TE_WIZSPIKE;
					loadwep();
					self.attack_finished = time + 0.5;
				}
				else
				{
					if (self.weapon == IT_MINI)
					{
						sound(self, CHAN_WEAPON, "weapons/reload3.wav", AS_STRAIGHT, ATTN_NORM);
					}
				}
			}
		}
	}
	self.count = MSG_BROADCAST;
};

void() W_Attack = 
{
	UpdateAmmoBars();
	makevectors(self.v_angle);
	self.show_hostile = time + AS_STRAIGHT;
	if (self.probe_active == AS_STRAIGHT)
	{
		makevectors(self.v_angle);
		self.velocity = aim(self, AS_STRAIGHT);
		self.velocity = self.velocity * 200;
		return;
	}
	if (self.tools == (self.tools | UT_BIGASSGUN))
	{
		self.atomic_intensity = MSG_BROADCAST;
		sound(self, CHAN_WEAPON, "misc/intense.wav", AS_STRAIGHT, ATTN_NORM);
		player_bag1();
		return;
	}
	if (self.tools == (self.tools | UT_MINISUB))
	{
		if (self.tube_wing > AS_STRAIGHT)
		{
			return;
		}
		else
		{
			W_FireTorpedo();
			self.attack_finished = time + 0.5;
			return;
		}
	}
	if (!W_CheckNoAmmo())
	{
		return;
	}
	if (self.weapon == IT_44)
	{
		if (!(self.speed & CHSCAM_ON))
		{
			self.weaponmodel = "progs/w_44.mdl";
		}
		self.count_shot_idle = 40;
		if (self.count == SVC_SETVIEWANGLES)
		{
			sprint(self, "Перезаряжайся\n");
			sound(self, CHAN_AUTO, "weapons/misfire1.wav", AS_STRAIGHT, ATTN_NORM);
			self.attack_finished = time + 0.2;
			return;
		}
		else
		{
			player_shot1();
			W_FireShotgun();
			self.attack_finished = time + 0.2;
			self.count = self.count + AS_STRAIGHT;
		}
	}
	else
	{
		if (self.weapon == IT_SHOT)
		{
			if (self.count == OTFATTACK)
			{
				sprint(self, "Перезаряжайся\n");
				sound(self, CHAN_AUTO, "weapons/misfire1.wav", AS_STRAIGHT, ATTN_NORM);
				self.attack_finished = time + 0.2;
				return;
			}
			else
			{
				if (self.ammo_shells2 < H_MEGA)
				{
					self.weapon = IT_44;
					W_SetCurrentAmmo();
					return;
				}
				else
				{
					player_hellfire1();
					W_FireShotgun();
					self.attack_finished = time + 0.2;
					self.count = self.count + AS_STRAIGHT;
				}
			}
		}
		else
		{
			if (self.weapon == IT_SHOT2)
			{
				if (self.count == WEAPON_BIG)
				{
					sprint(self, "Перезаряжайся\n");
					self.attack_finished = time + 0.4;
					sound(self, CHAN_AUTO, "weapons/misfire2.wav", AS_STRAIGHT, ATTN_NORM);
					return;
				}
				else
				{
					if (self.ammo_shells2 < WEAPON_SPIKES)
					{
						self.weapon = IT_44;
						W_SetCurrentAmmo();
						return;
					}
					else
					{
						player_blast1();
						W_FireSuperShotgun();
						self.attack_finished = time + 0.5;
						self.count = self.count + AS_STRAIGHT;
					}
				}
			}
			else
			{
				if (self.weapon == IT_UZI)
				{
					player_oozi1();
				}
				else
				{
					if (self.weapon == IT_MINI)
					{
						player_oozi1();
					}
					else
					{
						if (self.weapon == IT_MORTER)
						{
							if (self.count == TE_LIGHTNING2)
							{
								sprint(self, "Перезаряжайся\n");
								self.attack_finished = time + AS_STRAIGHT;
								sound(self, CHAN_AUTO, "weapons/misfire2.wav", AS_STRAIGHT, ATTN_NORM);
								return;
							}
							else
							{
								if (self.ammo_rockets2 < H_MEGA)
								{
									self.weapon = IT_44;
									W_SetCurrentAmmo();
									return;
								}
								player_morter1();
								W_FireMorter();
								self.attack_finished = time + AS_STRAIGHT;
								self.count = self.count + AS_STRAIGHT;
							}
						}
						else
						{
							if (self.weapon == IT_ROCKET)
							{
								player_rocket1();
								self.attack_finished = time + 1.15;
							}
							else
							{
								if (self.weapon == IT_PUNISHER)
								{
									if (self.barrel2 == MSG_BROADCAST)
									{
										player_rail1();
									}
									else
									{
										player_railb1();
									}
									W_FireRail();
									self.attack_finished = time + 0.5;
								}
							}
						}
					}
				}
			}
		}
	}
};

void() W_ChangeWeapon = 
{
	local float it;
	local float am;
	local float fl;
	if (self.tools == (self.tools | UT_BIGASSGUN) || self.tools == (self.tools | UT_MINISUB))
	{
		return;
	}
	if (self.probe_active == AS_STRAIGHT)
	{
		return;
	}
	it = self.items;
	am = MSG_BROADCAST;
	if (self.impulse == AS_STRAIGHT)
	{
		if (self.weapon == IT_44)
		{
			return;
		}
		fl = IT_44;
		self.count_shot_idle = 40;
	}
	else
	{
		if (self.impulse == H_MEGA)
		{
			if (self.weapon == IT_SHOT)
			{
				return;
			}
			fl = IT_SHOT;
			if (self.ammo_shells2 < H_MEGA)
			{
				am = AS_STRAIGHT;
			}
		}
		else
		{
			if (self.impulse == AS_MELEE)
			{
				if (self.weapon == IT_SHOT2)
				{
					return;
				}
				fl = IT_SHOT2;
				if (self.ammo_shells2 < WEAPON_SPIKES)
				{
					am = AS_STRAIGHT;
				}
			}
			else
			{
				if (self.impulse == WEAPON_SPIKES)
				{
					if (self.weapon == IT_UZI)
					{
						return;
					}
					fl = IT_UZI;
					if (self.ammo_nails2 < AS_STRAIGHT)
					{
						am = AS_STRAIGHT;
					}
				}
				else
				{
					if (self.impulse == SVC_SETVIEWPORT)
					{
						if (self.weapon == IT_MINI)
						{
							return;
						}
						fl = IT_MINI;
						if (self.ammo_nails2 < AS_STRAIGHT)
						{
							am = AS_STRAIGHT;
						}
					}
					else
					{
						if (self.impulse == TE_LIGHTNING2)
						{
							if (self.weapon == IT_MORTER)
							{
								return;
							}
							fl = IT_MORTER;
							if (self.ammo_rockets2 < H_MEGA)
							{
								am = AS_STRAIGHT;
							}
						}
						else
						{
							if (self.impulse == TE_WIZSPIKE)
							{
								if (self.weapon == IT_ROCKET || self.items != (self.items | IT_ROCKET) || self.ammo_rockets < AS_STRAIGHT)
								{
									return;
								}
								open_rocket1();
								sound(self, CHAN_AUTO, "weapons/loadrock.wav", AS_STRAIGHT, ATTN_NORM);
								fl = IT_ROCKET;
								if (self.ammo_rockets2 < AS_STRAIGHT)
								{
									am = AS_STRAIGHT;
								}
							}
							else
							{
								if (self.impulse == WEAPON_BIG)
								{
									if (self.weapon == IT_PUNISHER)
									{
										return;
									}
									fl = IT_PUNISHER;
									if (self.ammo_cells2 < AS_STRAIGHT)
									{
										am = AS_STRAIGHT;
									}
								}
							}
						}
					}
				}
			}
		}
	}
	self.impulse = MSG_BROADCAST;
	if (!(self.items & fl))
	{
		sprint(self, "нет оружия.\n");
		return;
	}
	if (am)
	{
		sprint(self, "не хватает патронов.\n");
		return;
	}
	self.weapon = fl;
	W_SetCurrentAmmo();
};

void() CheatCommand = 
{
	if (deathmatch || coop)
	{
		return;
	}
	self.ammo_rockets2 = 100;
	self.ammo_nails2 = 200;
	self.ammo_shells2 = 100;
	self.items = self.items | IT_44 | IT_ARMOR1 | IT_UZI | IT_SHOT | IT_SHOT2 | IT_ROCKET | IT_MORTER | IT_MINI | IT_KEY1 | IT_KEY2;
	self.tools = self.tools | UT_CHUTE | UT_PROBE | UT_HOVER | UT_SCUBA;
	if (self.hover_active == AS_STRAIGHT || self.probe_active == AS_STRAIGHT)
	{
		FireUtil();
	}
	self.items = self.items - (self.items & (IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3)) + IT_ARMOR1;
	self.util = UT_CHUTE;
	self.armorvalue = TE_LIGHTNING3;
	self.ammo_cells2 = 100;
	self.items = self.items | IT_PUNISHER;
	self.tools == (self.tools | UT_CHUTE | UT_PROBE | UT_HOVER | UT_SCUBA);
	self.weapon = IT_ROCKET;
	self.impulse = MSG_BROADCAST;
	W_SetCurrentAmmo();
};

void() CycleWeaponCommand = 
{
	local float it;
	local float am;
	if (self.tools == (self.tools | UT_BIGASSGUN))
	{
		return;
	}
	if (self.attack_finished > time || self.button0)
	{
		return;
	}
	if (self.probe_active == AS_STRAIGHT)
	{
		return;
	}
	it = self.items;
	self.impulse = MSG_BROADCAST;
	while (AS_STRAIGHT)
	{
		am = MSG_BROADCAST;
		if (self.weapon == IT_PUNISHER)
		{
			self.weapon = IT_44;
		}
		else
		{
			if (self.weapon == IT_44)
			{
				self.weapon = IT_SHOT;
				if (self.ammo_shells2 < H_MEGA)
				{
					am = AS_STRAIGHT;
				}
			}
			else
			{
				if (self.weapon == IT_SHOT)
				{
					self.weapon = IT_SHOT2;
					if (self.ammo_shells2 < WEAPON_SPIKES)
					{
						am = AS_STRAIGHT;
					}
				}
				else
				{
					if (self.weapon == IT_SHOT2)
					{
						self.weapon = IT_UZI;
						if (self.ammo_nails2 < AS_STRAIGHT)
						{
							am = AS_STRAIGHT;
						}
					}
					else
					{
						if (self.weapon == IT_UZI)
						{
							self.weapon = IT_MINI;
							if (self.ammo_nails2 < AS_STRAIGHT)
							{
								am = AS_STRAIGHT;
							}
						}
						else
						{
							if (self.weapon == IT_MINI)
							{
								self.weapon = IT_MORTER;
								if (self.ammo_rockets2 < H_MEGA)
								{
									am = AS_STRAIGHT;
								}
							}
							else
							{
								if (self.weapon == IT_MORTER)
								{
									self.weapon = IT_ROCKET;
									open_rocket1();
									sound(self, CHAN_BODY, "weapons/loadrock.wav", AS_STRAIGHT, ATTN_NORM);
									if (self.ammo_rockets2 < AS_STRAIGHT)
									{
										am = AS_STRAIGHT;
									}
								}
								else
								{
									if (self.weapon == IT_ROCKET)
									{
										sound(self, CHAN_BODY, "misc/null.wav", AS_STRAIGHT, ATTN_NORM);
										self.weapon = IT_PUNISHER;
										if (self.ammo_cells2 < AS_STRAIGHT)
										{
											am = AS_STRAIGHT;
										}
									}
								}
							}
						}
					}
				}
			}
		}
		if (self.items & self.weapon && am == MSG_BROADCAST)
		{
			W_SetCurrentAmmo();
			self.count_shot_idle = 40;
			return;
		}
	}
};

void() ServerflagsCommand = 
{
	serverflags = serverflags * H_MEGA + AS_STRAIGHT;
};

void() ImpulseCommands = 
{
	local string sv;
	local float cmax_num;
	if (self.impulse >= AS_STRAIGHT && self.impulse <= WEAPON_BIG)
	{
		W_ChangeWeapon();
	}
	if (self.impulse == TE_LIGHTNING3)
	{
		CheatCommand();
	}
	if (self.impulse == SVC_SETVIEWANGLES)
	{
		CycleWeaponCommand();
	}
	if (self.impulse == TE_TELEPORT)
	{
		ServerflagsCommand();
	}
	if (self.impulse == 12)
	{
		WeaponReload();
	}
	if (self.impulse == 13)
	{
		FireUtil();
	}
	if (self.impulse == 14)
	{
		CycleUtil();
	}
	if (self.impulse == 66)
	{
		release_deathsquad();
	}
	if (self.impulse == 100)
	{
		sound(self, CHAN_VOICE, "utils/pickup.wav", AS_STRAIGHT, ATTN_NORM);
		if (self.automount == MSG_BROADCAST)
		{
			self.automount = AS_STRAIGHT;
			stuffcmd(self, "echo Weapon AutoMount ON");
		}
		else
		{
			self.automount = MSG_BROADCAST;
			stuffcmd(self, "echo Weapon AutoMount OFF");
		}
	}
	if (self.impulse == 180)
	{
		bprint(vtos(self.origin));
		bprint("\n");
	}
	if (self.impulse == SVC_INTERMISSION)
	{
		Toggle_chase_cam();
	}
	self.impulse = MSG_BROADCAST;
};

void() W_WeaponFrame = 
{
	if (time < self.attack_finished)
	{
		return;
	}
	ImpulseCommands();
	if (self.button0)
	{
		W_Attack();
	}
};

