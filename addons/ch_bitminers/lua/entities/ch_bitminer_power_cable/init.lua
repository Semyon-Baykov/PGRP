AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function ENT:Initialize()
	self:SetModel( "models/craphead_scripts/bitminers/utility/plug.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:PhysWake()
	
	self:SetHealth( CH_Bitminers.Config.PowerCableHealth )
	self:SetMaxHealth( CH_Bitminers.Config.PowerCableHealth )
	
	self.IsPluggedIn = false
	self.HasPowerSource = false
	self.ConnectedEntity = nil
	
	self.PowerPlug = ents.Create( "ch_bitminer_power_cable_end" )
	self.PowerPlug:SetPos( self:GetPos() + Vector( 0, 0, 10 ) )
	self.PowerPlug.ConnectedCable = self
	self.PowerPlug:Spawn()
	
	self.Parent = self.PowerPlug

	self.Rope = constraint.Rope( self, self.PowerPlug, 0, 0, self:WorldToLocal( self:GetAttachment( 1 ).Pos ), self.PowerPlug:WorldToLocal( self.PowerPlug:GetAttachment( 1 ).Pos ), CH_Bitminers.Config.CableRopeLenght, 50, 0, 1, "cable/cable2", false )

	-- Set DarkRP owner
	self:CPPISetOwner( self:Getowning_ent() )
	self.PowerPlug:CPPISetOwner( self:Getowning_ent() )
end

function ENT:PlugCable( ent, plugpos, plugang )
	self:SetParent( ent )
	self:SetPos( plugpos )
	self:SetAngles( plugang )
	self:SetMoveType( MOVETYPE_NONE )
end

function ENT:UnplugCable( ent )
	self:SetParent( nil )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetPos( self:GetPos() + ( self:GetAngles():Forward() * - 10 ) + Vector( 0, 0, 5 ) )
	
	if ent:GetClass() == "ch_bitminer_shelf" then
		ent:SetHasPower( false )
		
		-- No longer connected
		self.ConnectedEntity = nil
		ent.ConnectedEntity = nil
		
		-- Stop spin sequence and set skin to off
		ent:PowerOff()
	elseif ent:GetClass() == "ch_bitminer_power_generator" then
		self.HasPowerSource = false
		self.Parent.HasPowerSource = false
		
		-- No longer connected
		self.ConnectedEntity = nil
		ent.ConnectedEntity = nil
	elseif ent:GetClass() == "ch_bitminer_power_solar" then
		ent:SolarPluggedOut()
		
		self.HasPowerSource = false
		self.Parent.HasPowerSource = false
		
		-- No longer connected
		self.ConnectedEntity = nil
		ent.ConnectedEntity = nil
	elseif ent:GetClass() == "ch_bitminer_power_rtg" then
		ent:RTGPluggedOut()
		
		self.HasPowerSource = false
		self.Parent.HasPowerSource = false
		
		-- No longer connected
		self.ConnectedEntity = nil
		ent.ConnectedEntity = nil
	elseif ent:GetClass() == "ch_bitminer_power_combiner" then
		
		ent.ConnectedCables = ent.ConnectedCables - 1
		
		-- Update available slots
		ent.ConnectedCablesTable[ self.ConnectedCableNumber ] = false
		
		-- If the rope was connected to the shelf
		if ent.RopeToShelf == self then
			ent.RopeToShelf = nil
			
			ent:CombinerPluggedOut()
			
			self.HasPowerSource = false
			self.Parent.HasPowerSource = false
			
			-- No longer connected
			ent.ConnectedEntity = nil
		end
		
		self.ConnectedEntity = nil
	end
	
	self.IsPluggedIn = false
	ent.IsPluggedIn = false
	
	if IsValid( self.Parent.ConnectedEntity ) then
		self.Parent:UnplugCable( self.Parent.ConnectedEntity )
	end
end

function ENT:StartTouch( ent )
	if ent:IsPlayer() then
		return
	end
	
	if ( ent.LastTouch or CurTime() ) > CurTime() then
		return
	end
	ent.LastTouch = CurTime() + 0.5
	
	local owner = self:CPPIGetOwner()
	
	if ent:GetClass() == "ch_bitminer_shelf" then
		if ent:GetHasPower() then
			DarkRP.notify( owner, 1, 5, CH_Bitminers.Config.Lang["The bitminer already has a power source connected!"][CH_Bitminers.Config.Language] )
			return
		end
		if not self.HasPowerSource then
			DarkRP.notify( owner, 1, 5, CH_Bitminers.Config.Lang["Please attach the cable to a power source first!"][CH_Bitminers.Config.Language] )
			return
		end
		
		-- If the other end of the cable is connected to a power source then
		self.ConnectedEntity = ent
		ent.ConnectedEntity = self
		
		self.IsPluggedIn = true
		ent.IsPluggedIn = true
		
		self:PlugCable( ent, ent:WorldToLocal( ent:GetAttachment( 2 ).Pos ), ent:GetAttachment( 2 ).Ang )
		
		
		-- If the cable has a connected entity (meaning a power source)
		if IsValid( self.Parent.ConnectedEntity ) then
			local power_source = self.Parent.ConnectedEntity
			
			-- If that power source has > 0 watts then power on the shelf.
			if power_source:GetWattsGenerated() > 0 then
				ent:SetHasPower( true )
			end
		end
	elseif ent:GetClass() == "ch_bitminer_power_generator" then
		if not self.HasPowerSource and not self.Parent.HasPowerSource then
			if not ent.IsPluggedIn then
				self.HasPowerSource = true
				self.Parent.HasPowerSource = true
				
				local parent_pos = self.Parent:GetPos()
				
				self.IsPluggedIn = true
				ent.IsPluggedIn = true
				
				self.ConnectedEntity = ent
				ent.ConnectedEntity = self
				
				self:PlugCable( ent, ent:WorldToLocal( ent:GetAttachment( 2 ).Pos ), ent:GetAttachment( 2 ).Ang )
				
				self.Parent:SetPos( parent_pos )
			end
		end
	elseif ent:GetClass() == "ch_bitminer_power_solar" then
		if not self.HasPowerSource and not self.Parent.HasPowerSource then
			if not ent.IsPluggedIn then
				self.HasPowerSource = true
				self.Parent.HasPowerSource = true
				
				local parent_pos = self.Parent:GetPos()
				
				self.IsPluggedIn = true
				ent.IsPluggedIn = true
				
				self.ConnectedEntity = ent
				ent.ConnectedEntity = self
				
				self:PlugCable( ent, ent:WorldToLocal( ent:GetAttachment( 1 ).Pos ), ent:GetAttachment( 1 ).Ang )
				
				-- Start generating solar power
				ent:SolarPluggedIn()
				
				self.Parent:SetPos( parent_pos )
			end
		end
	elseif ent:GetClass() == "ch_bitminer_power_rtg" then
		if not self.HasPowerSource and not self.Parent.HasPowerSource then
			if not ent.IsPluggedIn then
				self.HasPowerSource = true
				self.Parent.HasPowerSource = true
				
				local parent_pos = self.Parent:GetPos()
				
				self.IsPluggedIn = true
				ent.IsPluggedIn = true
				
				self.ConnectedEntity = ent
				ent.ConnectedEntity = self
				
				self:PlugCable( ent, ent:WorldToLocal( ent:GetAttachment( 1 ).Pos ), ent:GetAttachment( 1 ).Ang )
				
				-- Start generating power from RTG
				ent:RTGPluggedIn()
				
				self.Parent:SetPos( parent_pos )
			end
		end
	elseif ent:GetClass() == "ch_bitminer_power_combiner" then
		if ent.ConnectedCables < 5 then
			local parent_pos = self.Parent:GetPos()
			
			if not ent.RopeToShelf then
				if self.Parent.HasPowerSource then
					DarkRP.notify( owner, 1, 5, CH_Bitminers.Config.Lang["Please attach the power combiner to a shelf first!"][CH_Bitminers.Config.Language] )
					return
				end
				
				ent.ConnectedCables = ent.ConnectedCables + 1
				
				self.HasPowerSource = true
				self.Parent.HasPowerSource = true
				
				ent.RopeToShelf = self
				
				self.IsPluggedIn = true
				ent.IsPluggedIn = true
				
				self.ConnectedEntity = ent
				ent.ConnectedEntity = self
				
				self:PlugCable( ent, ent:WorldToLocal( ent:GetAttachment( 1 ).Pos ), ent:GetAttachment( 1 ).Ang )
				
				-- Update connected cables overview
				self.ConnectedCableNumber = 1
				ent.ConnectedCablesTable[ 1 ] = true
				
				-- Start giving power from combiner to shelf
				ent:CombinerPluggedInShelf()
			else
				if IsValid( self.Parent.ConnectedEntity ) and self.Parent.ConnectedEntity:GetClass() == "ch_bitminer_power_combiner" then
					return
				end
				ent.ConnectedCables = ent.ConnectedCables + 1
				
				self.IsPluggedIn = true
				
				self.ConnectedEntity = ent
				
				for i = 1, 5, 1 do
					if not ent.ConnectedCablesTable[ i ] then
						-- Plug accordingly to what slot is empty
						self:PlugCable( ent, ent:WorldToLocal( ent:GetAttachment( i ).Pos ), ent:GetAttachment( i ).Ang )
						
						-- Update connected cables overview
						self.ConnectedCableNumber = i
						ent.ConnectedCablesTable[ i ] = true
						break
					end
				end
			end
			
			-- Set pos of cable.
			self.Parent:SetPos( parent_pos )
		end
	end
end

function ENT:Use( activator )
	if IsValid( self:GetParent() ) then
		if self.IsPluggedIn then
			self:UnplugCable( self:GetParent() )
		end
	end
end

function ENT:OnTakeDamage( dmg )
	if ( not self.m_bApplyingDamage ) then
		self.m_bApplyingDamage = true
		
		self:SetHealth( ( self:Health() or 100 ) - dmg:GetDamage() )
		if self:Health() <= 0 then
			self:Destruct()
			self:Remove()
		end
		
		self.m_bApplyingDamage = false
	end
end

function ENT:Destruct()
	local vPoint = self:GetPos()
	local effectdata = EffectData()
	
	effectdata:SetStart( vPoint )
	effectdata:SetOrigin( vPoint )
	effectdata:SetScale( 1 )
	util.Effect( "ManhackSparks", effectdata )
end

function ENT:OnRemove()
	if IsValid( self.Parent ) then
		self.Parent:Remove()
	end
	
	if self.ConnectedEntity then
		self:UnplugCable( self.ConnectedEntity )
	end
end

local function BITMINER_CABLE_PhysgunPickup( ply, ent )
	if ent:GetClass() == "ch_bitminer_power_cable" or ent:GetClass() == "ch_bitminer_power_cable_end" then
		if IsValid( ent:GetParent() ) then
			return false
		else
			return true
		end
	end
end
hook.Add( "PhysgunPickup", "BITMINER_CABLE_PhysgunPickup", BITMINER_CABLE_PhysgunPickup )