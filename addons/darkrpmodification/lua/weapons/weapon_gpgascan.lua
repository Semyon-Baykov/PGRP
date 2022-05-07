SWEP.PrintName = 'Канистра с топливом'
SWEP.Author = 'KaiL'

SWEP.AdminSpawnable = true
SWEP.Spawnable = true

SWEP.ViewModel = 'models/props_junk/gascan001a.mdl'
SWEP.WorldModel = 'models/props_junk/gascan001a.mdl'

SWEP.HoldType = 'slam'

SWEP.base = 'weapon_base'

SWEP.Category = 'GPortalRP'

game.AddAmmoType( { name = "gas" } )

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 500
SWEP.Primary.Ammo	 = "gas"
SWEP.Primary.Automatic = true
SWEP.MaxDistance            = 120
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip	 = -1
SWEP.Secondary.Ammo = "none"


SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false

SWEP.Irons = {
    Normal = {
        Pos = Vector( 68.67, -30, -35 ),
        Ang = Vector( 3.95, 86.76, -24.98 ),
    },
 
    Pour = {
        Pos = Vector( 68.67, -30, -55 ),
        Ang = Vector( 3.95, 86.76, -34.98 ),     
    },
}

SWEP.Offset = {
    Pos = {
        Right = -5,
        Forward = 3,
        Up = -4,
    },
    Ang = {
        Right = 1,
        Forward = 20,
        Up = 122,
    },
    Scale = Vector( .5, .5, .5 ),
}


function SWEP:Deploy()

    self:SetNextPrimaryFire( CurTime() + self:SequenceDuration() )

end


function SWEP:Initialize()

	self:SetHoldType( self.HoldType )

end


function SWEP:DrawWorldModel()
   
    if not IsValid( self.Owner ) then
        return self:DrawModel( )
    end
    
    local offset, hand
    
    self.Hand2 = self.Hand2 or self.Owner:LookupAttachment( "anim_attachment_rh" )
    
    hand = self.Owner:GetAttachment( self.Hand2 )
    
    if not hand then
        return
    end
    
    offset = hand.Ang:Right( ) * self.Offset.Pos.Right + hand.Ang:Forward( ) * self.Offset.Pos.Forward + hand.Ang:Up( ) * self.Offset.Pos.Up
    
    hand.Ang:RotateAroundAxis( hand.Ang:Right( ), self.Offset.Ang.Right )
    hand.Ang:RotateAroundAxis( hand.Ang:Forward( ), self.Offset.Ang.Forward )
    hand.Ang:RotateAroundAxis( hand.Ang:Up( ), self.Offset.Ang.Up )
    
    self:SetRenderOrigin( hand.Pos + offset )
    self:SetRenderAngles( hand.Ang )
    
    self:SetModelScale( .5, 0 )
    
    self:DrawModel( )

end

function SWEP:GetViewModelPosition( pos, ang )
   
    local b, r, u, f, n, x, y, z, to, from
    
    b = self.Pouring
    
    if b == nil then
        b = false
    end
    
    if b ~= self.LastIron then
        self.BlendProgress = 0
        self.LastIron = b
    end
    
    self.SwayScale    = 1.0
    self.BobScale    = 1.0
    
    if b then
        to = self.Irons.Pour
        from = self.Irons.Normal
    else
        to = self.Irons.Normal
        from = self.Irons.Pour 
    end
    
    self.BlendProgress = math.Approach( self.BlendProgress, 1, FrameTime( ) * 2 )
    
    n = 1 - self.BlendProgress
    
    r, u, f = ang:Right( ), ang:Up( ), ang:Forward( )
    x = to.Ang.x * self.BlendProgress + from.Ang.x * n
    y = to.Ang.y * self.BlendProgress + from.Ang.y * n
    z = to.Ang.z * self.BlendProgress + from.Ang.z * n
    
    ang:RotateAroundAxis( r, x )
    ang:RotateAroundAxis( u, y )
    ang:RotateAroundAxis( f, z )
        
    r, u, f = ang:Right( ), ang:Up( ), ang:Forward( )
    
    x = to.Pos.x * self.BlendProgress + from.Pos.x * n
    y = to.Pos.y * self.BlendProgress + from.Pos.y * n
    z = to.Pos.z * self.BlendProgress + from.Pos.z * n
       
    pos = pos + x * r
    pos = pos + y * f
    pos = pos + z * u
    
    return pos, ang

