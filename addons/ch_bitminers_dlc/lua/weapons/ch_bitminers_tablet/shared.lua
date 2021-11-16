--[[ INFO
models/craphead_scripts/bitminers/dlc/c_mediapad.mdl
models/craphead_scripts/bitminers/dlc/w_mediapad.mdl
FOV: 95
Hold type: pistol
76561198051291901
idle 		ACT_VM_IDLE
use 		ACT_VM_PRIMARYATTACK
withdraw 	ACT_VM_SECONDARYATTACK
draw 		ACT_VM_DRAW
--]]

if SERVER then
	SWEP.Weight				= 5
	SWEP.AutoSwitchTo		= true
	SWEP.AutoSwitchFrom		= true
	AddCSLuaFile( "shared.lua" )
end

if CLIENT then
	SWEP.PrintName			= "Планшет Майнера"
	SWEP.Slot				= 2
	SWEP.SlotPos			= 1
	SWEP.DrawCrosshair 		= false
	SWEP.DrawAmmo			= false
	SWEP.SwayScale			= 0
	SWEP.BobScale			= 0
end

SWEP.Author					= "Crap-Head"
SWEP.Instructions 			= CH_Bitminers_DLC.Config.Lang["Left click: Link your tablet with a bitminer.\nRight click: Withdraw money from your linked bitminer.\nReload: Turn linked bitminer on/off."][CH_Bitminers_DLC.Config.Language]
SWEP.Category 				= "Bitminers by Crap-Head"

SWEP.UseHands				= true
SWEP.ViewModelFOV			= 100

SWEP.ViewModel 				= "models/craphead_scripts/bitminers/dlc/c_mediapad.mdl"
SWEP.WorldModel				= "models/craphead_scripts/bitminers/dlc/w_mediapad.mdl"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= true

SWEP.Primary.Range			= 120
SWEP.Primary.Recoil			= 4.6
SWEP.Primary.Damage			= 100
SWEP.Primary.Cone			= 0.005
SWEP.Primary.NumShots		= 1

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false	
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.HoldType = "pistol"

function SWEP:Initialize()
	self:SetWeaponHoldType( self.HoldType )
	
	self.LinkedBitminer = nil
	
	if CLIENT then
		self.Deployed = false
		
		timer.Simple( 0.9, function()
			if IsValid( self ) then
				self.Deployed = true
			end
		end )
	end
	
    return true
end

function SWEP:Deploy()
	self:SendWeaponAnim( ACT_VM_DRAW )
	local ply = self:GetOwner()
	
	if CLIENT then
		self.Deployed = false
		
		timer.Simple( 0.9, function()
			if IsValid( self ) then
				self.Deployed = true
			end
		end )
	end
	
	if CH_Bitminers_DLC.Config.UseIdleAnimation then
		timer.Simple( 1, function()
			if IsValid( self ) and IsValid( ply ) then
				if ply:GetActiveWeapon():GetClass() == "ch_bitminers_tablet" then
					self:SendWeaponAnim( ACT_VM_IDLE )
				end
			end
		end )
	end
	
	return true
end

function SWEP:Holster( wep )
	self:SendWeaponAnim( ACT_VM_HOLSTER )

	return true
