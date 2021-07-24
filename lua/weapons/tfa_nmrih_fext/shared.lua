SWEP.Base = "tfa_nmrimelee_base_sp"
SWEP.Category = "TFA NMRIH"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.PrintName = "Fire Extinguisher"

SWEP.ViewModel			= "models/weapons/tfa_nmrih/v_tool_extinguisher.mdl" --Viewmodel path
SWEP.ViewModelFOV = 50

SWEP.WorldModel			= "models/weapons/tfa_nmrih/w_tool_extinguisher.mdl" --Viewmodel path
SWEP.HoldType = "ar2"
SWEP.DefaultHoldType = "ar2"
SWEP.Offset = { --Procedural world model animation, defaulted for CS:S purposes.
        Pos = {
        Up = 8,
        Right = 1.25,
        Forward = 9,
        },
        Ang = {
        Up = -1,
        Right = -15,
        Forward = 178
        },
		Scale = 1.0
}

SWEP.Primary.Sound = Sound("Weapon_Melee.PipeLeadLight")
SWEP.Secondary.Sound = Sound("Weapon_Melee.PipeLeadHeavy")

SWEP.MoveSpeed = 0.935
SWEP.IronSightsMoveSpeed  = SWEP.MoveSpeed

SWEP.InspectPos = Vector(5.5, 1.424, -3.131)
SWEP.InspectAng = Vector(17.086, 3.938, 14.836)

SWEP.Primary.Blunt = true
SWEP.Primary.Damage = 55
SWEP.Primary.Reach = 80
SWEP.Primary.RPM = 60
SWEP.Primary.SoundDelay = 0.2
SWEP.Primary.Delay = 0.25
SWEP.Primary.Window = 0.3

SWEP.Secondary.Blunt = true
SWEP.Secondary.RPM = 60 -- Delay = 60/RPM, this is only AFTER you release your heavy attack
SWEP.Secondary.Damage = 85
SWEP.Secondary.Reach = 60	
SWEP.Secondary.SoundDelay = 0.1
SWEP.Secondary.Delay = 0.15

SWEP.Secondary.BashDamage = 25
SWEP.Secondary.BashDelay = 0.15
SWEP.Secondary.BashLength = 50

SWEP.ViewModelBoneMods = {
	["ValveBiped.Bip01_R_Finger1"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0.254, 0.09), angle = Angle(15.968, -11.193, 1.437) },
	["ValveBiped.Bip01_R_Finger0"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(3.552, 4.526, 0) },
	["Thumb04"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(6, 0, 0) },
	["Maglite"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, -30), angle = Angle(0, 0, 0) }
}

SWEP.AnimSequences = {
	attack_quick = "Attack_Quick",
	charge_begin = "Attack_Charge_Begin",
	charge_loop = "Attack_Charge_Idle",
	charge_end = "Attack_Charge_End",
	turn_on = "HoseEquip",
	turn_off = "HoseUnequip",
	idle_on = "HoseIdle",
	attack_enter = "HoseSprayFakeTransition",
	attack_loop = "HoseSpray",
	attack_exit = "HoseSprayFakeTransition"
}

SWEP.Primary.Ammo = "co2"
SWEP.Primary.ClipSize = 100
SWEP.Primary.DefaultClip = 400

SWEP.Primary.Motorized = true
SWEP.Primary.Motorized_ToggleBuffer = 0.1 --Blend time to idle when toggling
SWEP.Primary.Motorized_ToggleTime = 0.5 --Time until we turn on/off, independent of the above
SWEP.Primary.Motorized_IdleSound = Sound("") --Idle sound, when on
SWEP.Primary.Motorized_SawSound = Sound("Weapon_Extinguisher.Extinguish") --Rev sound, when on
SWEP.Primary.Motorized_AmmoConsumption_Idle = 0 --Ammo units to consume while idle
SWEP.Primary.Motorized_AmmoConsumption_Saw = 100/10 --Ammo units to consume while sawing
SWEP.Primary.Motorized_RPM = 400
SWEP.Primary.Motorized_Damage = 50 --DPS
SWEP.Primary.Motorized_Reach = 200 --DPS

SWEP.ExtinguishRadius = 32

DEFINE_BASECLASS(SWEP.Base)

local TYPE_PRIMARY = 0
local TYPE_SECONDARY = 1
local TYPE_MOTORIZED = 2

local pos,ang,hull
hull = {}

