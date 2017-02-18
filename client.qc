void() set_suicide_frame;
void() player_pain;
void() PlayerDie;
void() JumpFrame1;
void() Land1;
void() Panic1;
void() player_stand1;
void(vector org) spawn_tfog;
void(vector org, entity death_owner) spawn_tdeath;
void() info_intermission = 
{
};

void() SetChangeParms = 
{
	self.items = self.items - (self.items & (IT_KEY1 | IT_KEY2));
	if (self.health > 100)
	{
		self.health = 100;
	}
	if (self.health < 50)
	{
		self.health = 50;
	}
	parm1 = self.items;
	parm2 = self.health;
	if (self.ammo_shells2 < 25)
	{
		parm4 = 25;
	}
	else
	{
		parm4 = self.ammo_shells2;
	}
	parm5 = self.ammo_nails2;
	parm6 = self.ammo_rockets2;
	parm7 = self.ammo_cells2;
	parm8 = self.weapon;
	parm9 = self.automount;
};

void() SetNewParms = 
{
	parm1 = IT_44;
	parm2 = 100;
	parm3 = MSG_BROADCAST;
	parm4 = MSG_BROADCAST;
	parm5 = MSG_BROADCAST;
	parm6 = MSG_BROADCAST;
	parm6 = MSG_BROADCAST;
	parm8 = WEAPON_SHOTGUN;
	parm9 = WEAPON_SHOTGUN;
};

void() DecodeLevelParms = 
{
	if (serverflags)
	{
		if (world.model == "maps/start.bsp")
		{
			SetNewParms();
		}
	}
	self.items = parm1;
	self.health = parm2;
	self.ammo_shells2 = parm4;
	self.ammo_nails2 = parm5;
	self.ammo_rockets2 = parm6;
	self.ammo_cells2 = parm7;
	self.weapon = IT_44;
	self.automount = parm9;
};

entity() FindIntermission = 
{
	local entity spot;
	local float cyc;
	spot = find(world, classname, "info_intermission");
	if (spot)
	{
		cyc = random() * WEAPON_SPIKES;
		while (cyc > WEAPON_SHOTGUN)
		{
			spot = find(spot, classname, "info_intermission");
			if (!spot)
			{
				spot = find(spot, classname, "info_intermission");
			}
			cyc = cyc - WEAPON_SHOTGUN;
		}
		return spot;
	}
	spot = find(world, classname, "info_player_start");
	if (spot)
	{
		return spot;
	}
	spot = find(world, classname, "testplayerstart");
	if (spot)
	{
		return spot;
	}
	objerror("FindIntermission: no spot");
};

void() GotoNextMap = 
{
	if (cvar("samelevel"))
	{
		changelevel(mapname);
	}
	else
	{
		if (!CheckStartDemos())
		{
			changelevel(nextmap);
		}
	}
};

