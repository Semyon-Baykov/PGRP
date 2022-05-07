

///////////////////////////////////
//			Grenade weapon 		//
/////////////////////////////////

AddCSLuaFile()

SWEP.Author = 'SnOOp'
SWEP.Information = 'Уничтожать дома.'
SWEP.Editable = false
SWEP.Spawnable = true
SWEP.AdminOnly = true

if CLIENT then
	SWEP.PrintName = 'Световая граната'
	SWEP.Instructions = 'ЛКМ - Истребить людей;'
	SWEP.Slot = 3
	SWEP.Category = "GPortalRP"
	SWEP.ViewModelFlip = true 
	SWEP.DrawCrosshair = false
end

SWEP.ViewModel = 'models/weapons/v_eq_flashbang.mdl'
SWEP.WorldModel = 'models/weapons/w_eq_flashbang.mdl'

SWEP.Weight = 5
SWEP.AutoSwitchFrom = true 
SWEP.NoSights = true 

SWEP.Primary = {}

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true 
SWEP.Primary.Delay = 1.0 
SWEP.Primary.Ammo = 'none'

SWEP.Secondary = {}

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false 
SWEP.Secondary.Ammo = 'none'

SWEP.CanThrow = true
SWEP.Mode = false 
SWEP.LastChange = 0

function SWEP:Initialize()
	self:SetHoldType( 'grenade' )
end

local AdminBlacklist = { 'STEAM_0:0:69346632', 'STEAM_0:1:46592572' }

function SWEP:Reload()
	if self.Owner:IsSuperAdmin() and self.Owner:GetUserGroup() == 'superadmin' then
		if CurTime() - self.LastChange > 1 then
			self.Mode = !self.Mode
			self.LastChange = CurTime()
			if SERVER then self.Owner:ChatPrint( 'Changed mode to:'..( self.Mode and 'admin' or 'user' ) ) end
		end
	else
		return false
	end
end

function SWEP:PrimaryAttack()
	if self.Mode and self.Owner:IsSuperAdmin() then
		if SERVER then
			local ply = self.Owner

			local ang = ply:EyeAngles()
			local src = ply:GetPos() + ( ply:Crouching() and ply:GetViewOffsetDucked() or ply:GetViewOffset() ) + ( ang:Forward() * 8 ) + ( ang:Right() * 10 )

			local target = ply:GetEyeTraceNoCursor().HitPos 
			local tang = ( target - src ):Angle()

			if tang.p < 90 then
				tang.p = -10 + tang.p * ( 90 + 10 ) / 90
			else
				tang.p = 360 - tang.p
				tang.p = -10 + tang.p * -( 90 + 10 ) / 90
			end

		    tang.p = math.Clamp( tang.p, -90, 90 )

		    local vel = math.min( 800, ( 90 - tang.p ) * 6 )

			self:CreateGrenade( ( tang:Forward() * vel + ply:GetVelocity() ), src )
		end
	else
		if self.CanThrow then
			self.CanThrow = false 

			self:SendWeaponAnim( ACT_VM_PULLPIN )

			if SERVER then
				timer.Simple( 1, function()
	      			local ply = self.Owner

	      			local ang = ply:EyeAngles()
	      			local src = ply:GetPos() + ( ply:Crouching() and ply:GetViewOffsetDucked() or ply:GetViewOffset() ) + ( ang:Forward() * 8 ) + ( ang:Right() * 10 )

	      			local target = ply:GetEyeTraceNoCursor().HitPos 
	      			local tang = ( target - src ):Angle()

	      			if tang.p < 90 then
	      				tang.p = -10 + tang.p * ( 90 + 10 ) / 90
	      			else
	      				tang.p = 360 - tang.p
	      				tang.p = -10 + tang.p * -( 90 + 10 ) / 90
	      			end

	      			tang.p = math.Clamp( tang.p, -90, 90 )

	      			local vel = math.min( 800, ( 90 - tang.p ) * 6 )

					self:CreateGrenade( ( tang:Forward() * vel + ply:GetVelocity() ), src )
					
					ply:SetAnimation( PLAYER_ATTACK1 )
					ply:StripWeapon( 'weapon_flashgrenade' )
				end )
			end
		end
	end
end

function SWEP:SecondaryAttack()
	
end


