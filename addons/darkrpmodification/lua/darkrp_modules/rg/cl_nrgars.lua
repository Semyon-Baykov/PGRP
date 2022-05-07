module( 'gp_wep', package.seeall )

local function isvip()

	return LocalPlayer():IsSecondaryUserGroup "premium"
end

local function accesscolor( tbl )

	if tbl.access and not (LocalPlayer():rg_GetLVL() >= tbl.access) then 
		return 255,0,0
	end
	if tbl.vip and not isvip() then
		return 255,0,0
	end

	return 0,255,0
end

function nrg_arsm()
	
	local frame = vgui.Create( 'gpFrame' )
	frame:SetSize( 700,350 )
	frame:Center()
	frame:MakePopup()
	frame:SetTitle( 'Арсенал росгвардии' )

	local ds = vgui.Create( 'DScrollPanel', frame )
	ds:Dock( FILL )

	for k,v in SortedPairsByMemberValue( tbl, 'id' ) do
		local _ = vgui.Create( 'DPanel', ds )
		_:Dock( TOP )
		_:SetTall( 65 )
		_:DockMargin( 0, 5, 0, 0 )
		_.Paint = function( _,w, h )
			surface.SetDrawColor( accesscolor( v ) )
			surface.DrawOutlinedRect(0,0,w,h)
			draw.RoundedBox(0,0,0,w,h,Color(255,255,255,5))
			draw.DrawText( k, 'Trebuchet24', 10, 5, Color( 255,255,255 ) )
			draw.DrawText( v.desc, 'DermaDefault', 10, 28, Color( 255,255,255 ) )
		end 
		
		if LocalPlayer():GetNWString( 'nrgars_pack' ) == k then
			local join = vgui.Create( 'DButton', _ )
			join:SetText( '' )
			join:Dock( RIGHT )
			join:SetWide( 85 )
			join:DockMargin( 0,20,7,20 )
			join.DoClick = function()

				net.Start( 'nrg_arsm_get' )
					net.WriteString( k )
				net.SendToServer()

				frame:Remove()

			end
			join.Paint = function( _, w, h )
				draw.RoundedBox(0,0,0,w,h,Color(255,255,255,10))
				draw.RoundedBox(0,0,0,w,1,Color(60,60,60))
				draw.RoundedBox(0,0,h-1,w,1,Color(60,60,60))
				draw.RoundedBox(0,0,0,1,h,Color(60,60,60))
				draw.RoundedBox(0,w-1,0,1,h,Color(60,60,60))

				draw.SimpleText( 'Сдать', 'DermaDefault', w/2, h/2, color_white, 1, 1)
			end
			continue
		end


		local join = vgui.Create( 'DButton', _ )
		join:SetText( '' )
		join:Dock( RIGHT )
		join:SetWide( 85 )
		join:DockMargin( 0,20,7,20 )
		join.DoClick = function()

			net.Start( 'nrg_arsm' )
				net.WriteString( k )
			net.SendToServer()

			frame:Remove()

		end
		join.Paint = function( _, w, h )
			draw.RoundedBox(0,0,0,w,h,Color(255,255,255,10))
			draw.RoundedBox(0,0,0,w,1,Color(60,60,60))
			draw.RoundedBox(0,0,h-1,w,1,Color(60,60,60))
			draw.RoundedBox(0,0,0,1,h,Color(60,60,60))
			draw.RoundedBox(0,w-1,0,1,h,Color(60,60,60))

			draw.SimpleText( 'Получить', 'DermaDefault', w/2, h/2, color_white, 1, 1)
		end
	end

end