void() ExitIntermission = 
{
	if (deathmatch)
	{
		GotoNextMap();
		return;
	}
	intermission_exittime = time + WEAPON_SHOTGUN;
	intermission_running = intermission_running + WEAPON_SHOTGUN;
	if (intermission_running == WEAPON_ROCKET)
	{
		if (world.model == "maps/e1m7.bsp")
		{
			WriteByte(MSG_ALL, SVC_CDTRACK);
			WriteByte(MSG_ALL, WEAPON_ROCKET);
			WriteByte(MSG_ALL, AS_MELEE);
			if (!cvar("registered"))
			{
				WriteByte(MSG_ALL, SVC_FINALE);
				WriteString(MSG_ALL, "As the corpse of the monstrous entity\nChthon sinks back into the lava whence\nit rose, you grip the Rune of Earth\nMagic tightly. Now that you have\nconquered the Dimension of the Doomed,\nrealm of Earth Magic, you are ready to\ncomplete your task in the other three\nhaunted lands of Quake. Or are you? If\nyou don't register Quake, you'll never\nknow what awaits you in the Realm of\nBlack Magic, the Netherworld, and the\nElder World!");
			}
			else
			{
				WriteByte(MSG_ALL, SVC_FINALE);
				WriteString(MSG_ALL, "As the corpse of the monstrous entity\nChthon sinks back into the lava whence\nit rose, you grip the Rune of Earth\nMagic tightly. Now that you have\nconquered the Dimension of the Doomed,\nrealm of Earth Magic, you are ready to\ncomplete your task. A Rune of magic\npower lies at the end of each haunted\nland of Quake. Go forth, seek the\ntotality of the four Runes!");
			}
			return;
		}
		else
		{
			if (world.model == "maps/e2m6.bsp")
			{
				WriteByte(MSG_ALL, SVC_CDTRACK);
				WriteByte(MSG_ALL, WEAPON_ROCKET);
				WriteByte(MSG_ALL, AS_MELEE);
				WriteByte(MSG_ALL, SVC_FINALE);
				WriteString(MSG_ALL, "The Rune of Black Magic throbs evilly in\nyour hand and whispers dark thoughts\ninto your brain. You learn the inmost\nlore of the Hell-Mother; Shub-Niggurath!\nYou now know that she is behind all the\nterrible plotting which has led to so\nmuch death and horror. But she is not\ninviolate! Armed with this Rune, you\nrealize that once all four Runes are\ncombined, the gate to Shub-Niggurath's\nPit will open, and you can face the\nWitch-Goddess herself in her frightful\notherworld cathedral.");
				return;
			}
			else
			{
				if (world.model == "maps/e3m6.bsp")
				{
					WriteByte(MSG_ALL, SVC_CDTRACK);
					WriteByte(MSG_ALL, WEAPON_ROCKET);
					WriteByte(MSG_ALL, AS_MELEE);
					WriteByte(MSG_ALL, SVC_FINALE);
					WriteString(MSG_ALL, "The charred viscera of diabolic horrors\nbubble viscously as you seize the Rune\nof Hell Magic. Its heat scorches your\nhand, and its terrible secrets blight\nyour mind. Gathering the shreds of your\ncourage, you shake the devil's shackles\nfrom your soul, and become ever more\nhard and determined to destroy the\nhideous creatures whose mere existence\nthreatens the souls and psyches of all\nthe population of Earth.");
					return;
				}
				else
				{
					if (world.model == "maps/e4m7.bsp")
					{
						WriteByte(MSG_ALL, SVC_CDTRACK);
						WriteByte(MSG_ALL, WEAPON_ROCKET);
						WriteByte(MSG_ALL, AS_MELEE);
						WriteByte(MSG_ALL, SVC_FINALE);
						WriteString(MSG_ALL, "Despite the awful might of the Elder\nWorld, you have achieved the Rune of\nElder Magic, capstone of all types of\narcane wisdom. Beyond good and evil,\nbeyond life and death, the Rune\npulsates, heavy with import. Patient and\npotent, the Elder Being Shub-Niggurath\nweaves her dire plans to clear off all\nlife from the Earth, and bring her own\nfoul offspring to our world! For all the\ndwellers in these nightmare dimensions\nare her descendants! Once all Runes of\nmagic power are united, the energy\nbehind them will blast open the Gateway\nto Shub-Niggurath, and you can travel\nthere to foil the Hell-Mother's plots\nin person.");
						return;
					}
				}
			}
		}
		GotoNextMap();
	}
	if (intermission_running == AS_MELEE)
	{
		if (!cvar("registered"))
		{
			WriteByte(MSG_ALL, SVC_SELLSCREEN);
			return;
		}
		if ((serverflags & 15) == 15)
		{
			WriteByte(MSG_ALL, SVC_FINALE);
			WriteString(MSG_ALL, "Now, you have all four Runes. You sense\ntremendous invisible forces moving to\nunseal ancient barriers. Shub-Niggurath\nhad hoped to use the Runes Herself to\nclear off the Earth, but now instead,\nyou will use them to enter her home and\nconfront her as an avatar of avenging\nEarth-life. If you defeat her, you will\nbe remembered forever as the savior of\nthe planet. If she conquers, it will be\nas if you had never been born.");
			return;
		}
	}
	GotoNextMap();
};

void() IntermissionThink = 
{
	if (time < intermission_exittime)
	{
		return;
	}
	if (!(self.button0) && !(self.button1) && !(self.button2))
	{
		return;
	}
	ExitIntermission();
};

void() execute_changelevel = 
{
	local entity pos;
	intermission_running = WEAPON_SHOTGUN;
	if (deathmatch)
	{
		intermission_exittime = time + SVC_SETVIEWPORT;
	}
	else
	{
		intermission_exittime = time + WEAPON_ROCKET;
	}
	WriteByte(MSG_ALL, SVC_CDTRACK);
	WriteByte(MSG_ALL, AS_MELEE);
	WriteByte(MSG_ALL, AS_MELEE);
	pos = FindIntermission();
	other = find(world, classname, "player");
	while (other != world)
	{
		stuffcmd(other, "v_cshift 0 0 0 0\n");
		other.view_ofs = VEC_ORIGIN;
		other.angles = other.v_angle = pos.mangle;
		other.fixangle = 1;
		other.nextthink = time + 0.5;
		other.takedamage = DAMAGE_NO;
		other.solid = SOLID_NOT;
		other.movetype = MOVETYPE_NONE;
		other.modelindex = MSG_BROADCAST;
		setorigin(other, pos.origin);
		other = find(other, classname, "player");
	}
	WriteByte(MSG_ALL, SVC_INTERMISSION);
};

void() changelevel_touch = 
{
	local entity pos;
	if (other.classname != "player")
	{
		return;
	}
	if (other.probe_active == WEAPON_SHOTGUN)
	{
		return;
	}
	if (cvar("noexit"))
	{
		T_Damage(other, self, self, 50000);
		return;
	}
	if (coop || deathmatch)
	{
		bprint(other.netname);
		bprint(" выходит с уровня\n");
	}
	nextmap = self.map;
	SUB_UseTargets();
	if (self.spawnflags & WEAPON_SHOTGUN && deathmatch == MSG_BROADCAST)
	{
		GotoNextMap();
		return;
	}
	self.touch = SUB_Null;
	self.think = execute_changelevel;
	self.nextthink = time + 0.1;
};

void() trigger_changelevel = 
{
	if (!(self.map))
	{
		objerror("changelevel trigger doesn't have map");
	}
	InitTrigger();
	self.touch = changelevel_touch;
};

