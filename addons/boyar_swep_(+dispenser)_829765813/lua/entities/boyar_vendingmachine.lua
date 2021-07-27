AddCSLuaFile()

ENT.PrintName = 'Boyar Vending Machine'
ENT.Base = 'base_gmodentity'

ENT.Author = 'Campo'

ENT.Spawnable = true
ENT.AdminSpawnable = true

ENT.Category = 'Boyar'

local nothing = function() end

local takeMoney = DarkRP and function( ply, count ) ply:addMoney( -count ) end or nothing
local notify = DarkRP and DarkRP.notify or nothing

local bought = GetConVarString( 'gmod_language' ):lower():find( 'ru' ) and 'Вы купили боярышник за $250' or 'You bought boyar for $250'

function ENT:Initialize()
	
	if SERVER then
		self:SetModel( 'models/props_interiors/VendingMachineSoda01a.mdl' )
		self:SetMaterial( 'models/props_interiors/sodamachine02a' )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetUseType( SIMPLE_USE )
	end
	
end

function ENT:Use(_,caller)
	if SERVER then
		if self.Cooldown and self.Cooldown > CurTime() then
			return
		end
		self:EmitSound( 'buttons/button1.wav' )
		
		self.Cooldown = CurTime() + 5

		if !caller:HasWeapon('boyar') then
			notify( caller, 2, 3, bought)
			takeMoney( caller, 250 )
			
			caller:Give( 'boyar' )
		end
		caller:SelectWeapon( 'boyar' )
	end
end