ENT.Base = "base_ai"
ENT.Type = "ai"

ENT.PrintName 	= "Tune-man"
ENT.Author 		= "KaiL"
ENT.Contact 	= ""
ENT.Category	= "GPRP"

ENT.AutomaticFrameAdvance = true;

ENT.Spawnable = true;
ENT.AdminSpawnable = true;

function ENT:PhysicsCollide(data, physobj)
end;

function ENT:PhysicsUpdate(physobj)
end;

function ENT:SetAutomaticFrameAdvance(bUsingAnim)
	self.AutomaticFrameAdvance = bUsingAnim;
end