void() trigger_cutscene = 
{
	self.map = "start";
	setmodel(self, "progs/null.spr");
	setsize(self, '-30 -30 -10', '30 30 10');
	self.solid = SOLID_TRIGGER;
	self.movetype = MOVETYPE_STEP;
	self.touch = changelevel_touch;
};

void() respawn = 
{
	if (coop)
	{
		CopyToBodyQue(self);
		setspawnparms(self);
		PutClientInServer();
	}
	else
	{
		if (deathmatch)
		{
			CopyToBodyQue(self);
			SetNewParms();
			PutClientInServer();
			self.armorvalue = MSG_BROADCAST;
			self.util = MSG_BROADCAST;
			self.tools = self.tools - (self.tools & (UT_CHUTE | UT_HOVER | UT_PROBE | UT_SCUBA | UT_MINISUB | UT_BIGASSGUN));
		}
		else
		{
			localcmd("restart\n");
		}
	}
};

void() ClientKill = 
{
	bprint(self.netname);
	bprint(" прощается с жестоким миром\n");
	set_suicide_frame();
	self.modelindex = modelindex_player;
	self.frags = self.frags - WEAPON_ROCKET;
	respawn();
};

float(vector v) CheckSpawnPoint = 
{
	return FALSE;
};

entity() SelectSpawnPoint = 
{
	local entity spot;
	spot = find(world, classname, "testplayerstart");
	if (spot)
	{
		return spot;
	}
	if (coop)
	{
		lastspawn = find(lastspawn, classname, "info_player_coop");
		if (lastspawn == world)
		{
			lastspawn = find(lastspawn, classname, "info_player_start");
		}
		if (lastspawn != world)
		{
			return lastspawn;
		}
	}
	else
	{
		if (deathmatch)
		{
			lastspawn = find(lastspawn, classname, "info_player_deathmatch");
			if (lastspawn == world)
			{
				lastspawn = find(lastspawn, classname, "info_player_deathmatch");
			}
			if (lastspawn != world)
			{
				return lastspawn;
			}
		}
	}
	if (serverflags)
	{
		spot = find(world, classname, "info_player_start2");
		if (spot)
		{
			return spot;
		}
	}
	spot = find(world, classname, "info_player_start");
	if (!spot)
	{
		error("PutClientInServer: no info_player_start on level");
	}
	return spot;
};

void() PutClientInServer = 
{
	local entity spot;
	self.classname = "player";
	self.health = 100;
	self.takedamage = DAMAGE_AIM;
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_WALK;
	self.touch = player_touch;
	self.show_hostile = MSG_BROADCAST;
	self.max_health = 100;
	self.flags = FL_CLIENT;
	self.air_finished = time + 12;
	self.dmg = WEAPON_ROCKET;
	self.effects = MSG_BROADCAST;
	self.weaponframe = MSG_BROADCAST;
	self.tube_wing = MSG_BROADCAST;
	self.atomic_intensity = MSG_BROADCAST;
	self.count = MSG_BROADCAST;
	self.barrel2 = MSG_BROADCAST;
	self.burning = MSG_BROADCAST;
	self.extinguished = MSG_BROADCAST;
	self.hover_active = MSG_BROADCAST;
	self.aqua_sound = time + 9999999;
	self.aquamon = MSG_BROADCAST;
	self.probe_active = MSG_BROADCAST;
	self.count_shot_idle = 40;
	stuffcmd(self, "fov 90\n");
	if (!deathmatch && !coop)
	{
		fadein();
	}
	DecodeLevelParms();
	W_SetCurrentAmmo();
	self.items = self.items - (self.items & (IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3));
	self.attack_finished = time;
	self.th_pain = player_pain;
	self.th_die = PlayerDie;
	self.deadflag = DEAD_NO;
	self.pausetime = MSG_BROADCAST;
	spot = SelectSpawnPoint();
	self.origin = spot.origin + '0 0 1';
	self.angles = spot.angles;
	self.fixangle = 1;
	setmodel(self, "progs/d_bag.mdl");
	modelindex_bag = self.modelindex;
	setmodel(self, "progs/d_hover.mdl");
	modelindex_hover = self.modelindex;
	setmodel(self, "progs/d_scuba.mdl");
	modelindex_scuba = self.modelindex;
	setmodel(self, "progs/player.mdl");
	modelindex_player = self.modelindex;
	setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
	self.view_ofs = '0 0 22';
	player_stand1();
	if (deathmatch || coop)
	{
		makevectors(self.angles);
		spawn_tfog(self.origin + v_forward * 20);
	}
	spawn_tdeath(self.origin, self);
	localcmd("sv_maxspeed 600\n");
};

void() info_player_start = 
{
};

void() info_player_start2 = 
{
};

void() testplayerstart = 
{
};

void() info_player_deathmatch = 
{
};

void() info_player_coop = 
{
};

void(entity c) PrintClientScore = 
{
	if (c.frags > -10 && c.frags < MSG_BROADCAST)
	{
		bprint(" ");
	}
	else
	{
		if (c.frags >= MSG_BROADCAST)
		{
			if (c.frags < 100)
			{
				bprint(" ");
			}
			if (c.frags < SVC_SETVIEWANGLES)
			{
				bprint(" ");
			}
		}
	}
	bprint(ftos(c.frags));
	bprint(" ");
	bprint(c.netname);
	bprint("\n");
};

