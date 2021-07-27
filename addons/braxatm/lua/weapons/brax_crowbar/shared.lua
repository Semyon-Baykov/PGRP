CreateConVar("brax_crowbar_mode", 3, {FCVAR_ARCHIVE, FCVAR_REPLICATED, FCVAR_NOTIFY})

if SERVER then
	CreateConVar("brax_crowbar_money_atm", 5000, {FCVAR_ARCHIVE})
	CreateConVar("brax_crowbar_money_vending", 1000, {FCVAR_ARCHIVE})
	CreateConVar("brax_crowbar_repair", 60*30, {FCVAR_ARCHIVE})
	util.AddNetworkString("crowbar_breakin")
end

local mode = GetConVarNumber("brax_crowbar_mode")

cvars.AddChangeCallback("brax_crowbar_mode", function(c, p, n)
	mode = tonumber(n)
end)

-- Modes:
-- 0 = does nothing
-- 1 = basic melee weapon
-- 2 = multitool
-- 3 = both

-- thanks lolcats http://facepunch.com/showthread.php?t=1348923&p=45277438&viewfull=1#post45277438

SWEP.PrintName = "Crowbar"
SWEP.Author			= "Lolcats, Braxen"

SWEP.Instructions		= "Left mouse to swing.\nRight click for other uses."

SWEP.Spawnable	= true
SWEP.AdminOnly	= true
SWEP.Category	= "BraxnetRP"

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo		= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo		= "none"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Slot				= 0
SWEP.SlotPos			= 0
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= true

SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false

SWEP.ViewModel			= "models/weapons/c_crowbar.mdl"
SWEP.WorldModel			= "models/weapons/w_crowbar.mdl"
SWEP.Base 				= "weapon_base" 
SWEP.UseHands			= true

local sound_single = Sound("Weapon_Crowbar.Single")

local breakin = false
local dmg = 0
local rmsg = ""

local creak = {
	"ambient/misc/creak1.wav", 
	"ambient/misc/creak2.wav", 
	"ambient/misc/creak3.wav", 
	"ambient/misc/creak4.wav", 
	"ambient/misc/creak5.wav",
	"ambient/materials/metal_stress1.wav",
	"ambient/materials/metal_stress2.wav",
	"ambient/materials/metal_stress3.wav",
	"ambient/materials/metal_stress4.wav",
	"ambient/materials/metal_stress5.wav"
}

local bmsg = {
	"Keep going...",
	"Just a bit more...",
	"Almost there...",
	"Salvation is coming...",
	"I can feel it...",
	"Come on now!",
	"It's bending!",
	"I can see the money!"
}

if CLIENT then
	net.Receive("crowbar_breakin", function()
		dmg = net.ReadInt(16)
		breakin = true
		rmsg = table.Random(bmsg)
		print(rmsg)
		timer.Simple(1.8, function() breakin = false end)
	end)
else
	hook.Add("PlayerDeath","BraxCrowbarDeath", function(ply)
		if ply.BraxCrowbarFreeze then
			print("death")
			ply.BraxCrowbarFreeze = false
			ply:Freeze(false)
		end
	end)
end

function SWEP:Initialize()
    self:SetWeaponHoldType("melee")
end

function SWEP:PrimaryAttack()
	
	local ply = self.Owner

	if mode == 0 or mode == 2 then
		--if SERVER then DarkRP.notify(ply, 0, 4, "It's too heavy to swing.") end
		--print("nothing")
		return 
	end
	
	self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
	self.Weapon:SetNextPrimaryFire(CurTime() + .4)

	local trace = ply:GetEyeTrace()
	
	self.Weapon:EmitSound(sound_single)

	if trace.HitPos:Distance(self.Owner:GetShootPos()) <= 75 then
		bullet = {}
		bullet.Num    = 1
		bullet.Src    = ply:GetShootPos()
		bullet.Dir    = ply:GetAimVector()
		bullet.Spread = Vector(0.025, 0.025, 0.025)
		bullet.Tracer = 0
		bullet.Force  = 25
		bullet.Damage = 25
			ply:FireBullets(bullet)
			ply:SetAnimation( PLAYER_ATTACK1 )
	else
		self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER)	
		ply:SetAnimation( PLAYER_ATTACK1 )
	end
	
	ply:ViewPunch( Angle( -1, 0, 0 ) )
	
end

function SWEP:DrawHUD()
	if not breakin then return end
	local w = ScrW()
	local h = ScrH()
	local col = Color(255,255 - ((10-dmg)*25),255 - ((10-dmg)*25),255)
	draw.RoundedBox(8, w/2-125, h/2+35, 250, 70, Color(0, 0, 0, 160))
	draw.SimpleText("Breaking in...", "Trebuchet24", w/2, h/2 + 60, col, 1, 1)
	draw.SimpleText(rmsg or "...", "Trebuchet24", w/2, h/2 + 80, col, 1, 1)
end

function SWEP:SecondaryAttack()

	--self.Weapon:SetNextPrimaryFire(CurTime() + 2)
	
	if CLIENT then
		--if mode > 1 then self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER) end
		return 
	end
	
	if mode < 2 then return end

	local ply = self.Owner
	local trace = ply:GetEyeTrace()
	
	if trace.StartPos:Distance(trace.HitPos) > 48 then return end
	
	local ent = trace.Entity
	
	if ent.BreakOpen then
		
		self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER)	
		ply:SetAnimation( PLAYER_ATTACK1 )
		
		-- prevent spamming
		if ent.BreakOpenBroken == true then
			DarkRP.notify(ply, 0, 4, "Service hatch has been jammed.")
			return
		end
		
		-- spark effect
		local effectdata = EffectData()
		effectdata:SetStart( ent:GetPos() ) // not sure if ( we need a start and origin ( endpoint ) for this effect, but whatever
		effectdata:SetOrigin( ent:GetPos() )
		effectdata:SetScale( 1 )
		util.Effect( "StunstickImpact", effectdata, true, true )
		
		-- break open sound
		if not ent.BreakOpenSilent and not ent.BreakOpenAlarming then
			ent:EmitSound("eli_lab.firebell_loop_1")
			ent.BreakOpenAlarming = true
			timer.Simple(60, function()
				ent:StopSound("eli_lab.firebell_loop_1")
				ent.BreakOpenAlarming = false
			end)
		end
		
		-- break open attempt
		if trace.Entity.BreakOpenHealth > 0 then
			trace.Entity.BreakOpenHealth = trace.Entity.BreakOpenHealth - 1
			
			net.Start("crowbar_breakin")
				net.WriteInt(trace.Entity.BreakOpenHealth, 16)
			net.Send(self.Owner)
			
			--timer.Simple(1, function() 
			local c = table.Random(creak)
			trace.Entity:EmitSound(c)
				--self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
			--end)
			
			local ply = self.Owner
			
			ply.BraxCrowbarFreeze = true
			
			self.Owner:Freeze(true)
			timer.Simple(2, function()
				if not IsValid(ply) then return end
				ply:Freeze(false) 
				ply.BraxCrowbarFreeze = false
			end)
			
			return
		end
		
		-- break open for real
		if ent.BreakOpenBroken == false then
		
			ent:BreakOpen(self.Owner)
			ent.BreakOpenBroken = true
			DarkRP.notify(ply, 0, 4, "You broke in. Are you proud of yourself?")
			timer.Simple(GetConVarNumber("brax_crowbar_repair"), function()
				ent.BreakOpenBroken = false
				ent.BreakOpenHealth = ent.BreakOpenHealthMax
			end)

			ent:EmitSound("physics/metal/metal_box_break2.wav")

			return
		end
		
	end

end