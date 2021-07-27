SWEP.HoldType               = "slam"

if CLIENT then
   SWEP.PrintName           = "C4"
   SWEP.Slot                =  2
   
   SWEP.ViewModelFlip      = false
   SWEP.ViewModelFOV       = 54
   SWEP.DrawCrosshair      = false
end


SWEP.UseHands               = true
SWEP.ViewModel              = Model('models/weapons/cstrike/c_c4.mdl')
SWEP.WorldModel             = Model('models/weapons/w_c4.mdl')

SWEP.Primary.ClipSize       = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic      = true
SWEP.Primary.Ammo           = 'none'
SWEP.Primary.Delay          = 5.0

SWEP.Secondary.ClipSize     = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic    = true
SWEP.Secondary.Ammo         = 'none'
SWEP.Secondary.Delay        = 1.0

SWEP.NoSights               = true
function SWEP:PrimaryAttack()
   self:BombStick()
end

function SWEP:SecondaryAttack()
   self:BombStick()
end
local throwsound = Sound( "Weapon_SLAM.SatchelThrow" )

-- again replicating slam, now its attach fn
function SWEP:BombStick()
   if SERVER then
      local ply = self:GetOwner()
      if not IsValid(ply) then return end

      if self.Planted then return end

      local ignore = {ply, self}
      local spos = ply:GetShootPos()
      local epos = spos + ply:GetAimVector() * 80
      local tr = util.TraceLine({start=spos, endpos=epos, filter=ignore, mask=MASK_SOLID})

      if tr.HitWorld then
         local bomb = ents.Create("gp_c4")
         if IsValid(bomb) then
            bomb:PointAtEntity(ply)

            local tr_ent = util.TraceEntity({start=spos, endpos=epos, filter=ignore, mask=MASK_SOLID}, bomb)

            if tr_ent.HitWorld then

               local ang = tr_ent.HitNormal:Angle()
               ang:RotateAroundAxis(ang:Right(), -90)
               ang:RotateAroundAxis(ang:Up(), 180)

               bomb:SetPos(tr_ent.HitPos)
               bomb:SetAngles(ang)
               bomb:SetOwner(ply)
               bomb:Spawn()

               bomb.fingerprints = self.fingerprints

               local phys = bomb:GetPhysicsObject()
               if IsValid(phys) then
                  phys:EnableMotion(false)
               end

               bomb.IsOnWall = true

               self:Remove()

               self.Planted = true

            end
         end

         ply:SetAnimation( PLAYER_ATTACK1 )
      end
   end
end

function SWEP:Reload()
   return false
end

function SWEP:OnRemove()
   if CLIENT and IsValid(self:GetOwner()) and self:GetOwner() == LocalPlayer() and self:GetOwner():Alive() then
      RunConsoleCommand("lastinv")
   end
end
