AddCSLuaFile("shared.lua")
include('shared.lua')



function ENT:Initialize( ) --This function is run when the entity is created so it's a good place to setup our entity.
 
	self:SetModel( "models/props_junk/watermelon01.mdl" ) -- Sets the model of the NPC.
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetName("savav_watermelon")
	self:SetPos(self:GetPos()+Vector(0,0,self:OBBMaxs().z))
	--self:SetMaterial("model_color.vmt")
	--self:SetColor(Color(255,90,90))
	local phys = self:GetPhysicsObject()
	if(phys:IsValid()) then phys:Wake() end
 
end

function ENT:AcceptInput( Name, Activator, Caller )	
if Caller:GetNWFloat( "drug" ) == nil or Caller:GetNWFloat( "drug" ) == "0" then
Caller:SetNWFloat( "drug", "savav_watermelon" )
	if Name == "Use" and Caller:IsPlayer() then
		umsg.Start("DrugEffect_savav_watermelon", Caller)
		umsg.String( "savav_watermelon" )
		umsg.End() 
	end
	
	timer.Create( Caller:Name().."_DrugTimer", 70, 1, function() 
			Caller:SetNWFloat( "drug", "0" )
	end)
	self:Remove()
end
end


 