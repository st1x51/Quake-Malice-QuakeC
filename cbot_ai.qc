void() cbt_shot1;
void() cbt_rocketjump1;
void() cbot_ai_stand;
void() cbt_run1;
void() cbt_jump1;
void() cn_wpt = 
{
	if (!(self.speed))
	{
		self.speed = MSG_BROADCAST;
	}
	if (!(self.height))
	{
		self.height = AS_STRAIGHT;
	}
	if (self.angles == VEC_ORIGIN)
	{
		self.angles = '0 360 0';
	}
	if (!(self.button0))
	{
		self.button0 = MSG_BROADCAST;
	}
	SetMovedir();
	if (!(self.swim_flag))
	{
		self.swim_flag = 0;
	}
};

void(float slide_amount) cbot_slide = 
{
	local float ofs;
	local entity targ;
	local float targ_dist;
	local vector targ_pitch;
	local vector spot1;
	local vector spot2;
	targ = self.enemy;
	spot1 = self.origin;
	spot2 = targ.origin;
	targ_dist = vlen(spot1 - spot2);
	if (targ_dist < 200)
	{
		if (self.lefty)
		{
			ofs = 90;
		}
		else
		{
			ofs = -90;
		}
	}
	else
	{
		if (self.lefty)
		{
			ofs = random() * 45;
		}
		else
		{
			ofs = random() * -45;
		}
	}
	if (walkmove(self.ideal_yaw + ofs, random() * slide_amount + TE_LIGHTNING3))
	{
		return;
	}
	self.lefty = AS_STRAIGHT - self.lefty;
	walkmove(self.ideal_yaw - ofs, random() * slide_amount + TE_LIGHTNING3);
};

void(float slide_amount) cbot_retreat = 
{
	local float ofs;
	local entity targ;
	local float targ_dist;
	local vector targ_pitch;
	local vector spot1;
	local vector spot2;
	targ = self.enemy;
	spot1 = self.origin;
	spot2 = targ.origin;
	targ_dist = vlen(spot1 - spot2);
	if (self.lefty)
	{
		ofs = -135;
	}
	else
	{
		ofs = 135;
	}
	if (walkmove(self.ideal_yaw + ofs, random() * slide_amount + TE_LIGHTNING3))
	{
		return;
	}
	self.lefty = AS_STRAIGHT - self.lefty;
	walkmove(self.ideal_yaw - ofs, random() * slide_amount + TE_LIGHTNING3);
};

float() cbot_incoming_missile = 
{
	local entity article;
	article = findradius(self.origin, 400);
	while (article)
	{
		if (article.classname == "punisher" || article.classname == "grenade" || article.classname == "stinger")
		{
			if (article.owner != self)
			{
				return 1;
			}
		}
		article = article.chain;
	}
	return 0;
};

float() cbot_check_attack = 
{
	local vector spot1;
	local vector spot2;
	local entity targ;
	local float chance;
	local float r;
	targ = self.enemy;
	spot1 = self.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;
	traceline(spot1, spot2, 0, self);
	if (trace_ent != targ)
	{
		return 0;
	}
	if (trace_inopen && trace_inwater)
	{
		return 0;
	}
	if (time < self.attack_finished)
	{
		return 0;
	}
	r = vlen(spot1 - spot2);
	if (r > 1600)
	{
		return 0;
	}
	if (r < 120)
	{
		chance = 0.7;
	}
	else
	{
		if (r < 500)
		{
			chance = 0.55;
		}
		else
		{
			if (r < 1300)
			{
				chance = 0.3;
			}
			else
			{
				chance = MSG_BROADCAST;
			}
		}
	}
	if (random() < chance)
	{
		return 1;
	}
	return 0;
};