void() DumpScore = 
{
	local entity e;
	local entity sort;
	local entity walk;
	if (world.chain)
	{
		error("DumpScore: world.chain is set");
	}
	e = find(world, classname, "player");
	sort = world;
	while (e)
	{
		if (!sort)
		{
			sort = e;
			e.chain = world;
		}
		else
		{
			if (e.frags > sort.frags)
			{
				e.chain = sort;
				sort = e;
			}
			else
			{
				walk = sort;
				do
				{
					if (!(walk.chain))
					{
						e.chain = world;
						walk.chain = e;
					}
					else
					{
						if (walk.chain.frags < e.frags)
						{
							e.chain = walk.chain;
							walk.chain = e;
						}
						else
						{
							walk = walk.chain;
						}
					}
				} while (walk.chain != e);
			}
		}
		e = find(e, classname, "player");
	}
	bprint("\n");
	while (sort)
	{
		PrintClientScore(sort);
		sort = sort.chain;
	}
	bprint("\n");
};

void() NextLevel = 
{
	local entity o;
	o = find(world, classname, "trigger_changelevel");
	if (!o || mapname == "start")
	{
		o = spawn();
		o.map = mapname;
	}
	nextmap = o.map;
	if (o.nextthink < time)
	{
		o.think = execute_changelevel;
		o.nextthink = time + 0.1;
	}
};

void() CheckRules = 
{
	local float timelimit;
	local float fraglimit;
	if (gameover)
	{
		return;
	}
	timelimit = cvar("timelimit") * 60;
	fraglimit = cvar("fraglimit");
	if (timelimit && time >= timelimit)
	{
		NextLevel();
		return;
	}
	if (fraglimit && self.frags >= fraglimit)
	{
		NextLevel();
		return;
	}
};

void() PlayerDeathThink = 
{
	local entity old_self;
	local float forward;
	if (self.flags & FL_ONGROUND)
	{
		forward = vlen(self.velocity);
		forward = forward - 20;
		if (forward <= MSG_BROADCAST)
		{
			self.velocity = VEC_ORIGIN;
		}
		else
		{
			self.velocity = forward * normalize(self.velocity);
		}
	}
	if (self.deadflag == DEAD_DEAD)
	{
		if (self.button2 || self.button1 || self.button0)
		{
			return;
		}
		self.deadflag = DEAD_RESPAWNABLE;
		return;
	}
	if (!(self.button2) && !(self.button1) && !(self.button0))
	{
		return;
	}
	self.button0 = MSG_BROADCAST;
	self.button1 = MSG_BROADCAST;
	self.button2 = MSG_BROADCAST;
	respawn();
};

void() PlayerJump = 
{
	local vector start;
	local vector end;
	if (self.jump_release > time)
	{
		return;
	}
	if (self.probe_active == WEAPON_SHOTGUN)
	{
		return;
	}
	if (self.flags & FL_WATERJUMP)
	{
		return;
	}
	if (self.waterlevel >= WEAPON_ROCKET)
	{
		if (self.watertype == CONTENT_WATER)
		{
			if (self.tools == (self.tools | UT_SCUBA))
			{
				self.velocity_z = 150;
			}
			else
			{
				self.velocity_z = 100;
			}
		}
		else
		{
			if (self.watertype == CONTENT_SLIME)
			{
				self.velocity_z = 80;
			}
			else
			{
				self.velocity_z = 50;
			}
		}
		if (self.swim_flag < time)
		{
			self.swim_flag = time + WEAPON_SHOTGUN;
			if (self.tools == (self.tools | UT_MINISUB))
			{
				return;
			}
			if (random() < 0.5)
			{
				sound(self, CHAN_BODY, "misc/water1.wav", WEAPON_SHOTGUN, ATTN_NORM);
			}
			else
			{
				sound(self, CHAN_BODY, "misc/water2.wav", WEAPON_SHOTGUN, ATTN_NORM);
			}
		}
		return;
	}
	if (!(self.flags & FL_ONGROUND))
	{
		if (self.chute_active == MSG_BROADCAST && !(self.flags & FL_INWATER))
		{
			if (self.hover_active == WEAPON_SHOTGUN)
			{
				self.velocity = v_forward * 800;
				self.jump_release = time + WEAPON_SHOTGUN;
				particle(self.origin - '0 0 24', v_forward * -200, 42, SVC_SETVIEWANGLES);
				sound(self, CHAN_BODY, "utils/hovrboot.wav", WEAPON_SHOTGUN, ATTN_NORM);
			}
			else
			{
				if (self.tools == (self.tools | UT_CHUTE) && self.deploy_wait < time && (self.flags & FL_JUMPRELEASED))
				{
					if (self.velocity_z > -300)
					{
						return;
					}
					PullCord();
					self.jump_release = time + 0.2;
				}
			}
		}
		return;
	}
	if (!(self.flags & FL_JUMPRELEASED))
	{
		return;
	}
	self.flags = self.flags - FL_ONGROUND;
	self.flags = self.flags - (self.flags & FL_JUMPRELEASED);
	self.button2 = MSG_BROADCAST;
	if (self.hover_active == WEAPON_SHOTGUN)
	{
		sound(self, CHAN_BODY, "utils/hovrjmp8.wav", WEAPON_SHOTGUN, ATTN_NORM);
		self.velocity_z = self.velocity_z + 500;
	}
	else
	{
		sound(self, CHAN_BODY, "player/plyrjmp8.wav", WEAPON_SHOTGUN, ATTN_NORM);
		self.velocity_z = self.velocity_z + 270;
	}
	if (self.attack_finished < time)
	{
		JumpFrame1();
	}
	self.jump_release = time + 0.5;
	self.deploy_wait = time + 0.8;
};

