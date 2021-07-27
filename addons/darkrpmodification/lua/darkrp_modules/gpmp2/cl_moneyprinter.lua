module( 'gp_mp', package.seeall )

local function openmenu( ent )
	local inact = true
	timer.Simple(0.2, function() inact = false end)
	local frame = vgui.Create( 'DFrame' )
	frame:SetSize( 600, 240 )
	frame:DockPadding( 5, 25, 0, 0 )
	frame:Center()
	frame:MakePopup()
	frame:ShowCloseButton( false )
	frame:SetTitle( '' )
	frame.Paint = function( _, w, h )

		gp_inv.blur( _, 5, 10, 255 )
		draw.RoundedBox(0, 0, 0, w, h, Color( 30, 30, 30, 200 ) )
		draw.RoundedBox(0, 0, 0, w, 20, Color( 0, 0, 0, 200 ) )

		ent.info = util.JSONToTable( ent:GetNWString( 'gp_mp.info', '{}' ) )

		if input.IsKeyDown( KEY_E ) and !inact then
			frame:Remove()
		end

	end
	frame.Think = function()

		if LocalPlayer():GetPos():Distance( ent:GetPos() ) > 70 then
			frame:Remove()
		end

	end

	local w, h = frame:GetSize()
	local closeb = frame:Add( 'DButton' )
	closeb:SetSize( 20, 10 )
	closeb:SetPos( w-25, 5 )
	closeb:SetText( '' )
	closeb.Paint = function( _, w, h )

		draw.RoundedBox( 0, 0, 0, w, h, Color( 200, 0, 0 ) )

	end
	closeb.DoClick = function()
	
		frame:Remove()
	
	end

	local upg_p = frame:Add( 'DPanel' )
	upg_p:Dock( LEFT )
	upg_p:SetSize( 200 )
	upg_p.Paint = function() end

	local lerp = 0
	local fill = frame:Add( 'DPanel' )
	fill:Dock( FILL )
	fill.Paint = function( _, w, h )

		draw.SimpleText('Денежный принтер', 'Trebuchet24', w/2, 15, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		draw.SimpleText('Содержит:', 'Trebuchet24', w/2, 45, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		draw.SimpleText( DarkRP.formatMoney( ent.info.cash ), 'Trebuchet24', w/2, 70, Color( 108, 198, 100 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

		if ent.info.broken then
			draw.SimpleText( 'Сломан', 'Trebuchet24', w/2, h/2+10, Color( 150, 0, 0 ) , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			return
		end
		if ent.info.printing then
			lerp = Lerp( 0.1, lerp,  math.ceil((ent:GetNWInt( 'gp_mp.time',0)/ent.info.time*100))/100 )
			
			gp_util.FilledCircle( w/2, h/2+10, 25, 25, color_white, lerp )
			gp_util.FilledCircle( w/2, h/2+10, 20, 20, Color(0,0,0), 100/100 )
			if math.ceil((ent:GetNWInt( 'gp_mp.time',0)/ent.info.time*100)) > 80 then
				draw.SimpleText( math.ceil((ent:GetNWInt( 'gp_mp.time',0)/ent.info.time*100))..'%', 'Trebuchet24', w/2, h/2+10, Color( 0, 139, 0 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			else
				draw.SimpleText( math.ceil((ent:GetNWInt( 'gp_mp.time',0)/ent.info.time*100))..'%', 'Trebuchet24', w/2, h/2+10, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end
		else
			draw.SimpleText( 'Остановлен', 'Trebuchet18', w/2, h/2+10, Color( 150, 0, 0 ) , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end

	end


	for k,v in pairs( tbl ) do

		local _ = upg_p:Add( 'DButton' )
		_:Dock( TOP )
		_:DockMargin( 0, 0, 0, 0 )
		_:SetSize( 0, 70 )
		_:SetText( '' )
		_.Paint = function( _, w, h )

			if ent.info.tier >= k then
				draw.RoundedBox(0, 0, 0, w, h, tbl[k].color )
			else
				if !_:IsHovered() then
					draw.RoundedBox(0, 0, 0, w, h, Color( 30, 30, 30, 100 ) )
				else
					draw.RoundedBox(0, 0, 0, w, h, Color( 30, 30, 30, 170 ) )
				end	
			end

			draw.SimpleText( v.name, 'Trebuchet24', w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		
			if ent.info.tier >= k then
				surface.SetDrawColor( 255, 255, 255, 255 )
				surface.SetMaterial( Material( 'icon16/accept.png' ) )
				surface.DrawTexturedRect( w/2-8, h/2+15, 16, 16 )
			else
				draw.SimpleText( DarkRP.formatMoney(v.price), 'Trebuchet24', w/2, h/2+15, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end

		end
		_.DoClick = function()


			net.Start( 'gp_mp' )
				net.WriteString( 'upg' )
				net.WriteEntity( ent )
				net.WriteInt( k, 3 )
			net.SendToServer()


		end

	end

	if ent.info.broken then
		local wt = fill:Add( 'DButton' )
		wt:Dock( BOTTOM )
		wt:SetSize( 0, 50 )	
		wt:SetText( '' )
		wt:DockMargin( 5, 0, 5, 5)
		wt.Paint = function( _, w, h )
			
			if !wt:IsHovered() then
				draw.RoundedBox(0,0,0,w,h,Color(0,100,0,70))
			else
				draw.RoundedBox(0,0,0,w,h,Color(0,105,0,70))
			end	
			
			draw.SimpleText( 'Починить (100р)', 'DermaDefault', w/2, h/2, Color( 255,255,255 ) , 1, 1)	
			
			draw.RoundedBox(0,0,0,w,1,Color(60,60,60))
			draw.RoundedBox(0,0,h-1,w,1,Color(60,60,60))
			draw.RoundedBox(0,0,0,1,h,Color(60,60,60))
			draw.RoundedBox(0,w-1,0,1,h,Color(60,60,60))
		
		end
		wt.DoClick = function()
			net.Start( 'gp_mp.fix' )
				net.WriteEntity( ent )
			net.SendToServer()
			frame:Remove()
		end
		return
	end

	local wt = fill:Add( 'DButton' )
	wt:Dock( BOTTOM )
	wt:SetSize( 0, 25 )	
	wt:SetText( '' )
	wt:DockMargin( 5, 0, 5, 5)
	wt.Paint = function( _, w, h )
		
		if !wt:IsHovered() then
			draw.RoundedBox(0,0,0,w,h,Color(255,255,255,7))
		else
			draw.RoundedBox(0,0,0,w,h,Color(255,255,255,10))
		end	
		
		draw.SimpleText( 'Вывести', 'DermaDefault', w/2, h/2, Color( 255,255,255 ) , 1, 1)	
		
		draw.RoundedBox(0,0,0,w,1,Color(60,60,60))
		draw.RoundedBox(0,0,h-1,w,1,Color(60,60,60))
		draw.RoundedBox(0,0,0,1,h,Color(60,60,60))
		draw.RoundedBox(0,w-1,0,1,h,Color(60,60,60))
	
	end
	wt.DoClick = function()

		net.Start( 'gp_mp' )
			net.WriteString( 'withdraw' )
			net.WriteEntity( ent )
		net.SendToServer()

	end


	local ss = fill:Add( 'DButton' )
	ss:Dock( BOTTOM )
	ss:SetSize( 0, 25 )
	ss:SetText( '' )
	ss:DockMargin( 5, 0, 5, 5)
	ss.Paint = function( _, w, h )
		
		if !ss:IsHovered() then
			draw.RoundedBox(0,0,0,w,h,Color(255,255,255,7))
		else
			draw.RoundedBox(0,0,0,w,h,Color(255,255,255,10))
		end	
		if ent.info.printing then
			draw.SimpleText( 'Остановить', 'DermaDefault', w/2, h/2, Color( 255,255,255 ) , 1, 1)	
		else
			draw.SimpleText( 'Запустить', 'DermaDefault', w/2, h/2, Color( 255,255,255 ) , 1, 1)
		end
		draw.RoundedBox(0,0,0,w,1,Color(60,60,60))
		draw.RoundedBox(0,0,h-1,w,1,Color(60,60,60))
		draw.RoundedBox(0,0,0,1,h,Color(60,60,60))
		draw.RoundedBox(0,w-1,0,1,h,Color(60,60,60))
	end
	ss.DoClick = function()
		net.Start( 'gp_mp' )
			net.WriteString( 'startstop' )
			net.WriteEntity( ent )
		net.SendToServer()
	end

end

net.Receive( 'gp_mp', function()

	local ent = net.ReadEntity()

	openmenu(ent)

end)

net.Receive( 'gp_mp.unarrest', function()

	local time = net.ReadInt( 16 )
	local ent = net.ReadEntity()
	local t = 0

	timer.Create( 'gpmp_unarrest', 1, time, function()
		t = t + 1
	end )
	timer.Simple( time, function()
		hook.Remove( 'HUDPaint', 'gpmp_unarrest' )
	end )

	hook.Add( 'HUDPaint', 'gpmp_unarrest', function()
		if LocalPlayer():GetEyeTrace().Entity == ent then
			gp_util.FilledCircle( ScrW()/2, ScrH()/2, 30, 30, color_white, (t/time*100)/100 )
			gp_util.FilledCircle( ScrW()/2, ScrH()/2, 25, 25, Color(0,0,0), 100/100 )
			draw.SimpleText( math.ceil(t/time*100)..'%', 'Trebuchet24', ScrW()/2, ScrH()/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
	end )

end )