float() cbot_facing_ideal = 
{
	local float delta_yaw;
	local float delta_pitch;
	delta_yaw = anglemod(self.angles_y - self.ideal_yaw);
	delta_pitch = fabs(self.ideal_pitch - self.angles_x);
	if (delta_yaw > 0.5 && delta_yaw < 359.5 || delta_pitch > AS_STRAIGHT)
	{
		return 0;
	}
	return 1;
};
//st1x51: issue void
float() cbot_best_weapon = 
{
	local float it;
	it = self.items;
	if (self.ammo_shells2 >= AS_STRAIGHT && (it & IT_UZI))
	{
		return 4;
	}
	return 128;
};

float() cbot_check_no_ammo = 
{
	if (self.currentammo > MSG_BROADCAST)
	{
		return 1;
	}
	if (self.weapon == IT_NONE)
	{
		return 1;
	}
	self.weapon = IT_UZI;
	return 0;
};

float(entity e_target, entity e_inflictor) cbot_determine_mode = 
{
	if (self.weapon == IT_NONE)
	{
		return WITHDRAW;
	}
	if (self.botmode == SEARCH || self.botmode == OTFATTACK)
	{
		if (e_inflictor)
		{
			if (e_inflictor.classname != "rocket")
			{
				return ATTACK;
			}
		}
		else
		{
			if (random() > 0.2)
			{
				return ATTACK;
			}
		}
	}
	if (self.botmode == SEARCH || self.botmode == OTFATTACK)
	{
		return OTFATTACK;
	}
	return WITHDRAW;
};

void() cbot_fire_weapon = 
{
	if (!cbot_check_no_ammo())
	{
		return;
	}
	self.v_angle = self.angles;
	if (self.weapon == IT_NONE)
	{
		return;
	}
	else
	{
		if (self.weapon == IT_UZI)
		{
			self.v_angle_x = CONTENT_EMPTY * self.v_angle_x;
			cbt_shot1();
			makevectors(self.v_angle);
			W_DeathFire();
		}
	}
};

void() cbot_track_target = 
{
	local vector los;
	local vector los_angles;
	local float o_range;
	local float missile_factor;
	local vector spotty_squid;
	local string st;
	o_range = vlen(self.enemy.origin - self.origin);
	if (self.weapon == IT_UZI || self.weapon == IT_UZI || self.weapon == IT_UZI)
	{
		missile_factor = o_range / (1900 + random() * CHT_HOVERSPEED);
	}
	else
	{
		if (self.weapon == IT_UZI)
		{
			missile_factor = o_range / (1000 + random() * 50);
		}
		else
		{
			missile_factor = MSG_BROADCAST;
		}
	}
	if (o_range > 300)
	{
		spotty_squid = '9 9 8' * (random() - 0.5);
	}
	else
	{
		spotty_squid = VEC_ORIGIN;
	}
	los = self.enemy.origin - self.origin + self.enemy.velocity * missile_factor + spotty_squid;
	los_angles = vectoangles(los);
	self.ideal_yaw = los_angles_y;
	self.ideal_pitch = los_angles_x;
	if (self.ideal_pitch > 180)
	{
		self.ideal_pitch = self.ideal_pitch - 360;
	}
	ChangeYaw();
	ChangePitch();
};

void() cbot_attack = 
{
	if (cbot_incoming_missile())
	{
		if (random() < 0.3)
		{
			cbot_slide(TE_LAVASPLASH);
		}
		else
		{
			cbt_rocketjump1();
		}
	}
	if (visible(self.enemy))
	{
		cbot_track_target();
		self.sighted_time = time;
		self.notarget_flag = MSG_BROADCAST;
		if (cbot_check_attack() || self.botmode == OTFATTACK)
		{
			if (cbot_facing_ideal())
			{
				if (time > self.attack_finished)
				{
					cbot_fire_weapon();
				}
			}
		}
		else
		{
			cbot_track_target();
			if (self.botmode != JUMP)
			{
				cbot_slide(TE_LAVASPLASH);
			}
		}
	}
	else
	{
		if (self.sighted_time < time || self.enemy.health <= MSG_BROADCAST)
		{
			if (self.notarget_flag == SVC_INTERMISSION)
			{
				self.botmode = SEARCH;
				self.enemy = world;
				self.goal_status = MSG_BROADCAST;
				cbot_ai_stand();
			}
			else
			{
				self.notarget_flag = self.notarget_flag + AS_STRAIGHT;
				self.goal_status = CAMPER;
				self.goalentity = self.enemy;
				self.ideal_pitch = MSG_BROADCAST;
				ChangePitch();
				cbt_run1();
			}
		}
	}
};

