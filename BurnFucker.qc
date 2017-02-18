void() FlameMove;
void() BurnFucker;
void() smoke1 = [0, smoke2]
{
};

void() smoke2 = [1, smoke3]
{
};

void() smoke3 = [2, smoke4]
{
};

void() smoke4 = [3, smoke5]
{
};

void() smoke5 = [4, smoke6]
{
};

void() smoke6 = [5, smoke7]
{
};

void() smoke7 = [6, smoke8]
{
};

void() smoke8 = [7, smoke9]
{
};

void() smoke9 = [8, smoke10]
{
};

void() smoke10 = [9, SUB_Remove]
{
};

void() d_explode1 = [0, d_explode2]
{
};

void() d_explode2 = [1, d_explode3]
{
};

void() d_explode3 = [2, d_explode4]
{
};

void() d_explode4 = [3, d_explode5]
{
};

void() d_explode5 = [4, d_explode6]
{
};

void() d_explode6 = [5, d_explode7]
{
};

void() d_explode7 = [6, d_explode8]
{
};

void() d_explode8 = [7, d_explode9]
{
};

void() d_explode9 = [8, d_explode10]
{
};

void() d_explode10 = [9, d_explode11]
{
};

void() d_explode11 = [10, d_explode12]
{
};

void() d_explode12 = [11, d_explode13]
{
};

void() d_explode13 = [12, SUB_Remove]
{
};

void() fburn1 = [0, fburn2]
{
	self.origin = self.enemy.origin + v_forward * -10 + '0 0 30';
};

void() fburn2 = [1, fburn3]
{
	self.origin = self.enemy.origin + v_forward * -10 + '0 0 31';
};

void() fburn3 = [2, fburn4]
{
	self.origin = self.enemy.origin + v_forward * -10 + '0 0 32';
};

void() fburn4 = [3, fburn5]
{
	self.origin = self.enemy.origin + v_forward * -10 + '0 0 33';
};

void() fburn5 = [4, fburn6]
{
	self.origin = self.enemy.origin + v_forward * -10 + '0 0 34';
};

void() fburn6 = [5, fburn7]
{
	self.origin = self.enemy.origin + v_forward * -10 + '0 0 35';
};

void() fburn7 = [6, fburn8]
{
	self.origin = self.enemy.origin + v_forward * -10 + '0 0 36';
};

void() fburn8 = [7, fburn9]
{
	self.origin = self.enemy.origin + v_forward * -10 + '0 0 37';
};

void() fburn9 = [8, fburn10]
{
	self.origin = self.enemy.origin + v_forward * -10 + '0 0 38';
};

void() fburn10 = [9, SUB_Remove]
{
	self.enemy.effects = self.enemy.effects - (self.enemy.effects & EF_DIMLIGHT);
};

void() burn1 = [0, burn2]
{
	self.origin = self.enemy.origin + v_forward * -10 + '0 0 30';
};

void() burn2 = [1, burn3]
{
	self.origin = self.enemy.origin + v_forward * -10 + '0 0 30';
};

void() burn3 = [2, burn4]
{
	self.origin = self.enemy.origin + v_forward * -10 + '0 0 30';
	T_Damage(self.enemy, self.owner, self.owner, WEAPON_SPIKES);
};

void() burn4 = [3, burn1]
{
	FlameMove();
	self.origin = self.enemy.origin + v_forward * -10 + '0 0 30';
};

void() CheckTouch = 
{
	if (other.flags & FL_GODMODE)
	{
		return;
	}
	if (other.classname == "e_oj")
	{
		return;
	}
	if (other.classname == "door")
	{
		return;
	}
	if (other.health)
	{
		if (other.burning == AS_STRAIGHT)
		{
			return;
		}
		if (other.waterlevel > MSG_BROADCAST)
		{
			return;
		}
		BurnFucker();
	}
};

