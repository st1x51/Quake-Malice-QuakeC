void() Keep_cam_chasing_owner;
void() Start_chase_cam = 
{
	local entity chase_cam;
	chase_cam = spawn();
	chase_cam.owner = self;
	chase_cam.owner.speed = chase_cam.owner.speed | CHSCAM_ON;
	chase_cam.solid = SOLID_NOT;
	chase_cam.movetype = MOVETYPE_FLYMISSILE;
	chase_cam.flags = chase_cam.flags | FL_FLY;
	chase_cam.flags = chase_cam.flags | FL_MONSTER;
	chase_cam.angles = self.angles;
	setmodel(chase_cam, "progs/null.spr");
	setsize(chase_cam, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(chase_cam, self.origin + '0 0 32');
	chase_cam.classname = "chase_cam";
	chase_cam.nextthink = time;
	chase_cam.think = Keep_cam_chasing_owner;
	chase_cam.angles_z = MSG_BROADCAST;
	msg_entity = self;
	WriteByte(MSG_ONE, SVC_SETVIEWPORT);
	WriteEntity(MSG_ONE, chase_cam);
	WriteByte(MSG_ONE, SVC_SETVIEWANGLES);
	WriteAngle(MSG_ONE, chase_cam.angles_x);
	WriteAngle(MSG_ONE, chase_cam.angles_y);
	WriteAngle(MSG_ONE, chase_cam.angles_z);
	W_SetCurrentAmmo();
};

void() Remove_chase_cam = 
{
	local entity e;
	if (self.owner.speed & CHSCAM_ON)
	{
		self.owner.speed = self.owner.speed - CHSCAM_ON;
	}
	msg_entity = self.owner;
	WriteByte(MSG_ONE, SVC_SETVIEWPORT);
	WriteEntity(MSG_ONE, self.owner);
	e = self;
	self = self.owner;
	W_SetCurrentAmmo();
	self = e;
	remove(self);
};

void() Keep_cam_chasing_owner = 
{
	local vector spot2;
	local vector dir;
	local float dist;
	self.nextthink = time + 0.1;
	if (!(self.owner.speed & CHSCAM_ON))
	{
		Remove_chase_cam();
		return;
	}
	makevectors(self.owner.v_angle);
	if (self.owner.cam_pos == AS_STRAIGHT)
	{
		spot2 = self.owner.origin - v_forward * 40 + v_right * 12 + '0 0 14';
	}
	else
	{
		if (self.owner.cam_pos == H_MEGA)
		{
			spot2 = self.owner.origin - v_forward * 82 + '0 0 18';
		}
		else
		{
			spot2 = self.owner.origin - v_forward * 100 + '0 0 -10';
		}
	}
	traceline(self.owner.origin, spot2, 1, self.owner);
	spot2 = trace_endpos + v_forward * H_MEGA;
	traceline(spot2, spot2 + '0 0 24', 1, self.owner);
	if (trace_fraction < AS_STRAIGHT)
	{
		spot2 = trace_endpos - '0 0 24';
	}
	traceline(self.origin, spot2, 1, self.owner);
	if (trace_fraction == AS_STRAIGHT)
	{
		dir = normalize(spot2 - self.origin);
		dist = vlen(spot2 - self.origin);
		self.velocity = dir * dist * AS_MELEE;
		if (!infront(self.owner))
		{
			self.velocity = self.velocity * H_MEGA;
		}
	}
	else
	{
		setorigin(self, spot2);
	}
};

void() Toggle_chase_cam = 
{
	if (self.speed & CHSCAM_ON)
	{
		if (self.cam_pos == AS_STRAIGHT)
		{
			self.cam_pos = H_MEGA;
		}
		else
		{
			if (self.cam_pos == H_MEGA)
			{
				self.cam_pos = AS_MELEE;
			}
			else
			{
				self.cam_pos = AS_STRAIGHT;
				self.speed = self.speed - CHSCAM_ON;
				if (self.tools == (self.tools | UT_MINISUB))
				{
					self.weaponmodel = "progs/subpit.mdl";
				}
			}
		}
	}
	else
	{
		self.cam_pos = AS_STRAIGHT;
		Start_chase_cam();
	}
};

