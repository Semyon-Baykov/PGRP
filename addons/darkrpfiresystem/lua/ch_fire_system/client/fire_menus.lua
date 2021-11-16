print( "CL - Crap-Head's Fire System Initialized" )
isdarkrpfiresystemactive = true

net.Receive( "FIRE_SendTruckModelCL", function( len, ply )
	LocalPlayer().CurVehModel = net.ReadString()
end )

local mat_col_spec = 1 -- 76561197989440650
local mat_col = Color( 255, 255, 255, 255 )
local ff_ui = Material( "craphead_scripts/fire_system/ff_ui.png" )

local col_white = Color( 255, 255, 255, 255 )
local col_invs = Color( 42, 100, 42, 0 )

local col_gray_text = Color( 100, 100, 100, 255 )
local col_gray_scroll = Color( 24, 24, 24, 100 )
local col_red_scroll = Color( 255, 29, 29, 155 )

local col_red_button = Color( 255, 29, 29, 255 )
local col_gray_button = Color( 30, 30, 30, 255 )

local col_bg_outer = Color( 22, 22, 24, 255 )
local col_bg_inner = Color( 19, 19, 21, 255 )

net.Receive( "FIRE_FiretruckMenu", function( len, ply )
	local VehMenu = vgui.Create( "DFrame" )
	VehMenu:SetTitle( "" )
	VehMenu:SetSize( ScrW() * 0.5, ScrH() * 0.5 )
	VehMenu:SetPos( ScrW() * 0.5, ScrH() * 0.5 )
	VehMenu:Center()
	VehMenu.Paint = function( self )
		surface.SetDrawColor( mat_col )
		surface.SetMaterial( ff_ui )
		surface.DrawTexturedRect( 0, 0, ScrW() * 0.48, ScrH() * 0.495 )
		
		-- Draw the top title.
		draw.SimpleText("Firetruck Station", "FIRE_UIFontTitle", ScrW() * 0.082, ScrH() * 0.052, col_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	VehMenu:MakePopup()
	VehMenu:ShowCloseButton( false )
	
	local VehMainExit = vgui.Create( "DButton", VehMenu )
	VehMainExit:SetSize( ScreenScale( 6.5 ), ScreenScale( 6.5 ) )
	VehMainExit:SetPos( ScrW() * 0.465, ScrH() * 0.04 )
	VehMainExit:SetText( "" )
	VehMainExit.Paint = function()
	end
	VehMainExit.DoClick = function()
		VehMenu:Remove()
	end
	
	local VehListPanel = vgui.Create( "DPanelList", VehMenu )
	VehListPanel:SetTall( ScreenScale( 147.5 ) )
	VehListPanel:SetWide( ScrW() * 0.466 )
	VehListPanel:SetPos( ScrW() * 0.009, ScrH() * 0.073 )
	VehListPanel:EnableVerticalScrollbar( true )
	VehListPanel:EnableHorizontal( true )
	VehListPanel.Paint = function()
		draw.RoundedBox( 2, 0, 2, VehListPanel:GetWide(), VehListPanel:GetTall(), col_invs )
	end
	if ( VehListPanel.VBar ) then
		VehListPanel.VBar.Paint = function(self, w, h)
			draw.RoundedBox( 0, 0, 0, w, h, col_gray_scroll ) -- BG
		end
		
		VehListPanel.VBar.btnUp.Paint = function(self, w, h)
			draw.RoundedBox( 4, 0, 2, w, h, col_invs )
		end
		
		VehListPanel.VBar.btnGrip.Paint = function(self, w, h)
			draw.RoundedBoxEx( 16, 0, 0, w, h, col_red_scroll, true, true, true, true )
		end
		
		VehListPanel.VBar.btnDown.Paint = function(self, w, h)
			draw.RoundedBox( 0, 0, 0, w, h, col_invs )
		end
	end
	
	for k, v in pairs( CH_FireSystem.Trucks ) do
		if v.Name then
			local VehPanel = vgui.Create("DPanelList")
			VehPanel:SetTall( ScreenScale( 55 ) )
			VehPanel:SetWide( ScrW() * 0.455 )
			VehPanel:SetPos( ScreenScale( 3.3 ), ScreenScale( 10 ) )
			VehPanel:SetSpacing( 10 )
			VehPanel.Paint = function()
				-- Outer
				draw.RoundedBox( 2, ScrW() * 0.007, ScrH() * 0.0125, VehPanel:GetWide(),VehPanel:GetTall(), col_bg_outer )
				
				-- Firetruck model frame
				draw.RoundedBox( 2, ScrW() * 0.01, ScrH() * 0.0175, ScrW() * 0.125, ScrH() * 0.13, col_bg_inner )
				
				-- Firetruck text frame
				draw.RoundedBox( 2, ScrW() * 0.138, ScrH() * 0.0175, ScrW() * 0.313, ScrH() * 0.13, col_bg_inner )
			end
			
			surface.SetFont( "FIRE_UIFontText" )
			local x, y = surface.GetTextSize( v.Name )
			
			local VehNameText = vgui.Create( "DLabel", VehPanel )
			VehNameText:SetPos( ( VehPanel:GetWide() / 6.25 ) - ( x / 2 ), ScrH() * 0.025 )
			VehNameText:SetFont( "FIRE_UIFontText" )
			VehNameText:SetColor( col_white )
			VehNameText:SetText( v.Name )
			VehNameText:SizeToContents()
			
			local VehIcon = vgui.Create( "DModelPanel", VehPanel )
			VehIcon:SetPos( -15, ScreenScale( 14 ) )
			VehIcon:SetSize( ScreenScale( 90 ), ScreenScale( 35 ) )
			VehIcon:SetModel( v.Model )
			VehIcon:GetEntity():SetAngles( Angle( -10, 0, 15 ) )
			local mn, mx = VehIcon.Entity:GetRenderBounds()
			local size = 0
			size = math.max( size, math.abs( mn.x ) + math.abs( mx.x ) )
			size = math.max( size, math.abs( mn.y ) + math.abs( mx.y ) )
			size = math.max( size, math.abs( mn.z ) + math.abs( mx.z ) )
			VehIcon:SetFOV( 45 )
			VehIcon:SetCamPos( Vector( size, size, size ) )
			VehIcon:SetLookAt( (mn + mx) * 0.5 )
			function VehIcon:LayoutEntity( Entity ) return end
			
			-- Vehicle Description
			local VehDescTitle = vgui.Create( "DLabel", VehPanel )
			VehDescTitle:SetPos( ScrW() * 0.145, ScrH() * 0.025 )
			VehDescTitle:SetFont( "FIRE_UIFontText" )
			VehDescTitle:SetColor( col_gray_text )
			VehDescTitle:SetText( "Description" )
			VehDescTitle:SizeToContents()
			
			local x, y = surface.GetTextSize( v.Description )

			local VehDescText = vgui.Create( "DLabel", VehPanel )
			if x <= 500 then
				VehDescText:SetPos( ScrW() * 0.145, ScrH() * 0.03 )
			elseif x <= 1000 then
				VehDescText:SetPos( ScrW() * 0.145, ScrH() * 0.04 )
			else
				VehDescText:SetPos( ScrW() * 0.145, ScrH() * 0.05 )
			end
			
			VehDescText:SetSize( ScrW() * 0.27, ScrH() * 0.055 )
			VehDescText:SetFont( "FIRE_UIFontText" )
			VehDescText:SetColor( col_white )
			VehDescText:SetWrap( true )
			VehDescText:SetText( v.Description )
			
			-- Vehicle required jobs
			local VehJobsTitle = vgui.Create( "DLabel", VehPanel )
			VehJobsTitle:SetPos( ScrW() * 0.145, ScrH() * 0.1 )
			VehJobsTitle:SetFont( "FIRE_UIFontText" )
			VehJobsTitle:SetColor( col_gray_text )
			VehJobsTitle:SetText( "Required Job" )
			VehJobsTitle:SizeToContents()
			
			local VehJobsText = vgui.Create( "DLabel", VehPanel )
			VehJobsText:SetPos( ScrW() * 0.145, ScrH() * 0.11 )
			VehJobsText:SetSize( ScrW() * 0.124, ScrH() * 0.04 )
			VehJobsText:SetFont( "FIRE_UIFontText" )
			VehJobsText:SetColor( col_white )
			VehJobsText:SetText( table.concat(v.AllowedTeamNames,", ") )
			
			-- Vehicle required ulx rank
			local VehRankTitle = vgui.Create( "DLabel", VehPanel )
			VehRankTitle:SetPos( ScrW() * 0.27, ScrH() * 0.1 )
			VehRankTitle:SetFont( "FIRE_UIFontText" )
			VehRankTitle:SetColor( col_gray_text )
			VehRankTitle:SetText( "Allowed Rank" )
			VehRankTitle:SizeToContents()
			
			local VehRankText = vgui.Create( "DLabel", VehPanel )
			VehRankText:SetPos( ScrW() * 0.27, ScrH() * 0.11 )
			VehRankText:SetSize( ScrW() * 0.1, ScrH() * 0.04 )
			VehRankText:SetFont( "FIRE_UIFontText" )
			VehRankText:SetColor( col_white )
			if CH_FireSystem.Config.UseRequiredULXRanks then
				VehRankText:SetText( table.concat(v.ULXRanksAllowed,", ") )
			else
				VehRankText:SetText( "All Ranks" )
			end
			
			-- Retrieve/Remove buttons
			-- Remove
			if LocalPlayer().CurVehModel == v.Model then
				local VehRemoveCurrent = vgui.Create("DButton", VehPanel)
				VehRemoveCurrent:SetPos( ScrW() * 0.372, ScrH() * 0.11 )
				VehRemoveCurrent:SetSize( ScrW() * 0.075, ScrH() * 0.031 )
				VehRemoveCurrent:SetText("")
				VehRemoveCurrent.Paint = function()
					draw.RoundedBox( 8, 0, 0, VehRemoveCurrent:GetWide(), VehRemoveCurrent:GetTall(), col_gray_button )
					
					local struc = {}
					struc.pos = {}
					struc.pos[1] = ScrW() * 0.0375
					struc.pos[2] = ScrH() * 0.0145
					struc.color = col_white
					struc.text = "Remove Firetruck" 
					struc.font = "FIRE_UIFontTextButton"
					struc.xalign = TEXT_ALIGN_CENTER
					struc.yalign = TEXT_ALIGN_CENTER
					draw.Text( struc )
				end
				VehRemoveCurrent.DoClick = function()
					VehMenu:Remove()
					
					net.Start( "FIRE_RemoveFireTruck" )
					net.SendToServer()
					LocalPlayer().CurVehModel = nil
				end
			-- Retrieve
			else
				local VehRetrieveTruck = vgui.Create("DButton", VehPanel)
				VehRetrieveTruck:SetPos( ScrW() * 0.372, ScrH() * 0.11 )
				VehRetrieveTruck:SetSize( ScrW() * 0.075, ScrH() * 0.031 )
				VehRetrieveTruck:SetText("")
				VehRetrieveTruck.Paint = function()
					draw.RoundedBox( 8, 0, 0, VehRetrieveTruck:GetWide(), VehRetrieveTruck:GetTall(), col_red_button )
					
					local struc = {}
					struc.pos = {}
					struc.pos[1] = ScrW() * 0.0375
					struc.pos[2] = ScrH() * 0.0145
					struc.color = col_white
					struc.text = "Retrieve Firetruck" 
					struc.font = "FIRE_UIFontTextButton"
					struc.xalign = TEXT_ALIGN_CENTER
					struc.yalign = TEXT_ALIGN_CENTER
					draw.Text( struc )
				end
				VehRetrieveTruck.DoClick = function()
					VehMenu:Remove()
					
					net.Start("FIRE_CreateFireTruck")
						net.WriteString( k )
					net.SendToServer()
				end
			end
			
			VehListPanel:AddItem( VehPanel )
		end
	end
end )