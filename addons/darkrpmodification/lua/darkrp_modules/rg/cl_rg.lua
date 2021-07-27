module( 'gp_rg', package.seeall ) 

surface.CreateFont( 'rg_45', {

	font = 'Roboto',
	size = 45

} )
surface.CreateFont( 'rg_30', {

	font = 'Roboto',
	size = 25,

} )
surface.CreateFont( 'rg_18', {

	font = 'Roboto',
	size = 18,

} )
surface.CreateFont( 'rg_20', {

	font = 'Roboto',
	size = 22,

} )

function OpenDelo( ply )

	local sizew, sizeh = ScrW()/2.4, ScrH()/1.3 

	local frame = vgui.Create( 'gpFrame' )
	frame:SetSize( sizew, sizeh )
	frame:Center()
	frame:MakePopup()

	frame.Paint = function( _, w, h )

		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetMaterial( Material( 'ui/rg_delo.png' ) )
		surface.DrawTexturedRect( 0, 0, w, h )

		draw.DrawText( 'Личное дело №\n'..ply:UniqueID(), 'rg_45', w/2, 50, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

		for i = 1, 4 do

			surface.SetDrawColor( 0, 0, 0, 255 )
			surface.DrawLine( w/5, h/3 + (30*i), w-w/5, h/3 + (30*i) )

		end

		draw.SimpleText( ply:Nick(), 'rg_30', w/2, h/3+10, Color( 100, 100, 100 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		draw.SimpleText( ply:rg_GetRank(), 'rg_30', w/2, h/3+45, Color( 100, 100, 100 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

	end

	local com = frame:Add( 'DButton' )
	com:SetSize( 400, 25 )
	com:SetPos( sizew/2-200, sizeh/3+45+19 )
	com:SetText('')
	com.Paint = function( _, w, h )
		draw.SimpleText( 'Репутация: '..ply:rg_GetRep(), 'rg_30', w/2, h/2, _:IsHovered() and Color( 150, 150, 150 ) or Color( 100, 100, 100 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	com.DoClick = function()

		local comlist = util.JSONToTable( ply:getDarkRPVar( 'rg_com' ) )

		if #comlist == 0 then
			return
		end

		local f = vgui.Create( 'gpFrame' )
		f:SetSize( 500, 300 )
		f:SetTitle( 'Отзывы' )
		f:Center()
		f:MakePopup()

		local ds = f:Add( 'DScrollPanel' )
		ds:Dock( FILL )

		for k,v in pairs( comlist ) do
			
			local _ = ds:Add( 'DPanel' )
			_:Dock( TOP )
			_:SetSize( 0, 80 )
			_:DockMargin( 0, 0, 0, 5 )
			_.Paint = function( _, w, h )
				draw.RoundedBox( 0, 0, 0, w, h, Color( 75, 75, 75 ))
				draw.SimpleText( 'Автор: '..v.author, 'rg_18', 10, 15, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				draw.SimpleText( v.rep and 'Положительный (+1 Репутация)' or 'Отрицательный (-1 Репутация)', 'rg_18', 10, 35, v.rep and Color( 0, 255, 0 ) or Color( 255, 0, 0) , TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				draw.SimpleText( '— '..v.text, 'rg_18', 10, 55, color_white , TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				
			end


		end

	end

	local com = frame:Add( 'DButton' )
	com:SetSize( 400, 25 )
	com:SetPos( sizew/2-200, sizeh/3+75+19 )
	com:SetText('')
	com.Paint = function( _, w, h )
		draw.SimpleText( 'Предупреждения: '..ply:rg_GetWarnCount(), 'rg_30', w/2, h/2, _:IsHovered() and Color( 150, 150, 150 ) or Color( 100, 100, 100 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	com.DoClick = function()

		local comlist = util.JSONToTable( ply:getDarkRPVar( 'rg_warn' ) )

		if ply:rg_GetWarnCount() == 0 then
			return
		end

		local f = vgui.Create( 'gpFrame' )
		f:SetSize( 500, 200 )
		f:SetTitle( 'Предупреждения' )
		f:Center()
		f:MakePopup()

		local ds = f:Add( 'DScrollPanel' )
		ds:Dock( FILL )

		for k,v in pairs( comlist ) do
			
			local _ = ds:Add( 'DPanel' )
			_:Dock( TOP )
			_:SetSize( 0, 50 )
			_:DockMargin( 0, 0, 0, 5 )
			_.Paint = function( _, w, h )
				draw.RoundedBox( 0, 0, 0, w, h, Color( 75, 75, 75 ))
				draw.SimpleText( 'Выдал '..v.rank..' '..v.cmd_name, 'rg_18', 10, 15, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				draw.SimpleText( 'Причина — '..v.reason, 'rg_18', 10, 35, color_white , TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			end


		end

	end

end

function FirstJoinMenu()

	local frame = vgui.Create( 'gpFrame' )
	frame:SetSize( 550, 400 )
	frame:Center()
	frame:SetTitle('')
	frame:MakePopup()
	frame.PaintOver = function( _, w, h )

		draw.SimpleText( 'Командование В/Ч №3377', 'rg_30', w/2, 60, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		draw.DrawText('приглашает в ряды Федеральной службы \nвойск национальной гвардии граждан \nдостигших призывного возраста для службы на контрактной основе. \nИменно от вас зависит благополучие и безопасность \nНашего города, семей, родных и близких. \nГосударство гарантирует полный соцпакет, \nстраховку, ежедневные выплаты, \nформенное обмундирование и табельное огнестрельное оружие.\nНиже вы можете заступить на службу или \nпросмотреть свое личное дело.', 'rg_18', w/2, 75, color_white, TEXT_ALIGN_CENTER)


	end

	local delo = frame:Add( 'gpButton' )
	delo:Dock( BOTTOM )
	delo:setText( 'Личное дело' )
	delo:SetSize( 0, 30 )

	delo.DoClick = function()
		OpenDelo( LocalPlayer() )
	end

	local join = frame:Add( 'gpButton' )
	join:Dock( BOTTOM )
	join:setText( 'Служить' )
	join:SetSize( 0, 30 )
	join:DockMargin( 0, 0, 0, 5 )
	join.DoClick = function()
		SecondJoinMenu()
		frame:Remove()
	end

end

function SecondJoinMenu()

	local tbl = tbl[LocalPlayer():rg_GetRank()].jobs

	local frame = vgui.Create( 'gpFrame' )
	frame:SetSize( 700, 400 )
	frame:Center()
	frame:SetTitle( 'Доступные должности' )
	frame:MakePopup()

	local ds = frame:Add( 'DScrollPanel' )
	ds:Dock( FILL )

	for k,v in pairs( tbl ) do

		local _ = ds:Add( 'DPanel' )
		_:Dock( TOP )
		_:SetSize( 0, 100 )
		_:DockMargin( 0, 0, 0, 5 )

		_.Paint = function( _, w, h )

			draw.RoundedBox( 0, 0, 0, w, h, Color( 76, 76, 76 ) )
			draw.SimpleText( k, 'rg_20', 10, 15, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			draw.DrawText( v.desc, 'rg_18', 10, 25, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

		end

		local j = _:Add( 'gpButton' )
		j:Dock( RIGHT )
		j:DockMargin( 5, 35, 5, 35 )
		j:SetSize( 100, 0 )
		j:setText( 'Служить' )
		j.DoClick = function()
			net.Start( 'rg_join' )
				net.WriteString( k )
			net.SendToServer()
			frame:Remove()
		end

	end

end

function OpenCMD()

	if not LocalPlayer():rg_IsCMD() then
		return
	end

	if IsValid( frame ) then
		frame:Remove()//УДАЛИТЬ И СДЕЛАТЬ ФРЕЙМ ЛОКАЛЬНЫМ ПОСЛЕ РАЗРАБОТКИ
	end

	frame = vgui.Create( 'gpFrame' ) 
	frame:SetSize( 600, 500 )
	frame:Center()
	frame:SetTitle( 'Управление Росгвардией' )
	frame:MakePopup()

	local ds = frame:Add( 'DScrollPanel' )
	ds:Dock( FILL )
	ds:GetVBar():SetWide( 0 )

	for k,v in pairs( player.GetAll() ) do
		
		if not v:IsNRG() then
			continue
		end

		local tbl1 = tbl[v:rg_GetRank()]

		local _ = ds:Add( 'DPanel' )
		_:Dock( TOP )
		_:DockMargin( 0, 0, 0, 5 )
		_:SetSize( 0, 100 )
		_.Paint = function( _, w, h )

			draw.RoundedBox( 0, 0, 0, w, h, Color( 76, 76, 76 ) )

			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetMaterial( Material( tbl1.icon ) )
			surface.DrawTexturedRect( 5, 5, 50, 90 )

			draw.SimpleText( v:Nick(), 'rg_30', 60, 15, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			draw.SimpleText( v:rg_GetRank(), 'rg_18', 60, 35, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			draw.SimpleText( 'Дежурство: '..v:GetNWString( 'rg_dn', 'нет' ), 'rg_18', 60, 55, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )


		end

		if v == LocalPlayer() or  v:rg_IsCMD() then
			
			local j = _:Add( 'gpButton' )
			j:Dock( RIGHT )
			j:DockMargin( 5, 35, 5, 35 )
			j:SetSize( 100, 0 )
			j:setText( 'Действия' )
			j.DoClick = function()
				local m = DermaMenu()
				m:AddOption( 'Личное дело', function() 

					OpenDelo( v )

				end )
				m:Open()
			end

			continue
		end

		local j = _:Add( 'gpButton' )
		j:Dock( RIGHT )
		j:DockMargin( 5, 35, 5, 35 )
		j:SetSize( 100, 0 )
		j:setText( 'Действия' )
		j.DoClick = function()

			local m = DermaMenu()
			if (v:rg_GetLVL() == 8 or v:rg_GetLVL() == 12 ) and tonumber(v:GetNWInt( 'rg_exp' )) >= v:rg_GetUP() then
				m:AddOption( 'Аттестовать', function() 

					net.Start( 'rg_cmd' )
						net.WriteString( 'Trane' )
						net.WriteEntity( v )
					net.SendToServer()

				end )
			end
			m:AddOption( 'Личное дело', function() 

				OpenDelo( v )

			end )
			if tbl1.dn and #tbl1.dn > 1 then
				m:AddOption( 'Назначить на дежурство', function() 

					local frame = vgui.Create( 'gpFrame' )
					frame:SetTitle( 'Доступные дежурства' )
					frame:SetSize( 500, 300 )
					frame:Center()
					frame:MakePopup()

					local ds = frame:Add( 'DScrollPanel' )
					ds:Dock( FILL )
					ds:GetVBar():SetWide( 5 )

					for k1,v1 in pairs( tbl1.dn ) do

						local _ = ds:Add( 'gpButton' )
						_:Dock( TOP )
						_:SetSize( 0, 50 )
						_:DockMargin( 0, 0, 0, 5 )
						_:setText( v1 )
						_.DoClick = function()
							net.Start( 'rg_cmd' )
								net.WriteString( 'SetDN' )
								net.WriteEntity( v )
								net.WriteString( v1 )
							net.SendToServer()
							frame:Remove()
						end

					end

				/*
				net.Start( 'rg_cmd' )
					net.WriteString( 'SetDN' )
					net.WriteEntity( v )
					net.SendToServer()
					*/
				end )
			end
			m:AddOption( 'Оставить отзыв', function() 

				local f = vgui.Create( 'gpFrame' )
				f:SetSize( 500, 200 )
				f:Center()
				f:SetTitle( 'Оставить отзыв' )
				f:MakePopup()

				f.PaintOver = function( _, w, h )
					draw.SimpleText( 'Отзыв:', 'rg_20', 10, 45, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				end

				local dc = f:Add( 'DComboBox' )
				dc:Dock( TOP )
				dc:SetSize( 0, 30 )
				dc:DockMargin( 5, 40, 5, 0)
				dc:SetValue( 'Отрицательный' )
				dc:AddChoice( 'Положительный' )
				dc:AddChoice( 'Отрицательный' )

				local t = f:Add( 'gpTextEntry' )
				t:Dock( TOP )
				t:SetSize( 0, 40 )
				t:DockMargin( 5, 10, 5, 0)

				local b = f:Add( 'gpButton' )
				b:Dock( BOTTOM )
				b:SetSize( 0, 35 )
				b:DockMargin( 5, 0, 5, 5 )
				b:setText( 'Выдать' )

				b.DoClick = function()

					net.Start( 'rg_cmd' )
						net.WriteString( 'Com' )
						net.WriteEntity( v )
						net.WriteString( t:GetValue() )
						if dc:GetSelected() == 'Положительный' then
							net.WriteBool( true )
						else
							net.WriteBool( false )
						end
					net.SendToServer()
					f:Remove()

				end


			end )
			m:AddOption( 'Доступ к арсеналу/транспорту', function() 

				local f = vgui.Create( 'gpFrame' )
				f:SetTitle( 'Доступ' )
				f:SetSize( 150, 100 )
				f:Center()
				f:MakePopup()
				f.PaintOver = function( _, w, h )
					draw.SimpleText( 'Арсенал', 'rg_20', 35, 45, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
					draw.SimpleText( 'Транспорт', 'rg_20', 35, 75, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				end

				local ars = f:Add( 'DCheckBox' )
				ars:SetPos( 15, 40 )
				ars:SetValue( v:GetNWBool( 'nrg_access_wep', false ) )
				ars.OnChange = function( val )
					net.Start( 'rg_cmd' )
						net.WriteString( 'wep' )
						net.WriteEntity( v )
						net.WriteString( '' )
						net.WriteBool( ars:GetChecked() )
					net.SendToServer()
				end

				local veh = f:Add( 'DCheckBox' )
				veh:SetPos( 15, 70 )
				veh:SetValue( v:GetNWBool( 'nrg_access_veh', false ) )
				veh.OnChange = function( val )
					net.Start( 'rg_cmd' )
						net.WriteString( 'veh' )
						net.WriteEntity( v )
						net.WriteString( '' )
						net.WriteBool( veh:GetChecked() )
					net.SendToServer()
				end


			end )
			m:AddOption( 'Уволить', function() 

				net.Start( 'rg_cmd' )
					net.WriteString( 'Uval' )
					net.WriteEntity( v )
				net.SendToServer()
				frame:Remove()
				timer.Simple( 0.5, function() OpenCMD() end)

			end )
			m:AddOption( 'Выдать предупреждение', function() 


				local f = vgui.Create( 'gpFrame' )
				f:SetSize( 500, 160 )
				f:Center()
				f:SetTitle( 'Выдать предупреждение' )
				f:MakePopup()

				f.PaintOver = function( _, w, h )
					draw.SimpleText( 'Причина:', 'rg_20', 10, 45, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				end

				local t = f:Add( 'gpTextEntry' )
				t:Dock( TOP )
				t:SetSize( 0, 40 )
				t:DockMargin( 5, 40, 5, 0)

				local b = f:Add( 'gpButton' )
				b:Dock( BOTTOM )
				b:SetSize( 0, 35 )
				b:DockMargin( 5, 0, 5, 5 )
				b:setText( 'Выдать' )

				b.DoClick = function()

					net.Start( 'rg_cmd' )
						net.WriteString( 'Warn' )
						net.WriteEntity( v )
						net.WriteString( t:GetValue() )
					net.SendToServer()
					f:Remove()

				end


			end )
			m:Open()

		end

	end

end

concommand.Add( 'rg_cmd', function()

	if LocalPlayer():rg_IsCMD() then
		OpenCMD()
	end

end )