void() cbot_attack_initial = 
{
	cbot_attack();
};

void() cbot_jump = 
{
	local vector jump_vec;
	local float vel;
	vel = 240 + random() * 25;
	makevectors(self.angles);
	self.velocity_x = v_forward_x * vel;
	self.velocity_y = v_forward_y * vel;
	if (self.flags & FL_ONGROUND)
	{
		self.flags = self.flags - FL_ONGROUND;
		self.velocity_z = vel;
		self.botmode = JUMP;
	}
	self.nextthink = time + 0.3;
	cbt_jump1();
};

void() cbot_watchdog = 
{
	local float dist;
	local vector test_vectors;
	local vector top;
	if (self.origin == self.old_position)
	{
		self.botmode = SEARCH;
		self.enemy = world;
		self.goal_status = MSG_BROADCAST;
		cbot_ai_stand();
		return;
	}
	self.old_position = self.origin;
	dist = vlen(self.origin - self.old_posn);
	if (dist < 25)
	{
		makevectors(self.angles);
		test_vectors = self.origin + (self.maxs_x + OTFATTACK) * v_forward;
		top = self.origin;
		test_vectors_z = test_vectors_z + self.maxs_z;
		top_z = top_z + self.maxs_z;
		traceline(top, test_vectors, 0, self);
		if (trace_fraction < AS_STRAIGHT)
		{
			self.goalentity = world;
			self.goal_status = MSG_BROADCAST;
			self.think = self.th_stand;
		}
		else
		{
			top = self.origin + (self.maxs_x + OTFATTACK) * trace_fraction * v_forward;
			test_vectors = top;
			test_vectors_z = test_vectors_z - IT_SHELLS;
			traceline(top, test_vectors, 1, self);
			if (IT_SHELLS * trace_fraction < self.size_z - WITHDRAW)
			{
				self.goalentity = world;
				self.goal_status = MSG_BROADCAST;
				self.think = self.th_stand;
			}
			else
			{
				cbot_jump();
			}
		}
	}
	self.old_posn = self.origin;
};

float(float itype) cbot_got_item = 
{
	if (itype == SVC_TEMPENTITY)
	{
		return self.pi1;
	}
	if (itype == 22)
	{
		return self.pi2;
	}
	if (itype == 21)
	{
		return self.pi3;
	}
	if (itype == OTFATTACK)
	{
		return self.pi4;
	}
	if (itype == 15)
	{
		return self.pi5;
	}
	if (itype == 14)
	{
		return self.pi6;
	}
	if (itype == 13)
	{
		return self.pi7;
	}
	if (itype == 12)
	{
		return self.pi8;
	}
	if (itype == TE_TELEPORT)
	{
		return self.pi9;
	}
};

entity() cbot_find_nearest_enemy = 
{
	local entity article;
	local entity best_article;
	local float o_range;
	local float best_dist;
	local vector los;
	local vector los_angles;
	best_article = world;
	best_dist = 9999;
	article = find(world, classname, "player");
	while (article != world)
	{
		o_range = vlen(article.origin - self.origin);
		traceline(self.origin, article.origin, 1, self);
		if (trace_fraction == AS_STRAIGHT && o_range <= best_dist && article.health > MSG_BROADCAST && article != self)
		{
			los = article.origin - self.origin;
			los_angles = vectoangles(los);
			if (los_angles_x > 180)
			{
				los_angles_x = los_angles_x - 360;
			}
			if (fabs(los_angles_x) < 54)
			{
				best_article = article;
				best_dist = o_range;
			}
		}
		article = find(article, classname, "player");
	}
	return best_article;
};