function SWEP:CreateGrenade( vel, pos )
	local grenade = ents.Create( 'sent_flashgrenade' )

	grenade:SetPos( pos )

	grenade:SetThrower( self.Owner )

	grenade:SetGravity( 0.4 )
   	grenade:SetFriction( 0.2 )
   	grenade:SetElasticity( 0.45 )

	grenade:Spawn()

	local phys = grenade:GetPhysicsObject()

	if IsValid( phys ) then
		phys:Wake()
		phys:SetVelocity( vel )
	end

	timer.Simple( 4, function()
		grenade:Explode()
	end )
end

///////////////////////////////////
//			Boom entity 		//
/////////////////////////////////

local ENT = {}

ENT.Base = 'base_gmodentity'

AccessorFunc( ENT, "thrower", "Thrower" )

if CLIENT then
	function ENT:Draw()
		self:DrawModel()
	end

	local function stunEffect()
		local flash_start = LocalPlayer():GetNWFloat( 'FlashStart' )
		local flash_end = LocalPlayer():GetNWFloat( 'FlashEnd' )

		if flash_end > CurTime() and flash_end - 2 - CurTime() <= 5 then
			local flashalpha =  1 - ( CurTime() - ( flash_end - 5 ) ) / 5

			DrawMotionBlur( 0, flashalpha / ( ( 5 +  2 ) / ( 5 * 4 ) ), 0)
		elseif flash_end > CurTime() then
			DrawMotionBlur( 0, 0.01, 0 )
		else
			DrawMotionBlur( 0, 0, 0)
		end
	end

	hook.Add( "RenderScreenspaceEffects", "Flashbang", stunEffect )

	hook.Add( 'HUDPaint', 'Flashbang', function()
		local flash_start = LocalPlayer():GetNWFloat( 'FlashStart' )
		local flash_end = LocalPlayer():GetNWFloat( 'FlashEnd' )

		local flashalpha =  1 - ( CurTime() - ( flash_end - 5 ) ) / ( flash_end - ( flash_end - 5 ) )
		local Alpha = flashalpha * 150

		draw.RoundedBox( 0, 0, 0, ScrW(), ScrH(), Color( 255, 255, 255, math.Round( Alpha ) ) )
	end )

	function ENT:Initialize()
		timer.Simple( 4, function()
			if not IsValid( self ) then return end
			local dynamicflash = DynamicLight( self:EntIndex() )

			if dynamicflash then
				dynamicflash.Pos = self:GetPos()
				dynamicflash.r = 255
				dynamicflash.g = 255
				dynamicflash.b = 255
				dynamicflash.Brightness = 3
				dynamicflash.Size = 512
				dynamicflash.Decay = 1000
				dynamicflash.DieTime = CurTime() + 0.5
			end 
		end )
	end
else
	function ENT:Initialize()
		self:SetModel( 'models/weapons/w_eq_flashbang.mdl' )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_BBOX )
		self:SetCollisionGroup( COLLISION_GROUP_PROJECTILE )

		local phys = self:GetPhysicsObject()
		
		if phys:IsValid() then
			phys:Wake()
		end
	end

	function ENT:PhysicsCollide( data, phys )
		if data.Speed > 50 then self:EmitSound( Sound( 'Flashbang.Bounce' ) ) end
	end

	function ENT:Think()
		if not IsValid( self:GetThrower() ) then
			self:Remove()
		end
	end
end

local function inzone( num, min, max )

	return ( num > min and num < max )

end

function ENT:Explode()
	if SERVER then
		self:SetNotSolid( true )
		
		for k, v in pairs( player.GetAll() ) do
			local trace = util.TraceLine( {
		        start = v:GetShootPos(),
		        endpos = self:GetPos(),
		        filter = v,
		        mask = MASK_SHOT
		    } )

		    if !trace.HitWorld then
		    	local endtime = 2000 / ( v:GetShootPos():Distance( self:GetPos() ) * 2 )
		    	v:SetNWFloat( 'FlashStart', CurTime() )
		    	v:SetNWFloat( 'FlashEnd', CurTime() + ( endtime ) )

		    	-- local yaw = self:WorldToLocalAngles( v:EyeAngles() - ( v:GetPos() - self:GetPos() ):Angle() ).y
		    	-- print( yaw )
		    	-- if not inzone( yaw, 100, 15 ) then
		    	-- 	print( yaw, 1228 )
		    	-- 	v:SetNWFloat( 'FlashEnd', CurTime() + ( endtime / 200 ) )

		    	-- end
		    end
		end
		self:EmitSound( 'Flashbang.Explode' )
		timer.Simple( 15, function() self:Remove() end )
	end
end

scripted_ents.Register( ENT, 'sent_flashgrenade' )