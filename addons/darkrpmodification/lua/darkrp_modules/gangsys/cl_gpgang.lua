module( 'gp_gangs', package.seeall )

surface.CreateFont('gp_gangs_arial', {
	font = 'Arial',
	size = 17,
	weight = 500
})
surface.CreateFont('gp_gangs_arial2', {
	font = 'Arial',
	size = 21,
	weight = 500
})


local function gpgangs_defm()

	local gang_name = 'без названия'

	local frame = vgui.Create( 'gpFrame' )
	frame:SetSize( 500,200 )
	frame:Center()
	frame:MakePopup()
	frame:SetTitle( '' )
	frame.PaintOver = function( _, w, h ) 

		draw.SimpleText( 'Вы не состоите в ОПГ', 'Trebuchet24', w/2, h/3, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

	end

	local fw, fh = frame:GetSize()

	local bt = frame:Add( 'DButton' )
	bt:SetSize( 130, 50 )
	bt:SetPos( fw/2-(130/2), fh/2 )
	bt:SetText( '' )
	bt.Paint = function( _, w, h )

		draw.SimpleText( 'Создать', 'Trebuchet24', w/2, h/2, Color( 200, 200, 200 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		if bt:IsHovered() then
			draw.RoundedBox( 0, 0, h-5, w, 2, Color( 200, 200, 200 ))
		else
			draw.RoundedBox( 0, 0, h-5, w, 2, color_white)
		end

	end

	bt.DoClick = function()

		frame:Remove()

		local fr = vgui.Create( 'gpFrame' )
		fr:SetSize( 500, 200 )
		fr:Center()
		fr:MakePopup()
		fr:SetTitle( '' )
		fr.PaintOver = function( _, w, h ) 

			draw.SimpleText( 'Создание ОПГ', 'Trebuchet24', w/2, 50, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			draw.DrawText( 'Введите название ОПГ\nНазвание не должно состоять из символов, цифр, нецензурной брани.', 'gp_gangs_arial', w/2, 70, Color( 200, 200, 200 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

		end
		local GangName = fr:Add( 'DTextEntry')
		GangName:SetPos( 500/2-100, 115 )
		GangName:SetSize( 200,34 )

		GangName.PaintOver = function( self, w, h )
			draw.SimpleText( #self:GetValue() > 0 and "" or "Название банды...", 'DermaDefault', 5, h/2, Color( 107,107,107 ), _, TEXT_ALIGN_CENTER)
		end

		
		local fw, fh = fr:GetSize()

		local bt = fr:Add( 'DButton' )
		bt:SetSize( 130, 50 )
		bt:SetPos( fw/2-(130/2), fh/2+45 )
		bt:SetText( '' )
		bt.Paint = function( _, w, h )

			draw.SimpleText( 'Создать', 'Trebuchet24', w/2, h/2, Color( 200, 200, 200 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			if bt:IsHovered() then
				draw.RoundedBox( 0, 0, h-5, w, 2, Color( 200, 200, 200 ))
			else
				draw.RoundedBox( 0, 0, h-5, w, 2, color_white)
			end

		end
		bt.DoClick = function()

			gang_name = GangName:GetValue()

			local frame = vgui.Create( 'gpFrame' )
			frame:SetSize( 500,250 )
			frame:Center()
			frame:MakePopup()
			frame:SetTitle( '' )
			frame.PaintOver = function( _, w, h ) 

				draw.SimpleText( 'Выберите гопников для вашей опг!', 'Trebuchet24', w/2, 45, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				draw.SimpleText( 'Минимальное количество гопников для создания опг - 2.', 'Trebuchet18', w/2, 65, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				

			end

			local pn = frame:Add( 'DScrollPanel' )
			pn:Dock( FILL )
			pn:DockMargin( 100, 60, 100, 60 )
			--pn.Paint = function() end
			local tbl = {}
			for k,v in pairs( player.GetAll() ) do

				if v:Team() == TEAM_GANG and v:GetNWBool( 'gp_gangsys_ingang' ) ~= true then
					if v == LocalPlayer() then continue end

 					local _ = pn:Add( 'DCheckBoxLabel' )
					_:SizeToContents()
					_:Dock( TOP )
					_:SetText( v:Nick() )
					_:DockMargin(65, 0, 0, 0)
					_:SetValue(0)
					_:SetFont( 'Trebuchet18' )
					_.OnChange = function( val )

						if val then
							table.insert( tbl, v )
						else
							table.RemoveByValue( tbl, v )
						end

					end

				end
			end

			local fw, fh = frame:GetSize()

			local bt = frame:Add( 'DButton' )
			bt:SetSize( 130, 50 )
			bt:SetPos( fw/2-(130/2), fh/2+45 )
			bt:SetText( '' )
			bt.Paint = function( _, w, h )

				draw.SimpleText( 'Создать', 'Trebuchet24', w/2, h/2, Color( 200, 200, 200 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				if bt:IsHovered() then
					draw.RoundedBox( 0, 0, h-5, w, 2, Color( 200, 200, 200 ))
				else
					draw.RoundedBox( 0, 0, h-5, w, 2, color_white)
				end

			end
			bt.DoClick = function()

				net.Start( 'gp_gang_new' )
					net.WriteTable( tbl )
					net.WriteString( gang_name )
				net.SendToServer()
				frame:Remove()
			end
			fr:Remove()

		end

	end

end


local function gpgangs_ownm( gangs )

	local gang = gangs

	local frame = vgui.Create( 'gpFrame' )
	frame:SetSize( 400,400 )
	frame:Center()
	frame:MakePopup()
	frame:SetTitle( '' )
	frame.PaintOver = function( _, w, h ) 

		draw.SimpleText( 'ОПГ "'..gang.name..'"', 'Trebuchet24', w/2, 50, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		draw.RoundedBox(0, 100, 70, w-200, 1, color_white)


	end

	local b = frame:Add( 'DButton' )
	b:Dock( BOTTOM )
	b:SetText( '' )
	b.Paint = function( _, w, h )
	
		draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 105 ) )
		draw.SimpleText( 'Расформировать', 'gp_gangs_arial', w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	
	end
	b.DoClick = function()

		Derma_Query('Вы уверены?', 'Расформирование ОПГ', 'Да', function() net.Start( 'gp_gangs_rasf' ) net.SendToServer() frame:Remove() end, 'Отмена', function() end)

	end
	local b = frame:Add( 'DButton' )
	b:Dock( BOTTOM )
	b:SetText( '' )
	b:DockMargin( 0, 0, 0, 5 )
	b.Paint = function( _, w, h )
	
		draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 105 ) )
		draw.SimpleText( 'Пригласить', 'gp_gangs_arial', w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	
	end
	b.DoClick = function()

		local mn = DermaMenu()
		for k,v in pairs( player.GetAll() ) do
			if v:Team() == TEAM_GANG and LocalPlayer() != v then
				mn:AddOption( v:Nick(), function() net.Start( 'gp_gangs_invite' ) net.WriteEntity( v ) net.SendToServer() end )
			end
		end
		mn:Open()

	end

	local ds = frame:Add( 'DScrollPanel' )
	ds:Dock( FILL )
	ds:DockMargin( 0, 65, 0, 5 )

	local _ = ds:Add( 'DPanel' )
	_:Dock( TOP )
	_:SetSize( 0, 50 )
	_.Paint = function( _, w, h )

		draw.RoundedBox( 0, 0, 0, w, h, Color( 50, 50, 50, 170 ) )
		draw.SimpleText( LocalPlayer():Nick(), 'gp_gangs_arial2', 70, 5, Color( 200, 200, 200 ), TEXT_ALIGN_LEFT )
		draw.SimpleText( 'Глава', 'gp_gangs_arial', 70, 25, Color( 200, 200, 200 ), TEXT_ALIGN_LEFT )

	end
	local img = _:Add( 'AvatarImage' )
	img:SetSize( 50, 50 )
	img:SetPos( 0, 0 )
	img:SetPlayer( LocalPlayer() )

	if gang.members[1] then
		for k,v in pairs( gang.members ) do
			if !IsValid(v) then continue end
			if v == LocalPlayer() then continue end
			local _ = ds:Add( 'DButton' )
			_:SetText('')
			_:Dock( TOP )
			_:DockMargin( 0, 5, 0, 0 )
			_:SetSize( 0, 50 )
			_.ply = v
			_.Paint = function( _, w, h )

				draw.RoundedBox( 0, 0, 0, w, h, Color( 50, 50, 50, 170 ) )
				draw.SimpleText( v:Nick(), 'gp_gangs_arial2', 70, 5, Color( 200, 200, 200 ), TEXT_ALIGN_LEFT )
				draw.SimpleText( 'Гопник', 'gp_gangs_arial', 70, 25, Color( 200, 200, 200 ), TEXT_ALIGN_LEFT )

			end
			_.DoClick = function()

				local mn = DermaMenu()

				mn:AddOption( 'Выгнать', function() net.Start( 'gp_gangs_kick' ) net.WriteEntity( _.ply ) net.SendToServer() frame:Remove() end ):SetImage('icon16/cart_delete.png')
				mn:Open()

			end
			local img = _:Add( 'AvatarImage' )
			img:SetSize( 50, 50 )
			img:SetPos( 0, 0 )
			img:SetPlayer( v )

		end	
	end

end
local function gpgangs_memb( gangs )

	local gang = gangs


	local frame = vgui.Create( 'gpFrame' )
	frame:SetSize( 400,400 )
	frame:Center()
	frame:MakePopup()
	frame:SetTitle( '' )
	frame.PaintOver = function( _, w, h ) 

		draw.SimpleText( 'ОПГ "'..LocalPlayer():GetNWString( 'gp_gang' )..'"', 'Trebuchet24', w/2, 50, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		draw.RoundedBox(0, 100, 70, w-200, 1, color_white)


	end

	local b = frame:Add( 'DButton' )
	b:Dock( BOTTOM )
	b:SetText( '' )
	b.Paint = function( _, w, h )
	
		draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 105 ) )
		draw.SimpleText( 'Покинуть', 'gp_gangs_arial', w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	
	end
	b.DoClick = function()

		Derma_Query('Вы уверены?', 'Выход из ОПГ', 'Да', function() net.Start( 'gp_gangs_rasf' ) net.SendToServer() frame:Remove() end, 'Отмена', function() end)

	end
	local ds = frame:Add( 'DScrollPanel' )
	ds:Dock( FILL )
	ds:DockMargin( 0, 65, 0, 5 )

	local _ = ds:Add( 'DPanel' )
	_:Dock( TOP )
	_:SetSize( 0, 50 )
	_.Paint = function( _, w, h )

		draw.RoundedBox( 0, 0, 0, w, h, Color( 50, 50, 50, 170 ) )
		draw.SimpleText( gang.creator:Nick(), 'gp_gangs_arial2', 70, 5, Color( 200, 200, 200 ), TEXT_ALIGN_LEFT )
		draw.SimpleText( 'Глава', 'gp_gangs_arial', 70, 25, Color( 200, 200, 200 ), TEXT_ALIGN_LEFT )

	end
	local img = _:Add( 'AvatarImage' )
	img:SetSize( 50, 50 )
	img:SetPos( 0, 0 )
	img:SetPlayer( gang.creator:Nick() )

	if gang.members[1] then
		for k,v in pairs( gang.members ) do
				if !IsValid(v) then continue end
					if v == gang.creator then continue end
			local _ = ds:Add( 'DButton' )
			_:SetText('')
			_:Dock( TOP )
			_:DockMargin( 0, 5, 0, 0 )
			_:SetSize( 0, 50 )
			_.ply = v
			_.Paint = function( _, w, h )

				draw.RoundedBox( 0, 0, 0, w, h, Color( 50, 50, 50, 170 ) )
				draw.SimpleText( v:Nick(), 'gp_gangs_arial2', 70, 5, Color( 200, 200, 200 ), TEXT_ALIGN_LEFT )
				draw.SimpleText( 'Гопник', 'gp_gangs_arial', 70, 25, Color( 200, 200, 200 ), TEXT_ALIGN_LEFT )

			end
			local img = _:Add( 'AvatarImage' )
			img:SetSize( 50, 50 )
			img:SetPos( 0, 0 )
			img:SetPlayer( v )

		end	
	end

end
net.Receive( 'gp_gang_menu', function()

	local menutype = net.ReadString()
	local gangs = net.ReadTable()

	if menutype == 'def' then
		gpgangs_defm()
	elseif menutype == 'owner' then
		gpgangs_ownm( gangs )
	elseif menutype == 'member' then
		gpgangs_memb( gangs )
	end

end )