entity(float findp, float ignore, float endp) cbot_get_waypoint = 
{
	local float o_range;
	local entity article;
	local float best_dist;
	local entity best_article;
	local float best_items;
	local vector los;
	local vector los_angles;
	best_dist = 9999;
	best_article = world;
	best_items = MSG_BROADCAST;
	article = find(world, classname, "cn_wpt");
	while (article != world)
	{
		if (findp == AS_STRAIGHT && article.items > best_items || (findp == SEARCH && article.items == MSG_BROADCAST) || findp == MSG_BROADCAST)
		{
			o_range = vlen(article.origin - self.origin);
			traceline(self.origin, article.origin, 1, self);
			if (trace_fraction == AS_STRAIGHT && (o_range <= best_dist || article.items > best_items) && !cbot_got_item(article.items) && article != self.goalentity && (ignore == 100 || article.items != ignore) && (article.target != "-" || endp))
			{
				los = article.origin - self.origin;
				los_angles = vectoangles(los);
				if (los_angles_x > 180)
				{
					los_angles_x = los_angles_x - 360;
				}
				if (fabs(los_angles_x) < 54)
				{
					best_article = article;
					best_dist = o_range;
					best_items = article.items;
				}
			}
		}
		article = find(article, classname, "cn_wpt");
	}
	return best_article;
};
//st1x51: another issue
float(entity article) cbot_check_max_ammo = 
{
	if (article.classname == "item_cells" && self.ammo_cells2 == 100)
	{
		return 0;
	}
	return 1;
};

void() cbot_ai_stand = 
{
	local float o_range;
	local entity article;
	local float best_dist;
	local entity best_article;
	local vector camp_origin;
	local float cbot_mode;
	WaterMove();
	if (self.botmode == JUMP && (self.flags & FL_ONGROUND))
	{
		self.botmode = SEARCH;
	}
	if (cbot_incoming_missile())
	{
		if (random() < 0.3)
		{
			cbot_slide(TE_LAVASPLASH);
		}
		else
		{
			cbt_rocketjump1();
		}
	}
	article = cbot_find_nearest_enemy();
	if (article)
	{
		cbot_mode = cbot_determine_mode(article, world);
		if (cbot_mode == ATTACK)
		{
			self.botmode = ATTACK;
			self.enemy = article;
		}
	}
	if (self.botmode == WITHDRAW)
	{
		self.enemy = world;
		self.botmode = SEARCH;
		self.goal_status = MSG_BROADCAST;
	}
	if (self.botmode == SEARCH)
	{
		if (self.goal_status == MSG_BROADCAST)
		{
			best_article = cbot_get_waypoint(MSG_BROADCAST, 100, MSG_BROADCAST);
			if (best_article != world)
			{
				self.goalentity = best_article;
				self.goal_status = AS_STRAIGHT;
				self.think = self.th_run;
				self.nextthink = time + 0.1;
			}
			else
			{
				best_article = cbot_get_waypoint(MSG_BROADCAST, 100, AS_STRAIGHT);
				if (best_article != world)
				{
					best_article = find(world, target, best_article.targetname);
					if (best_article != world)
					{
						self.goalentity = best_article;
						self.goal_status = AS_STRAIGHT;
						self.think = self.th_run;
						self.nextthink = time + 0.1;
						return;
					}
				}
				self.angles_y = 360 * random();
				cbot_jump();
			}
		}
		else
		{
			self.goal_status = SEARCH;
			if (SEARCH)
			{
				self.goal_status = CAMPER;
				self.goalentity = self.origin_save;
				self.think = self.th_run;
				self.nextthink = time + 0.1;
			}
		}
		self.watchdog_time = time + 1.2;
	}
	else
	{
		if (self.botmode == CAMPER)
		{
			if (visible(self.enemy))
			{
				cbot_attack();
			}
			else
			{
				cbt_run1();
			}
		}
		else
		{
			if (self.botmode == ATTACK)
			{
				cbot_attack_initial();
				if (self.warp_factor < time)
				{
					sound(self, CHAN_BODY, "vasquez/sight1.wav", AS_STRAIGHT, ATTN_NORM);
					self.warp_factor = time + TE_LAVASPLASH;
				}
				if (self.enemy.health <= MSG_BROADCAST)
				{
					self.enemy = world;
					self.botmode = SEARCH;
					self.goal_status = MSG_BROADCAST;
					self.angles_x = MSG_BROADCAST;
				}
				if (self.weapon == IT_NONE)
				{
					self.enemy = world;
					self.botmode = WITHDRAW;
					self.goal_status = MSG_BROADCAST;
					self.angles_x = MSG_BROADCAST;
				}
			}
			else
			{
				if (self.botmode == OTFATTACK)
				{
					cbot_attack_initial();
					self.enemy = world;
					self.botmode = SEARCH;
				}
			}
		}
	}
};

