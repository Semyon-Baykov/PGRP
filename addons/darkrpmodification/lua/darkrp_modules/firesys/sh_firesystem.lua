ENT = {}

ENT.Base = "base_gmodentity"

ENT.PrintName = 'Fire'

ENT.Author = 'SnOOp{!}'

ENT.Category = 'GportalRP'

ENT.Editable = false

ENT.Spawnable = false

ENT.AdminOnly = true
 

if SERVER then 

	SFires = SFires or {}

	function ENT:Think()

		if not self.snd or not self.snd:IsPlaying() then

			self.snd = CreateSound( self, 'ambient/fire/fire_med_loop1.wav' )

			self.snd:PlayEx( 1, 80 )

		end

		if self.fire and not IsValid( self.fire ) then

			self:Remove()

			return 

		end

		for k, v in pairs( ents.FindInSphere( self:GetPos(), 60 ) ) do

			if not IsValid( v ) or not v then continue end

			if v:IsPlayer() and ( not v:Alive() or v:HasGodMode() ) then continue end

			if v:GetClass() == 'env_fire' or v:GetClass() == 'sfire' then continue end

			if v:IsVehicle() then continue end


			local trace = util.TraceLine( {

				start = self:GetPos(),

				endpos = v:GetPos()

			} )

			if trace.Entity != v then continue end

			v:Ignite( v:IsPlayer() and 10 or 20 )

		end

	end

	function ENT:OnRemove()

		self.snd:Stop()

		self.fire:Remove()

		table.RemoveByValue( SFires[ self.ifire ], self )

		timer.Destroy( 'SFire' .. self:EntIndex() )

		timer.Destroy( 'SFire_delete' .. self:EntIndex() )

	end

	function ENT:Initialize()

		local id = self:EntIndex()

		if not self.ifire then

			SFires[ id ] = {}

			self.ifire = id

		end

		table.insert( SFires[ self.ifire ], self )

		self:SetModel( 'models/weapons/w_bullet.mdl' )

		self:SetNoDraw( true )

		self:DrawShadow( false )

		self:SetCollisionGroup( 1 )

		self:DropToFloor()


		self.snd = CreateSound( self, 'ambient/fire/fire_med_loop1.wav' )

		self.snd:PlayEx( 1, 80 )


		self.counter = ( self.counter or 0 ) + 1


		local fire = ents.Create( 'env_fire' )

		fire:SetParent( self )

		fire:SetPos( self:GetPos() )

		fire:SetKeyValue( 'spawnflags', tostring( 128 + 32 + 4 + 2 + 1 ) )

		fire:SetKeyValue( 'firesize', ( math.random( 100, 120 ) * math.Rand( 0.7, 1.1 ) ) )

		fire:SetKeyValue( 'fireattack', 2 )

		fire:SetKeyValue( 'health', 50 )

		fire:SetKeyValue( 'damagescale', '1' )

		fire:Spawn()

		fire:Activate()

		fire.sfire = self

		self.fire = fire

		timer.Create( 'SFire_delete' .. id, 1800, 1, function() if IsValid( fire ) then fire:Remove() end end )

		timer.Create( 'SFire' .. id, 6, 0, function()

			if not IsValid( self ) then timer.Destroy( 'SFire' .. id ) return end

			for i = 1, math.random( 4, 8 ) do

				local pos = self:GetPos() + Vector( math.sin( i ) * 60, math.cos( i ) * 60, 0 )

				local canspawn = true

				for k, v in pairs( ents.FindInSphere( pos, 50 ) ) do

					if ( v:GetClass() == 'sfire' or v:GetClass() == 'env_fire' ) and v != self and v != self.fire then

						canspawn = false

					end

				end

				local trace = util.TraceLine( {

					start = self:GetPos(),

					endpos = pos

				} )


				if not canspawn or trace.Fraction != 1 then continue end
				
				local fire = ents.Create( 'sfire' )

				if not IsValid( fire ) then return end

				fire:SetPos( pos )

				fire.ifire = self.ifire

				fire.counter = self.counter + 1

				fire:Spawn()

				self.counter = self.counter + 1

				if self.counter > 10 or fire:WaterLevel() < 0 then 
	
					timer.Destroy( 'SFire' .. fire:EntIndex() ) 

					timer.Destroy( 'SFire' .. id ) 

					fire:Remove() 

					return 

				end

			end

		end )

	end


end

scripted_ents.Register( ENT, 'sfire' )