function SWEP:HitThing( damage, force, reach, blunt, sndtype )
	if not self:OwnerIsValid() then return end
	if self:GetStatus() == TFA.GetStatus("NMRIH_MELEE_MOTOR_ATTACK") then
		sndtype = TYPE_MOTORIZED
	end
	local dofx = true
	local clientvar = SERVER and self.Owner:GetInfoNum("cl_tfa_nmrih_fx_fext", 1) or ( cv_nmrih_fx_fext and cv_nmrih_fx_fext:GetInt() or 1 )
	local servervar = self.svfxvar and self.svfxvar:GetInt() or -1

	if servervar >= -0.01 then
		if math.Round(servervar) == 0 then
			dofx = false
		end
	else
		if math.Round(clientvar) == 0 then
			dofx = false
		end
	end
	if dofx then
		local fx = EffectData()
		fx:SetEntity(self.Owner)
		fx:SetAttachment(1)
		fx:SetMagnitude(2)
		fx:SetScale(3)
		util.Effect("nmrih_fext_fx",fx)
	end
	if SERVER then
		local tr = util.QuickTrace(self.Owner:GetShootPos(), self.Owner:EyeAngles():Forward() * self.Primary.Motorized_Reach, self.Owner)
		local enttbl = ents.FindInSphere(tr.HitPos, self.ExtinguishRadius)

		for k, v in pairs(enttbl) do
			if v.Extinguish and v.IsOnFire and v:IsOnFire() then
				v:Extinguish()
			end

			if v:GetClass() == "env_fire" then
				v:Remove()
			end
		end
	end
	pos = self.Owner:GetShootPos()
	ang = self.Owner:GetAimVector()

	local secondary = false
	if sndtype == TYPE_SECONDARY then
		secondary = true
	end

	self.Owner:LagCompensation(true)

	hull.start = pos
	hull.endpos = pos + (ang * reach)
	hull.filter = self.Owner
	hull.mins = Vector(-5, -5, 0)
	hull.maxs = Vector(5, 5, 5)
	local slashtrace = util.TraceHull(hull)

	self.Owner:LagCompensation(false)

	if slashtrace.Hit then
		if slashtrace.Entity == nil then return end

		if game.GetTimeScale() > 0.99 then
			local srctbl = secondary and self.Secondary or self.Primary
			if sndtype == TYPE_MOTORIZED then srctbl = nil end
			self.Owner:FireBullets({
				Attacker = self.Owner,
				Inflictor = self,
				Damage = damage,
				Force = force,
				Distance = reach + 10,
				HullSize = 12.5,
				Tracer = 0,
				Src = self.Owner:GetShootPos(),
				Dir = slashtrace.Normal,
				Callback = function(a, b, c)
					if c then
						if sndtype == TYPE_MOTORIZED then
							c:SetDamageType( bit.bor(DMG_PLASMA,DMG_NEVERGIB) )
						else
							c:SetDamageType( blunt and DMG_CLUB or DMG_SLASH )
						end
					end
					if srctbl then
						if b.MatType == MAT_FLESH or b.MatType == MAT_ALIENFLESH then
							self:EmitSound( srctbl.HitSound_Flesh["sharp"] or srctbl.HitSound_Flesh["blunt"] )
						else
							local sndtbl = srctbl.HitSound[ blunt and "blunt" or "sharp" ]
							local snd = sndtbl[ b.MatType ] or sndtbl[ MAT_DIRT ]
							self:EmitSound( snd )
						end
					end
				end
			})
		else
			local dmg = DamageInfo()
			dmg:SetAttacker(self.Owner)
			dmg:SetInflictor(self)
			dmg:SetDamagePosition(self.Owner:GetShootPos())
			dmg:SetDamageForce(self.Owner:GetAimVector() * (dmgval * 0.25))
			dmg:SetDamage(dmgval)
			if sndtype == TYPE_MOTORIZED then
				dmg:SetDamageType( bit.bor(DMG_PLASMA,DMG_NEVERGIB) )
			else
				dmg:SetDamageType( blunt and DMG_CLUB or DMG_SLASH )
			end
			slashtrace.Entity:TakeDamageInfo(dmg)
		end

		targ = slashtrace.Entity

		local srctbl = secondary and self.Secondary or self.Primary
		if sndtype == TYPE_MOTORIZED then sndtbl = nil end
		if srctbl and game.GetTimeScale() < 0.99 then
			if slashtrace.MatType == MAT_FLESH or slashtrace.MatType == MAT_ALIENFLESH then
				self:EmitSound( srctbl.HitSound_Flesh["sharp"] or srctbl.HitSound_Flesh["blunt"] )
			else
				local sndtbl = srctbl.HitSound[ blunt and "blunt" or "sharp" ]
				local snd = sndtbl[ slashtrace.MatType ] or sndtbl[ MAT_DIRT ]
				self:EmitSound( snd )
			end
		end
	end
end

function SWEP:DoImpactEffect(tr, dmgtype)
	if not IsValid(self) then return end
	stat = self:GetStatus()
	if stat == TFA.GetStatus("NMRIH_MELEE_SWING")  then
		dmgtype = self.Primary.Blunt and DMG_CLUB or DMG_SLASH
	elseif stat == TFA.GetStatus("NMRIH_MELEE_CHARGE_END")  then
		dmgtype = self.Secondary.Blunt and DMG_CLUB or DMG_SLASH
	elseif self.Primary.Motorized and not ( self.GetBashing and self:GetBashing() ) then
		return true
	end
	if tr.MatType ~= MAT_FLESH and tr.MatType ~= MAT_ALIENFLESH then
		self:ImpactEffectFunc( tr.HitPos, tr.HitNormal, tr.MatType )
		if tr.HitSky then return true end
		if bit.band(dmgtype,DMG_SLASH) == DMG_SLASH then
			util.Decal("ManhackCut", tr.HitPos + tr.HitNormal * 4, tr.HitPos - tr.HitNormal)
			return true
		else
			return false
		end
	end
	return false
end