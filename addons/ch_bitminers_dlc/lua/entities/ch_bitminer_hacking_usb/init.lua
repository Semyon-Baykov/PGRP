AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function ENT:Initialize()
	self:SetModel( "models/craphead_scripts/bitminers/dlc/usb.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetHealth( CH_Bitminers_DLC.Config.HackingUSBHealth )
	self:PhysWake()
	
	self:CPPISetOwner( self:Getowning_ent() )
end

function ENT:OnTakeDamage( dmg )
	if ( not self.m_bApplyingDamage ) then
		self.m_bApplyingDamage = true
		
		self:SetHealth( ( self:Health() or CH_Bitminers_DLC.Config.HackingUSBHealth ) - dmg:GetDamage() )
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
	
	-- Don't allow if bitminer is currently being hacked already
	if bitminer.IsBeingHacked then
		DarkRP.notify( usb_owner, 1, CH_Bitminers_DLC.Config.NotificationTime, CH_Bitminers_DLC.Config.Lang["This bitminer is already being hacked!"][CH_Bitminers_DLC.Config.Language] ) 
		return
	end

	-- Don't allow if not powered on
	if not bitminer:GetIsMining() or not bitminer:GetHasPower() then
		DarkRP.notify( usb_owner, 1, CH_Bitminers_DLC.Config.NotificationTime, CH_Bitminers_DLC.Config.Lang["You cannot hack a bitminer that is not powered on!"][CH_Bitminers_DLC.Config.Language] )
		return
	end

	-- Don't allow if already hacked
	if bitminer:GetIsHacked() then
		DarkRP.notify( usb_owner, 1, CH_Bitminers_DLC.Config.NotificationTime, CH_Bitminers_DLC.Config.Lang["This bitminer is already successfully hacked!"][CH_Bitminers_DLC.Config.Language] )
		return
	end

	-- ALL GOOD - START HACKING SHELF
	bitminer.IsBeingHacked = true
	self.IsConnectedToBitminer = true
	
	-- Notify hacker that we're starting the hacking process
	DarkRP.notify( usb_owner, 1, CH_Bitminers_DLC.Config.NotificationTime, CH_Bitminers_DLC.Config.Lang["You've started hacking this bitminer. Wait until the hacking has finished to access the bitminer."][CH_Bitminers_DLC.Config.Language] )
	DarkRP.notify( usb_owner, 1, CH_Bitminers_DLC.Config.NotificationTime, CH_Bitminers_DLC.Config.Lang["Stay close to the bitminer or else the hacking process will fail!"][CH_Bitminers_DLC.Config.Language] )
	
	-- Network it to the bitminer screen
	net.Start( "CH_BITMINERS_DLC_StartHacking" )
		net.WriteDouble( CH_Bitminers_DLC.Config.BitminerHackingTime )
		net.WriteEntity( bitminer )
	net.Broadcast()
	
	-- Place USB on shelf
	local usb_pos = bitminer:WorldToLocal( bitminer:GetAttachment( 1 ).Pos )
	local usb_ang = bitminer:GetAngles()

	usb_pos = Vector( usb_pos.x - 6.75, usb_pos.y + 22.3, usb_pos.z + 2.1 )
	usb_ang = Angle( usb_ang.x + 180, usb_ang.y - 178, usb_ang.z - 37.5 )

	self:SetParent( bitminer )
	self:SetPos( usb_pos )
	self:SetAngles( usb_ang )
	
	-- bLogs support
	hook.Run( "CH_BITMINER_DLC_PlayerStartedHacking", usb_owner, bitminer_owner )

	-- CHECK IF SUCCESSFUL
	timer.Simple( CH_Bitminers_DLC.Config.BitminerHackingTime, function()
		if IsValid( bitminer ) and IsValid( usb_owner ) then
			-- Hacking finished
			bitminer.IsBeingHacked = false
			
			-- Remove usb entity if valid (should be valid, but who knows)
			if IsValid( self ) then
				SafeRemoveEntityDelayed( self, 0 )
			end

			-- Check distance between bitminer and hacker (FAILED)
			if bitminer:GetPos():DistToSqr( usb_owner:GetPos() ) > CH_Bitminers_DLC.Config.BitminerHackingDistance then
				DarkRP.notify( usb_owner, 1, CH_Bitminers_DLC.Config.NotificationTime, CH_Bitminers_DLC.Config.Lang["You are too far away from the bitminer shelf and the hacking has failed!"][CH_Bitminers_DLC.Config.Language] )
				
				-- bLogs support
				hook.Run( "CH_BITMINER_DLC_PlayerFailedHacking", usb_owner, bitminer_owner )
				return
			end
			
			-- Randomize chance to FAIL
			local chance = math.random( 1, 100 )

			if chance <= CH_Bitminers_DLC.Config.HackingFailChance then
				DarkRP.notify( self.Owner, 1, CH_Bitminers_DLC.Config.NotificationTime, CH_Bitminers_DLC.Config.Lang["Your attempt at hacking the bitminer has failed!"][CH_Bitminers_DLC.Config.Language] )
				
				-- bLogs support
				hook.Run( "CH_BITMINER_DLC_PlayerFailedHacking", usb_owner, bitminer_owner )
				return 
			end
			
			-- Passed checks, hacking successfully completed.
			DarkRP.notify( usb_owner, 1, CH_Bitminers_DLC.Config.NotificationTime, CH_Bitminers_DLC.Config.Lang["Hacking completed! The bitminer is now unlocked."][CH_Bitminers_DLC.Config.Language] )

			bitminer:SetIsHacked( true )
			
			-- XP System Support
			-- Give experience support for Vronkadis DarkRP Level System
			if CH_Bitminers_DLC.Config.DarkRPLevelSystemEnabled then
				usb_owner:addXP( CH_Bitminers_DLC.Config.XPHackingReward, true )
			end
		
			-- Give experience support for Sublime Levels
			if CH_Bitminers_DLC.Config.SublimeLevelSystemEnabled then
				usb_owner:SL_AddExperience( CH_Bitminers_DLC.Config.XPHackingReward, CH_Bitminers_DLC.Config.Lang["for successfully hacking a bitminer."][CH_Bitminers_DLC.Config.Language] )
			end
			
			if CH_Bitminers_DLC.Config.EXP2SystemEnabled then
				EliteXP.CheckXP( usb_owner, CH_Bitminers_DLC.Config.XPHackingReward )
			end
			
			-- bLogs support
			hook.Run( "CH_BITMINER_DLC_PlayerSuccessfulHacking", usb_owner, bitminer_owner )
		end
	end )
end