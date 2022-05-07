module( 'gp_vehsys.Radio', package.seeall )

local function getVehicle()

	return LocalPlayer():GetSimfphys()

end

function OpenMenu()

	frame = vgui.Create( 'gpFrame' )
		frame:SetTitle( 'Радио' )
		frame:SetSize( 350, 350 )
		frame:SetPos( 10, ScrH()/2 - 350/2 )
		frame:MakePopup()

	local ds = frame:Add( 'DScrollPanel' )
		ds:Dock( FILL )
		ds:DockMargin( 0, 0, 0, 0 )
		ds:GetVBar():SetWide( 3 )
		ds:GetVBar().btnGrip.Paint = function( _, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, color_cgray )
		end

	local _StationOff = ds:Add( 'gpButton' )
		_StationOff:Dock( TOP )
		_StationOff:setText( 'Выключено' )
		_StationOff:SetHeight( 40 )
		_StationOff:DockMargin( 0, 0, 0, 5 )
		_StationOff.DoClick = function()

			net.Start( 'gp_vehsys.RadioSet' )
				net.WriteInt( 0, 7 )
			net.SendToServer()

		end
		_StationOff.PaintOver = function( self, w, h )

			if getVehicle():GetNWInt( 'wcr_station', 0 ) == 0 then

				surface.SetDrawColor( 255, 255, 255, 255 )
				surface.SetMaterial( Material( 'icon16/accept.png' ) )
				surface.DrawTexturedRect( w - 25, h/2 - 16/2, 16, 16 )

			end

		end

	for k,v in pairs( wyozicr.Stations ) do
		local _Station = ds:Add( 'gpButton' )
			_Station:Dock( TOP )
			_Station:setText( v.Name )
			_Station:SetHeight( 40 )
			_Station:DockMargin( 0, 0, 0, 5 )
			_Station.DoClick = function()

				net.Start( 'gp_vehsys.RadioSet' )
					net.WriteInt( k, 7 )
				net.SendToServer()

			end
			_Station.PaintOver = function( self, w, h )

				if getVehicle():GetNWInt( 'wcr_station', 0 ) == k then

					surface.SetDrawColor( 255, 255, 255, 255 )
					surface.SetMaterial( Material( 'icon16/accept.png' ) )
					surface.DrawTexturedRect( w - 25, h/2 - 16/2, 16, 16 )

				end

			end
	end

end


hook.Add( 'ContextMenuOpen', 'gp_RadioMenu', function()

	if LocalPlayer():GetSimfphys() != NULL and LocalPlayer():GetSimfphys():GetDriver() and LocalPlayer():GetSimfphys():GetDriver() == LocalPlayer() then
		OpenMenu()
	end

end)

hook.Add( 'OnContextMenuClose', 'gp_RadioMenuClose', function()

	if IsValid( frame ) then
		frame:Remove()
	end

end)