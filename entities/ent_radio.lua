AddCSLuaFile()

ENT.Type = "anim"

ENT.PrintName		= "Рация"
ENT.Author			= ""
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""
ENT.Category 		= "GPortalRP"

ENT.AdminSpawnable 	= false
ENT.Spawnable 		= true

if SERVER then

function ENT:Initialize()
 
		self:SetModel( "models/radio/w_radio.mdl" )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
	 
        local phys = self:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:Wake()
		end
	
		self:SetUseType( SIMPLE_USE )

	end
 
	function ENT:Use( activator, caller )
		if caller:GetNWBool( 'gp_radio', false ) ~= false then
			DarkRP.notify(caller, 2, 6, 'У вас уже есть рация')
			return
		end
		caller:SetNWBool( 'gp_radio', true )
		caller:SetNWBool( 'gp_radio_off', false )
		DarkRP.notify(caller, 2, 6, 'Нажмите "B" для использования рации')
		self:Remove()
	end
	 
	function ENT:Think()

	end

end

if CLIENT then
	function ENT:Draw()
    	self:DrawModel()
	end

end
