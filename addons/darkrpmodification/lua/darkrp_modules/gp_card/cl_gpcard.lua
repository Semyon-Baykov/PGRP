module( 'gp_cardealer', package.seeall )

surface.CreateFont( 'gp_card_arial19', {

	font = 'Arial',
	size = 19,
	weight = 500

})

local function buyout_menu( class )

	local tbl = tbl.cars[class]

	local f = vgui.Create( 'DPanel' )
	f:SetSize( 500, 435 )
	f:Center()
	f:MakePopup()
	f.Paint = function( _, w, h )

		gp_inv.blur( _, 5, 12, 255 )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 235 ) )
		draw.SimpleText( 'Продажа транспорта', 'Trebuchet24', w/2,35, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		draw.DrawText( 'Тут вы можете продать транспорт государству.','gp_card_arial19', w/2, 55, color_white, TEXT_ALIGN_CENTER )
		draw.DrawText( 'Цена при продаже государству: '..DarkRP.formatMoney( math.ceil(tbl.price/2) ),'gp_card_arial19', w/2, 135, color_white, TEXT_ALIGN_CENTER )
	end

	local top = f:Add( 'DPanel' )
	top:Dock( TOP )
	top:SetTall( 20 )
	top.Paint = function( _, w, h )

	end

	local fw, fh = f:GetSize()

	local cb = top:Add( 'DButton' )
	cb:SetPos( fw - 35, 5 )
	cb:SetSize( 30, 7 )
	cb:SetText( '' )
	cb.DoClick = function()

		f:Remove()

	end
	cb.Paint = function( _, w, h )

		draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 0, 0 ) )

	end	

	local _ = f:Add( 'DButton' )
	_:Dock( BOTTOM )
	_:SetText( '' )
	_:SetSize( 100, 100 )
	_:DockMargin( 5, 0, 5, 5 )
	_.Paint = function( _, w, h )

		if !_:IsHovered() then
			draw.RoundedBox(0,0,0,w,h,Color(255,255,255,7))
		else
			draw.RoundedBox(0,0,0,w,h,Color(255,255,255,10))
		end	
		draw.SimpleText( 'Продать государству', 'DermaDefault', w/2, h/2, Color( 255,255,255 ) , 1, 1)	
		draw.RoundedBox(0,0,0,w,1,Color(60,60,60))
		draw.RoundedBox(0,0,h-1,w,1,Color(60,60,60))
		draw.RoundedBox(0,0,0,1,h,Color(60,60,60))
		draw.RoundedBox(0,w-1,0,1,h,Color(60,60,60))

	end
	_.DoClick = function()

		LocalPlayer():EmitSound( 'garrysmod/ui_click.wav', 100 )

		Derma_Query('Вы уверены?','Продажа т/c государству', 'Да', function() 

			f:Remove()

			LocalPlayer():EmitSound( 'garrysmod/ui_click.wav', 100 )

			net.Start( 'gpcard_sell' )
				net.WriteString( class )
				net.WriteString( 'sell_gov' )
			net.SendToServer()	

		end, 'Отмена', function() end)

	
	end
	--[[
	local _ = f:Add( 'DButton' )
	_:Dock( BOTTOM )
	_:SetText( '' )
	_:SetSize( 100, 100 )
	_:DockMargin( 5, 5, 5, 5 )
	_.Paint = function( _, w, h )

		if !_:IsHovered() then
			draw.RoundedBox(0,0,0,w,h,Color(255,255,255,7))
		else
			draw.RoundedBox(0,0,0,w,h,Color(255,255,255,10))
		end	
		draw.SimpleText( 'Выставить на авторынок', 'DermaDefault', w/2, h/2, Color( 255,255,255 ) , 1, 1)	
		draw.RoundedBox(0,0,0,w,1,Color(60,60,60))
		draw.RoundedBox(0,0,h-1,w,1,Color(60,60,60))
		draw.RoundedBox(0,0,0,1,h,Color(60,60,60))
		draw.RoundedBox(0,w-1,0,1,h,Color(60,60,60))

	end

	_.DoClick = function()
		f:Remove()

		local f = vgui.Create( 'DFrame' )
		f:SetSize( 500, 500 )
		f:Center()
		f:ShowCloseButton( false )
		f:MakePopup()
		f:SetTitle( '' )
		f:SetDraggable( false )
		f.Paint = function( _, w, h )

			gp_inv.blur( _, 5, 12, 255 )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 235 ) )
			draw.SimpleText( 'Продажа '..tbl.name, 'Trebuchet24', w/2,35, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			draw.DrawText( 'Для того что бы выставить ваше т/c на авторынок напишите\n ниже описание, цену и нажмите "подтвердить".\n\nВнимание, покупатель может приобрести т/c\n даже когда вы оффлайн.', 'gp_card_arial19', w/2,70, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			draw.SimpleText( 'Описание: ', 'gp_card_arial19', w/2,200, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			draw.SimpleText( 'Цена: ', 'gp_card_arial19', w/2,385, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )


		end

		local top = f:Add( 'DPanel' )
		top:Dock( TOP )
		top:SetTall( 20 )
		top.Paint = function( _, w, h )

		end

		local fw, fh = f:GetSize()

		local cb = f:Add( 'DButton' )
		cb:SetPos( fw - 35, 5 )
		cb:SetSize( 30, 7 )
		cb:SetText( '' )
		cb.DoClick = function()

			f:Remove()

		end
		cb.Paint = function( _, w, h )

			draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 0, 0 ) )

		end	

		local dte = f:Add( 'DTextEntry' )
		dte:Dock( TOP )
		dte:SetTall( 150 )
		dte:SetFont( 'gp_card_arial19' )
		dte:SetText( 'Описание..' )
		dte:SetMultiline( true )
		dte:DockMargin( 5, 170, 5, 0 )

		dte.Paint = function( _, w, h )

			surface.SetDrawColor( 0, 0, 0, 200 )
			surface.DrawRect( 0, 0, w, h )
			_:DrawTextEntryText( Color( 255, 255, 255 ), Color( 30, 130, 255 ), Color( 255, 255, 255 ) )

		end

		local pte = f:Add( 'DNumberWang' )
		pte:Dock( TOP )
		pte:SetTall( 20 )
		pte:SetMultiline( true )
		pte:DockMargin( 190, 30, 190, 0 )
		pte:SetMin( math.ceil(tbl.price/1.5) )
		pte:SetValue( math.ceil(tbl.price/1.5) )
		pte:HideWang()
		pte:SetFont( 'gp_card_arial19' )

		pte.Paint = function( _, w, h )

			surface.SetDrawColor( 0, 0, 0, 200 )
			surface.DrawRect( 0, 0, w, h )
			_:DrawTextEntryText( Color( 255, 255, 255 ), Color( 30, 130, 255 ), Color( 255, 255, 255 ) )
			draw.SimpleText( '₽', 'gp_card_arial19', w-17, 1, color_white, TEXT_ALIGN_CENTER )


		end

		local _b = f:Add( 'DButton' )
		_b:Dock( BOTTOM )
		_b:SetSize( 100, 50 )
		_b:DockMargin( 150, 5, 150, 10)
		_b:SetText( '' )
		_b.Paint = function( _, w, h )

			if !_b:IsHovered() then
				draw.RoundedBox(0,0,0,w,h,Color(255,255,255,7))
			else
				draw.RoundedBox(0,0,0,w,h,Color(255,255,255,10))
			end	
			draw.SimpleText( 'Подтвердить', 'DermaDefault', w/2, h/2, Color( 255,255,255 ) , 1, 1)	
			draw.RoundedBox(0,0,0,w,1,Color(60,60,60))
			draw.RoundedBox(0,0,h-1,w,1,Color(60,60,60))
			draw.RoundedBox(0,0,0,1,h,Color(60,60,60))
			draw.RoundedBox(0,w-1,0,1,h,Color(60,60,60))

			
		end
		
		_b.DoClick = function()

			f:Remove()

			LocalPlayer():EmitSound( 'garrysmod/ui_click.wav', 100 )

			net.Start( 'gpcard_sell' )
				net.WriteString( class )
				net.WriteString( 'sell_ar' )
				net.WriteString( dte:GetText() )
				net.WriteInt(  pte:GetValue() , 25 )
			net.SendToServer()

		end

	end
	--]]

