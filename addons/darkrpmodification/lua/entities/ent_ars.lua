AddCSLuaFile()

//local ENT = {}

ENT.Base = "base_gmodentity"

ENT.PrintName = 'Арсенал росгвардии'
ENT.Author = 'KaiL'
ENT.Information = 'ага'
ENT.Category = 'GPRP'
ENT.Editable = false
ENT.Spawnable = true
ENT.AdminOnly = false



if CLIENT then
	function ENT:Draw()
		self:DrawModel()
	end
else
	function ENT:Initialize()
		self:SetModel( 'models/props/de_prodigy/ammo_can_03.mdl' )
		self:PhysicsInit( SOLID_VPHYSICS ) 
		self:SetUseType( SIMPLE_USE )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		
		self:SetCollisionGroup( COLLISION_GROUP_NONE )
			

		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
		end
	end

	function ENT:Use( activator, caller )

		if !caller:GetNWString( 'nrg_access_wep', false) and !caller:rg_IsCMD() then
			caller:ChatAddText(Color(60,120,70),'[Штаб округа] ',Color(255,255,255), 'У вас нету доступа к арсеналу' )
			return
		end

		caller:SendLua( 'gp_wep.nrg_arsm()' )
		

	end

end


scripted_ents.Register( ENT, 'ent_ars' )