void(vector org, vector dir) Flame_bomb = 
{
	newmis = spawn();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_BOUNCE;
	newmis.solid = SOLID_BBOX;
	newmis.touch = CheckTouch;
	setmodel(newmis, "progs/d_explod.spr");
	if (deathmatch)
	{
		setsize(newmis, '2 2 -2', '2 2 2');
	}
	else
	{
		setsize(newmis, '5 5 -2', '5 5 2');
	}
	setorigin(newmis, org);
	newmis.nextthink = time + random() * 0.5;
	newmis.think = d_explode1;
	makevectors(dir);
	newmis.velocity_x = v_forward_x * 200 + random() * 100;
	newmis.velocity_y = v_forward_y * 200 + random() * 100;
	newmis.velocity_z = 100 + random() * 200;
};

void(vector org, vector dir) Fire_bomb = 
{
	local float x;
	newmis = spawn();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_NOCLIP;
	newmis.solid = SOLID_BBOX;
	newmis.touch = SUB_Remove;
	setmodel(newmis, "progs/d_explod.spr");
	setsize(newmis, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(newmis, org);
	if (random() > 0.5)
	{
		x = CONTENT_EMPTY;
	}
	else
	{
		x = AS_STRAIGHT;
	}
	newmis.nextthink = time;
	newmis.think = d_explode1;
	newmis.velocity_x = random() * 600 * x;
	newmis.velocity_y = random() * 600 * x;
	newmis.velocity_z = random() * 300;
};

void() FlameMove = 
{
	if (self.enemy.health <= MSG_BROADCAST || self.enemy.extinguished == AS_STRAIGHT)
	{
		self.enemy.burning = MSG_BROADCAST;
		self.enemy.extinguished = MSG_BROADCAST;
		setmodel(self, "progs/s_flame1.spr");
		fburn1();
		if (self.enemy.classname == "player")
		{
			if (self.enemy.probe_active == AS_STRAIGHT)
			{
				stuffcmd(self.enemy, "v_cshift 200 0 0 100\n");
			}
			else
			{
				stuffcmd(self.enemy, "v_cshift 0 0 0 0\n");
			}
		}
	}
	else
	{
		if (self.enemy.waterlevel >= AS_STRAIGHT)
		{
			sound(self, CHAN_WEAPON, "misc/hiss.wav", AS_STRAIGHT, ATTN_NORM);
			self.enemy.burning = MSG_BROADCAST;
			self.enemy.extinguished = MSG_BROADCAST;
			setmodel(self, "progs/s_smoke.spr");
			self.velocity_z = 50;
			smoke1();
			self.enemy.effects = self.enemy.effects - (self.enemy.effects & EF_DIMLIGHT);
			if (self.enemy.classname == "player")
			{
				if (self.enemy.probe_active == AS_STRAIGHT)
				{
					stuffcmd(self.enemy, "v_cshift 200 0 0 100\n");
				}
				else
				{
					stuffcmd(self.enemy, "v_cshift 0 0 0 0\n");
				}
			}
		}
		else
		{
			self.origin = self.enemy.origin + v_forward * -10 + '0 0 40';
			self.nextthink = time;
			self.think = burn1;
		}
	}
};

void() BurnFucker = 
{
	if (other.classname == "monster_banshee")
	{
		return;
	}
	if (other.classname == "monster_torcher")
	{
		return;
	}
	if (other.classname == "monster_probe")
	{
		return;
	}
	if (other.classname == "monster_rider")
	{
		return;
	}
	if (other.classname == "monster_hunter")
	{
		return;
	}
	if (other.classname == "monster_bossman" || other.classname == "monster_merc")
	{
		return;
	}
	if (other.health)
	{
		if (other.classname == "player")
		{
			stuffcmd(other, "v_cshift 250 50 0 100\n");
		}
		other.burning = AS_STRAIGHT;
		other.effects = other.effects | EF_DIMLIGHT;
		newmis = spawn();
		newmis.enemy = other;
		if (self.owner.classname == "player")
		{
			newmis.owner = self.owner;
		}
		else
		{
			newmis.owner = self.owner.owner;
		}
		newmis.movetype = MOVETYPE_NOCLIP;
		newmis.solid = SOLID_NOT;
		setmodel(newmis, "progs/s_flame2.spr");
		setsize(newmis, VEC_ORIGIN, VEC_ORIGIN);
		setorigin(newmis, other.origin + '0 0 22');
		newmis.think = FlameMove;
		newmis.nextthink = time;
	}
};