end

local function nocars_menu()

	local f = vgui.Create( 'DPanel' )
	f:SetSize( 500, 150 )
	f:Center()
	f:MakePopup()
	f.Paint = function( _, w, h )

		gp_inv.blur( _, 5, 12, 255 )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 235 ) )
		draw.SimpleText( 'Нет доступного транспорта', 'DermaLarge', w/2,40, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

	end

	local top = f:Add( 'DPanel' )
	top:Dock( TOP )
	top:SetTall( 20 )
	top.Paint = function( _, w, h )

	end

	local fw, fh = f:GetSize()

	local cb = top:Add( 'DButton' )
	cb:SetPos( fw - 35, 5 )
	cb:SetSize( 30, 7 )
	cb:SetText( '' )
	cb.DoClick = function()

		f:Remove()

	end
	cb.Paint = function( _, w, h )

		draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 0, 0 ) )

	end	

	local _b = f:Add( 'DButton' )
	_b:Dock( BOTTOM )
	_b:SetSize( 100, 50 )
	_b:DockMargin( 150, 5, 150, 10)
	_b:SetText( '' )
	_b.Paint = function( _, w, h )

		if !_b:IsHovered() then
			draw.RoundedBox(0,0,0,w,h,Color(255,255,255,7))
		else
			draw.RoundedBox(0,0,0,w,h,Color(255,255,255,10))
		end	
		draw.SimpleText( 'Купить', 'DermaDefault', w/2, h/2, Color( 255,255,255 ) , 1, 1)	
		draw.RoundedBox(0,0,0,w,1,Color(60,60,60))
		draw.RoundedBox(0,0,h-1,w,1,Color(60,60,60))
		draw.RoundedBox(0,0,0,1,h,Color(60,60,60))
		draw.RoundedBox(0,w-1,0,1,h,Color(60,60,60))

		
	end

	_b.DoClick = function()

		f:Remove()

		LocalPlayer():EmitSound( 'garrysmod/ui_click.wav', 100 )
		gp_F4.Open()
		gp_F4.SetTab( gp_F4.tabs[5] )

	end