void() BreatheOut = 
{
	local float x;
	if (self.probe_active == WEAPON_SHOTGUN)
	{
		return;
	}
	x = WEAPON_SHOTGUN;
	if (random() < 0.5)
	{
		x = CONTENT_EMPTY;
	}
	make_bub(self.origin + v_forward * random() * 15 + v_up * 24 + v_right * random() * 15 * x);
	make_bub(self.origin + v_forward * random() * 15 + v_up * 25 + v_right * random() * 15 * x);
	make_bub(self.origin + v_forward * random() * 15 + v_up * 26 + v_right * random() * 15 * x);
	make_bub(self.origin + v_forward * random() * 15 + v_up * SVC_KILLEDMONSTER + v_right * random() * 15 * x);
};

void() WaterMove = 
{
	if (self.movetype == MOVETYPE_NOCLIP)
	{
		return;
	}
	if (self.health < WEAPON_SHOTGUN)
	{
		return;
	}
	if (self.waterlevel != AS_MELEE)
	{
		if (self.classname != "cbot")
		{
			if (self.tools != (self.tools | UT_MINISUB) && self.tools != (self.tools | UT_SCUBA) && self.armorvalue <= MSG_BROADCAST)
			{
				if (self.air_finished < time)
				{
					sound(self, CHAN_BODY, "player/gasp2.wav", WEAPON_SHOTGUN, ATTN_NORM);
				}
				else
				{
					if (self.air_finished < time + TE_LIGHTNING3)
					{
						sound(self, CHAN_BODY, "player/gasp1.wav", WEAPON_SHOTGUN, ATTN_NORM);
					}
				}
				self.air_finished = time + 12;
				self.dmg = WEAPON_ROCKET;
			}
			else
			{
				self.air_finished = time + 12;
			}
		}
	}
	else
	{
		if (self.air_finished < time)
		{
			if (self.pain_finished < time)
			{
				if (self.tools == (self.tools | UT_MINISUB))
				{
					self.pain_finished = time + 12;
					return;
				}
				else
				{
					if (self.tools == (self.tools | UT_SCUBA) && self.armorvalue > MSG_BROADCAST)
					{
						BreatheOut();
						sound(self, CHAN_BODY, "damage/scuba.wav", WEAPON_SHOTGUN, ATTN_NORM);
						if (self.deploy_wait < time)
						{
							self.armorvalue = self.armorvalue - WEAPON_SHOTGUN;
							self.deploy_wait = time + SVC_SETVIEWANGLES;
							if (self.armorvalue == MSG_BROADCAST)
							{
								self.tools = self.tools - (self.tools & UT_SCUBA);
							}
						}
						self.pain_finished = time + SVC_SETVIEWPORT;
					}
					else
					{
						self.dmg = self.dmg + WEAPON_ROCKET;
						if (self.dmg > 15)
						{
							self.dmg = SVC_SETVIEWANGLES;
						}
						T_Damage(self, world, world, self.dmg);
						self.pain_finished = time + WEAPON_SHOTGUN;
					}
				}
			}
		}
	}
	if (!(self.waterlevel))
	{
		if (self.flags & FL_INWATER)
		{
			self.flags = self.flags - FL_INWATER;
			self.aqua_sound = time + 100000000;
			self.aquamon = MSG_BROADCAST;
			self.deploy_wait = time + WEAPON_SHOTGUN;
			stuffcmd(self, "cl_forwardspeed 360\n");
			self.cl_forwardspeed = CHT_NORMSPEED;
			if (self.modelindex != modelindex_bag)
			{
				self.modelindex = modelindex_player;
			}
			sound(self, CHAN_VOICE, "misc/outwater.wav", WEAPON_SHOTGUN, ATTN_NORM);
			if (self.tools == (self.tools | UT_MINISUB))
			{
				exit_vehicle();
			}
		}
		return;
	}
	if (self.watertype == CONTENT_LAVA)
	{
		if (self.dmgtime < time)
		{
			self.dmgtime = time + 0.2;
			T_Damage(self, world, world, SVC_SETVIEWANGLES * self.waterlevel);
		}
	}
	else
	{
		if (self.watertype == CONTENT_SLIME)
		{
			if (self.dmgtime < time && self.radsuit_finished < time)
			{
				self.dmgtime = time + 0.6;
				T_Damage(self, world, world, WEAPON_SPIKES * self.waterlevel);
			}
		}
	}
	if (!(self.flags & FL_INWATER))
	{
		if (self.hover_active == WEAPON_SHOTGUN)
		{
			self.velocity_z = 60;
			if (self.chute_active == WEAPON_SHOTGUN)
			{
				self.chute_active = MSG_BROADCAST;
			}
			return;
		}
		if (self.watertype == CONTENT_LAVA)
		{
			sound(self, CHAN_BODY, "player/inlava.wav", WEAPON_SHOTGUN, ATTN_NORM);
		}
		if (self.watertype == CONTENT_WATER)
		{
			sound(self, CHAN_VOICE, "player/inh2o.wav", WEAPON_SHOTGUN, ATTN_NORM);
			WaterSplash(SVC_SETVIEWPORT, self);
		}
		if (self.watertype == CONTENT_SLIME)
		{
			sound(self, CHAN_BODY, "player/slimbrn2.wav", WEAPON_SHOTGUN, ATTN_NORM);
		}
		self.flags = self.flags + FL_INWATER;
		self.dmgtime = MSG_BROADCAST;
		self.chute_active = MSG_BROADCAST;
		if (!(self.button0))
		{
			player_run();
		}
		if (self.tools == (self.tools | UT_SCUBA))
		{
			stuffcmd(self, "cl_forwardspeed 420\n");
			self.cl_forwardspeed = CHT_SCUBASPEED;
		}
		self.tools = self.tools - (self.tools & UT_FALLING);
	}
	if (!(self.flags & FL_WATERJUMP))
	{
		self.velocity = self.velocity - 0.8 * self.waterlevel * frametime * self.velocity;
	}
	if (self.tools == (self.tools | UT_MINISUB))
	{
		if (self.velocity_x || self.velocity_y)
		{
			if (random() < 0.060000)
			{
				make_bub(self.origin + v_forward * -60);
			}
		}
		else
		{
			if (random() < 0.010000)
			{
				make_bub(self.origin + v_forward * -60);
			}
		}
	}
};

