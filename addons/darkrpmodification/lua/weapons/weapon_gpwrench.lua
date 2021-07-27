SWEP.PrintName = 'Ключ для починки т/с'
SWEP.Author = 'KaiL'

SWEP.AdminSpawnable = true
SWEP.Spawnable = true

SWEP.ViewModel = 'models/weapons/sycreations/kobralost/v_ajustableWrench.mdl'
SWEP.WorldModel = 'models/weapons/sycreations/kobralost/w_ajustableWrench.mdl'

SWEP.HoldType = 'knife'

SWEP.base = 'weapon_base'

SWEP.Category = 'GPortalRP'


SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Ammo	 = "none"
SWEP.Primary.Delay = 1
SWEP.Primary.Automatic = true
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip	 = -1
SWEP.Secondary.Ammo = "none"

if CLIENT then

	SWEP.CustomViewModel = ClientsideModel("models/props_c17/tools_wrench01a.mdl", RENDERGROUP_OPAQUE)
	SWEP.CustomViewModel:SetNoDraw(true)
	SWEP.AnimProgress = 0
	SWEP.AnimProgress2 = 0
	SWEP.PosAng = {}
	SWEP.PosAng.Pos = Vector(0, 0, 0)
	SWEP.PosAng.Ang = Angle(0, 0, 0)
	SWEP.ViewModelFOV	= 50
end

SWEP.DrawCrosshair = false


function SWEP:Initialize()

	self:SetHoldType( self.HoldType )

end



if SERVER then

	SWEP.NextPrimaryAttack = 0
	SWEP.price = 0
	local pr = 250
	function SWEP:PrimaryAttack()


		if ( self.NextPrimaryAttack > CurTime() ) then return end

		self.NextPrimaryAttack = CurTime() + self.Primary.Delay

		


		local ply = self.Owner

		if ply:GetEyeTrace().Entity:IsVehicle() and ply:GetPos():Distance( ply:GetEyeTrace().Entity:GetPos() ) < 150 then--and !ply:GetEyeTrace().Entity:GetClass() == 'sicknesstowtruck' then -- and not Entity:GetName() == "sicknesstowtruck"
			
			local veh = ply:GetEyeTrace().Entity

			local amount = veh:GetCurHealth() + 75

			if veh:GetCurHealth() == veh:GetMaxHealth() then
				return
			end

			if ply:canAfford( 250 ) and amount >= veh:GetMaxHealth() then
				
				ply:addMoney( -250 )
				self.price = self.price + 250
				veh:SetCurHealth( veh:GetMaxHealth() )
				self.Owner:EmitSound( 'ambient/materials/squeekyfloor2.wav' )
			
			end

			if ply:canAfford( 250 )  and amount < veh:GetMaxHealth() then
				
				if veh.Destroyed == true then
					veh.Destroyed = false
				end

				if amount > ( veh:GetMaxHealth() * 0.6 ) then
					veh:SetOnFire( false )
					veh:SetOnSmoke( false )					
				end
				if amount > ( veh:GetMaxHealth() * 0.3 ) then
					veh:SetOnFire( false )
					if amount <= (veh:GetMaxHealth() * 0.6) then
						veh:SetOnSmoke( true )					
					end
				end

				ply:addMoney( -250 )
				self.price = self.price + 250
				veh:SetCurHealth( amount )
				self.Owner:EmitSound( 'ambient/materials/squeekyfloor2.wav' )

			end

		elseif ply:GetEyeTrace().Entity:GetClass() == 'gmod_sent_vehicle_fphysics_wheel' and ply:GetPos():Distance( ply:GetEyeTrace().Entity:GetPos() ) < 150 then
			if ply:canAfford( 100 ) and ply:GetEyeTrace().Entity:GetDamaged() then
					
					ply:GetEyeTrace().Entity:SetDamaged( false )
					ply:addMoney( -100 )
					DarkRP.notify( self.Owner, 0, 10, 'Вы заплатили '..DarkRP.formatMoney(100)..' за починку колеса' )

			end
		end

	end

	function SWEP:SecondaryAttack()
	end
	function SWEP:Think()

		if self.Owner:KeyReleased( IN_ATTACK ) and self.price > 0 then
			DarkRP.notify( self.Owner, 0, 10, 'Вы заплатили '..DarkRP.formatMoney(self.price)..' за починку авто' )
			self.price = 0
		end

	end
end

if CLIENT then


	function SWEP:Initialize()
		self:SetModelScale(.7, 0)
		self.AnimDir = 1
	end
	
	function SWEP:DrawWorldModel()
		if self.Owner and self.Owner:IsValid() then
			local PosAng
			local attach = self.Owner:LookupAttachment("anim_attachment_rh")
			if attach == 0 then
				PosAng = {Pos = Vector(), Ang = Angle()}
			else
				PosAng = self.Owner:GetAttachment(attach)
			end

			self:SetRenderOrigin(PosAng.Pos + PosAng.Ang:Up() * 3)
			PosAng.Ang:RotateAroundAxis(PosAng.Ang:Forward(), 90)
			self:SetRenderAngles(PosAng.Ang)
		end
		self:DrawModel()
	end

		
	function SWEP:ViewModelDrawn(vm)
		local pos, ang = vm:GetBonePosition(0)

		pos = pos + ang:Up() * 200 --Forward
		pos = pos + ang:Right() * 4 --Up
		pos = pos + ang:Forward() * -15 --Right
		ang:RotateAroundAxis(ang:Right(), 180)

		if self.DoAnim then
			self.AnimProgress = self.AnimProgress + FrameTime() * 5 * self.AnimDir
			if self.AnimProgress >= 1 or self.AnimProgress <= -.8 then
				self.AnimDir = -self.AnimDir
			end
		else
			self.AnimProgress = self.AnimProgress - FrameTime() * 5
		end

		self.AnimProgress = math.Clamp(self.AnimProgress, -.8, 1)

		if self.AnimProgress > 0 then
			ang:RotateAroundAxis(ang:Up(), 40 * self.AnimProgress)
		end

		self.CustomViewModel:SetPos(pos)
		self.CustomViewModel:SetAngles(ang)
		self.CustomViewModel:DrawModel()
	end

	function SWEP:DrawHUD()

		if self.Owner:InVehicle() then return end

		if self.Owner:GetEyeTrace().Entity:IsVehicle() and self.Owner:GetPos():Distance( self.Owner:GetEyeTrace().Entity:GetPos() ) < 150 then--and !self.Owner:GetEyeTrace().Entity:GetClass() == 'sicknesstowtruck' then -- !self.Owner:GetEyeTrace().Entity:GetName() == "sicknesstowtruck"
			
			draw.RoundedBox( 0, ScrW()/2-75, ScrH()/2-50, 150, 21, Color( 0, 0, 0, 200 ) )

			draw.RoundedBox( 0, ScrW()/2-74, ScrH()/2-49, self.Owner:GetEyeTrace().Entity:GetCurHealth() / self.Owner:GetEyeTrace().Entity:GetMaxHealth()  * 148, 19, Color( 43, 168, 14, 200 ) )

			draw.SimpleTextOutlined( math.ceil(self.Owner:GetEyeTrace().Entity:GetCurHealth() / self.Owner:GetEyeTrace().Entity:GetMaxHealth()  * 100 )..'%', 'Trebuchet24', ScrW()/2, ScrH()/2-39, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
		
		end

	end

end