void(float dist) cbot_ai_walk = 
{
	local entity trywpt;
	local float o_range;
	local float h_range;
	local vector h1;
	local vector h2;
	local float cont;
	local vector norm_vel;
	local entity other_item;
	local float cbot_mode;
	local entity article;
	local string sf;
	if (cbot_incoming_missile())
	{
		if (random() < 0.3)
		{
			cbot_slide(TE_LAVASPLASH);
		}
		else
		{
			cbt_rocketjump1();
		}
	}
	if (self.botmode == SEARCH)
	{
		if (self.goalentity.swim_flag)
		{
			if (self.watertype == CONTENT_WATER || self.watertype == CONTENT_SLIME)
			{
				self.velocity_z = self.goalentity.origin_z - self.origin_z;
				if (self.velocity_z > MSG_BROADCAST)
				{
					self.velocity_z = self.velocity_z * 3.3;
				}
				self.velocity_y = self.goalentity.origin_y - self.origin_y;
				self.velocity_x = self.goalentity.origin_x - self.origin_x;
				norm_vel = normalize(self.velocity) * 70;
				norm_vel_z = MSG_BROADCAST;
				self.velocity = self.velocity + norm_vel;
			}
		}
		WaterMove();
		if (self.goal_status == AS_STRAIGHT)
		{
			if (self.goalentity.items == MSG_BROADCAST)
			{
				trywpt = cbot_get_waypoint(AS_STRAIGHT, MSG_BROADCAST, MSG_BROADCAST);
				if (trywpt != world)
				{
					self.goalentity = trywpt;
					self.goal_status = AS_STRAIGHT;
					self.think = self.th_run;
					self.nextthink = time + 0.1;
					return;
				}
			}
			else
			{
				trywpt = cbot_get_waypoint(AS_STRAIGHT, MSG_BROADCAST, MSG_BROADCAST);
				if (trywpt != world)
				{
					if (trywpt.items > self.goalentity.items)
					{
						self.goalentity = trywpt;
						self.goal_status = AS_STRAIGHT;
						self.think = self.th_run;
						self.nextthink = time + 0.1;
						return;
					}
				}
			}
			if (self.other_item_time < time)
			{
				if (other_item != world)
				{
					self.other_item_time = time + 0.3;
					self.think = self.th_run;
					self.nextthink = time + 0.1;
					return;
				}
			}
			o_range = vlen(self.origin - self.goalentity.origin);
			h1 = self.origin;
			h1_z = MSG_BROADCAST;
			h2 = self.goalentity.origin;
			h2_z = MSG_BROADCAST;
			h_range = vlen(h1 - h2);
			if (o_range < 70)
			{
				if (h_range < 20)
				{
					if (self.goalentity.jump_flag)
					{
						self.goalentity.jump_flag = self.goalentity.jump_flag - AS_STRAIGHT;
						if (self.flags & FL_ONGROUND)
						{
							self.botmode = JUMP;
							self.flags = self.flags - FL_ONGROUND;
							self.velocity_z = 50;
						}
						return;
					}
					if (self.goalentity.speed > MSG_BROADCAST)
					{
						self.velocity_x = self.goalentity.movedir_x * self.goalentity.speed;
						self.velocity_y = self.goalentity.movedir_y * self.goalentity.speed;
						if (self.flags & FL_ONGROUND)
						{
							self.flags = self.flags - FL_ONGROUND;
							self.velocity_z = self.goalentity.height;
						}
						self.nextthink = time + 0.2;
						cbt_jump1();
					}
					if (self.goal_status == AS_STRAIGHT && self.goalentity.target != "-")
					{
						if (self.goalentity.noise4)
						{
							if (random() > 0.4)
							{
								self.goalentity = find(world, targetname, self.goalentity.noise4);
							}
							else
							{
								self.goalentity = find(world, targetname, self.goalentity.target);
							}
						}
						else
						{
							self.goalentity = find(world, targetname, self.goalentity.target);
						}
					}
					else
					{
						self.goal_status = MSG_BROADCAST;
						self.think = self.th_stand;
					}
				}
			}
		}
		else
		{
			if (self.goal_status == AS_MELEE || self.goal_status == CAMPER)
			{
				if (self.goal_status == AS_MELEE)
				{
					o_range = vlen(self.origin - self.goalentity.origin);
					h1 = self.origin;
					h1_z = MSG_BROADCAST;
					h2 = self.goalentity.origin;
					h2_z = MSG_BROADCAST;
					h_range = vlen(h1 - h2);
					if (o_range < 70)
					{
						if (h_range < 20)
						{
							self.goal_status = SEARCH;
							self.think = self.th_stand;
							remove(self.goalentity);
							return;
						}
					}
				}
				else
				{
					if (self.goal_status == CAMPER)
					{
						o_range = vlen(self.origin - self.origin_save.origin);
						h1 = self.origin;
						h1_z = MSG_BROADCAST;
						h2 = self.origin_save.origin;
						h2_z = MSG_BROADCAST;
						h_range = vlen(h1 - h2);
						if (o_range < 70)
						{
							if (h_range < 20)
							{
								if (self.oldgoalname != "none")
								{
									self.goalentity = find(world, targetname, self.oldgoalname);
									self.goal_status = AS_STRAIGHT;
								}
								else
								{
									self.goal_status = MSG_BROADCAST;
									self.think = self.th_stand;
								}
								remove(self.origin_save);
								self.nextthink = time + 0.1;
								return;
							}
						}
					}
				}
			}
		}
	}
	else
	{
		if (self.botmode == CAMPER)
		{
			if (visible(self.enemy))
			{
				cbot_attack();
			}
			else
			{
				sprint(self.enemy, "No Target\n");
				sound(self, CHAN_WEAPON, "weapons/guncock.wav", AS_STRAIGHT, ATTN_NORM);
			}
			if (o_range < 70)
			{
				if (h_range < 20)
				{
					self.goal_status = MSG_BROADCAST;
					self.think = self.th_stand;
					remove(self.goalentity);
					return;
				}
			}
		}
		else
		{
			if (self.botmode == ATTACK || self.botmode == OTFATTACK || self.botmode == WITHDRAW || self.botmode == JUMP)
			{
				self.think = self.th_stand;
				self.nextthink = time + 0.1;
			}
		}
	}
	self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
	ChangeYaw();
	movetogoal(dist);
	if (self.watchdog_time < time)
	{
		cbot_watchdog();
		self.watchdog_time = time + 0.2;
		article = cbot_find_nearest_enemy();
		if (article)
		{
			cbot_mode = cbot_determine_mode(article, world);
			if (cbot_mode == ATTACK)
			{
				self.botmode = ATTACK;
				self.enemy = article;
			}
		}
	}
	if (self.nextthink < time)
	{
		self.nextthink = time + 0.1;
	}
};

void(float dist) cbot_ai_run = 
{
	cbot_ai_walk(dist);
};