void() CheckWaterJump = 
{
	local vector start;
	local vector end;
	makevectors(self.angles);
	start = self.origin;
	start_z = start_z + WEAPON_BIG;
	v_forward_z = MSG_BROADCAST;
	normalize(v_forward);
	end = start + v_forward * 24;
	traceline(start, end, 1, self);
	if (trace_fraction < WEAPON_SHOTGUN)
	{
		start_z = start_z + self.maxs_z - WEAPON_BIG;
		end = start + v_forward * 24;
		self.movedir = trace_plane_normal * -50;
		traceline(start, end, 1, self);
		if (trace_fraction == WEAPON_SHOTGUN)
		{
			self.flags = self.flags | FL_WATERJUMP;
			self.velocity_z = 225;
			self.flags = self.flags - (self.flags & FL_JUMPRELEASED);
			self.teleport_time = time + WEAPON_ROCKET;
			return;
		}
	}
};

void() PlayerPreThink = 
{
	local float mspeed;
	local float aspeed;
	local float r;
	if (intermission_running)
	{
		IntermissionThink();
		return;
	}
	if (self.view_ofs == VEC_ORIGIN)
	{
		return;
	}
	makevectors(self.v_angle);
	CheckRules();
	WaterMove();
	if (self.waterlevel == WEAPON_ROCKET)
	{
		CheckWaterJump();
		if (self.aquamon == MSG_BROADCAST)
		{
			self.aqua_sound = time;
		}
	}
	if (self.deadflag >= DEAD_DEAD)
	{
		PlayerDeathThink();
		return;
	}
	if (self.deadflag == DEAD_DYING)
	{
		return;
	}
	if (self.button2)
	{
		PlayerJump();
	}
	else
	{
		self.flags = self.flags | FL_JUMPRELEASED;
	}
	if (time < self.pausetime)
	{
		self.velocity = VEC_ORIGIN;
	}
	if (self.vars_flag == MSG_BROADCAST)
	{
		NormalVars();
	}
	if (self.probe_active == WEAPON_SHOTGUN)
	{
		probe_physics();
	}
};

