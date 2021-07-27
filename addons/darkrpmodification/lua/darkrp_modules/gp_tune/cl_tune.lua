module( 'gp_tune', package.seeall )

surface.CreateFont( 'gp_nf4_20_sh', {
	font = 'Roboto',
	size = 20
} )
surface.CreateFont( 'gp_nf4_21_sh', {
	font = 'Roboto',
	size = 21
} )

function OpenTuneMenu( veh_tbl )

	local tbl_card = gp_cardealer.tbl.cars[veh_tbl.info.class]

	local car_tune = veh_tbl.parts

	fill = vgui.Create( 'DPanel' )
	fill:Dock( FILL )
	fill.Paint = function( _, w, h )

		gp_inv.blur( _, 5, 12, 255 )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 70 ) )

	end
	
	rp = fill:Add( 'DFrame' )
	rp:SetSize( 400, 255 )
	rp:SetTitle( '' )
	rp:SetSizable( false )
	rp:MakePopup()
	rp:ShowCloseButton( false )
	rp:SetDraggable( true )
	rp:DockPadding( 0, 30, 0, 0 )
	rp:SetPos( ScrW()-500, ScrH()/2-150 )
	rp.Paint = function( _, w, h )

		draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 220 ) )
		draw.RoundedBox( 0, 0, 0, w, 50, Color( 0, 0, 0, 230 ) )
		draw.SimpleText( 'Тюнинг '..tbl_card.name, 'gp_nf4_21_sh', w/2, 25, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER  )
		if rp.color then
			draw.SimpleText( 'Вид покрасочных работ:', 'gp_nf4_20_sh', 60, h-55, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		end

	end

	local mdl = fill:Add( 'DModelPanel' )
	mdl:Dock( FILL )
	mdl:DockMargin( 150, 150, 500, 150  )
	mdl:SetModel( tbl_card.model )
	mdl:SetColor( veh_tbl.info.color )
	gp_F4.fixMdlPos( mdl )

	for k,v in pairs( mdl.Entity:GetBodyGroups() ) do
		if car_tune[v.name] then
			mdl.Entity:SetBodygroup( v.id, car_tune[v.name].num )	
		end
	end

	local function _GetColorblyad()

		return mdl:GetColor()

	end

	function buy_menu( v, vs, k )

		if dp_buy then
			dp_buy:Remove()
		end
		if !car_tune[vs.name] and ( v.name == 'Установить' or v.name == 'Нет' ) then
			return
		end
		if car_tune[vs.name] and car_tune[vs.name].num == k then 
			return 
		end

		dp_buy = fill:Add( 'DPanel' )
		dp_buy:SetSize( 400, 100 )
		dp_buy:SetPos( ScrW()-500, ScrH()/2+35 )
		dp_buy.Paint = function( _, w, h )

			draw.RoundedBox( 0, 0, 0, w, 35, Color( 0, 0, 0, 220 ) )
			draw.RoundedBox( 0, 0, 35, w, h-35, Color( 0, 0, 0, 150 ) )
			draw.SimpleText( 'Купить "'..vs.name..'>'..v.name..'"?', 'gp_nf4_20_sh', w/2, 15, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		end

		local bt = dp_buy:Add( 'DButton' )
		bt:SetText( '' )
		bt:Dock( LEFT )
		bt:DockMargin( 125, 55, 15, 25 )
		bt.Paint = function( _, w, h )

			draw.RoundedBox(0,0,0,w,h,Color(255,255,255,10))
			if _:IsHovered() then
				draw.RoundedBox(0,0,0,w,1,Color(60,150,60))
				draw.RoundedBox(0,0,h-1,w,1,Color(60,150,60))
				draw.RoundedBox(0,0,0,1,h,Color(60,150,60))
				draw.RoundedBox(0,w-1,0,1,h,Color(60,150,60))
			end

			draw.SimpleText( 'Да', 'gp_nf4_20_sh', w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

		end
		bt.DoClick = function()

			net.Start( 'gp_tunecar' )
				net.WriteString( veh_tbl.info.class )
				net.WriteString( vs.name )
				net.WriteInt( k, 4 )
			net.SendToServer()

			if LocalPlayer():canAfford( v.price ) then
				Derma_Query( 'Вы успешно купили "'..vs.name..'>'..v.name..'"', 'Уведомление', 'OK', function() end)
			else
				Derma_Query( 'Недостаточно средств для покупки "'..vs.name..'>'..v.name..'"', 'Уведомление', 'OK', function() end)
			end
			fill:Remove()
		end


		local bt = dp_buy:Add( 'DButton' )
		bt:SetText( '' )
		bt:Dock( RIGHT )
		bt:DockMargin( 15, 55, 125, 25 )
		bt.Paint = function( _, w, h )

			draw.RoundedBox(0,0,0,w,h,Color(255,255,255,10))
			if _:IsHovered() then
				draw.RoundedBox(0,0,0,w,1,Color(60,150,60))
				draw.RoundedBox(0,0,h-1,w,1,Color(60,150,60))
				draw.RoundedBox(0,0,0,1,h,Color(60,150,60))
				draw.RoundedBox(0,w-1,0,1,h,Color(60,150,60))
			end

			draw.SimpleText( 'Нет', 'gp_nf4_20_sh', w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

		end
		bt.DoClick = function()

			dp_buy:Remove()

		end

	end


	function buy_menu_ent( tbl, k )
		
		if dp_buy_en then
			dp_buy_en:Remove()
		end

		dp_buy_en = fill:Add( 'DPanel' )
		dp_buy_en:SetSize( 400, 100 )
		dp_buy_en:SetPos( ScrW()-500, ScrH()/2+70 )
		dp_buy_en.Paint = function( _, w, h )

			draw.RoundedBox( 0, 0, 0, w, 35, Color( 0, 0, 0, 220 ) )
			draw.RoundedBox( 0, 0, 35, w, h-35, Color( 0, 0, 0, 150 ) )
			draw.SimpleText( 'Установить "'..tbl.name..'"?', 'gp_nf4_20_sh', w/2, 15, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		end

		local bt = dp_buy_en:Add( 'DButton' )
		bt:SetText( '' )
		bt:Dock( LEFT )
		bt:DockMargin( 125, 55, 15, 25 )
		bt.Paint = function( _, w, h )

			draw.RoundedBox(0,0,0,w,h,Color(255,255,255,10))
			if _:IsHovered() then
				draw.RoundedBox(0,0,0,w,1,Color(60,150,60))
				draw.RoundedBox(0,0,h-1,w,1,Color(60,150,60))
				draw.RoundedBox(0,0,0,1,h,Color(60,150,60))
				draw.RoundedBox(0,w-1,0,1,h,Color(60,150,60))
			end

			draw.SimpleText( 'Да', 'gp_nf4_20_sh', w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

		end
		bt.DoClick = function()

			if LocalPlayer():canAfford( tbl.price ) then
				Derma_Query( 'Вы успешно установили "'..tbl.name..'"', 'Уведомление', 'OK', function() end)
			else
				Derma_Query( 'Недостаточно средств для покупки "'..tbl.name..'"', 'Уведомление', 'OK', function() end)
			end
			fill:Remove()

			net.Start( 'gp_tunecar_en' )
				net.WriteString( veh_tbl.info.class )
				net.WriteInt( k, 4 )
			net.SendToServer()
			
		end


		local bt = dp_buy_en:Add( 'DButton' )
		bt:SetText( '' )
		bt:Dock( RIGHT )
		bt:DockMargin( 15, 55, 125, 25 )
		bt.Paint = function( _, w, h )

			draw.RoundedBox(0,0,0,w,h,Color(255,255,255,10))
			if _:IsHovered() then
				draw.RoundedBox(0,0,0,w,1,Color(60,150,60))
				draw.RoundedBox(0,0,h-1,w,1,Color(60,150,60))
				draw.RoundedBox(0,0,0,1,h,Color(60,150,60))
				draw.RoundedBox(0,w-1,0,1,h,Color(60,150,60))
			end

			draw.SimpleText( 'Нет', 'gp_nf4_20_sh', w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

		end
		bt.DoClick = function()

			dp_buy_en:Remove()

		end

	end

	function buy_menu_color()

		if dp_buy_clr then
			dp_buy_clr:Remove()
		end

		dp_buy_clr = fill:Add( 'DPanel' )
		dp_buy_clr:SetSize( 400, 100 )
		dp_buy_clr:SetPos( ScrW()-500, ScrH()/2+165 )
		dp_buy_clr.Paint = function( _, w, h )

			draw.RoundedBox( 0, 0, 0, w, 35, Color( 0, 0, 0, 220 ) )
			draw.RoundedBox( 0, 0, 35, w, h-35, Color( 0, 0, 0, 150 ) )
			draw.SimpleText( 'Перекрасить т/c? ('..DarkRP.formatMoney( 25000 )..')' , 'gp_nf4_20_sh', w/2, 15, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		end

		local bt = dp_buy_clr:Add( 'DButton' )
		bt:SetText( '' )
		bt:Dock( LEFT )
		bt:DockMargin( 125, 55, 15, 25 )
		bt.Paint = function( _, w, h )

			draw.RoundedBox(0,0,0,w,h,Color(255,255,255,10))
			if _:IsHovered() then
				draw.RoundedBox(0,0,0,w,1,Color(60,150,60))
				draw.RoundedBox(0,0,h-1,w,1,Color(60,150,60))
				draw.RoundedBox(0,0,0,1,h,Color(60,150,60))
				draw.RoundedBox(0,w-1,0,1,h,Color(60,150,60))
			end

			draw.SimpleText( 'Да', 'gp_nf4_20_sh', w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

		end
		bt.DoClick = function()

			net.Start( 'gp_tunecar_clr' )
				net.WriteString( veh_tbl.info.class )
				net.WriteString( string.FromColor( mdl.col ) )
				net.WriteInt( mdl.Entity:GetSkin(), 6 )
			net.SendToServer()

			if LocalPlayer():canAfford( 25000 ) then
				Derma_Query( 'Вы успешно перекрасили т/с!', 'Уведомление', 'OK', function() end)
			else
				Derma_Query( 'Недостаточно средств для перекраски т/с', 'Уведомление', 'OK', function() end)
			end
			fill:Remove()
			
		end


		local bt = dp_buy_clr:Add( 'DButton' )
		bt:SetText( '' )
		bt:Dock( RIGHT )
		bt:DockMargin( 15, 55, 125, 25 )
		bt.Paint = function( _, w, h )

			draw.RoundedBox(0,0,0,w,h,Color(255,255,255,10))
			if _:IsHovered() then
				draw.RoundedBox(0,0,0,w,1,Color(60,150,60))
				draw.RoundedBox(0,0,h-1,w,1,Color(60,150,60))
				draw.RoundedBox(0,0,0,1,h,Color(60,150,60))
				draw.RoundedBox(0,w-1,0,1,h,Color(60,150,60))
			end

			draw.SimpleText( 'Нет', 'gp_nf4_20_sh', w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

		end
		bt.DoClick = function()

			dp_buy_clr:Remove()

		end

	end

	local function OpenMenu_TuneList( cat, dss )	

		local ds = dss

		ds:Remove()

		ds = rp:Add( 'DScrollPanel' )
		ds:Dock( FILL )
		ds:DockMargin( 0, 25, 0, 5)
		ds:SetWide( ScrW()/3.5 )
		ds.Paint = function( _, w ,h )
		end
		ds:GetVBar():SetWide( 2 )
		--[[
		ds:GetVBar().Paint = function() end
		
		for k, v in pairs( ds:GetVBar():GetChildren() ) do
			v.Paint = function() end
		end
		--]]
		for k,v in pairs( mdl.Entity:GetBodyGroups() ) do
			
			if tbl[v.name] and tbl[v.name].cat == cat then
				
				local _ = ds:Add( 'DButton' )
				_:Dock( TOP )
				_:DockMargin( 0, 0, 0, 5 )
				_:SetSize( 35, 35 )
				_:SetText( '' )
				_.Paint = function( _, w, h )

					draw.RoundedBox( 0, 0, 0, w, h, Color( 45, 45, 45, 215 ) )
					if _:IsHovered() then
						draw.RoundedBox(0,0,0,w,1,Color(60,150,60))
						draw.RoundedBox(0,0,h-1,w,1,Color(60,150,60))
						draw.RoundedBox(0,0,0,1,h,Color(60,150,60))
						draw.RoundedBox(0,w-1,0,1,h,Color(60,150,60))
					end
					draw.SimpleText( tbl[v.name].name, 'gp_nf4_20_sh', w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				end	
				_.DoClick = function()

					ds:Remove()

					rp:SetSize( 400, 175 )

					local vs = v

					local ds = rp:Add( 'DScrollPanel' )
					ds:Dock( FILL )
					ds:DockMargin( 0, 25, 0, 5)
					ds:SetWide( ScrW()/3.5 )
					ds.Paint = function( _, w ,h )
					end
					ds:GetVBar().Paint = function() end
					ds:GetVBar():SetWide( 2 )
					--[[
					ds:GetVBar().Paint = function() end
					
					for k, v in pairs( ds:GetVBar():GetChildren() ) do
						v.Paint = function() end
					end
					--]]
					for k,v in pairs( tbl[vs.name].subs ) do

						local _ = ds:Add( 'DButton' )
						_:Dock( TOP )
						_:DockMargin( 0, 0, 0, 5 )
						_:SetSize( 35, 35 )
						_:SetText( '' )
						_.Paint = function( _, w, h )

							draw.RoundedBox( 0, 0, 0, w, h, Color( 45, 45, 45, 215 ) )
							if _:IsHovered() then
								draw.RoundedBox(0,0,0,w,1,Color(60,150,60))
								draw.RoundedBox(0,0,h-1,w,1,Color(60,150,60))
								draw.RoundedBox(0,0,0,1,h,Color(60,150,60))
								draw.RoundedBox(0,w-1,0,1,h,Color(60,150,60))
							end
							
							draw.SimpleText( v.name, 'gp_nf4_20_sh', 15, h/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

							if !car_tune[vs.name] and  ( v.name == 'Установить' or v.name == 'Нет' ) then

								surface.SetDrawColor( 255, 255, 255, 255 )
								surface.SetMaterial( Material( 'icon16/box.png' ) )
								surface.DrawTexturedRect( w-50, h/2-8, 16, 16)

							elseif car_tune[vs.name] and car_tune[vs.name].num == k then

								surface.SetDrawColor( 255, 255, 255, 255 )
								surface.SetMaterial( Material( 'icon16/box.png' ) )
								surface.DrawTexturedRect( w-50, h/2-8, 16, 16)

							else
								surface.SetFont( 'gp_nf4_20_sh' )

								local tw,th = surface.GetTextSize( DarkRP.formatMoney(  v.price  ) )

								draw.SimpleText( DarkRP.formatMoney(  v.price  ), 'gp_nf4_20_sh', w-tw-5, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
							end
						end
						_.DoClick = function()
							act = v
							buy_menu( v, vs, k )
							for klas,vlad in pairs( mdl.Entity:GetBodyGroups() ) do
								if vlad.name == vs.name then
									mdl.Entity:SetBodygroup( vlad.id, k )
								end
							end
						end
					end
					local _ = rp:Add( 'DButton' )
					_:Dock( BOTTOM )
					_:DockMargin( 0, 0, 0, 5 )
					_:SetSize( 35, 35 )
					_:SetText( '' )
					_.Paint = function( _, w, h )

						draw.RoundedBox(0,0,0,w,h,Color(255,255,255,10))
						if _:IsHovered() then
							draw.RoundedBox(0,0,0,w,1,Color(60,150,60))
							draw.RoundedBox(0,0,h-1,w,1,Color(60,150,60))
							draw.RoundedBox(0,0,0,1,h,Color(60,150,60))
							draw.RoundedBox(0,w-1,0,1,h,Color(60,150,60))
						end

						draw.SimpleText( 'Назад', 'gp_nf4_20_sh', w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

					end
					ds.OnRemove = function()

						_:Remove()

					end
					_.DoClick = function()
						if dp_buy then
							dp_buy:Remove()
						end
						ds:Remove()
						rp:SetSize( 400, 255 )
						OpenMenu_TuneList( cat, ds )
					end
				end
			end
		end

		local _ = rp:Add( 'DButton' )
		_:Dock( BOTTOM )
		_:DockMargin( 0, 0, 0, 5 )
		_:SetSize( 35, 35 )
		_:SetText( '' )
		_.Paint = function( _, w, h )

			draw.RoundedBox(0,0,0,w,h,Color(255,255,255,10))
			if _:IsHovered() then
				draw.RoundedBox(0,0,0,w,1,Color(60,150,60))
				draw.RoundedBox(0,0,h-1,w,1,Color(60,150,60))
				draw.RoundedBox(0,0,0,1,h,Color(60,150,60))
				draw.RoundedBox(0,w-1,0,1,h,Color(60,150,60))
			end

			draw.SimpleText( 'Назад', 'gp_nf4_20_sh', w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

		end
		_.DoClick = function()

			ds:Remove()
			LoadButtons()

		end

		ds.OnRemove = function()

			_:Remove()

		end

	end


	function LoadButtons()
		local ds = rp:Add( 'DScrollPanel' )
		ds:Dock( FILL )
		ds:DockMargin( 0, 25, 0, 5)
		ds:SetWide( ScrW()/3.5 )
		ds.Paint = function( _, w ,h )
		end
		ds:GetVBar().Paint = function() end
		ds:GetVBar():SetWide( 0 )
		for k, v in pairs( ds:GetVBar():GetChildren() ) do
			v.Paint = function() end
		end

		for k,v in pairs( cats ) do
		
			local _ = ds:Add( 'DButton' )
			_:Dock( TOP )
			_:DockMargin( 0, 0, 0, 5 )
			_:SetSize( 35, 35 )
			_:SetText( '' )
			_.Paint = function( _, w, h )

				draw.RoundedBox( 0, 0, 0, w, h, Color( 45, 45, 45, 215 ) )
				if _:IsHovered() then
					draw.RoundedBox(0,0,0,w,1,Color(60,150,60))
					draw.RoundedBox(0,0,h-1,w,1,Color(60,150,60))
					draw.RoundedBox(0,0,0,1,h,Color(60,150,60))
					draw.RoundedBox(0,w-1,0,1,h,Color(60,150,60))
				end
				draw.SimpleText( v, 'gp_nf4_20_sh', w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

			end
			_.DoClick = function()
				OpenMenu_TuneList( v, ds )
			end
		end


		local _ = ds:Add( 'DButton' )
		_:Dock( TOP )
		_:DockMargin( 0, 0, 0, 5 )
		_:SetSize( 35, 35 )
		_:SetText( '' )
		_.Paint = function( _, w, h )

			draw.RoundedBox( 0, 0, 0, w, h, Color( 45, 45, 45, 215 ) )
			if _:IsHovered() then
				draw.RoundedBox(0,0,0,w,1,Color(60,150,60))
				draw.RoundedBox(0,0,h-1,w,1,Color(60,150,60))
				draw.RoundedBox(0,0,0,1,h,Color(60,150,60))
				draw.RoundedBox(0,w-1,0,1,h,Color(60,150,60))
			end
			draw.SimpleText( 'Покраска', 'gp_nf4_20_sh', w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

		end
		
		_.DoClick = function()

			ds:Remove()

			rp:SetSize( 400, 300 )

			local cp = rp:Add( 'DRGBPicker' )
			cp:SetSize( 30, 190 )
			cp:Dock( LEFT )
			cp:DockMargin( 5, 25, 5, 5 )


			local cc = rp:Add( 'DColorCube' )
			cc:Dock( FILL )
			cc:DockMargin( 5, 25, 5, 5 )

			function cp:OnChange( col )
				local h = ColorToHSV( col )
				local _, s, v = ColorToHSV( cc:GetRGB() )

				
				col = HSVToColor( h, s, v )
				cc:SetColor( col )

				UpdateColors( col )

			end

			function UpdateColors( col )

				mdl:SetColor( col )
				mdl.col = col
				buy_menu_color()
				
			end

			function cc:OnUserChanged( col )

				UpdateColors( col )

			end

			local _ = rp:Add( 'DButton' )
			_:Dock( BOTTOM )
			_:DockMargin( 0, 0, 0, 5 )
			_:SetSize( 35, 35 )
			_:SetText( '' )
			_.Paint = function( _, w, h )

				draw.RoundedBox(0,0,0,w,h,Color(255,255,255,10))
				if _:IsHovered() then
					draw.RoundedBox(0,0,0,w,1,Color(60,150,60))
					draw.RoundedBox(0,0,h-1,w,1,Color(60,150,60))
					draw.RoundedBox(0,0,0,1,h,Color(60,150,60))
					draw.RoundedBox(0,w-1,0,1,h,Color(60,150,60))
				end

				draw.SimpleText( 'Назад', 'gp_nf4_20_sh', w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

			end
			_.DoClick = function()

				if dp_buy_clr then
					dp_buy_clr:Remove()
				end
				rp.color = false
				dnw:Remove()
				cc:Remove()
				cp:Remove()
				rp:SetSize( 400, 255 )
				LoadButtons()

			end

			cc.OnRemove = function()

				_:Remove()

			end

			dnw = rp:Add( 'DNumberWang' )
			dnw:Dock( BOTTOM )
			dnw:DockMargin( 320, 5, 10, 5)
			dnw:SetMin( 0 )
			dnw:SetMax( mdl.Entity:SkinCount() )
			dnw.OnValueChanged = function( val )

				if dnw:GetValue() > mdl.Entity:SkinCount() then return end

				mdl.Entity:SetSkin( dnw:GetValue() )
				buy_menu_color( mdl.col, mdl.Entity:GetSkin() )

			end
			rp.color = true

		end

		local _ = ds:Add( 'DButton' )
		_:Dock( TOP )
		_:DockMargin( 0, 0, 0, 5 )
		_:SetSize( 35, 35 )
		_:SetText( '' )
		_.Paint = function( _, w, h )

			draw.RoundedBox( 0, 0, 0, w, h, Color( 45, 45, 45, 215 ) )
			if _:IsHovered() then
				draw.RoundedBox(0,0,0,w,1,Color(60,150,60))
				draw.RoundedBox(0,0,h-1,w,1,Color(60,150,60))
				draw.RoundedBox(0,0,0,1,h,Color(60,150,60))
				draw.RoundedBox(0,w-1,0,1,h,Color(60,150,60))
			end
			draw.SimpleText( 'Тюнинг двигателя', 'gp_nf4_20_sh', w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

		end
		_.DoClick = function()

			ds:Remove()
			
			rp:SetSize( 400, 215 )

			local ds = rp:Add( 'DScrollPanel' )
			ds:Dock( FILL )
			ds:DockMargin( 0, 25, 0, 5)
			ds:SetWide( ScrW()/3.5 )
			ds.Paint = function( _, w ,h )
			end
			ds:GetVBar().Paint = function() end
			ds:GetVBar():SetWide( 0 )
			for k, v in pairs( ds:GetVBar():GetChildren() ) do
				v.Paint = function() end
			end

			for k,v in SortedPairsByMemberValue( tbl_en, 'mt' ) do
			
				local _ = ds:Add( 'DButton' )
				_:Dock( TOP )
				_:DockMargin( 0, 0, 0, 5 )
				_:SetSize( 35, 35 )
				_:SetText( '' )
				_.Paint = function( _, w, h )

					draw.RoundedBox( 0, 0, 0, w, h, Color( 45, 45, 45, 215 ) )
					if _:IsHovered() then
						draw.RoundedBox(0,0,0,w,1,Color(60,150,60))
						draw.RoundedBox(0,0,h-1,w,1,Color(60,150,60))
						draw.RoundedBox(0,0,0,1,h,Color(60,150,60))
						draw.RoundedBox(0,w-1,0,1,h,Color(60,150,60))
					end
					
					draw.SimpleText( v.name, 'gp_nf4_20_sh', 15, h/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

					if veh_tbl.parts and veh_tbl.parts.en_tune and veh_tbl.parts.en_tune.stage and veh_tbl.parts.en_tune.stage == k then

						surface.SetDrawColor( 255, 255, 255, 255 )
						surface.SetMaterial( Material( 'icon16/box.png' ) )
						surface.DrawTexturedRect( w-50, h/2-8, 16, 16)

					else
						surface.SetFont( 'gp_nf4_20_sh' )

						local tw,th = surface.GetTextSize( DarkRP.formatMoney(  v.price  ) )

						draw.SimpleText( DarkRP.formatMoney(  v.price  ), 'gp_nf4_20_sh', w-tw, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
					end

				end
				_.DoClick = function()
					if veh_tbl.parts and veh_tbl.parts.en_tune and veh_tbl.parts.en_tune.stage and veh_tbl.parts.en_tune.stage == k then return end
					buy_menu_ent( v, k )
				end

			end

			local _ = rp:Add( 'DButton' )
			_:Dock( BOTTOM )
			_:DockMargin( 0, 0, 0, 5 )
			_:SetSize( 35, 35 )
			_:SetText( '' )
			_.Paint = function( _, w, h )

				draw.RoundedBox(0,0,0,w,h,Color(255,255,255,10))
				if _:IsHovered() then
					draw.RoundedBox(0,0,0,w,1,Color(60,150,60))
					draw.RoundedBox(0,0,h-1,w,1,Color(60,150,60))
					draw.RoundedBox(0,0,0,1,h,Color(60,150,60))
					draw.RoundedBox(0,w-1,0,1,h,Color(60,150,60))
				end

				draw.SimpleText( 'Назад', 'gp_nf4_20_sh', w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

			end
			_.DoClick = function()

				if dp_buy_en then dp_buy_en:Remove() end
				ds:Remove()
				LoadButtons()
				rp:SetSize( 400, 255 )
			end

			ds.OnRemove = function()

				_:Remove()

			end


		end

		local _ = rp:Add( 'DButton' )
		_:Dock( BOTTOM )
		_:DockMargin( 0, 0, 0, 5 )
		_:SetSize( 35, 35 )
		_:SetText( '' )
		_.Paint = function( _, w, h )

			draw.RoundedBox(0,0,0,w,h,Color(255,255,255,10))
			if _:IsHovered() then
				draw.RoundedBox(0,0,0,w,1,Color(60,150,60))
				draw.RoundedBox(0,0,h-1,w,1,Color(60,150,60))
				draw.RoundedBox(0,0,0,1,h,Color(60,150,60))
				draw.RoundedBox(0,w-1,0,1,h,Color(60,150,60))
			end

			draw.SimpleText( 'Выход', 'gp_nf4_20_sh', w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

		end
		_.DoClick = function()

			fill:Remove()

		end
		ds.OnRemove = function()

			_:Remove()

		end
	end

	LoadButtons()

end

concommand.Add('close_blyad', function() fill:Remove() end)

net.Receive( 'gp_tune_opmenu', function()

	local tbl = net.ReadTable()

	OpenTuneMenu( tbl )

end )