end

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire( CurTime() + 1 )
	self:SetNextSecondaryFire( CurTime() + 1 )
	
	local ply = self:GetOwner()
	local trace = util.GetPlayerTrace( ply )
	local tr = util.TraceLine( trace )

	local ent = tr.Entity
	
	if not IsValid( ent ) then
		return
	end

	if ent:GetPos():DistToSqr( ply:GetPos() ) > CH_Bitminers_DLC.Config.BitminerLinkDistance then
		if SERVER then
			DarkRP.notify( ply, 1, CH_Bitminers_DLC.Config.NotificationTime, CH_Bitminers_DLC.Config.Lang["You need to move closer to the bitminer to link it with the tablet!"][CH_Bitminers_DLC.Config.Language] )
		end
		return
	end
	
	if SERVER then
		if ent:GetClass() == "ch_bitminer_shelf" then
			local bitminer_owner = ent:CPPIGetOwner()

			-- Not linking if not the owner of bitminer is hacked
			if not ent:GetIsHacked() then
				if ply != bitminer_owner then -- person trying to access is not owner
					DarkRP.notify( ply, 1, CH_Bitminers_DLC.Config.NotificationTime, CH_Bitminers_DLC.Config.Lang["Only the owner of this bitminer can link their tablet to it!"][CH_Bitminers.Config.Language] )
					DarkRP.notify( ply, 1, CH_Bitminers_DLC.Config.NotificationTime, CH_Bitminers_DLC.Config.Lang["Hack the bitminer in order to access it!"][CH_Bitminers.Config.Language] )
					return
				end
			end
		
			if self.LinkedBitminer == ent then
				DarkRP.notify( ply, 1, CH_Bitminers_DLC.Config.NotificationTime, CH_Bitminers_DLC.Config.Lang["You've already linked your tablet with this bitminer."][CH_Bitminers_DLC.Config.Language] )
				return
			end
			
			self.LinkedBitminer = ent
			DarkRP.notify( ply, 1, CH_Bitminers_DLC.Config.NotificationTime, CH_Bitminers_DLC.Config.Lang["This bitminer has been linked with your remote tablet."][CH_Bitminers_DLC.Config.Language] )
			
			-- Network it
			net.Start( "CH_BITMINERS_DLC_LinkBitminerRemotely" )
				net.WriteEntity( ent )
				net.WriteEntity( self )
			net.Send( ply )
			
			-- bLogs support
			hook.Run( "CH_BITMINER_DLC_PlayerLinkedBitminer", ply, bitminer_owner )
		else
			DarkRP.notify( ply, 1, CH_Bitminers_DLC.Config.NotificationTime, CH_Bitminers_DLC.Config.Lang["This tablet can only link with bitminers."][CH_Bitminers_DLC.Config.Language] )
		end
	end
end

function SWEP:SecondaryAttack()
	self:SetNextPrimaryFire( CurTime() + 1 )
	self:SetNextSecondaryFire( CurTime() + 1 )
	
	local bitminer = self.LinkedBitminer
	local ply = self:GetOwner()
	
	if bitminer and bitminer:GetHasPower() and bitminer:GetIsMining() then
		self:SendWeaponAnim( ACT_VM_SECONDARYATTACK )
	end
	
	if CH_Bitminers_DLC.Config.UseIdleAnimation then
		timer.Simple( 0.8, function()
			if IsValid( self ) and IsValid( ply ) then
				if ply:GetActiveWeapon():GetClass() == "ch_bitminers_tablet" then
					self:SendWeaponAnim( ACT_VM_IDLE )
				end
			end
		end )
	end
	
	timer.Simple( 0.3, function()
		if IsValid( self ) and IsValid( ply ) then
			if SERVER then
				if not bitminer then
					DarkRP.notify( ply, 1, CH_Bitminers_DLC.Config.NotificationTime, CH_Bitminers_DLC.Config.Lang["Your tablet is not linked with any bitminers."][CH_Bitminers_DLC.Config.Language] )
					return
				end
				
				if not bitminer:GetHasPower() then
					DarkRP.notify( ply, 1, CH_Bitminers_DLC.Config.NotificationTime, CH_Bitminers_DLC.Config.Lang["You cannot exchange bitcoins. Your linked bitminer has no power source!"][CH_Bitminers_DLC.Config.Language] )
					return
				end
				
				if not bitminer:GetIsMining() then
					DarkRP.notify( ply, 1, CH_Bitminers_DLC.Config.NotificationTime, CH_Bitminers_DLC.Config.Lang["You cannot exchange bitcoins. Your linked bitminer is not turned on!"][CH_Bitminers_DLC.Config.Language] )
					return
				end
				
				-- Attempt to withdraw money from bitminer.
				bitminer:WithdrawMoney( ply, true )
			end
		end
	end )
end

function SWEP:Reload()
	local ply = self:GetOwner()
	local tr = ply:GetEyeTrace()
	
	self:SetNextPrimaryFire( CurTime() + 1 )
	self:SetNextSecondaryFire( CurTime() + 1 )
	
	if ( self.CurDelay or CurTime() ) > CurTime() then
		return
	end
	
	self.CurDelay = CurTime() + 2
	
	if SERVER then
		local bitminer = self.LinkedBitminer

		if not bitminer then
			DarkRP.notify( ply, 1, CH_Bitminers_DLC.Config.NotificationTime, CH_Bitminers_DLC.Config.Lang["Your tablet is not linked with any bitminers."][CH_Bitminers_DLC.Config.Language] )
			return
		end
	
		if bitminer:GetHasPower() then -- power source is connected
			if not bitminer:GetIsMining() then
				bitminer:PowerOn()
				
				DarkRP.notify( ply, 1, 5, CH_Bitminers.Config.Lang["You have powered on your bitminers!"][CH_Bitminers.Config.Language] )
			else
				bitminer:PowerOff()
				
				DarkRP.notify( ply, 1, 5, CH_Bitminers.Config.Lang["You have shut down your bitminers!"][CH_Bitminers.Config.Language] )
			end
		else
			DarkRP.notify( ply, 1, 5, CH_Bitminers.Config.Lang["Your bitminer has no active power source."][CH_Bitminers.Config.Language] )
		end
	end
