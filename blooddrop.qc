void() streak;
void() WIPE_UP_BLOOD = 
{
	num_blooddrops = num_blooddrops - SPAWNFLAG_SUPERSPIKE;
	remove(self);
};

void() bd = 
{
	if (self.aqua_sound)
	{
		self.think = bd;
		self.nextthink = time + 0.8;
		self.frame = self.frame + SPAWNFLAG_SUPERSPIKE;
		if (self.frame > TE_LIGHTNING2)
		{
			WIPE_UP_BLOOD();
		}
	}
	else
	{
		self.think = bd;
		self.nextthink = time + 0.2;
		self.frame = self.frame - SPAWNFLAG_SUPERSPIKE;
		if (self.frame <= self.warp_factor)
		{
			self.aqua_sound = SPAWNFLAG_SUPERSPIKE;
			self.nextthink = time + SPAWNFLAG_SUPERSPIKE;
		}
	}
};

void() blooddrops = 
{
	local vector spot;
	local entity drop;
	if (random() > 0.8 * (MAX_DROPS - num_blooddrops) / MAX_DROPS)
	{
		return;
	}
	drop = spawn();
	num_blooddrops = num_blooddrops + SPAWNFLAG_SUPERSPIKE;
	traceline(self.origin, '0 0 -4096', 1, self);
	spot_x = trace_endpos_x + crandom() * TE_LIGHTNING2;
	spot_y = trace_endpos_y + crandom() * TE_LIGHTNING2;
	spot_z = trace_endpos_z;
	setorigin(drop, spot);
	drop.angles = vectoangles(trace_plane_normal);
	drop.angles_x = drop.angles_x - 90;
	setmodel(drop, "progs/bdrop.mdl");
	setsize(drop, VEC_ORIGIN, VEC_ORIGIN);
	drop.solid = SOLID_NOT;
	drop.movetype = MOVETYPE_BOUNCE;
	drop.owner = self;
	drop.frame = TE_LIGHTNING2;
	drop.aqua_sound = MSG_BROADCAST;
	drop.warp_factor = floor(random() * 6.990000);
	drop.think = bd;
	drop.nextthink = time;
};

void() wallsplat = 
{
	local vector dir;
	local vector direction;
	local float bcount;
	local entity drop;
	if (random() < 0.2)
	{
		streak();
		return;
	}
	dir = self.origin + '0 0 40' - (damage_attacker.origin + '0 0 20');
	makevectors(dir);
	bcount = floor(SPAWNFLAG_LASER * (MAX_DROPS - num_blooddrops) / AS_MELEE);
	while (bcount > MSG_BROADCAST)
	{
		if (num_blooddrops >= MAX_DROPS)
		{
			return;
		}
		direction = dir + crandom() * SVC_INTERMISSION * v_right + crandom() * SVC_INTERMISSION * v_up;
		traceline(self.origin, direction * IT_CELLS, 1, self);
		drop = spawn();
		num_blooddrops = num_blooddrops + SPAWNFLAG_SUPERSPIKE;
		setorigin(drop, trace_endpos + trace_plane_normal);
		setmodel(drop, "progs/bdrop.mdl");
		setsize(drop, VEC_ORIGIN, VEC_ORIGIN);
		drop.solid = SOLID_NOT;
		drop.movetype = MOVETYPE_NONE;
		drop.owner = self;
		drop.frame = floor(random() * 6.990000);
		drop.angles = vectoangles(trace_plane_normal);
		drop.angles_x = drop.angles_x - 90;
		drop.think = bd;
		drop.aqua_sound = SPAWNFLAG_SUPERSPIKE;
		drop.nextthink = time + SPAWNFLAG_SUPERSPIKE + random();
		bcount = bcount - SPAWNFLAG_SUPERSPIKE;
	}
};

void() streak = 
{
	local vector dir;
	local vector direction;
	local vector spiral;
	local vector UP;
	local vector RIGHT;
	local float bcount;
	local float tightness;
	local float hypo;
	local entity drop;
	tightness = SVC_INTERMISSION + crandom() * SVC_SETVIEWPORT;
	if (random() < 0.5)
	{
		tightness = MSG_BROADCAST - tightness;
	}
	hypo = SVC_CUTSCENE + crandom() * SVC_SETVIEWPORT;
	dir = self.origin + '0 0 40' - (damage_attacker.origin + '0 0 20');
	makevectors(dir);
	UP = v_up;
	RIGHT = v_right;
	bcount = MSG_BROADCAST;
	while (bcount < TE_WIZSPIKE)
	{
		if (num_blooddrops >= MAX_DROPS)
		{
			return;
		}
		makevectors(spiral);
		spiral_y = spiral_y + tightness;
		direction = dir + hypo * RIGHT * v_forward_x + hypo * UP * v_forward_y;
		traceline(self.origin, direction * IT_CELLS, 1, self);
		drop = spawn();
		num_blooddrops = num_blooddrops + SPAWNFLAG_SUPERSPIKE;
		setorigin(drop, trace_endpos + trace_plane_normal);
		setmodel(drop, "progs/bdrop.mdl");
		setsize(drop, VEC_ORIGIN, VEC_ORIGIN);
		drop.solid = SOLID_NOT;
		drop.movetype = MOVETYPE_NONE;
		drop.owner = self;
		drop.frame = bcount;
		drop.angles = vectoangles(trace_plane_normal);
		drop.angles_x = drop.angles_x - 90;
		drop.think = bd;
		drop.aqua_sound = SPAWNFLAG_SUPERSPIKE;
		drop.nextthink = time + SPAWNFLAG_SUPERSPIKE + random();
		bcount = bcount + SPAWNFLAG_SUPERSPIKE;
	}
};