void() PlayerPostThink = 
{
	local float mspeed;
	local float aspeed;
	local float r;
	local float amount;
	local vector path;
	if (deathmatch && cvar("temp1") == WEAPON_SHOTGUN)
	{
		self.cheatcheck = self.cheatcheck + WEAPON_SHOTGUN;
		if (self.cheatcheck >= SVC_SETVIEWPORT)
		{
			self.cheatcheck = MSG_BROADCAST;
			preventcheat();
		}
	}
	if (self.view_ofs == VEC_ORIGIN)
	{
		return;
	}
	if (self.deadflag)
	{
		return;
	}
	W_WeaponFrame();
	if (self.jump_flag < -300 && (self.flags & FL_ONGROUND) && self.health > MSG_BROADCAST)
	{
		if (self.watertype == CONTENT_WATER)
		{
			sound(self, CHAN_BODY, "player/h2ojump.wav", WEAPON_SHOTGUN, ATTN_NORM);
		}
		else
		{
			if (self.jump_flag < -650)
			{
				if (self.hover_active == WEAPON_SHOTGUN)
				{
					sound(self, CHAN_BODY, "utils/hovrjmp8.wav", WEAPON_SHOTGUN, ATTN_NORM);
					self.tools = self.tools - (self.tools & UT_FALLING);
					player_run();
				}
				else
				{
					amount = self.jump_flag * self.jump_flag / 11000;
					if (deathmatch)
					{
						T_Damage(self, world, world, amount * WEAPON_ROCKET);
					}
					else
					{
						T_Damage(self, world, world, amount);
					}
					sound(self, CHAN_VOICE, "player/land2.wav", WEAPON_SHOTGUN, ATTN_NORM);
					self.deathtype = "falling";
					self.tools = self.tools - (self.tools & UT_FALLING);
					if (self.health > MSG_BROADCAST)
					{
						Land1();
					}
				}
			}
			else
			{
				if (self.hover_active == WEAPON_SHOTGUN)
				{
					sound(self, CHAN_BODY, "utils/hovrjmp8.wav", WEAPON_SHOTGUN, ATTN_NORM);
					self.tools = self.tools - (self.tools & UT_FALLING);
				}
				else
				{
					sound(self, CHAN_VOICE, "player/land.wav", WEAPON_SHOTGUN, ATTN_NORM);
					self.tools = self.tools - (self.tools & UT_FALLING);
				}
				player_run();
			}
		}
		self.jump_flag = MSG_BROADCAST;
		if (self.hover_active == WEAPON_SHOTGUN)
		{
			self.velocity_z = self.velocity_z + 200;
		}
	}
	if (!(self.flags & FL_ONGROUND))
	{
		self.jump_flag = self.velocity_z;
	}
	if (self.velocity_z < -300)
	{
		if (!(self.tools & UT_FALLING) && !(self.flags & FL_INWATER))
		{
			if (self.hover_active != WEAPON_SHOTGUN)
			{
				self.tools = self.tools + UT_FALLING;
				Panic1();
			}
		}
	}
	if (self.tools == (self.tools | UT_SCUBA) || self.tools == (self.tools | UT_MINISUB))
	{
		if (!(self.flags & FL_INWATER))
		{
			return;
		}
		if (self.waterlevel > WEAPON_ROCKET)
		{
			if (self.modelindex != modelindex_scuba && self.tools != (self.tools | UT_MINISUB))
			{
				if (self.tools != (self.tools | UT_BIGASSGUN))
				{
					self.modelindex = modelindex_scuba;
				}
			}
			path = aim(self, WEAPON_SHOTGUN);
			self.angles = vectoangles(path);
		}
	}
	if (self.aqua_sound < time && self.hover_active != WEAPON_SHOTGUN && self.tools != (self.tools | UT_MINISUB))
	{
		sound(self, CHAN_VOICE, "ambience/subaqua.wav", WEAPON_SHOTGUN, ATTN_NORM);
		self.aquamon = WEAPON_SHOTGUN;
		self.aqua_sound = time + SVC_SETVIEWPORT;
	}
};

void() ClientConnect = 
{
	bprint(self.netname);
	bprint(" входит в игру\n");
	if (intermission_running)
	{
		ExitIntermission();
	}
};

void() ClientDisconnect = 
{
	if (gameover)
	{
		return;
	}
	if (self.tools == (self.tools | UT_MINISUB))
	{
		exit_vehicle();
	}
	bprint(self.netname);
	bprint(" свалил и унес с собой ");
	bprint(ftos(self.frags));
	bprint(" очков\n");
	sound(self, CHAN_BODY, "player/tornoff2.wav", WEAPON_SHOTGUN, ATTN_NONE);
	set_suicide_frame();
};

