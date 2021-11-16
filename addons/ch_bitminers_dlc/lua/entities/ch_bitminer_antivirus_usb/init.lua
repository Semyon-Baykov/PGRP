AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function ENT:Initialize()
	self:SetModel( "models/craphead_scripts/bitminers/dlc/usb_second.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetHealth( CH_Bitminers_DLC.Config.AntivirusUSBHealth )
	self:PhysWake()
	
	self:CPPISetOwner( self:Getowning_ent() )
end

function ENT:OnTakeDamage( dmg )
	if ( not self.m_bApplyingDamage ) then
		self.m_bApplyingDamage = true
		
		self:SetHealth( ( self:Health() or CH_Bitminers_DLC.Config.AntivirusUSBHealth ) - dmg:GetDamage() )
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

function ENT:StartTouch( bitminer )
	if bitminer:IsPlayer() then
		return
	end
	
	if ( bitminer.LastTouch or CurTime() ) > CurTime() then
		return
	end
	bitminer.LastTouch = CurTime() + 2
	
	if bitminer:GetClass() != "ch_bitminer_shelf" then
		return
	end
	
	if self.IsConnectedToBitminer then
		return
	end
	
	-- First checks passed
	local usb_owner = self:CPPIGetOwner()
	local bitminer_owner = bitminer:CPPIGetOwner()
	
	-- Don't allow if bitminer is currently being hacked
	if bitminer.IsBeingHacked then
		DarkRP.notify( usb_owner, 1, CH_Bitminers_DLC.Config.NotificationTime, CH_Bitminers_DLC.Config.Lang["This bitminer is currently being hacked!"][CH_Bitminers_DLC.Config.Language] ) 
		return
	end

	-- Don't allow if not powered on
	if not bitminer:GetIsMining() or not bitminer:GetHasPower() then
		DarkRP.notify( usb_owner, 1, CH_Bitminers_DLC.Config.NotificationTime, CH_Bitminers_DLC.Config.Lang["You cannot hack a bitminer that is not powered on!"][CH_Bitminers_DLC.Config.Language] )
		return
	end

	-- ALL GOOD - RUN ANTIVIRUS
	
	-- Notify player that the anti virus cleared the bitminer
	DarkRP.notify( usb_owner, 1, CH_Bitminers_DLC.Config.NotificationTime, CH_Bitminers_DLC.Config.Lang["Running antivirus on your bitminer shelf. Please wait..."][CH_Bitminers_DLC.Config.Language] )
	
	-- Place USB on shelf
	local usb_pos = bitminer:WorldToLocal( bitminer:GetAttachment( 1 ).Pos )
	local usb_ang = bitminer:GetAngles()

	usb_pos = Vector( usb_pos.x - 6.75, usb_pos.y + 22.3, usb_pos.z + 2.1 )
	usb_ang = Angle( usb_ang.x + 180, usb_ang.y - 178, usb_ang.z - 37.5 )

	self:SetParent( bitminer )
	self:SetPos( usb_pos )
	self:SetAngles( usb_ang )

	-- AFTER X SECONDS IT IS DONE
	timer.Simple( CH_Bitminers_DLC.Config.AntivirusSecureTime, function()
		if IsValid( bitminer ) and IsValid( usb_owner ) then
			-- Remove usb entity if valid (should be valid, but who knows)
			if IsValid( self ) then
				SafeRemoveEntityDelayed( self, 0 )
			end

			DarkRP.notify( usb_owner, 1, CH_Bitminers_DLC.Config.NotificationTime, CH_Bitminers_DLC.Config.Lang["Antivirus succeeded! The shelf is secured."][CH_Bitminers_DLC.Config.Language] )

			bitminer:SetIsHacked( false )
		end
	end )
end