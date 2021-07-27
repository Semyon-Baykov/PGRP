--  _               _            _   ____              _                      _       __  __           _            
-- | |    ___  __ _| | _____  __| | | __ ) _   _      | | ___  ___  ___ _ __ | |__   |  \/  | __ _ ___| |_ ___ _ __ 
-- | |   / _ \/ _` | |/ / _ \/ _` | |  _ \| | | |  _  | |/ _ \/ __|/ _ \ '_ \| '_ \  | |\/| |/ _` / __| __/ _ \ '__|
-- | |__|  __/ (_| |   <  __/ (_| | | |_) | |_| | | |_| | (_) \__ \  __/ |_) | | | | | |  | | (_| \__ \ ||  __/ |   
-- |_____\___|\__,_|_|\_\___|\__,_| |____/ \__, |  \___/ \___/|___/\___| .__/|_| |_| |_|  |_|\__,_|___/\__\___|_|   
--                                          |___/                      |_|                                          
AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");
include("shared.lua");

function ENT:Initialize()
	self:SetModel("models/props_c17/metalPot001a.mdl");
	self:PhysicsInit(SOLID_VPHYSICS);
	
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:SetSolid(SOLID_VPHYSICS);

	--[[
	local visProp = ents.Create("prop_physics");
	visProp:SetModel("models/props_phx/wheels/magnetic_med_base.mdl");
	visProp:SetPos(self:GetPos()+self:GetUp()*6);
	visProp:SetAngles(self:GetAngles()+Angle(180, 0, 0));
	visProp:SetParent(self);
	visProp:SetMaterial("models/shadertest/predator");
	visProp:SetModelScale(0.925, 0);
	visProp:Spawn()
	
	]]--
	self:SetNWInt("distance", EML_DrawDistance);
	self:SetNWInt("macid", 0);	
	self:SetNWInt("sulfur", 0);
	self:SetNWInt("time", EWL_Pot_StartTime);
	self:SetNWInt("maxTime", EWL_Pot_StartTime);
	self:SetNWString("status", "inprogress");
end;
 
function ENT:SpawnFunction(ply, trace)
	local ent = ents.Create("eml_pot");
	ent:SetPos(trace.HitPos + trace.HitNormal * 8);
	ent:Spawn();
	ent:Activate();
     
	return ent;
end;

function ENT:OnTakeDamage(dmginfo)
	self:VisualEffect();
	self:Remove()
end;

function ENT:PhysicsCollide(data, phys)
local curTime = CurTime(); 
	if ((data.DeltaTime > 0) and (data.HitEntity:GetClass() == "eml_macid") and (self:GetNWInt("macid")<10) and (self:GetNWString("status") != "ready")) then
		if (data.HitEntity:GetNWInt("amount")>0) then
			data.HitEntity:SetNWInt("amount", math.Clamp(data.HitEntity:GetNWInt("amount") - 1, 0, 100));
			if EML_Pot_DestroyEmpty then
				if (data.HitEntity:GetNWInt("amount")==0) then	
					data.HitEntity:VisualEffect();
				end;		
			end;
			self:SetNWInt("time", self:GetNWInt("time")+EML_Pot_OnAdd_MuriaticAcid);
			self:SetNWInt("maxTime", self:GetNWInt("maxTime")+EML_Pot_OnAdd_MuriaticAcid);
			self:SetNWInt("macid", self:GetNWInt("macid") + 1);
			self:EmitSound("ambient/levels/canals/toxic_slime_sizzle3.wav", EML_Sound_Volume, 100);
			self:VisualEffect();
		end;
	end;
	if ((data.DeltaTime > 0) and (data.HitEntity:GetClass() == "eml_sulfur") and (self:GetNWInt("sulfur")<10) and (self:GetNWString("status") != "ready")) then
		if (data.HitEntity:GetNWInt("amount")>0) then
			data.HitEntity:SetNWInt("amount", math.Clamp(data.HitEntity:GetNWInt("amount") - 1, 0, 100));
			if EML_Pot_DestroyEmpty then
				if (data.HitEntity:GetNWInt("amount")==0) then	
					data.HitEntity:VisualEffect();
				end;		
			end;	
			self:SetNWInt("time", self:GetNWInt("time")+EML_Sulfur_Amount);
			self:SetNWInt("maxTime", self:GetNWInt("maxTime")+EML_Sulfur_Amount);
			self:SetNWInt("sulfur", self:GetNWInt("sulfur") + 1);
			self:EmitSound("ambient/levels/canals/toxic_slime_sizzle3.wav", EML_Sound_Volume, 100);		
			self:VisualEffect();
		end;
	end;
end;

function ENT:Use( activator, caller )
local curTime = CurTime();
	if (!self.nextUse or curTime >= self.nextUse) then
		if activator:KeyDown(IN_SPEED) then				
			self:SetAngles(Angle(self:GetAngles().p, activator:GetAngles().y+180, 0));
		elseif ((self:GetNWString("status")=="ready") and ((self:GetNWInt("macid")>0) and (self:GetNWInt("sulfur")>0))) then			
			local redpAmount = (self:GetNWInt("macid")+self:GetNWInt("sulfur"));
		
			self:EmitSound("ambient/levels/canals/toxic_slime_sizzle2.wav", EML_Sound_Volume, 100);
			self:SetNWInt("macid", 0);			
			self:SetNWInt("sulfur", 0);
			self:SetNWInt("time", EWL_Pot_StartTime);
			self:SetNWInt("maxTime", EWL_Pot_StartTime);
			self:SetNWString("status", "inprogress");			
			
			redP = ents.Create("eml_redp");
			redP:SetPos(self:GetPos()+self:GetUp()*12);
			redP:SetAngles(self:GetAngles());
			redP:Spawn();
			redP:GetPhysicsObject():SetVelocity(self:GetUp()*2);
			redP:SetNWInt("amount", redpAmount);
			redP:SetNWInt("maxAmount", redpAmount);			
		end;
		
		self.nextUse = curTime + 0.5;
	end;
end;

function ENT:VisualEffect()
	local effectData = EffectData();	
	effectData:SetStart(self:GetPos());
	effectData:SetOrigin(self:GetPos());
	effectData:SetScale(8);	
	util.Effect("GlassImpact", effectData, true, true);
end;