end

if CLIENT then
	-- Cache colors
	local col_blue = Color( 62, 173, 229, 255 )
	
	local col_bg = Color( 20, 20, 20, 255 )
	local col_bar_bg = Color( 62, 62, 62, 100 )
	local col_bar_bg_notrans = Color( 35, 35, 35, 255 )
	
	local col_red = Color( 150, 0, 0, 255 )
	
	local rect_col_green = Color( 0, 100, 0, 255 )
	local rect_col_orange = Color( 240, 137, 19, 255 )
	local rect_col_red = Color( 100, 0, 0, 255 )
	
	-- Circles
	local back_circle_capacity = BITMINERS_UTIL_CreateCircle( 75, 395, 180, 80, 360, 115 ) -- Back circle
	local circle_capacity
	local front_circle_capacity = BITMINERS_UTIL_CreateCircle( 75, 395, 180, 40, 360, 105 ) -- Front circle
	
	-- Cache materials
	local mat_no_linked = Material( "craphead_scripts/bitminers/dlc/tablet_screen/link.png" )
	
	-- Networking
	net.Receive( "CH_BITMINERS_DLC_LinkBitminerRemotely", function( length, ply )
		local bitminer = net.ReadEntity()
		local swep = net.ReadEntity()

		swep.LinkedBitminer = bitminer
	end )
	
	function SWEP:PostDrawViewModel( vm, wep, ply )
		if ( IsValid( vm ) ) then
			local ComPos = vm:GetPos()
			ComPos = ComPos + vm:GetForward() * 11.3 + vm:GetRight() * -3.4 + vm:GetUp() * 2.55
			local ComAng = vm:GetAngles()
			
			ComAng:RotateAroundAxis( ComAng:Forward(), 90 )
			ComAng:RotateAroundAxis( ComAng:Right(), 90 )
			
			if not IsValid( self.LinkedBitminer ) then
				self.LinkedBitminer = nil
			end
			
			if not self.Deployed then
				return
			end
			
			local bitminer = self.LinkedBitminer
			local bitcoin_rate = CH_Bitminers.Config.BitcoinRate
			
			cam.Start3D2D( ComPos, ComAng, 0.01 )
				-- BG
				surface.SetDrawColor( col_bg )
				surface.DrawRect( -185, -140, 1045, 790 )
				
				draw.DrawText( CH_Bitminers_DLC.Config.Lang["Bitminer Remote Tablet"][CH_Bitminers_DLC.Config.Language], "BITMINER_DLC_TabletLarge", 340, -115, color_white, TEXT_ALIGN_CENTER )
				
				-- SPLIT TOP LINE
				surface.SetDrawColor( col_bar_bg_notrans )
				surface.DrawRect( -185, -5, 1045, 7.5 )
				
				if not bitminer then
					surface.SetDrawColor( color_white )
					surface.SetMaterial( mat_no_linked )
					surface.DrawTexturedRect( 120, 70, 400, 400 )
					
					draw.DrawText( CH_Bitminers_DLC.Config.Lang["No Bitminer Linked"][CH_Bitminers_DLC.Config.Language], "BITMINER_DLC_TabletSmall", 340, 550, col_red, TEXT_ALIGN_CENTER )
				elseif not bitminer:GetIsMining() or not bitminer:GetHasPower() then
					draw.DrawText( CH_Bitminers_DLC.Config.Lang["Bitminer Connected"][CH_Bitminers_DLC.Config.Language], "BITMINER_DLC_TabletSmall", 340, 25, rect_col_green, TEXT_ALIGN_CENTER )
					
					if not bitminer:GetHasPower() and not bitminer:GetIsMining() then
						draw.DrawText( CH_Bitminers_DLC.Config.Lang["No Power Source"][CH_Bitminers_DLC.Config.Language], "BITMINER_DLC_TabletSmall", 340, 100, rect_col_red, TEXT_ALIGN_CENTER )
						draw.DrawText( CH_Bitminers_DLC.Config.Lang["Turned Off"][CH_Bitminers_DLC.Config.Language], "BITMINER_DLC_TabletSmall", 340, 175, rect_col_red, TEXT_ALIGN_CENTER )
					elseif not bitminer:GetHasPower() then
						draw.DrawText( CH_Bitminers_DLC.Config.Lang["No Power Source"][CH_Bitminers_DLC.Config.Language], "BITMINER_DLC_TabletSmall", 340, 100, rect_col_red, TEXT_ALIGN_CENTER )
					elseif not bitminer:GetIsMining() then
						draw.DrawText( CH_Bitminers_DLC.Config.Lang["Turned Off"][CH_Bitminers_DLC.Config.Language], "BITMINER_DLC_TabletSmall", 340, 100, rect_col_red, TEXT_ALIGN_CENTER )
					end

				elseif not bitminer:GetHasPower() then
					draw.DrawText( CH_Bitminers_DLC.Config.Lang["Bitminer Connected"][CH_Bitminers_DLC.Config.Language], "BITMINER_DLC_TabletSmall", 340, 25, rect_col_green, TEXT_ALIGN_CENTER )
					draw.DrawText( CH_Bitminers_DLC.Config.Lang["No Power Source"][CH_Bitminers_DLC.Config.Language], "BITMINER_DLC_TabletSmall", 340, 100, rect_col_red, TEXT_ALIGN_CENTER )
				else
					-- SPLIT CENTER LINE
					surface.SetDrawColor( col_bar_bg_notrans )
					surface.DrawRect( 332.5, 0, 7.5, 645 )
					
					-- DRAW HEALTH
					draw.DrawText( CH_Bitminers_DLC.Config.Lang["HEALTH"][CH_Bitminers_DLC.Config.Language], "BITMINER_DLC_TabletSmall", -155, 25, color_white, TEXT_ALIGN_LEFT )
					draw.DrawText( bitminer:Health() .."%", "BITMINER_DLC_TabletSmall", 305, 25, color_white, TEXT_ALIGN_RIGHT )
					
					-- Rect showing health
					surface.SetDrawColor( col_bar_bg_notrans )
					surface.DrawRect( -155, 100, 460, 50 )
					
					if bitminer:Health() >= 75 then
						surface.SetDrawColor( rect_col_green )
					elseif bitminer:Health() >= 50 then
						surface.SetDrawColor( rect_col_orange )
					elseif bitminer:Health() >= 50 then
						surface.SetDrawColor( rect_col_orange )
					else
						surface.SetDrawColor( rect_col_red )
					end
					surface.DrawRect( -155, 100, math.Clamp( bitminer:Health() * 4.6, 0, 460), 50 )
					
					-- DRAW MONEY MINED
					draw.DrawText( CH_Bitminers_DLC.Config.Lang["BITCOINS MINED"][CH_Bitminers_DLC.Config.Language], "BITMINER_DLC_TabletSmall", 75, 170, color_white, TEXT_ALIGN_CENTER )
					if bitcoin_rate then
						draw.DrawText( "1BTC = ".. DarkRP.formatMoney( bitcoin_rate ), "BITMINER_DLC_TabletSmaller", 75, 225, color_white, TEXT_ALIGN_CENTER )
					end

					BITMINERS_UTIL_DrawCircle( back_circle_capacity, col_bar_bg ) -- Back circle
					
					local mined_bitcoins_degrees = 361 * bitminer:GetBitcoinsMined() / CH_Bitminers.Config.MaxBitcoinsMined
					circle_capacity = BITMINERS_UTIL_CreateCircle( 75, 395, 180, 80, math.Clamp( mined_bitcoins_degrees, 0, 361 ), 115 ) -- Money circle
					BITMINERS_UTIL_DrawCircle( circle_capacity, col_blue ) -- Money circle
					
					BITMINERS_UTIL_DrawCircle( front_circle_capacity, col_bar_bg_notrans ) -- Front circle
					
					draw.DrawText( CH_Bitminers_DLC.Config.Lang["CAPACITY"][CH_Bitminers_DLC.Config.Language], "BITMINER_DLC_TabletSmaller", 75, 340, col_white, TEXT_ALIGN_CENTER )
					draw.DrawText( math.Round( bitminer:GetBitcoinsMined() / CH_Bitminers.Config.MaxBitcoinsMined * 100, 1 ) .."%", "BITMINER_DLC_TabletSmall", 75, 385, col_white, TEXT_ALIGN_CENTER )
					
					-- WITHDRAW BUTTON
					surface.SetDrawColor( rect_col_green )
					surface.DrawRect( -155, 535, 460, 85 )
					
					draw.DrawText( CH_Bitminers_DLC.Config.Lang["Sell Bitcoins"][CH_Bitminers_DLC.Config.Language] .." (" ..math.Round( bitminer:GetBitcoinsMined(), 4 ) ..")", "BITMINER_DLC_TabletSmaller", 75, 540, col_white, TEXT_ALIGN_CENTER )
					if bitcoin_rate then
						draw.DrawText( DarkRP.formatMoney( math.Round( bitminer:GetBitcoinsMined() * bitcoin_rate ) ), "BITMINER_DLC_TabletSmaller", 75, 575, col_white, TEXT_ALIGN_CENTER )
					end
					
					--[[
					RIGHT SIDE OF THE TABLET
					--]]
					
					-- Draw miners installed
					draw.DrawText( CH_Bitminers_DLC.Config.Lang["MINERS"][CH_Bitminers_DLC.Config.Language], "BITMINER_DLC_TabletSmall", 370, 25, color_white, TEXT_ALIGN_LEFT )
					draw.DrawText( bitminer:GetMinersInstalled() .." / ".. bitminer:GetMinersAllowed(), "BITMINER_DLC_TabletSmall", 830, 25, color_white, TEXT_ALIGN_RIGHT )
					
					-- Rect showing miners
					surface.SetDrawColor( col_bar_bg_notrans )
					surface.DrawRect( 370, 100, 460, 50 )
					
					surface.SetDrawColor( col_blue )
					local multiple_rate = 0
					
					if bitminer:GetMinersAllowed() <= 4 then
						multiple_rate = 115
					elseif bitminer:GetMinersAllowed() <= 8 then
						multiple_rate = 57.5
					elseif bitminer:GetMinersAllowed() <= 12 then
						multiple_rate = 38.33
					elseif bitminer:GetMinersAllowed() <= 16 then
						multiple_rate = 28.75
					end
					
					surface.DrawRect( 370, 100, bitminer:GetMinersInstalled() * multiple_rate, 50 )
					
					-- Draw power supplies installed
					draw.DrawText( CH_Bitminers_DLC.Config.Lang["UPS'S"][CH_Bitminers_DLC.Config.Language], "BITMINER_DLC_TabletSmall", 370, 170, color_white, TEXT_ALIGN_LEFT )
					draw.DrawText( bitminer:GetUPSInstalled() .." / 4", "BITMINER_DLC_TabletSmall", 830, 170, color_white, TEXT_ALIGN_RIGHT )
					
					-- Rect showing amount of ups's installed
					surface.SetDrawColor( col_bar_bg_notrans )
					surface.DrawRect( 370, 245, 460, 50 )
					
					surface.SetDrawColor( col_blue )
					surface.DrawRect( 370, 245, bitminer:GetUPSInstalled() * 115, 50 )
					
					-- Draw vents installed
					draw.DrawText( CH_Bitminers_DLC.Config.Lang["VENTILATION"][CH_Bitminers_DLC.Config.Language], "BITMINER_DLC_TabletSmall", 370, 315, color_white, TEXT_ALIGN_LEFT )
					draw.DrawText( bitminer:GetFansInstalled() .." / 3", "BITMINER_DLC_TabletSmall", 830, 315, color_white, TEXT_ALIGN_RIGHT )
					
					-- Rect showing amount of ups's installed
					surface.SetDrawColor( col_bar_bg_notrans )
					surface.DrawRect( 370, 390, 460, 50 )
					
					surface.SetDrawColor( col_blue )
					surface.DrawRect( 370, 390, bitminer:GetFansInstalled() * 153.33, 50 )
					
					-- Draw temperature
					draw.DrawText( CH_Bitminers_DLC.Config.Lang["TEMP"][CH_Bitminers_DLC.Config.Language], "BITMINER_DLC_TabletSmall", 370, 460, color_white, TEXT_ALIGN_LEFT )
					draw.DrawText( math.Round( bitminer:GetTemperature(), 3 ) .."C", "BITMINER_DLC_TabletSmall", 830, 460, color_white, TEXT_ALIGN_RIGHT )
					-- °
					-- Rect showing temp
					surface.SetDrawColor( col_bar_bg_notrans )
					surface.DrawRect( 370, 535, 460, 50 )
					
					if bitminer:GetTemperature() <= 33 then
						surface.SetDrawColor( rect_col_green )
					elseif bitminer:GetTemperature() <= 66 then
						surface.SetDrawColor( rect_col_orange )
					elseif bitminer:GetTemperature() <= 100 then
						surface.SetDrawColor( rect_col_red )
					end
					surface.DrawRect( 370, 535, bitminer:GetTemperature() * 4.6, 50 )
				end
			cam.End3D2D()
		end
	end
end