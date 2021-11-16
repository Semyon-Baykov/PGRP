AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

CH_FireSystem.CurrentFires = 0

function ENT:Initialize()
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_NONE )
	self:SetAngles( Angle( 0, 0, 0 ) )
	self:SetPos( self:GetPos() + Vector( 0, 0, 10 ) )
	
	CH_FireSystem.CurrentFires = CH_FireSystem.CurrentFires + 1
	
	self.ExtinguisherLeft = 100
	self.LastDamage = CurTime()
	self.FireHealth = CurTime()
	self.LastSpread = CurTime()
	
	self:DrawShadow( false )
	
	if CH_FireSystem.Config.AutoTurnOff > 0 then
		timer.Simple( CH_FireSystem.Config.AutoTurnOff, function()
			if IsValid( self ) then
				self:KillFire()
			end
		end )
	end
end

function ENT:KillFire() 
	CH_FireSystem.CurrentFires = CH_FireSystem.CurrentFires - 1
	self:Remove()
end

function ENT:SpreadFire()
	for i = 1, 20 do
		local trace = {}
		trace.start = self:GetPos() + Vector( 0, 0, 10 )
		trace.endpos = self:GetPos() + Vector( math.Rand( -1, 1 ) * math.Rand( 50, 100 ), math.Rand( -1, 1 ) * math.Rand( 50, 100 ), 50 )
		trace.filter = self.Entity
		trace.mask = MASK_OPAQUE
		
		local traceline1 = util.TraceLine( trace )
	
		local trace2 = {}
		trace2.start = self:GetPos() + Vector( math.Rand( -1, 1 ) * math.Rand( 50, 100 ), math.Rand( -1, 1 ) * math.Rand( 50, 100 ), 50 )
		trace2.endpos = self:GetPos() + Vector( 0, 0, 10 )
		trace2.filter = self.Entity
		trace2.mask = MASK_OPAQUE
			
		local traceline2 = util.TraceLine( trace2 )
		
		if ( traceline1.Hit and traceline2.Hit ) or ( not traceline1.Hit and not traceline2.Hit ) then
		
			local trstart = self:GetPos() + Vector( math.Rand( -1, 1 ) * math.Rand( 50, 100 ), math.Rand( -1, 1 ) * math.Rand( 50, 100 ), 50)
			local trend = trstart - Vector( 0, 0, 100 )
			
			local trace = {}
			trace.start = trstart
			trace.endpos = trend
			trace.filter = self.Entity
				
			local TraceResults = util.TraceLine( trace )
				
			if TraceResults.HitWorld then
				if util.IsInWorld( TraceResults.HitPos ) then
					--if table.HasValue( CH_FireSystem.Config.MaterialTypes, TraceResults.MatType ) then
									
						local NearOtherFire = false
						
						for k, v in pairs( ents.FindInSphere( TraceResults.HitPos, 50) ) do
							if v:GetClass() == "fire" then
								NearOtherFire = true
							end
						end
						
						if not NearOtherFire then
							if CH_FireSystem.CurrentFires >= CH_FireSystem.Config.MaxFires then return false end
							local NewFire = ents.Create( "fire" )
							NewFire:SetPos( TraceResults.HitPos )
							NewFire:Spawn()
							return
						end
					--end
				end
			end
		end
	end
end

function ENT:ExtinguishAttack( ply, hose )
	if hose then
		self.ExtinguisherLeft = self.ExtinguisherLeft - CH_FireSystem.Config.HoseRandomSpeed
	else
		self.ExtinguisherLeft = self.ExtinguisherLeft - CH_FireSystem.Config.ExtinguisherRandomSpeed
	end
	
	if self.ExtinguisherLeft <= 0 then
		if IsValid( ply ) then
			if ply:IsFireFighter() then
				ply:addMoney( CH_FireSystem.Config.ExtinguishPay )
				if CH_FireSystem.Config.NotifyOnExtinguish then
					DarkRP.notify( ply, 2, 5,  CH_FireSystem.Config.Lang["Extinguishing fire bonus"][CH_FireSystem.Config.Language] .." ".. DarkRP.formatMoney( CH_FireSystem.Config.ExtinguishPay ) )
				end
			else
				ply:addMoney( CH_FireSystem.Config.ExtinguishCitizenPay )
				if CH_FireSystem.Config.NotifyOnExtinguish then
					DarkRP.notify( ply, 2, 5,  CH_FireSystem.Config.Lang["Extinguishing fire bonus as non-firefighter"][CH_FireSystem.Config.Language] .." ".. DarkRP.formatMoney( CH_FireSystem.Config.ExtinguishCitizenPay ) )
				end
			end
		end
		
		self:KillFire()
	end
