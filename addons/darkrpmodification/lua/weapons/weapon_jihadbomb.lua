AddCSLuaFile()

SWEP.PrintName = 'Джихадка'

SWEP.Author = 'какой-то пидор & SnOOp{!}'

SWEP.Instructions = 'ЛКМ - взорвать все.'

SWEP.Purpose = 'чечня круто'


SWEP.Slot = 3

SWEP.SlotPos = 0

SWEP.Weight	= 5


SWEP.DrawAmmo = false 

SWEP.DrawCrosshair = false 


SWEP.Spawnable = true 

SWEP.AdminSpawnable = true


SWEP.ViewModel = 'models/weapons/v_jb.mdl'

SWEP.WorldModel = 'models/weapons/w_jb.mdl'



SWEP.AutoSwitchTo = false

SWEP.AutoSwitchFrom	= false


SWEP.Primary.ClipSize = -1

SWEP.Primary.DefaultClip = -1

SWEP.Primary.Automatic = false

SWEP.Primary.Ammo = 'none'

SWEP.Primary.Delay = 3


SWEP.Secondary.ClipSize	= -1

SWEP.Secondary.DefaultClip = -1

SWEP.Secondary.Automatic = false

SWEP.Secondary.Ammo	= 'none'


SWEP.last_reload = 0


function SWEP:Initialize()

	util.PrecacheSound( 'siege/big_explosion.wav' )

   	util.PrecacheSound( 'siege/jihad.wav' )


  	 self:SetHoldType( 'slam' )

end

function SWEP:Reload()

	if CurTime() - self.last_reload <= 2 then return end

	self.Owner:EmitSound( 'siege/jihad.wav' )

	self.last_reload = CurTime()

end



function SWEP:PrimaryAttack()

	self.Weapon:SetNextPrimaryFire( CurTime() + 3 )


	local effectdata = EffectData()

	effectdata:SetOrigin( self.Owner:GetPos() )
		
	effectdata:SetNormal( self.Owner:GetPos() )
		
	effectdata:SetMagnitude( 8 )
		
	effectdata:SetScale( 1 )
		
	effectdata:SetRadius( 16 )

	util.Effect( 'Sparks', effectdata )


	self.BaseClass.ShootEffects( self )


	if SERVER then

		timer.Simple( 2, function() if IsValid( self ) then self:Explode() end end )

		self.Owner:EmitSound( 'siege/jihad.wav' )

	end

end

function SWEP:SecondaryAttack()

	local TauntSound = Sound( 'vo/npc/male01/overhere01.wav' )

	self.Weapon:SetNextSecondaryFire( CurTime() + 1 )

	self.Weapon:EmitSound( TauntSound )


	if not SERVER then return end

	self.Weapon:EmitSound( TauntSound )

end

function SWEP:Explode()

	if not IsValid( self.Owner ) then return end

	local ent = ents.Create( 'env_explosion' )

	ent:SetPos( self.Owner:GetPos() )

	ent:SetOwner( self.Owner )

	ent:Spawn()


	ent:SetKeyValue( 'iMagnitude', '250' )

	ent:Fire( 'Explode', 0, 0 )


	ent:EmitSound( 'siege/big_explosion.wav', 100, 100 )


	self.Owner:Kill()

	self.Owner:AddFrags( -1 )

 
	for k, v in pairs( player.GetAll() ) do

	  v:ConCommand( 'play siege/big_explosion.wav\n' )

	end

end

function SWEP:DrawWorldModel()

    if not IsValid( self.Owner ) then 

        self:DrawModel()

        return

    end

    if not self.Hand then

        self.Hand = self.Owner:LookupAttachment( 'anim_attachment_rh' )
        
    end

    local hand = self.Owner:GetAttachment( self.Hand )

    if not hand then

    	hand = { Pos = self:GetPos(), Ang = self:GetAngles() }

    end

    self:SetRenderOrigin( hand.Pos + self.Owner:GetRight() * 5 + self.Owner:GetUp() * 5 )

    self:SetRenderAngles( hand.Ang + Angle( 45, 0, 0 ) )

    self:DrawModel()

end
