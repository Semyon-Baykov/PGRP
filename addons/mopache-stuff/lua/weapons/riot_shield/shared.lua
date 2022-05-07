if SERVER then
  AddCSLuaFile( "shared.lua" )
	
	resource.AddFile("models/arleitiss/riotshield/shield.mdl")
	resource.AddFile("models/arleitiss/riotshield/shield.dx80.vtx")
	resource.AddFile("models/arleitiss/riotshield/shield.dx90.vtx")
	resource.AddFile("models/arleitiss/riotshield/shield.phy")
	resource.AddFile("models/arleitiss/riotshield/shield.sw.vtx")
	resource.AddFile("models/arleitiss/riotshield/shield.vvd")
	resource.AddFile("materials/arleitiss/riotshield/riot_metal.vmt")
	resource.AddFile("materials/arleitiss/riotshield/riot_metal_bump.vtf")
	resource.AddFile("materials/arleitiss/riotshield/shield_cloth.vmt")
	resource.AddFile("materials/arleitiss/riotshield/shield_edges.vmt")
	resource.AddFile("materials/arleitiss/riotshield/shield_glass.vmt")
	resource.AddFile("materials/arleitiss/riotshield/shield_grip.vmt")
	resource.AddFile("materials/arleitiss/riotshield/shield_gripbump.vtf")	
end



if (CLIENT) then
SWEP.PrintName = "Щит"
SWEP.Category = "MoPachE"
SWEP.Slot = 3
SWEP.SlotPos = 1
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.Author = "MoPachE"
SWEP.Contact = "Цой Якут"
SWEP.Purpose = "'Блокирует немного дамага"
end

SWEP.HoldType			= "pistol"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.AnimPrefix	 = "rpg"
SWEP.Primary.Damage         = 0
SWEP.Primary.ClipSize       = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic      = true
SWEP.Primary.Delay = 1.1
SWEP.Primary.Ammo       = "none"

SWEP.Primary.ClipSize  = -1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic  = true
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

SWEP.WorldModel = "models/arleitiss/riotshield/shield.mdl"
SWEP.ViewModel = ""

function SWEP:Deploy()
	if SERVER then
		if IsValid(self.ent) then return end
		self:SetNoDraw(true)
		self.ent = ents.Create("prop_physics")
			self.ent:SetModel("models/arleitiss/riotshield/shield.mdl")
			self.ent:SetPos(self.Owner:GetPos() + Vector(10,0,15) + (self.Owner:GetForward()*27))
			self.ent:SetAngles(Angle(0,self.Owner:EyeAngles().y,self.Owner:EyeAngles().r))
			self.ent:SetParent(self.Owner)
			self.ent:Fire("SetParentAttachmentMaintainOffset", "eyes", 0.01)
			self.ent:SetCollisionGroup( COLLISION_GROUP_WORLD )
			self.ent:Spawn()
			self.ent:Activate()
	end
	
	return true
end

function SWEP:PrimaryAttack()

end

function SWEP:Holster()
	if SERVER then
		if not IsValid(self.ent) then return end
		self.ent:Remove()
	end
	return true
end

function SWEP:OnDrop()
	if SERVER then
		self:SetColor(Color(255,255,255,255))
		if not IsValid(self.ent) then return end
		self.ent:Remove()
	end
end

function SWEP:OnRemove()
	if SERVER then
		self:SetColor(Color(255,255,255,255))
		if not IsValid(self.ent) then return end
		self.ent:Remove()
	end
end