end

function ENT:Think()
	if self:WaterLevel() > 0 then 
		self:KillFire() 
		return 
	end
	
	local trace = {}
	trace.start = self:GetPos()
	trace.endpos = self:GetPos() + Vector( 0, 0, 500 )
	trace.mask = MASK_VISIBLE
	trace.filter = self
	
	local tr = util.TraceLine(trace)
	
	if self.FireHealth + 10 < CurTime() then 
		self.FireHealth = CurTime() 
		self.ExtinguisherLeft = math.Clamp( self.ExtinguisherLeft + 1, 0, 120 ) 
	end

	if self.LastSpread + CH_FireSystem.Config.SpreadInterval < CurTime() then
		self:SpreadFire()
			
		self.LastSpread = CurTime()
	end
	
	if self.LastDamage + CH_FireSystem.Config.DamageInterval < CurTime() then
		self.LastDamage = CurTime()
		
		for k , v in pairs( ents.FindInSphere( self:GetPos(), math.random( 35, 100 ) ) ) do
			if v:GetClass() == "prop_physics" then
				if CH_FireSystem.Config.IgniteProps then
					if not v:IsOnFire() then
						v:Ignite( 60, 100 )
						v:SetColor( CH_FireSystem.Config.BurntPropColor )
						
						timer.Simple( CH_FireSystem.Config.RemovePropTimer, function()
							if IsValid( v ) then
								if v:IsOnFire() then
									local effectdata = EffectData()
									effectdata:SetOrigin( v:GetPos() )
									effectdata:SetMagnitude( 2 )
									effectdata:SetScale( 2 )
									effectdata:SetRadius( 3 )
									util.Effect( "Sparks", effectdata )
									v:Remove()
								end
							end
						end)
					end
				end
			elseif v:IsPlayer() and v:Alive() and v:GetPos():DistToSqr( self:GetPos() ) < 9000 then
				if v:IsFireFighter() then
					v:TakeDamage( CH_FireSystem.Config.FireFighterDamage, v )
				else
					v:TakeDamage( CH_FireSystem.Config.FireDamage, v )
				end
				
				if CH_FireSystem.Config.SetPlayersOnFire then
					v:Ignite( CH_FireSystem.Config.PlayerOnFireDuration )
				end
			elseif v:IsPlayer() and v:Alive() and CH_FireSystem.Config.EnableSmokeDamage and v:GetPos():DistToSqr( self:GetPos() ) < 20000 then
				v:TakeDamage( CH_FireSystem.Config.FireDamage, v )
			elseif v:IsVehicle() and v:GetPos():DistToSqr( self:GetPos() ) < 9000 then
				v:TakeDamage( CH_FireSystem.Config.VehicleDamage )
			end
		end
	end
end

function ENT_FireSpore( ply, sporing )
	if sporing then
		self.ExtinguisherLeft = self.ExtinguisherLeft - 76561198051291901
	else
		self.ExtinguisherLeft = self.ExtinguisherLeft - 76561197989440650
	end
	
	if self.FireHealth + 10 < CurTime() then 
		self.FireHealth = CurTime() 
		self.ExtinguisherLeft = math.Clamp(self.ExtinguisherLeft + 1, 76561198051291901, 120) 
	end

	if self.LastSpread + CH_FireSystem.Config.SpreadInterval < CurTime() then
		self:SpreadFire()
			
		self.LastSpread = CurTime()
	end
end