end

function SWEP:IsAimingAt( vpos )
    if not IsValid( self.Owner ) then return false end
    local dir = self.Owner:GetAimVector()
    local pos = self.Owner:GetShootPos()
    local des_dir = (vpos - pos):GetNormalized()
    
    local dist = (pos - vpos):Length()
    local ang = math.acos( math.Clamp( dir:Dot(des_dir) ,-1,1) ) * (180 / math.pi)
    
    local IsAimingAt = ang < 5 and dist < self.MaxDistance
    
    return IsAimingAt
end

if SERVER then

	
	
	function SWEP:PrimaryAttack()		
        
        if ( self:GetNextPrimaryFire() > CurTime() ) then return end
        
        if self:Ammo1() <= 0 then

            return

        end

		local ply = self.Owner

		if ply:GetEyeTrace().Entity:IsVehicle() and ply:GetPos():Distance( ply:GetEyeTrace().Entity:GetPos() ) < 150 and self:IsAimingAt( ply:GetEyeTrace().Entity:GetFuelPos() ) then --and not ply:GetEyeTrace().Entity:GetClass() == 'sicknesstowtruck' then

			local veh = ply:GetEyeTrace().Entity

			if veh:GetFuel() >= veh:GetMaxFuel() then
				return
			end

              if ( veh:GetFuel() + 5 ) >= veh:GetMaxFuel() then
            
                  veh:SetFuel( veh:GetMaxFuel() )
                  self.Owner:EmitSound( 'ambient/water/water_spray1.wav' )
                  return
            
              end

              if self:Ammo1()-5 <= 0 then
                  self:Remove()
              end


              self:TakePrimaryAmmo( 5 )

              veh:SetFuel( veh:GetFuel() + 5 )
              self.Owner:EmitSound( 'ambient/water/water_spray1.wav' )
		end

                self:SetNextPrimaryFire( CurTime() + 0.5 )

	end

	function SWEP:SecondaryAttack()
	end
end

if CLIENT then
	
	function SWEP:PrimaryAttack()
	end

	function SWEP:SecondaryAttack()
	end

    local fuelposmat = Material( "sprites/fuelfiller_icon" )
 
    function SWEP:DrawHUD()

		if self.Owner:InVehicle() then return end

		if self.Owner:GetEyeTrace().Entity:IsVehicle() and self.Owner:GetPos():Distance( self.Owner:GetEyeTrace().Entity:GetPos() ) < 150 then --and not self.Owner:GetEyeTrace().Entity:GetClass() == 'sicknesstowtruck' then

            local ent = self.Owner:GetEyeTrace().Entity

			draw.RoundedBox( 0, ScrW()/2-75, ScrH()/2-50, 150, 21, Color( 0, 0, 0, 200 ) )

			draw.RoundedBox( 0, ScrW()/2-74, ScrH()/2-49, self.Owner:GetEyeTrace().Entity:GetFuel() / self.Owner:GetEyeTrace().Entity:GetMaxFuel()  * 148, 19, Color( 248, 244, 0 ) )

			draw.SimpleTextOutlined( math.ceil(self.Owner:GetEyeTrace().Entity:GetFuel() / self.Owner:GetEyeTrace().Entity:GetMaxFuel()  * 100 )..'%', 'Trebuchet24', ScrW()/2, ScrH()/2-39, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )

                               draw.SimpleTextOutlined( 'Содержимое канистры: '..self:Ammo1()..'/500', 'Trebuchet24', ScrW()/2, ScrH()/2-65, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )

		    local fuelpos = ent:GetFuelPos()
            local IsAimingAt = self:IsAimingAt( fuelpos )
            local col = IsAimingAt and Color(0,255,0,50) or Color(255,255,255,255)
            local size = IsAimingAt and 4 or 8
          
            cam.Start3D()
                render.SetMaterial( fuelposmat )
                render.DrawSprite( fuelpos, size, size, col )
            cam.End3D()
        

        end

	end

end
