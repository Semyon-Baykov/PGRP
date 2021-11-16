include( "shared.lua" )

function ENT:Draw()
end

function ENT:Initialize()	
	self.LastFireEffect = 0
	
	self.RandomSound = math.random( 1, 2 )
	
	if self.RandomSound == 1 then
		self.FireSound = CreateSound(self, Sound("ambient/fire/fire_med_loop1.wav"))
		self.SoundDuration = 6.5
	elseif self.RandomSound == 2 then
		self.FireSound = CreateSound(self, Sound("ambient/fire/firebig.wav"))
		self.SoundDuration = 5
	else
		self.FireSound = CreateSound(self, Sound("ambient/fire/fire_big_loop1.wav"))
		self.SoundDuration = 5
	end
	
	self.LastPlay = 0
end

function ENT:Think()	
	if not LocalPlayer():CanSee( self ) and not LocalPlayer():InVehicle() then return end
	
	if self.LastFireEffect + .25 < CurTime() then
		self.LastFireEffect = CurTime()
		
		local FireEffect = EffectData()
		FireEffect:SetOrigin(self:GetPos())
		util.Effect( "fire_effect", FireEffect )
	end
	
	if self.LastPlay + self.SoundDuration < CurTime() then
		self.FireSound:Stop()
		self.FireSound:Play()
		self.LastPlay = CurTime()
	end
end

function ENT:OnRemove()
	self.FireSound:Stop()
end