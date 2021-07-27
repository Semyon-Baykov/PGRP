if( SERVER ) then
	SWEP.PrintName = "Drugs Checker"
end

if( CLIENT ) then
	SWEP.PrintName = "Проверка на наркотики"
	SWEP.Slot = 3
	SWEP.SlotPos = 1
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
end

SWEP.HoldType = "knife"


SWEP.UseHands = true




SWEP.Category = "Other"
SWEP.Author			= "SaVav"
SWEP.Instructions	= ""
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Primary.Damage		= 0
SWEP.Primary.Ammo		= "none"
SWEP.Primary.Automatic		= true

SWEP.ViewModelFOV = 60
SWEP.ViewModelFlip	= false

SWEP.Spawnable			= true 
SWEP.AdminSpawnable		= false
  
SWEP.ViewModel = ""
SWEP.WorldModel = ""

SWEP.Secondary.ClipSize		= -1					
SWEP.Secondary.DefaultClip	= -1					
SWEP.Secondary.Automatic	= false				
SWEP.Secondary.Ammo		= "none"
SWEP.COUTDONW = 0


function SWEP:Precache()

end

function SWEP:Initialize()
    self:SetWeaponHoldType("knife")
end

function SWEP:Deploy()

	return true
end

function SWEP:Think()
local ply = self.Owner

if ply:GetEyeTrace().Entity:GetClass() != "prop_physics" then
self.COUTDONW = 0
end

end

function SWEP:PrimaryAttack()
local ply = self.Owner

if ply:GetEyeTrace().Entity:GetClass() == "prop_physics" then
if self.COUTDONW < 300 then
self.COUTDONW = self.COUTDONW + 1
ply:PrintMessage( HUD_PRINTCENTER, self.COUTDONW )
end
else
self.COUTDONW = 0
end

if self.COUTDONW == 300 then
if ply:GetEyeTrace().Entity:GetNWFloat( "drug" ) != "0" or ply:GetEyeTrace().Entity:GetNWFloat( "drug" ) == nil then
ply:PrintMessage( HUD_PRINTCENTER, "DRUGS NOT FINDED" )
else
ply:PrintMessage( HUD_PRINTCENTER, "DRUGS FINDED!" )
end	
end

end




function SWEP:Holster()
	if self:GetNextPrimaryFire() > CurTime() then return end
	return true
end