void(entity targ, entity attacker) ClientObituary = 
{
	local float rnum;
	local string deathstring;
	local string deathstring2;
	rnum = random();
	if (targ.classname == "player")
	{
		if (attacker.classname == "teledeath")
		{
			bprint(targ.netname);
			bprint(" телефрагнут ");
			bprint(attacker.owner.netname);
			bprint("\n");
			attacker.owner.frags = attacker.owner.frags + WEAPON_SHOTGUN;
			return;
		}
		if (attacker.classname == "teledeath2")
		{
			bprint("Аццкие силы отбивают телефраг ");
			bprint(targ.netname);
			bprint("\n");
			targ.frags = targ.frags - WEAPON_SHOTGUN;
			return;
		}
		if (attacker.classname == "player")
		{
			if (targ == attacker)
			{
				attacker.frags = attacker.frags - WEAPON_SHOTGUN;
				bprint(targ.netname);
				if (targ.weapon == JUMP && targ.waterlevel > WEAPON_SHOTGUN)
				{
					bprint(" разрядился в воду.\n");
					return;
				}
				if (targ.weapon == OTFATTACK)
				{
					bprint(" нужен предохранитель\n");
				}
				else
				{
					if (rnum)
					{
						bprint(" просто выжрал говнеца\n");
					}
					else
					{
						bprint(" проверил, заряжен ли его ствол\n");
					}
				}
				return;
			}
			else
			{
				attacker.frags = attacker.frags + WEAPON_SHOTGUN;
				rnum = attacker.weapon;
				if (attacker.tools == (attacker.tools | UT_BIGASSGUN))
				{
					deathstring = " распылен частицами, пущенными ";
					deathstring2 = "\n";
				}
				else
				{
					if (attacker.tools == (attacker.tools | UT_MINISUB))
					{
						deathstring = " отведал торпедушки  ";
						deathstring2 = "\n";
					}
					else
					{
						if (rnum == IT_44)
						{
							deathstring = " заклеван орлом ";
							deathstring2 = "\n";
						}
						else
						{
							if (rnum == IT_UZI)
							{
								deathstring = " узибагоился благодаря узи ";
								deathstring2 = "\n";
							}
							else
							{
								if (rnum == IT_SHOT)
								{
									deathstring = " прикурил от огонька ";
									deathstring2 = "\n";
								}
								else
								{
									if (rnum == IT_SHOT2)
									{
										deathstring = " получил раз-вертку от ";
										deathstring2 = "\n";
									}
									else
									{
										if (rnum == IT_ROCKET)
										{
											deathstring = " покрылся корочкой из-за ";
											deathstring2 = "\n";
											if (targ.health < -40)
											{
												deathstring = " не сдержал жало ";
												deathstring2 = "\n";
											}
										}
										else
										{
											if (rnum == IT_MORTER)
											{
												deathstring = " оценил напалм ";
												deathstring2 = "\n";
												if (targ.health < -40)
												{
													deathstring = " не понравился напалм ";
													deathstring2 = "\n";
												}
											}
											else
											{
												if (rnum == IT_MINI)
												{
													deathstring = " немного потрепало миниганом ";
													deathstring2 = "\n";
												}
												else
												{
													if (rnum == IT_PUNISHER)
													{
														deathstring = " принял кару от ";
														deathstring2 = "\n";
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
				bprint(targ.netname);
				bprint(deathstring);
				bprint(attacker.netname);
				//if (deathstring2 != "\n")
				//{
					//bprint("'s");
				//}
				bprint("<");
				bprint(ftos(attacker.health));
				bprint(">");
				bprint(deathstring2);
			}
			return;
		}
		else
		{
			targ.frags = targ.frags - WEAPON_SHOTGUN;
			rnum = targ.watertype;
			bprint(targ.netname);
			if (rnum == CONTENT_WATER)
			{
				if (random() < 0.5)
				{
					bprint(" ушел на корм рыбам\n");
				}
				else
				{
					bprint(" сделал буль-буль\n");
				}
				return;
			}
			else
			{
				if (rnum == CONTENT_SLIME)
				{
					if (random() < 0.5)
					{
						bprint(" наглотался слизи\n");
					}
					else
					{
						bprint(" влился в слизь\n");
					}
					return;
				}
				else
				{
					if (rnum == CONTENT_LAVA)
					{
						if (targ.health < -15)
						{
							bprint(" спонтанненько сгорел\n");
							return;
						}
						if (random() < 0.5)
						{
							bprint(" превратился в уголек\n");
						}
						else
						{
							bprint(" сходил в гости к Вулкану\n");
						}
						return;
					}
				}
			}
			if (attacker.flags & FL_MONSTER)
			{
				if (attacker.classname == "monster_swat")
				{
					bprint(" узибагоили\n");
				}
				if (attacker.classname == "monster_hanger")
				{
					bprint(" взяли на подвес\n");
				}
				if (attacker.classname == "monster_torcher")
				{
					bprint(" зашел на огонек\n");
				}
				if (attacker.classname == "monster_probe")
				{
					bprint(" отзондировали по самое нехочу\n");
				}
				if (attacker.classname == "monster_banshee")
				{
					bprint(" чересчур суеверен\n");
				}
				if (attacker.classname == "monster_rider")
				{
					bprint(" оседлали\n");
				}
				if (attacker.classname == "monster_riot")
				{
					bprint(" проломили черепушку\n");
				}
				if (attacker.classname == "monster_merc")
				{
					bprint(" поимела наемница\n");
				}
				if (attacker.classname == "cbot")
				{
					if (random() < 0.5)
					{
						bprint(" рискнул пофлиртовать с васкесом\n");
					}
					else
					{
						bprint(" нежно уложен васкесом\n");
					}
				}
				if (attacker.classname == "monster_bara")
				{
					bprint(" сгрызен баракудами\n");
				}
				if (attacker.classname == "monster_blowfish")
				{
					bprint(" подорван иглобрюхом\n");
				}
				if (attacker.classname == "monster_hunter")
				{
					bprint(" явно не любил охоту\n");
				}
				if (attacker.classname == "monster_baboon")
				{
					bprint(" наигрался с обезьянкой\n");
				}
				if (attacker.classname == "monster_frogman")
				{
					bprint(" заколот водолазом\n");
				}
				if (attacker.classname == "monster_bossman")
				{
					bprint(" попытался сломать систему\n");
				}
				if (attacker.classname == "monster_turret")
				{
					bprint(" подпален шефскими турелями\n");
				}
				return;
			}
			if (attacker.classname == "barrel")
			{
				bprint(" долго над полем летал\n");
				return;
			}
			if (attacker.solid == SOLID_BSP && attacker != world)
			{
				bprint(" раздавили, как крысу\n");
				return;
			}
			if (targ.deathtype == "falling")
			{
				targ.deathtype = "";
				bprint(" стал блинчиком\n");
				return;
			}
			if (attacker.classname == "trap_shooter" || attacker.classname == "trap_spikeshooter")
			{
				bprint(" прибит к стене\n");
				return;
			}
			if (attacker.classname == "fireball")
			{
				bprint(" попытался съесть файербол\n");
				return;
			}
			if (attacker.classname == "trigger_changelevel")
			{
				bprint(" -- баба\n");
				return;
			}
			bprint(" сдох\n");
		}
	}
};

