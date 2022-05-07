///////////////////////////////////
//			Boom entity 		//
/////////////////////////////////



///////////////////////////////////	
//			Grenade weapon 		//
////////////////////////////////

AddCSLuaFile()

SWEP.Author = 'SnOOp'
SWEP.Information = 'Уничтожать дома.'
SWEP.Editable = false
SWEP.Spawnable = true
SWEP.AdminOnly = true

if CLIENT then
	SWEP.PrintName = 'Слезоточивый газ'
	SWEP.Instructions = 'ЛКМ - Истребить людей;'
	SWEP.Slot = 3
	SWEP.Category = "GPortalRP"
	SWEP.ViewModelFlip = true 
	SWEP.DrawCrosshair = false
end

SWEP.ViewModel = 'models/weapons/v_eq_smokegrenade.mdl'
SWEP.WorldModel = 'models/weapons/w_eq_smokegrenade.mdl'

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
					ply:StripWeapon( 'weapon_gas' )
				end )
			end
		end
	end
end

function SWEP:SecondaryAttack()
	
end


function SWEP:CreateGrenade( vel, pos )
	local grenade = ents.Create( 'sent_smokegrenade' )

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


local ENT = {}

ENT.Base = 'base_gmodentity'

AccessorFunc( ENT, "thrower", "Thrower" )
AccessorFunc( ENT, "radius", "Radius", FORCE_NUMBER )

if CLIENT then
	function ENT:Draw()
		self:DrawModel()
	end

	// bidlo kod.exe

	local entered = false
	local lastenter = 0


	local function eff( n, num )
		DrawMotionBlur( n, num, 0 )

		local oldang = LocalPlayer():EyeAngles()
		LocalPlayer():SetEyeAngles( Angle( Lerp( 0.01, oldang.p, math.random( -90, 90 ) ), Lerp( 0.01, oldang.y, math.random( -90, 90 ) ), Lerp( 0.015, oldang.r, math.random( -90, 90 ) ) ) )
		LocalPlayer():SetFOV( Lerp( FrameTime() * 5, LocalPlayer():GetFOV(), 10 ), 0 )
	end

	hook.Add( "RenderScreenspaceEffects", "EntGasEffect", function()

		local has = false

		if entered == false then
			for k, v in pairs( ents.FindByClass( 'sent_smokegrenade' ) ) do
				if v:GetPos():Distance( LocalPlayer():GetPos() ) <= 135 and v:GetNWBool( 'Exploded' ) == true then
					entered = true
					lastenter = CurTime()

					has = true
				end
			end 
		end

		if not LocalPlayer():Alive() then

			lastenter = 0

		end


		if not has and CurTime() - lastenter <= 25 and not LocalPlayer():GetNWBool( 'ingasmask', false ) then

			eff( 0.03, 15 )

		else

			local oldfov = LocalPlayer():GetFOV()

			LocalPlayer():SetFOV( 0, 0 )

			local def_fov = LocalPlayer():GetFOV()

			LocalPlayer():SetFOV( oldfov, 0 )

			local oldang = LocalPlayer():EyeAngles()

			LocalPlayer():SetEyeAngles( Angle( oldang.p, oldang.y, Lerp( FrameTime() * 2, oldang.r, 0 ) ) )

			LocalPlayer():SetFOV( Lerp( FrameTime() * 2, LocalPlayer():GetFOV(), def_fov ), 0 )

			if LocalPlayer():EyeAngles().r == 0 then

				entered = false 

			end
		end
	end ) 
else
	function ENT:Initialize()
		if not self:GetRadius() then self:SetRadius( 60 ) end
self.extime = CurTime()
		self:SetModel( 'models/weapons/w_eq_smokegrenade.mdl' )
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
		if data.Speed > 50 then 

			self:EmitSound( Sound( 'SmokeGrenade.Bounce' ) ) 


		end
	end

	function ENT:Think()
		if not IsValid( self:GetThrower() ) then
			self:Remove()
		end
	end
end

function ENT:Explode()
	if SERVER then
		self:SetNWBool( 'Exploded', true )

		self:SetNotSolid( true )

		self.extime = CurTime()

		local effect = ents.Create'env_smoketrail'
		effect:SetPos( self:GetPos() )

		effect:SetKeyValue( 'spawnradius', tostring( self:GetRadius() ) )
		effect:SetKeyValue( 'minspeed', '0.5' )
		effect:SetKeyValue( 'maxspeed', '4' )
		effect:SetKeyValue( 'startsize', '10800' )
		effect:SetKeyValue( 'endsize', '256' )
		effect:SetKeyValue( 'endcolor', '200 175 0' ) -- 200 175 0
		effect:SetKeyValue( 'startcolor', '200 175 0' ) // 100 205 70 - green is good | 
		effect:SetKeyValue( 'opacity', '4' )
		effect:SetKeyValue( 'spawnrate', '30' )
		effect:SetKeyValue( 'lifetime', '25' ) 

		effect:SetColor( Color( 255, 255, 255, 100 ) )

		effect:SetParent( self )
		effect:Spawn()
		effect:Activate()

		effect:Fire( 'turnon', '', 0.1 )
		effect:Fire( 'kill', '', 30 )

		self:EmitSound( Sound( 'BaseSmokeEffect.Sound' ) )

		
		timer.Simple( 50, function()
			self:SetNWBool( 'Exploded', false )
		end )

		timer.Simple( 60, function()
			self:Remove()
		end )
	end
end

scripted_ents.Register( ENT, 'sent_smokegrenade' )