end

local function carmenu()

	local f = vgui.Create( 'gpFrame' )
	f:SetSize( 500, 145 )
	f:Center()
	f:MakePopup()
	f:SetTitle( 'Управление' )

	local cart = util.JSONToTable(LocalPlayer():GetNWString( 'gpcard_cartable'))
	local car = LocalPlayer():GetNWEntity( 'gpcard_veh' )
	local k = cart.info.class
	local dist = math.ceil( car:GetPos():Distance( LocalPlayer():GetPos() )/30 )

	local _ = f:Add( 'DPanel' )
	_:Dock( TOP )
	_:SetSize( 100, 100 )
	_:DockMargin( 5, 5, 5, 5 )
	_:DockPadding( 1, 1, 1, 1 )
	_.Paint = function( _, w, h )

		local cin = ( math.sin( CurTime() ) + 1 ) / 2
		local color = Color( cin * 255, 0, 255 - ( cin * 255 ), 255 )

	

		if tbl.cars[k] then
			draw.SimpleText( tbl.cars[k].name..' | '..cart.info.number, 'Trebuchet24', 110, 5, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		elseif tbl.doncars[k] then
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetMaterial( Material( 'icon16/heart.png' ) )
			surface.DrawTexturedRect( 115, 10, 15, 15 )
			draw.SimpleText( tbl.doncars[k].name..' | '..cart.info.number, 'Trebuchet24', 140, 5, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		else
			draw.SimpleText( tbl.govcars[k].name..' | '..cart.info.number, 'Trebuchet24', 110, 5, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		end	
		
		if #car:GetNWString( 'veh_lastowner' ) > 0 then
			draw.SimpleTextOutlined( 'Машина в угоне', 'Trebuchet24', 110, 30, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 0.3, Color( 0, 0, 0 ) )
			draw.SimpleText( 'Верните её, чтобы отозвать.', 'gp_card_arial19', 110, 55, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		else

			if dist > 15 then
				draw.SimpleText( '~'..dist..'м. от вас', 'gp_card_arial19', 110, 35, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			else
				draw.RoundedBox( 0, 110, 35, 25, 26, Color( 0, 0, 0, 150 ) )
				draw.RoundedBox( 0, 110, 65, 25, 26, Color( 0, 0, 0, 150 ) )
				draw.RoundedBox( 0, 140, 35, 150, 26, Color( 0, 0, 0, 150 ) )
				draw.RoundedBox( 0, 140, 65, 150, 26, Color( 0, 0, 0, 150 ) )
				
				if car:GetCurHealth() then
					draw.RoundedBox( 0, 143, 38, car:GetCurHealth()/car:GetMaxHealth()*144, 20, Color( 43, 168, 14, 150 ) )
					draw.RoundedBox( 0, 143, 68, car:GetFuel()/car:GetMaxFuel()*144, 20, Color( 248, 244, 0, 150 ) )
					draw.SimpleTextOutlined( math.ceil(car:GetCurHealth()/car:GetMaxHealth()*100)..'%', 'Trebuchet24', 215, 48, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
					draw.SimpleTextOutlined( math.ceil(car:GetFuel()/car:GetMaxFuel()*100)..'%', 'Trebuchet24', 215, 78, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
				else
					draw.RoundedBox( 0, 143, 38, 144, 20, Color( 43, 168, 14, 150 ) )
					draw.RoundedBox( 0, 143, 68, 144, 20, Color( 248, 244, 0, 150 ) )
				end


				surface.SetDrawColor( 255, 255, 255, 255 )
				surface.SetMaterial( Material( 'gportalhud/car.png' ) )
				surface.DrawTexturedRect( 115, 40, 15, 15 )
				surface.SetMaterial( Material( 'gportalhud/fuel.png' ) )
				surface.DrawTexturedRect( 115, 70, 15, 15 )

			end
		end

	end

	local dp = _:Add( 'DPanel' )
	dp:Dock( LEFT )
	dp:SetSize( 100, 100 )
	dp.Paint = function( _, w, h )

		draw.RoundedBox(0,0,0,w,h,Color(100,100,100,15))
		draw.RoundedBox(0,0,0,w,2,Color(40,40,40))
		draw.RoundedBox(0,0,h-2,w,2,Color(40,40,40))
		draw.RoundedBox(0,0,0,2,h,Color(40,40,40))
		draw.RoundedBox(0,w-2,0,2,h,Color(40,40,40))

	end

	local icon = dp:Add( 'ModelImage' )
	icon:Dock( FILL )
	if tbl.cars[k] then
		icon:SetModel( tbl.cars[k].model )
	elseif tbl.doncars[k] then 
		icon:SetModel( tbl.doncars[k].model )
	else
		icon:SetModel( tbl.govcars[k].model )
	end
	icon:SetSize( 100, 100 )

	local _b = _:Add( 'DButton' )
	_b:Dock( RIGHT )
	_b:SetSize( 100, 0 )
	_b:DockMargin( 5, 25, 5, 25)
	_b:SetText( '' )
	_b.Paint = function( _, w, h )
		if #car:GetNWString( 'veh_lastowner' ) > 0 then
			draw.RoundedBox(0,0,0,w,h,Color(255,255,255,5))
			draw.SimpleText( 'Отозвать', 'DermaDefault', w/2, h/2, Color( 255,255,255, 100 ) , 1, 1)
		else
			if !_b:IsHovered() then
				draw.RoundedBox(0,0,0,w,h,Color(255,255,255,7))
			else
				draw.RoundedBox(0,0,0,w,h,Color(255,255,255,10))
			end	
			draw.SimpleText( 'Отозвать', 'DermaDefault', w/2, h/2, Color( 255,255,255 ) , 1, 1)	
		end	
		draw.RoundedBox(0,0,0,w,1,Color(60,60,60))
		draw.RoundedBox(0,0,h-1,w,1,Color(60,60,60))
		draw.RoundedBox(0,0,0,1,h,Color(60,60,60))
		draw.RoundedBox(0,w-1,0,1,h,Color(60,60,60))

		
	end

	_b.DoClick = function()

		f:Remove()

		if #car:GetNWString( 'veh_lastowner' ) > 0 then
			return
		end

		LocalPlayer():EmitSound( 'garrysmod/ui_click.wav', 100 )

		net.Start( 'gpcard_remove' )
		net.SendToServer()

	end

end

function spawn_menu( ent, player_cars )

	if LocalPlayer():GetNWEntity( 'gpcard_veh' ) != NULL then
		carmenu()
		return
	end

	if table.Count( player_cars ) <= 0 then
		nocars_menu()
		return
	end

	local f = vgui.Create( 'gpFrame' )
		f:SetSize( 700, 600 )
	f:SetTitle( 'Вызов транспорта' )
	f:Center()
	f:MakePopup()


	local fw, fh = f:GetSize()


	local ds = f:Add( 'DScrollPanel' )
	ds:Dock( FILL )
	ds:GetVBar().Paint = function() end
	ds:GetVBar():SetWide( 0 )
	for k, v in pairs( ds:GetVBar():GetChildren() ) do
		v.Paint = function() end
	end
	ds:DockMargin( 0, 0, 0, 5 )

	local tblc = tbl.cars


	for k,v in SortedPairsByMemberValue( player_cars, 'id' ) do
	
		local _ = ds:Add( 'DPanel' )
		_:Dock( TOP )
		_:SetSize( 100, 100 )
		_:DockMargin( 5, 5, 5, 5 )
		_:DockPadding( 1, 1, 1, 1 )
		_.Paint = function( _, w, h )

			gp_inv.blur( _, 5, 12, 255 )

			draw.RoundedBox(0,0,0,w,h,Color(255,255,255,2))
			if tbl.govcars[k] then
				
				local cin = ( math.sin( CurTime() ) + 1 ) / 2
				local color = Color( cin * 255, 0, 255 - ( cin * 255 ), 255 )



				draw.RoundedBox(0,0,0,w,1,color)
				draw.RoundedBox(0,0,h-1,w,1,color)
				draw.RoundedBox(0,0,0,1,h,color)
				draw.RoundedBox(0,w-1,0,1,h,color)
			else
				draw.RoundedBox(0,0,0,w,1,Color(60,60,60))
				draw.RoundedBox(0,0,h-1,w,1,Color(60,60,60))
				draw.RoundedBox(0,0,0,1,h,Color(60,60,60))
				draw.RoundedBox(0,w-1,0,1,h,Color(60,60,60))
			end
			if tblc[k] then
				draw.SimpleText( tblc[k].name..' | '..v.info.number, 'Trebuchet24', 110, 5, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			elseif tbl.govcars[k] then
				draw.SimpleText( tbl.govcars[k].name..' | Служебная', 'Trebuchet24', 110, 5, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			elseif tbl.doncars[k] then
				surface.SetDrawColor( 255, 255, 255, 255 )
				surface.SetMaterial( Material( 'icon16/heart.png' ) )
				surface.DrawTexturedRect( 115, 10, 15, 15 )
				draw.SimpleText( tbl.doncars[k].name..' | '..v.info.number, 'Trebuchet24', 140, 5, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			end	
			draw.RoundedBox( 0, 110, 35, 25, 26, Color( 0, 0, 0, 150 ) )
			draw.RoundedBox( 0, 110, 65, 25, 26, Color( 0, 0, 0, 150 ) )
			draw.RoundedBox( 0, 140, 35, 150, 26, Color( 0, 0, 0, 150 ) )
			draw.RoundedBox( 0, 140, 65, 150, 26, Color( 0, 0, 0, 150 ) )

			if v.info.hp and v.info.maxhp then
				draw.RoundedBox( 0, 143, 38, v.info.hp/v.info.maxhp*144, 20, Color( 43, 168, 14, 150 ) )
				draw.RoundedBox( 0, 143, 68, v.info.fuel/v.info.maxfuel*144, 20, Color( 248, 244, 0, 150 ) )
				draw.SimpleTextOutlined( math.ceil(v.info.hp/v.info.maxhp*100)..'%', 'Trebuchet24', 215, 48, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
				draw.SimpleTextOutlined( math.ceil(v.info.fuel/v.info.maxfuel*100)..'%', 'Trebuchet24', 215, 78, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
			else
				draw.RoundedBox( 0, 143, 38, 144, 20, Color( 43, 168, 14, 150 ) )
				draw.RoundedBox( 0, 143, 68, 144, 20, Color( 248, 244, 0, 150 ) )
			end

			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetMaterial( Material( 'gportalhud/car.png' ) )
			surface.DrawTexturedRect( 115, 40, 15, 15 )
			surface.SetMaterial( Material( 'gportalhud/fuel.png' ) )
			surface.DrawTexturedRect( 115, 70, 15, 15 )

		end

		local dp = _:Add( 'DPanel' )
		dp:Dock( LEFT )
		dp:SetSize( 100, 100 )
		dp.Paint = function( _, w, h )

		end

		local icon = dp:Add( 'ModelImage' )
		icon:Dock( FILL )
		if tblc[k] then
			icon:SetModel( tblc[k].model )
		elseif tbl.govcars[k] then
			icon:SetModel( tbl.govcars[k].model )
		elseif tbl.doncars[k] then
			icon:SetModel( tbl.doncars[k].model )
		end
		icon:SetSize( 100, 100 )

		local _b = _:Add( 'DButton' )
		_b:Dock( RIGHT )
		_b:SetSize( 100, 0 )
		_b:DockMargin( 5, 15, 5, 55)
		_b:SetText( '' )
		_b.Paint = function( _, w, h )
		
			if !_b:IsHovered() then
				draw.RoundedBox(0,0,0,w,h,Color(255,255,255,7))
			else
				draw.RoundedBox(0,0,0,w,h,Color(255,255,255,10))
			end		
			draw.RoundedBox(0,0,0,w,1,Color(60,60,60))
			draw.RoundedBox(0,0,h-1,w,1,Color(60,60,60))
			draw.RoundedBox(0,0,0,1,h,Color(60,60,60))
			draw.RoundedBox(0,w-1,0,1,h,Color(60,60,60))

			draw.SimpleText( 'Вызвать', 'DermaDefault', w/2, h/2, Color( 255,255,255 ) , 1, 1)
		end

		_b.DoClick = function()

			LocalPlayer():EmitSound( 'garrysmod/ui_click.wav', 100 )

			net.Start( 'gpcard_spawn' )
				net.WriteEntity( ent )
				net.WriteString( k )
			net.SendToServer()

			f:Remove()

		end
		local _b = _:Add( 'DButton' )
		_b:Dock( RIGHT )
		_b:SetSize( 100, 0 )
		_b:DockMargin( 5, 55, -105, 15)
		_b:SetText( '' )
		_b.Paint = function( _, w, h )
		
			if !_b:IsHovered() then
				draw.RoundedBox(0,0,0,w,h,Color(255,255,255,7))
			else
				draw.RoundedBox(0,0,0,w,h,Color(255,255,255,10))
			end		
			draw.RoundedBox(0,0,0,w,1,Color(60,60,60))
			draw.RoundedBox(0,0,h-1,w,1,Color(60,60,60))
			draw.RoundedBox(0,0,0,1,h,Color(60,60,60))
			draw.RoundedBox(0,w-1,0,1,h,Color(60,60,60))

			draw.SimpleText( 'Продать', 'DermaDefault', w/2, h/2, Color( 255,255,255 ) , 1, 1)
		end

		_b.DoClick = function()

			LocalPlayer():EmitSound( 'garrysmod/ui_click.wav', 100 )

			buyout_menu( k )

			f:Remove()

		end

	end

end

net.Receive( 'gp_card_spawnmenu', function()

	local t = net.ReadTable()
	local ent = net.ReadEntity()

	if t and ent then
		spawn_menu( ent, t )
	end

end)

concommand.Add('gpcard_remove', function()

		LocalPlayer():EmitSound( 'garrysmod/ui_click.wav', 100 )

		net.Start( 'gpcard_remove' )
		net.SendToServer()

end)



-------
local tbl = {
	['models/crsk_autos/avtovaz/2170priora_2008.mdl'] = {
		{	
			pos=Vector(0,107,21),
			ang=Angle(0,180,90),
			scale=0.035,
		},
		{	
			pos=Vector(0,-105,36),
			ang=Angle(0,0,80),
			scale=0.035,
		},
	},
	['models/crsk_autos/rolls-royce/phantom_viii_2018.mdl'] = {
		{	
			pos=Vector(0,85.2,21),
			ang=Angle(0,180,90),
			scale=0.035,
		},
		{	
			pos=Vector(0,-150,38),
			ang=Angle(0,0,80),
			scale=0.035,
		},
	},
	['models/crsk_autos/bmw/z4e89_2012.mdl'] = {
		{	
			pos=Vector(0,98,20),
			ang=Angle(0,180,90),
			scale=0.035,
		},
		{	
			pos=Vector(0,-103,25),
			ang=Angle(0,0,80),
			scale=0.035,
		},
	},
	['models/crsk_autos/avtovaz/2101.mdl'] = {
		{	
			pos=Vector(0,92,20),
			ang=Angle(0,180,90),
			scale=0.035,
		},
		{	
			pos=Vector(0,-95,30),
			ang=Angle(0,0,90),
			scale=0.035,
		},
	},
	['models/crsk_autos/avtovaz/2106.mdl'] = {
		{	
			pos=Vector(0,92,20),
			ang=Angle(0,180,90),
			scale=0.035,
		},
		{	
			pos=Vector(0,-94,30),
			ang=Angle(0,0,90),
			scale=0.035,
		},
	},
	['models/crsk_autos/avtovaz/2107.mdl'] = {
		{	
			pos=Vector(0,96.7,17),
			ang=Angle(0,180,90),
			scale=0.035,
		},
		{	
			pos=Vector(0,-91,30),
			ang=Angle(0,0,90),
			scale=0.035,
		},
	},
	['models/crsk_autos/uaz/patriot_2014.mdl'] = {
		{	
			pos=Vector(0,97,35),
			ang=Angle(0,180,90),
			scale=0.035,
		},
		{	
			pos=Vector(-16,-121,40),
			ang=Angle(0,0,90),
			scale=0.035,
		},
	},
	['models/crsk_autos/avtovaz/vesta.mdl'] = {
		{	
			pos=Vector(0,105,23),
			ang=Angle(0,180,90),
			scale=0.035,
		},
		{	
			pos=Vector(0,-103,41),
			ang=Angle(0,0,90),
			scale=0.035,
		},
	},
	['models/crsk_autos/bmw/alpina_b10.mdl'] = {
		{	
			pos=Vector(0,109,23),
			ang=Angle(0,180,90),
			scale=0.035,
		},
		{	
			pos=Vector(0,-115.6,36),
			ang=Angle(0,0,90),
			scale=0.035,
		},
	},
	['models/crsk_autos/bmw/750i_e38_1995.mdl'] = {
		{	
			pos=Vector(0,118,23),
			ang=Angle(0,180,90),
			scale=0.035,
		},
		{	
			pos=Vector(0,-124,36),
			ang=Angle(0,0,90),
			scale=0.035,
		},
	},






	['models/crsk_autos/bmw/7er_g11_2015.mdl'] = {
		{	
			pos=Vector(0,125,23),
			ang=Angle(0,180,90),
			scale=0.035,
		},
		{	
			pos=Vector(0,-121,41),
			ang=Angle(0,0,90),
			scale=0.035,
		},
	},
	['models/crsk_autos/bmw/x6m_f86_2015.mdl'] = {
		{	
			pos=Vector(0,131.1,27),
			ang=Angle(0,180,90),
			scale=0.035,
		},
		{	
			pos=Vector(0,-111.7,52),
			ang=Angle(0,0,90),
			scale=0.035,
		},
	},
	['models/crsk_autos/audi/rs6_avant_2016.mdl'] = {
		{	
			pos=Vector(0,112,25),
			ang=Angle(0,180,90),
			scale=0.035,
		},
		{	
			pos=Vector(0,-121,38),
			ang=Angle(0,0,90),
			scale=0.035,
		},
	},


	['models/crsk_autos/ford/focus_mk3_2012.mdl'] = {
		{	
			pos=Vector(0,100,23),
			ang=Angle(0,180,90),
			scale=0.035,
		},
		{	
			pos=Vector(0,-116,42),
			ang=Angle(0,0,90),
			scale=0.035,
		},
	},
	['models/crsk_autos/gaz/24_volga.mdl'] = {
		{	
			pos=Vector(0,107,26),
			ang=Angle(0,180,90),
			scale=0.035,
		},
		{	
			pos=Vector(0,-132,34),
			ang=Angle(0,0,90),
			scale=0.035,
		},
	},
	['models/crsk_autos/mercedes-benz/500se_w140_1992.mdl'] = {
		{	
			pos=Vector(0,127.5,19),
			ang=Angle(0,180,90),
			scale=0.035,
		},
		{	
			pos=Vector(0,-113,38),
			ang=Angle(0,0,90),
			scale=0.035,
		},
	},
	['models/crsk_autos/mercedes-benz/c63s_amg_coupe_2016.mdl'] = {
		{	
			pos=Vector(0,105.2,15),
			ang=Angle(0,180,90),
			scale=0.035,
		},
		{	
			pos=Vector(0,-120,25),
			ang=Angle(0,0,90),
			scale=0.035,
		},
	},
	['models/crsk_autos/mercedes-benz/gt63s_coupe_amg_2018.mdl'] = {
		{	
			pos=Vector(0,125,15),
			ang=Angle(0,180,90),
			scale=0.035,
		},
		{	
			pos=Vector(0,-124,25),
			ang=Angle(0,0,90),
			scale=0.035,
		},
	},
	

	['models/crsk_autos/mercedes-benz/g500_2008.mdl'] = {
		{	
			pos=Vector(0,94,25),
			ang=Angle(0,180,90),
			scale=0.035,
		},
		{	
			pos=Vector(0,-114,25),
			ang=Angle(0,0,90),
			scale=0.035,
		},
	},
	['models/crsk_autos/mercedes-benz/gl63_amg_2013.mdl'] = {
		{	
			pos=Vector(0,107,20),
			ang=Angle(0,180,90),
			scale=0.035,
		},
		{	
			pos=Vector(0,-134,45),
			ang=Angle(0,0,90),
			scale=0.035,
		},
	},
	['models/crsk_autos/porsche/911_turbos_2017.mdl'] = {
		{	
			pos=Vector(0,110,20),
			ang=Angle(0,180,90),
			scale=0.035,
		},
		{	
			pos=Vector(0,-110,25),
			ang=Angle(0,0,90),
			scale=0.035,
		},
	},
	['models/crsk_autos/toyota/landcruiser_200_2012.mdl'] = {
		{	
			pos=Vector(0,131,33),
			ang=Angle(0,180,90),
			scale=0.035,
		},
		{	
			pos=Vector(0,-112,44),
			ang=Angle(0,0,90),
			scale=0.035,
		},
	},
	['models/crsk_autos/avtovaz/2109.mdl'] = {
		{	
			pos=Vector(0,101,25),
			ang=Angle(0,180,90),
			scale=0.035,
		},
		{	
			pos=Vector(0,-102,33),
			ang=Angle(0,0,90),
			scale=0.035,
		},
	},
	['models/crsk_autos/avtovaz/2115.mdl'] = {
		{	
			pos=Vector(0,108.1,24),
			ang=Angle(0,180,90),
			scale=0.035,
		},
		{	
			pos=Vector(0,-108,20),
			ang=Angle(0,0,90),
			scale=0.035,
		},
	},
	['models/crsk_autos/avtovaz/2114.mdl'] = {
		{	
			pos=Vector(0,100.5,22.5),
			ang=Angle(0,180,90),
			scale=0.035,
		},
		{	
			pos=Vector(0,-83,29),
			ang=Angle(0,0,90),
			scale=0.035,
		},
	},
	['models/crsk_autos/zaz/968m.mdl'] = {
		{	
			pos=Vector(0,79,22.5),
			ang=Angle(0,180,90),
			scale=0.035,
		},
		{	
			pos=Vector(0,-94.7,29),
			ang=Angle(0,0,90),
			scale=0.035,
		},
	},
	['models/lonewolfie/uaz_452.mdl'] = {
		{	
			pos=Vector(0,79,22.5),
			ang=Angle(0,180,90),
			scale=0.035,
		},
		{	
			pos=Vector(0,-94.7,29),
			ang=Angle(0,0,90),
			scale=0.035,
		},
	},



}

surface.CreateFont('LicensePlate',{
	font='Arial',
	size=128,
	weight = 500,
	antialias=true,

})
surface.CreateFont('LicensePlate2',{
	font='Arial',
	size=115,
	weight = 500,
	antialias=true,

})
local model
local w,h
hook.Add('PostDrawTranslucentRenderables','LicensePlate',function()
	surface.SetMaterial(Material('gportalrp/number_rus.png'))
	surface.SetDrawColor(255,255,255,255)
	surface.SetFont('LicensePlate')
	surface.SetTextColor(Color(0,0,0))
	for _,veh in ipairs(ents.FindByClass('prop_vehicle_*')) do
		model=veh:GetModel()
		if tbl[model] then
			local id=veh:GetNWString('LicensePlate','А000АА')
			if id then
				w,h=surface.GetTextSize(id)
				for _,plate in ipairs(tbl[model]) do
					cam.Start3D2D(veh:LocalToWorld(plate.pos),veh:LocalToWorldAngles(plate.ang),plate.scale)
						surface.DrawTexturedRect(-390,-82.5,780,165)
						surface.SetTextPos(-200, -70)
						surface.DrawText(utf8.upper(string.sub(id, 3, 5)))
						surface.SetFont('LicensePlate2')
						surface.SetTextPos(-310, -60)
						surface.DrawText(utf8.upper(string.sub(id, 1, 2)))
						surface.SetFont('LicensePlate2')
						surface.SetTextPos(20, -60)
						surface.DrawText(utf8.upper(string.sub(id, 6, 9)))
					cam.End3D2D()
				end
			end
		end
	end
end)
