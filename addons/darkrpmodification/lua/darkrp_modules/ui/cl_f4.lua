module( 'gp_F4', package.seeall )

surface.CreateFont( 'f4.buttons', {
	font = 'Roboto',
	size = 24
} )
surface.CreateFont( 'f4.name', {
	font = 'Roboto',
	size = 21
} )
surface.CreateFont( 'f4.text', {
	font = 'Roboto',
	size = 18
} )

tabs = {}
local d_tabs = {}

local active
local sizex, sizey = ScrW()/1.4, ScrH()/1.3

local hidelist = {
	['nrg1'] = true,
	['nrg2'] = true,
	['nrg3'] = true,
	['nrg4'] = true,
	['mayor'] = true,
	['mobboss'] = true	
}
local hidecatlist = {
	['Citizens'] = true,
	['Gangsters'] = true,
	['Civil Protection'] = true,
	['Other'] = true
}


function fixMdlPos( mdl )
	if !mdl then return end

	local mn, mx = mdl.Entity:GetRenderBounds()
	local size = 0
	size = math.max( size, math.abs(mn.x) + math.abs(mx.x) )
	size = math.max( size, math.abs(mn.y) + math.abs(mx.y) )
	size = math.max( size, math.abs(mn.z) + math.abs(mx.z) )
	mdl:SetFOV( 45 )
	mdl:SetCamPos( Vector( size, size, size ) )
	mdl:SetLookAt( (mn + mx) * 0.5 )
end

local function AddTab( name, icon, func )
	table.insert( tabs, { name = name, icon = icon, func = func } )
end
local function AddDTab( name, func )
	table.insert( d_tabs, { name = name,  func = func } )
end



local function add_menu()

	local a = vgui.Create( 'gpFrame' )
	a:SetSize( 300, 125 )
	a:SetTitle( 'Пополнение баланса' )
	a:Center()
	a:MakePopup()
	a.PaintOver = function( _, w, h )

		draw.SimpleText( 'На сколько вы хотите пополнить баланс?', 'Trebuchet18', 10, 45, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

	end

	local d = vgui.Create( 'DNumberWang', a )
	d:Dock( TOP )
	d:DockMargin( 5, 35, 5, 0 )

	local db = vgui.Create( 'DButton', a )
	db:Dock( TOP )
	db:SetText( '' )
	db:DockMargin( 5, 5, 5, 5 )
	db.Paint = function( _, w, h )

		draw.RoundedBox( 0, 0, 0, w, h, Color( 50, 90, 50 ) )
		draw.SimpleText( 'Пополнить', 'DermaDefault', w/2, h/2, Color( 255,255,255 ) , 1, 1)

	end

	db.DoClick = function()

		if d:GetValue() <= 0 then 
			a:Remove()
			return 
		end

		gui.OpenURL( 'http://gprp.ru/core/donate_st.php?steamid='..LocalPlayer():SteamID()..'&amount='..d:GetValue()..'&svid=GPortalRP' )
		a:Remove()

	end

end

local function getMaxOfTeam( job )
    if not job.max or job.max == 0 then return '∞' end
    if job.max % 1 == 0 then return tostring( job.max ) end

    return tostring( math.floor( job.max * #player.GetAll() ) )
end

local PANEL = {}

function PANEL:Init()
	
	self.job = DarkRP.getJobByCommand( 'citizen' )

	self.mpn = self:Add( 'DModelPanel' )
	self.mpn:Dock( TOP )
	self.mpn:SetTall( ScrW()/5.6 )
	self.mpn:DockMargin( 0, 25, 0, 0 )
	self.mpn:SetFOV( 70 )
	function self.mpn:LayoutEntity( self ) 
		self:SetAngles( Angle( 0, 45, 0 ) )
		return 
	end

	self.desc = vgui.Create( 'DTextEntry', self )
	self.desc:Dock( TOP )
	self.desc:SetTall( 300 )
	self.desc:DockMargin( 5, 5, 5, 5 )
	self.desc:SetEnterAllowed( false )
	self.desc.DoRightClick = function() return end
	self.desc.DoClick = function() return end
	self.desc:SetMultiline( true )
	self.desc.AllowInput = function( self, char )
		return true
	end
	self.desc:SetFont( 'f4.text' )
	self.desc.Think = function( self )
		if self:GetText() != self.text then
			self:SetText( self.text )
		end
	end

	self.desc.Paint = function( self, aw, ah )
		--draw.RoundedBox( 0, 0, 0, aw, ah,  Color( 0, 0, 0, 175 ) )
		self:DrawTextEntryText( Color( 255, 255, 255 ), Color( 30, 130, 255 ), Color( 255, 255, 255 ) )
	end

	local function button()

		if self.job.vote then
			return 'Создать голосование'
		else
			return 'Устроиться'
		end

	end

	self.btn = self:Add( 'DButton' )
	self.btn:Dock( BOTTOM )
	self.btn:SetText( '' )
	self.btn:DockMargin( 5, 5, 5, 5 )
	self.btn:SetTall( 50 )
	self.btn.Paint = function( _, w, h )

		draw.RoundedBox(0,0,0,w,h, color_okgreen)
		draw.SimpleText( button(), 'f4.buttons', w/2, h/2, color_white, 1, 1 )

	end
	self.btn.DoClick = function()

		if isstring(self.job.model) then
			if self.job.vote then
				RunConsoleCommand( 'darkrp', 'vote'..self.job.command )
			else
				RunConsoleCommand( 'darkrp', self.job.command )
			end
		else
			openmodelselector( self.job )
		end

	end

end

local function getjobmodel( model )

	if isstring( model ) then
		return model
	elseif istable(model) then
		return model[1]
	end

end

function PANEL:SetJob( cmd )

	self.job = DarkRP.getJobByCommand( cmd )
	--PrintTable( job )
	self.desc:SetText( self.job.description )
	self.desc.text = self.job.description
	self.mpn:SetModel( getjobmodel(self.job.model) )

end

function PANEL:GetJob()
	return self.job.command
end

function PANEL:Paint( w, h )

	draw.RoundedBox( 0, 0, 0, w, h, Color( 51, 51, 51, 200 ) )

	draw.SimpleText( self.job.name, 'f4.name', w/2, 45, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

end


vgui.Register( 'gpf4_jobinfo', PANEL )

function openmodelselector( job )

	local models = job.model

	local frame = vgui.Create( 'gpFrame' )
	frame:SetSize( 75*#models, 110 )
	frame:Center()
	frame:SetTitle( 'Выбор модели' )
	frame:MakePopup()


	for k,v in pairs( models ) do
		
		local _ = frame:Add( 'SpawnIcon' )
		_:SetSize( 65, 65 )
		_:Dock( LEFT )
		_:DockMargin( 5, 5, 5, 5 )
		_:SetModel( v )
		_.DoClick = function()

			DarkRP.setPreferredJobModel( job.team, v )
			
			if job.vote then
				RunConsoleCommand( 'darkrp', 'vote'..job.command )
			else
				RunConsoleCommand( 'darkrp', job.command )
			end
			frame:Remove()
		end

	end
end

AddTab( 'Профессии', 'ui/f4/portfolio.png', function( pnl )
	
	local fill = pnl:Add( 'DPanel' )
	fill:Dock( FILL )
	active = fill
	fill.Paint = function()
	end
	fill:DockMargin( 5, 5, 5, 5 )

	local right = fill:Add( 'gpf4_jobinfo' )
	right:Dock( RIGHT )
	right:SetSize( sizex/3.9, sizey )
	right:DockMargin( 5, 0, 0, 0 )
	right:SetJob( 'citizen' )

	local jobp = fill:Add( 'DScrollPanel' )
	jobp:Dock( FILL )
	jobp:DockMargin( 0, 0, 0, 0 )
	jobp:GetVBar():SetWide( 3 )
	jobp:GetVBar().btnGrip.Paint = function( _, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, color_cgray )
	end


	for k,v in SortedPairsByMemberValue( DarkRP.getCategories().jobs, 'sortOrder' ) do
		
		if hidecatlist[v.name] then continue end

		local c = jobp:Add( 'DPanel' )
		c:Dock( TOP )
		c:SetSize( 0, 40 )
		c:DockMargin( 0, 0, 0, 5 )

		c.Paint = function( _, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 60, 60, 60, 255 ) )
			draw.SimpleText( v.name, 'f4.buttons', w/2, h/2, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end

		for k,v in pairs( v.members ) do

			if hidelist[v.command] then continue end

			local _ = jobp:Add( 'DButton' )
			_:Dock( TOP )
			_:SetSize( 0, 55 )
			_:DockMargin( 0, 0, 0, 5 )
			_:SetText( '' )

			_.Paint = function( _, w, h )
				draw.RoundedBox( 0, 0, 0, w, h, Color( 76, 76, 76 ) )
				if right:GetJob() == v.command then
					draw.RoundedBox( 0, 0, 0, w, h, Color( color_cgray.r, color_cgray.g, color_cgray.b, 90 ) )
				end
				draw.SimpleText( v.name, 'f4.name', 10, 20, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				draw.SimpleText( 'Зарплата: '..DarkRP.formatMoney( v.salary ) , 'f4.text', 10, 30, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
				draw.SimpleText( team.NumPlayers(v.team)..'/'..getMaxOfTeam( v ), 'f4.text', w-20, h/2, Color( 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
				draw.RoundedBox( 0, 0, h-1, w, 1, v.color )
			end

			_.DoClick = function()
				right:SetJob( v.command )
			end


		end

	end

end )
AddTab( 'Предметы', 'ui/f4/printer.png', function( pnl )

	local fill = pnl:Add( 'DScrollPanel' )
	fill:Dock( FILL )
	active = fill
	fill.Paint = function()
	end
	fill:DockMargin( 5, 5, 5, 5 )
	fill:GetVBar():SetWide( 3 )
	
	fill:GetVBar().btnGrip.Paint = function( _, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, color_cgray )
	end

	local function getct( id )
		return { RPExtraTeams[ id ].name, RPExtraTeams[ id ].color }
	end
	
	local items = {}

	for k, v in pairs( DarkRPEntities ) do
		if v.allowed then
			items[v.allowed[1]] = items[v.allowed[1]] or {}
			table.insert( items[v.allowed[1]], v )
		else
			items['all'] = items['all'] or {}
			table.insert( items['all'], v )
		end
	end

	local dep = fill:Add( 'DPanel' )
	dep:Dock( TOP )
	dep:DockMargin( 0, 0, 0, 5 )
	dep:SetSize( 0, 40 )
	dep.Paint = function( _, w, h )

		draw.RoundedBox( 0, 0, 0, w, h, Color( 60, 60, 60, 255 ) )
		draw.SimpleText( 'Доступно для: ', 'f4.buttons', w/2-70, h/2, Color( 255, 255, 255 ) , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		draw.SimpleText( 'ВСЕХ', 'f4.buttons', w/2, h/2, Color( 255, 255, 255 ) , TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

	end

	for k,v in pairs( items['all'] ) do
		local _ = fill:Add( 'DButton' )
		_:SetSize( 85, 55 )
		_:Dock( TOP )
		_:SetText( '' )
		_:DockMargin( 0, 0, 0, 5 )
		_.Paint = function( _, w, h )

			draw.RoundedBox( 0, 0, 0, w, h, Color( 76, 76, 76 ) )
			draw.SimpleText( v.name, 'f4.buttons', 55, 5, Color( 255,  255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			draw.SimpleText( 'Лимит: '..v.max..' шт.', 'f4.text', 55, 30, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP  )
			draw.SimpleText( DarkRP.formatMoney( v.price ) , 'f4.text', w-50, h/2, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER  )

		end
		_.DoClick = function()

			LocalPlayer():EmitSound( 'garrysmod/ui_click.wav', 100 )

			Derma_Query( 'Вы действительно хотите купить предмет "'..v.name..'"?', 'Подтверждение', 'Да', function()

				RunConsoleCommand( 'darkrp', v.cmd )

			end, 'Нет', function() end)
			

		end

		local mp = _:Add( 'ModelImage' )
		mp:Dock( LEFT )
		mp:DockMargin( 5, 5, 5, 5 )
		mp:SetSize( 40, 40 )
		mp:SetModel( v.model )
	end

	for k,v in pairs( items ) do
	
		if k == 'all' then continue end

		local dep = fill:Add( 'DPanel' )
		dep:Dock( TOP )
		dep:DockMargin( 0, 0, 0, 5 )
		dep:SetSize( 0, 40 )
		dep.Paint = function( _, w, h )

			draw.RoundedBox( 0, 0, 0, w, h, Color( 60, 60, 60, 255 ) )
			draw.SimpleText( 'Доступно для: ', 'f4.buttons', w/2-70, h/2, Color( 255, 255, 255 ) , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			draw.SimpleTextOutlined( getct( k )[1]  , 'f4.buttons', w/2, h/2, getct( k )[2] , TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, color_black )

		end

		for k,v in pairs( v ) do
			
			local _ = fill:Add( 'DButton' )
			_:SetSize( 85, 55 )
			_:Dock( TOP )
			_:SetText( '' )
			_:DockMargin( 0, 0, 0, 5 )
			_.Paint = function( _, w, h )

				draw.RoundedBox( 0, 0, 0, w, h, Color( 76, 76, 76 ) )
				draw.SimpleText( v.name, 'f4.buttons', 55, 5, Color( 255,  255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
				draw.SimpleText( 'Лимит: '..v.max..' шт.', 'f4.text', 55, 30, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP  )
				draw.SimpleText( DarkRP.formatMoney( v.price ) , 'f4.text', w-50, h/2, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER  )

			end
			_.DoClick = function()

				LocalPlayer():EmitSound( 'garrysmod/ui_click.wav', 100 )

				Derma_Query( 'Вы действительно хотите купить предмет "'..v.name..'"?', 'Подтверждение', 'Да', function()

					RunConsoleCommand( 'darkrp', v.cmd )

				end, 'Нет', function() end)
				

			end

			local mp = _:Add( 'ModelImage' )
			mp:Dock( LEFT )
			mp:DockMargin( 5, 5, 5, 5 )
			mp:SetSize( 40, 40 )
			mp:SetModel( v.model )
		end
	end

end )
AddTab( 'Поставки', 'ui/f4/box.png', function( pnl )

	local ds = pnl:Add( 'DScrollPanel' )
	ds:Dock( FILL )
	active = ds
	ds.Paint = function()
	end
	ds:DockMargin( 5, 5, 5, 5 )
	ds:GetVBar():SetWide( 3 )
	
	ds:GetVBar().btnGrip.Paint = function( _, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, color_cgray )
	end

	local function getct( id )

		
		return { RPExtraTeams[ id ].name, RPExtraTeams[ id ].color }
		

	end

	local sorted = {}

	for k, v in pairs( CustomShipments ) do
		sorted[v.allowed[1]] = sorted[v.allowed[1]] or {}

		table.insert( sorted[v.allowed[1]], v )
	end
	
	for k,v in pairs( sorted ) do
	
		local dep = ds:Add( 'DPanel' )
		dep:Dock( TOP )
		dep:DockMargin( 0, 0, 0, 5 )
		dep:SetSize( 0, 40 )
		dep.Paint = function( _, w, h )

			draw.RoundedBox( 0, 0, 0, w, h, Color( 60, 60, 60, 255 ) )
			draw.SimpleText( 'Доступно для: ', 'f4.buttons', w/2-70, h/2, Color( 255, 255, 255 ) , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			draw.SimpleTextOutlined( getct( k )[1]  , 'f4.buttons', w/2, h/2, getct( k )[2] , TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, color_black )

		end

		for k,v in pairs( v ) do
			
			local _ = ds:Add( 'DButton' )
			_:SetSize( 85, 55 )
			_:Dock( TOP )
			_:SetText( '' )
			_:DockMargin( 0, 0, 0, 5 )
			_.Paint = function( _, w, h )

				draw.RoundedBox( 0, 0, 0, w, h, Color( 76, 76, 76 ) )
				draw.SimpleText( v.name, 'f4.buttons', 55, 5, Color( 255,  255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
				draw.SimpleText( 'Количество: '..v.amount..' шт.', 'f4.text', 55, 30, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP  )
				draw.SimpleText( DarkRP.formatMoney( v.price ) , 'f4.text', w-50, h/2, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER  )

			end
			_.DoClick = function()

				LocalPlayer():EmitSound( 'garrysmod/ui_click.wav', 100 )

				Derma_Query( 'Вы действительно хотите купить ящик с  "'..v.name..'('..v.amount..' шт.)"?', 'Подтверждение', 'Да', function()

					RunConsoleCommand( 'darkrp', 'buyshipment', v.name )

				end, 'Нет', function() end)
				

			end


			local mp = _:Add( 'ModelImage' )
			mp:Dock( LEFT )
			mp:DockMargin( 5, 5, 5, 5 )
			mp:SetSize( 40, 40 )
			mp:SetModel( v.model )

		end

	end

end )
AddTab( 'Патроны', 'ui/f4/bullets.png', function( pnl )
	local ds = pnl:Add( 'DScrollPanel' )
	ds:Dock( FILL )
	active = ds
	ds.Paint = function()
	end
	ds:DockMargin( 5, 5, 5, 5 )
	ds:GetVBar():SetWide( 3 )
	
	ds:GetVBar().btnGrip.Paint = function( _, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, color_cgray )
	end

	local dep = ds:Add( 'DPanel' )
	dep:Dock( TOP )
	dep:DockMargin( 0, 0, 0, 5 )
	dep:SetSize( 0, 40 )
	dep.Paint = function( _, w, h )

		draw.RoundedBox( 0, 0, 0, w, h, Color( 60, 60, 60, 255 ) )
		draw.SimpleText( 'Доступно для: ', 'f4.buttons', w/2-70, h/2, Color( 255, 255, 255 ) , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		draw.SimpleText( 'ВСЕХ'  , 'f4.buttons', w/2, h/2, Color( 255, 255, 255 ) , TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

	end

	for k,v in pairs( GAMEMODE.AmmoTypes ) do
		
		local _ = ds:Add( 'DButton' )
		_:SetSize( 85, 55 )
		_:Dock( TOP )
		_:SetText( '' )
		_:DockMargin( 0, 0, 0, 5 )
		_.Paint = function( _, w, h )

			draw.RoundedBox( 0, 0, 0, w, h, Color( 76, 76, 76 ) )
			draw.SimpleText( v.name, 'f4.buttons', 55, h/2, Color( 255,  255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			draw.SimpleText( DarkRP.formatMoney( v.price ) , 'f4.text', w-50, h/2, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER  )

		end
		_.DoClick = function()

			LocalPlayer():EmitSound( 'garrysmod/ui_click.wav', 100 )
			
			RunConsoleCommand( 'darkrp', 'buyammo', v.ammoType )

		end


		local mp = _:Add( 'ModelImage' )
		mp:Dock( LEFT )
		mp:DockMargin( 5, 5, 5, 5 )
		mp:SetSize( 40, 40 )
		mp:SetModel( v.model )	

	end

end )

AddTab( 'Транспорт', 'ui/f4/car.png', function( f ) 
		local atv 
	local don_tbl = {}

	local function buycar( class )

		local tbl = gp_cardealer.tbl.cars[ class ]

		local f = vgui.Create( 'DPanel' )
		f:SetSize( 500, 700 )
		f:Center()
		f:MakePopup()
		f.Paint = function( _, w, h )

			gp_inv.blur( _, 5, 12, 255 )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 235 ) )
			draw.SimpleText( 'Покупка '..tbl.name, 'DermaLarge', w/2,40, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

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

		local dm = f:Add( 'DModelPanel' )
		dm:Dock( TOP )
		dm:DockMargin( 0, 35, 0, 0)
		dm:SetSize( 300, 300 )
		dm:SetModel( tbl.model )
		dm.col = Color( 255, 255, 255 )
		dm:SetColor( Color( 255, 255, 255 ) )
		fixMdlPos( dm )

		local _b = f:Add( 'DButton' )
		_b:Dock( BOTTOM )
		_b:SetSize( 100, 100 )
		_b:DockMargin( 5, 5, 5, 5 )
		_b:SetText( '' )
		_b.Paint = function( _, w, h )
			draw.RoundedBox(0,0,0,w,h,Color(255,255,255,10))
			if _:IsHovered() then
				draw.RoundedBox(0,0,0,w,1,Color(60,150,60))
				draw.RoundedBox(0,0,h-1,w,1,Color(60,150,60))
				draw.RoundedBox(0,0,0,1,h,Color(60,150,60))
				draw.RoundedBox(0,w-1,0,1,h,Color(60,150,60))
			end
			draw.SimpleText( 'Купить за '..DarkRP.formatMoney( tbl.price ), 'DermaDefault', w/2, h/2, Color( 255,255,255 ) , 1, 1)
			--draw.SimpleText( , 'DermaDefault', w/2, h/2+15, Color( 255,255,255 ) , 1, 1)
		end

		_b.DoClick = function()


			net.Start( 'gpcard_buy' )
				net.WriteString( class )
				net.WriteString( 'buy' )
				net.WriteString( string.FromColor(dm.col) )
			net.SendToServer()

			f:Remove()

		end

		local cp = f:Add( 'DRGBPicker' )
		cp:SetSize( 30, 190 )
		cp:Dock( LEFT )
		cp:DockMargin( 5, 5, 5, 5 )


		local cc = f:Add( 'DColorCube' )
		cc:Dock( FILL )
		cc:DockMargin( 5, 5, 5, 5 )

		function cp:OnChange( col )
			local h = ColorToHSV( col )
			local _, s, v = ColorToHSV( cc:GetRGB() )

			
			col = HSVToColor( h, s, v )
			cc:SetColor( col )

			UpdateColors( col )

		end

		function UpdateColors( col )

			dm:SetColor( col )
			dm.col = col

		end

		function cc:OnUserChanged( col )

			UpdateColors( col )

		end

	end
	local function buycar_ar( tbl_m )

		local tbl = gp_cardealer.tbl.cars[ tbl_m.carname ]

		local f = vgui.Create( 'DPanel' )
		f:SetSize( 500, 500 )
		f:Center()
		f:MakePopup()
		f.Paint = function( _, w, h )

			gp_inv.blur( _, 5, 12, 255 )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 235 ) )
			draw.SimpleText( 'Покупка '..tbl.name, 'DermaLarge', w/2,40, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

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

		local dm = f:Add( 'DModelPanel' )
		dm:Dock( TOP )
		dm:DockMargin( 0, 35, 0, 0)
		dm:SetSize( 300, 300 )
		dm:SetModel( tbl.model )
		dm:SetColor( string.ToColor( tbl_m.color ) )
		fixMdlPos( dm )

		local _b = f:Add( 'DButton' )
		_b:Dock( BOTTOM )
		_b:SetSize( 100, 100 )
		_b:DockMargin( 5, 5, 5, 5 )
		_b:SetText( '' )
		_b.Paint = function( _, w, h )
			draw.RoundedBox(0,0,0,w,h,Color(255,255,255,10))
			if _:IsHovered() then
				draw.RoundedBox(0,0,0,w,1,Color(60,150,60))
				draw.RoundedBox(0,0,h-1,w,1,Color(60,150,60))
				draw.RoundedBox(0,0,0,1,h,Color(60,150,60))
				draw.RoundedBox(0,w-1,0,1,h,Color(60,150,60))
			end
			draw.SimpleText( 'Купить за '..DarkRP.formatMoney( tbl_m.price ), 'DermaDefault', w/2, h/2, Color( 255,255,255 ) , 1, 1)
			--draw.SimpleText( , 'DermaDefault', w/2, h/2+15, Color( 255,255,255 ) , 1, 1)
		end

		_b.DoClick = function()

			net.Start( 'gpcard_buy' )
				net.WriteString( 'nil' )
				net.WriteString( 'buy_ar' )
				net.WriteString( 'nil' )
				net.WriteInt( tbl_m.id, 16 )
			net.SendToServer()

			f:Remove()

		end

	end	
	
	function add_btn( tname,id, func)
		don_tbl[tname] = {
			id = id,
			f = func
		}
	end

	add_btn( 'Дилер', 1, function( p )

		local cat = 'Groups'
		local t = gp_cardealer.tbl.cars
		local ds = p:Add( 'DScrollPanel' )
		local load = true
		ds:Dock( FILL )
		ds.Paint = function( _, w ,h )
			if load then
				draw.SimpleText( 'Загрузка..', 'Trebuchet24', w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end
		end
		ds:GetVBar().Paint = function() end
		ds:GetVBar():SetWide( 0 )
		for k, v in pairs( ds:GetVBar():GetChildren() ) do
			v.Paint = function( _, w, h )
			end
		end

		atv = ds
		timer.Simple( 0.2, function()
		for k,v in SortedPairsByMemberValue( t, 'price' ) do
			
			if string.find( k, 'low' ) then
				continue
			end

			local _ = ds:Add( 'DPanel' )
			_:Dock( TOP )
			_:DockMargin( 5, 5, 5, 5 )
			_:SetSize( 100, 155 )
			_.Paint = function( _, w, h )

				draw.RoundedBox( 0, 0, 0, w, h, Color( 76,76,76 ) )

				draw.SimpleText( v.name, 'Trebuchet24', 156, 5, color_white, TEXT_ALIGN_LEFT )

				draw.SimpleText( 'Стоимость: '..DarkRP.formatMoney( v.price ), 'f4.text', 156, 30, color_white, TEXT_ALIGN_LEFT )

				if v.vip then
					 
					surface.SetDrawColor( 255, 255, 255, 255 )
					surface.SetMaterial( Material( 'gportalrp/premium.png' ) )
					surface.DrawTexturedRect( 0, 0, 75, 75 )

				end

			end

			local dm = _:Add( 'DModelPanel' )
			dm:Dock( LEFT )
			dm:SetSize( 150, 100 )
			dm:SetModel( v.model )
			fixMdlPos( dm )
			
			local desc = _:Add( 'DTextEntry' )
			desc:Dock( LEFT )
			desc:SetSize( 400, 400 )
			desc:DockMargin( 5, 55, 5, 5 )
			desc:SetEnterAllowed( false )
			desc.DoRightClick = function() return end
			desc.DoClick = function() return end
			desc:SetMultiline( true )
			desc.AllowInput = function( self, char )
				return true
			end
			desc:SetText( v.desc )
			desc.text = v.desc

			desc:SetFont( 'f4.text' )
			desc.Think = function( self )
				if self:GetText() != self.text then
					self:SetText( self.text )
				end
			end

			desc.Paint = function( self, aw, ah )
				--draw.RoundedBox( 0, 0, 0, aw, ah,  Color( 0, 0, 0, 175 ) )
				self:DrawTextEntryText( Color( 255, 255, 255 ), Color( 30, 130, 255 ), Color( 255, 255, 255 ) )
			end

			local _b = _:Add( 'DButton' )
			_b:Dock( RIGHT )
			_b:SetSize( 100, 0 )
		--	_b:DockMargin( 5, 15, 5, 75)
			_b:SetText( '' )
			_b.Paint = function( _, w, h )
				draw.RoundedBox(0,0,0,w,h,Color(255,255,255,10))
				if _:IsHovered() then
					draw.RoundedBox(0,0,0,w,1,Color(60,150,60))
					draw.RoundedBox(0,0,h-1,w,1,Color(60,150,60))
					draw.RoundedBox(0,0,0,1,h,Color(60,150,60))
					draw.RoundedBox(0,w-1,0,1,h,Color(60,150,60))
				end
				draw.SimpleText( 'Купить', 'DermaDefault', w/2, h/2, Color( 255,255,255 ) , 1, 1)
			end

			_b.DoClick = function()

				buycar( k )

			end

		end
		load = false
		end)
	end )
--=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=--
--=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=--
--=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=--
	add_btn( 'Авторынок', 2, function( p )
		
		-- local cat = 'Money'
		-- local t = gp_shop.tbl[ cat ]

		local ds = p:Add( 'DScrollPanel' )
		ds:Dock( FILL )
		ds.loading = true
		ds.none = false
		ds.Paint = function( _, w ,h )

			if ds.none then
				draw.SimpleText( 'Нету доступных для покупки т/c', 'Trebuchet24', w/2, h/2, color_white, TEXT_ALIGN_CENTER )
			end

			if !ds.none and ds.loading then
				draw.SimpleText( 'Загрузка...', 'Trebuchet24', w/2, h/2, color_white, TEXT_ALIGN_CENTER )
			end


		end
		
		timer.Simple( 5, function() if ds.loading then ds.none = true end end )

		ds:GetVBar().Paint = function() end
		ds:GetVBar():SetWide( 0 )
		for k, v in pairs( ds:GetVBar():GetChildren() ) do
			v.Paint = function() end
		end

		net.Start( 'gpcard_database' )
		net.SendToServer()

		net.Receive( 'gpcard_database', function()

			local tbl = net.ReadTable()

			if !ds.loading then return end 

			for k,v in pairs( tbl ) do
			
				local tb = gp_cardealer.tbl.cars[ v.carname ]

				local _ = ds:Add( 'DPanel' )
				_:Dock( TOP )
				_:DockMargin( 5, 5, 5, 5 )
				_:SetSize( 100, 200 )
				_.Paint = function( _, w, h )

					draw.RoundedBox( 0, 0, 0, w, h, Color( 50, 50, 50, 50 ) )

					draw.SimpleText( tb.name, 'Trebuchet24', 156, 5, color_white, TEXT_ALIGN_LEFT )

					draw.SimpleText( 'Продавец: '..v.owner, 'f4.text', 156, 30, color_white, TEXT_ALIGN_LEFT )

					draw.SimpleText( 'Стоимость: '..DarkRP.formatMoney( v.price ), 'f4.text', 156, 50, color_white, TEXT_ALIGN_LEFT )

					draw.SimpleText( 'Номер: '..v.number, 'f4.text', 156, 70, color_white, TEXT_ALIGN_LEFT )

					draw.SimpleText( os.date( "%d/%m/%Y" , v.date ), 'f4.text', 156, 90, color_white, TEXT_ALIGN_LEFT )

				end

				
				local dm = _:Add( 'DModelPanel' )
				dm:Dock( LEFT )
				dm:SetSize( 150, 100 )
				dm:SetModel( tb.model )
				dm:SetColor( string.ToColor( v.color ) )
				fixMdlPos( dm )
				
				local desc = _:Add( 'DTextEntry' )
				desc:Dock( LEFT )
				desc:SetSize( p:GetWide()/2, 400 )
				desc:DockMargin( 5, 115, 5, 5 )
				desc:SetEnterAllowed( false )
				desc.DoRightClick = function() return end
				desc.DoClick = function() return end
				desc:SetMultiline( true )
				desc.AllowInput = function( self, char )
					return true
				end
				desc:SetText( v.descs )
				desc.text = v.descs

				desc:SetFont( 'f4.text' )
				desc.Think = function( self )
					if self:GetText() != self.text then
						self:SetText( self.text )
					end
				end

				desc.Paint = function( self, aw, ah )
					--draw.RoundedBox( 0, 0, 0, aw, ah,  Color( 0, 0, 0, 175 ) )
					self:DrawTextEntryText( Color( 255, 255, 255 ), Color( 30, 130, 255 ), Color( 255, 255, 255 ) )
				end

				local _b = _:Add( 'DButton' )
				_b:Dock( RIGHT )
				_b:SetSize( 100, 0 )
			--	_b:DockMargin( 5, 15, 5, 75)
				_b:SetText( '' )
				_b.Paint = function( _, w, h )
					draw.RoundedBox(0,0,0,w,h,Color(255,255,255,10))
					if _:IsHovered() then
						draw.RoundedBox(0,0,0,w,1,Color(60,150,60))
						draw.RoundedBox(0,0,h-1,w,1,Color(60,150,60))
						draw.RoundedBox(0,0,0,1,h,Color(60,150,60))
						draw.RoundedBox(0,w-1,0,1,h,Color(60,150,60))
					end
					
					if v.osid == LocalPlayer():SteamID() then
						draw.SimpleText( 'Снять с продажи', 'DermaDefault', w/2, h/2, Color( 255,255,255 ) , 1, 1)
					else
						draw.SimpleText( 'Купить', 'DermaDefault', w/2, h/2, Color( 255,255,255 ) , 1, 1)
					end
				end

				_b.DoClick = function()

					if v.osid == LocalPlayer():SteamID() then
					
						net.Start( 'gpcard_rmar' )
							net.WriteInt( v.id, 20 )
						net.SendToServer()
						
						frame:Remove()

					else
						buycar_ar( v )
						frame:Remove()
					end

				end

			end
			ds.loading = false

		end )

		atv = ds

	end )
--=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=--
--=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=--
--=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=----=--
	gp = f:Add( 'DPanel' )
	gp:Dock( FILL )
	gp.Paint = function() 
	end

	function change_tab_don( name )

		if IsValid( atv ) then atv:Remove() end
		
		don_tbl[ name ].f( gp )

	end

	local top = gp:Add( 'DPanel' )
	top:Dock( BOTTOM )
	top:SetTall( 70 )
	top:DockMargin( 0, 5, 0, 0 )
	top.Paint = function( _, w, h )
	
		draw.RoundedBox( 0, 0, 0, w, h, Color( 54,54,54 ) )
		if LocalPlayer():GetNWInt( 'gpcard_armon' ) > 0 then
			draw.SimpleText( 'Ваш баланс на авторынке: '..LocalPlayer():GetNWInt( 'gpcard_armon' ) ..'₽', 'f4.text', w-120, h/2-2.5, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
		end

	end
	if LocalPlayer():GetNWInt( 'gpcard_armon' ) > 0 then
		local btn = top:Add( 'DButton' )
		btn:Dock( RIGHT )
		btn:DockMargin( 0, 15, 10, 20 )
		btn:SetSize( 100, 100 )
		btn:SetText( '' )
		btn.Paint = function( _, w, h )

			draw.RoundedBox(0,0,0,w,h,Color(255,255,255,10))
			if btn:IsHovered() then
				draw.RoundedBox(0,0,0,w,1,Color(60,150,60))
				draw.RoundedBox(0,0,h-1,w,1,Color(60,150,60))
				draw.RoundedBox(0,0,0,1,h,Color(60,150,60))
				draw.RoundedBox(0,w-1,0,1,h,Color(60,150,60))
			end
			draw.SimpleText( 'Вывести', 'f4.text', w/2, h/2, Color( 255,255,255 ) , 1, 1)

		end
		btn.DoClick = function()

			net.Start( 'gpcard_withdraw' )
			net.SendToServer()
			btn:Remove()

		end
	end

	local act = 'Дилер'

	for k,v in SortedPairsByMemberValue( don_tbl, 'id' ) do
		
		local _ = top:Add( 'DButton' )
		_:Dock( LEFT )
		_:SetText( '' )
		_:SetSize( 100, 70 )
		_:DockMargin( 5, 5, 5, 5 )
		_.Paint = function( _, w, h )

			draw.RoundedBox(0,0,0,w,h,Color(255,255,255,10))
			if _:IsHovered() then
				draw.RoundedBox(0,0,0,w,1,Color(60,150,60))
				draw.RoundedBox(0,0,h-1,w,1,Color(60,150,60))
				draw.RoundedBox(0,0,0,1,h,Color(60,150,60))
				draw.RoundedBox(0,w-1,0,1,h,Color(60,150,60))
			end
			if act == k then
				draw.RoundedBox(0,0,0,w,2,Color(60,150,60))
			end
			draw.SimpleText( k, 'f4.text', w/2, h/2, Color( 255,255,255 ) , 1, 1)

		end
		_.DoClick = function()

			change_tab_don( k )
			act = k

		end

	end

	active = gp
	change_tab_don( 'Дилер' )
end )

//
local donact

AddDTab( 'Премиум', function( pnl )

	local fill = pnl:Add( 'DPanel' )
	fill:Dock( FILL )
	donact = fill
	fill.Paint = function( _, w, h ) 

		if LocalPlayer():gp_VipAccess() == true then
			local days = os.date( '%d/%m/%Y',  LocalPlayer():GetNWInt( 'gp_premium_buytime' )+gp_shop.DaysToSeconds( 30 ))
			draw.SimpleText( 'У вас активный Premium!', 'f4.buttons', w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			draw.SimpleText( 'Конец '..days, 'f4.text', w/2, h/2+20, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			
		end

	end

	local job_desc_p = fill:Add( 'DPanel' )
	job_desc_p:SetSize( 100, ScrH()/5 )
	job_desc_p:Dock( TOP )
	job_desc_p:DockMargin( 0, 50, ScrW()/6, 0)
	job_desc_p.Paint = function( _, w, h )

		local name = 'GPRP Premium'

		draw.SimpleText( name, 'f4.buttons', 10, 10, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		surface.SetFont( 'f4.buttons' )
		local nx, ny = surface.GetTextSize( name )
		draw.RoundedBox(0, 10, 25, nx, 2, color_white)
	end
	if LocalPlayer():gp_VipAccess() == true then
		return
	end
	local desc = vgui.Create( 'DTextEntry', job_desc_p )
	desc.text = '"Премиум" дает вам дополнительные преимущеста на сервере, с его приобретением вы начинаете быстрее зарабатывать и получаете повышенный шанс выжить. '
	desc:Dock( FILL )
	desc:DockMargin( 10, 50, 0, 0 )
	desc:SetEnterAllowed( false )
	desc.DoRightClick = function() return end
	desc.DoClick = function() return end
	desc:SetMultiline( true )
	desc.AllowInput = function( self, char )
		return true
	end
	desc:SetFont( 'f4.text' )
	desc.Think = function( self )
		if self:GetText() != self.text then
			self:SetText( self.text )
		end
	end

	desc.Paint = function( self, aw, ah )
		--draw.RoundedBox( 0, 0, 0, aw, ah,  Color( 0, 0, 0, 175 ) )
		self:DrawTextEntryText( Color( 230, 230, 230 ), Color( 30, 130, 255 ), Color( 255, 255, 255 ) )
	end



	local prem_tips = {
		'Возрождение сокращается до 10 секунд', 'Голод наступает в 4 раза медленнее', 'Потребление бензина сокращается на 50%', 'Мэр получает 5% от выигрыша в лотереях', 'Занимать профессии можно в обход лимитов', 'х3 опыт в Росгвардии', 'От продажи руды и мета нпс вы получаете на 10% больше дохода', 'Выделяющая вас Премиум иконка в скорборде среди остальных игроков'
	}	

	local descs = fill:Add( 'DPanel' )
	descs:Dock( TOP )
	descs:SetSize( 0, 50*#prem_tips )
	descs.Paint = function( _, w, h )
		--draw.RoundedBox( 0, 0, 0, w, h, color_white )
		draw.SimpleText( 'Возможности', 'f4.buttons', 10, 10, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		surface.SetFont( 'f4.buttons' )
		local nx, ny = surface.GetTextSize( 'Возможности' )
		draw.RoundedBox(0, 10, 25, nx, 2, color_white)

		for k,v in pairs( prem_tips ) do

			draw.SimpleText( '✓ '..v, 'f4.text', 10, 25 + (25*k), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

		end

	end


	local buy = fill:Add( 'DButton' )
	buy:Dock( BOTTOM )
	buy:DockMargin( 10, 10, 10, 10 )
	buy:SetSize( 0, 50 )
	buy:SetText( '' )
	buy.Paint = function( _, w, h )

		draw.RoundedBox( 0, 0, 0, w, h, Color(0,70,150, 255))
		if _:IsHovered() then
			draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 255, 255, 30 ) )
		end		
		local text = 'Приобрести за 250 руб.'

		draw.SimpleText( text, 'f4.text', w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

	end
	buy.DoClick = function()

		if not LocalPlayer():gpshop_CanAfford( 250 ) then return end
		RunConsoleCommand( 'play', 'gprp/button-50' )
		Derma_Query( 'Вы действительно хотите купить GPRP Premium за 250₽?', 'Подтверждение', 'Да', function() 
			
			LocalPlayer():EmitSound( 'garrysmod/save_load2.wav', 100 )
			net.Start( 'gpshop_buy_prem' )
			net.SendToServer()
		 	frame:Remove()
		 end, 'Отмена', function() end)

	end

end )
AddDTab( 'Привилегии', function( pnl )

	local tbl = gp_shop.tbl['Groups']

	local fill = pnl:Add( 'DScrollPanel' )
	fill:Dock( FILL )
	donact = fill
	fill:GetVBar():SetWide( 3 )
	fill:GetVBar().btnGrip.Paint = function( _, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, color_cgray )
	end

	for k,v in SortedPairsByMemberValue( tbl, 'id' ) do
		
		local anus = LocalPlayer():GetUserGroup() == k and ' ✓' or ''

		local _ = fill:Add( 'DPanel' )
		_:Dock( TOP )
		_:SetSize( 0, 100 + (15 * #v.descs) )
		_:DockMargin( 0, 0, 0, 5 )
		_.Paint = function( _, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 76, 76, 76 ) )
			draw.SimpleText( v.PrintName..anus, 'f4.buttons', 10, 20, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			draw.DrawText( v.desc, 'f4.name', 10, 40, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			if LocalPlayer():gpshop_GetGroupPrice( v.group )[1] then
				draw.SimpleText(  'Цена: '..gp_shop.discount_price(v.price, gp_shop.discount)..' руб.', 'f4.text', w-10, 20, Color( 200, 200, 200 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
				surface.SetFont( 'f4.text' )
				local tx, ty = surface.GetTextSize( 'Цена: '..v.price..' руб.' )
				surface.SetDrawColor(255, 0, 0)
				surface.DrawLine( w-10-tx-1, 15, w-10, 25 )
				draw.SimpleText(  'Можно доплатить за '..LocalPlayer():gpshop_GetGroupPrice( v.group )[2]..' руб.', 'f4.text', w-10, 40, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
			else
				if gp_shop.discount ~= 0 then
					draw.SimpleText(  'Цена: '..v.price..' руб.', 'f4.text', w-10, 20, Color( 200, 200, 200 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
					surface.SetFont( 'f4.text' )
					local tx, ty = surface.GetTextSize( 'Цена: '..v.price..' руб.' )
					surface.SetDrawColor(255, 0, 0)
					surface.DrawLine( w-10-tx-1, 15, w-10, 25 )
					draw.SimpleText(  'Цена: '..gp_shop.discount_price( v.price, gp_shop.discount )..' руб.', 'f4.text', w-10, 40, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
					draw.SimpleText(  'Скидка '..gp_shop.discount..' %', 'f4.text', w-10, 60, Color( 255, 0, 0 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
				else
					draw.SimpleText(  'Цена: '..v.price..' руб.', 'f4.text', w-10, 20, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
				end
			end
			//or 
			for i = 1, #v.descs do
				draw.SimpleText( '✓ '..v.descs[i], 'f4.text', 10, 80 + 15*i, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			end

		end
		if tbl[ LocalPlayer():GetUserGroup() ] and tbl[ LocalPlayer():GetUserGroup() ].id and tbl[ LocalPlayer():GetUserGroup() ].id >= v.id then 
			continue
		end

		local buy = _:Add( 'DButton' )
		buy:Dock( RIGHT )
		buy:SetText( '' )
		buy:DockMargin( 0, 50 + (15 * #v.descs), 10, 10 )
		buy:SetSize( 100, 0 )
		--buy:DockMargin(number marginLeft, number marginTop, number marginRight, number marginBottom)
		buy.Paint = function( _, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color(0,70,150, 255))
			if _:IsHovered() then
				draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 255, 255, 30 ) )
			end		
			local text = 'Приобрести'

			draw.SimpleText( text, 'f4.text', w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end

		buy.DoClick = function()
			Derma_Query( 'Вы действительно хотите купить привилегию '..v.PrintName..' за '..LocalPlayer():gpshop_GetGroupPrice( k )[2]..'₽?', 'Подтверждение', 'Да', function() 
					net.Start( 'gpshop_buy' )
						net.WriteString( 'Groups' )
						net.WriteString( k )
					net.SendToServer()
			end, 'Отмена', function() end)
		end

	end


end )

AddDTab( 'Валюта', function( pnl )

	local tbl = gp_shop.tbl['Money']

	local fill = pnl:Add( 'DScrollPanel' )
	fill:Dock( FILL )
	donact = fill
	fill:GetVBar():SetWide( 3 )
	fill:GetVBar().btnGrip.Paint = function( _, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, color_cgray )
	end


	for k,v in SortedPairsByMemberValue( tbl, 'id' ) do
		
		local _ = fill:Add( 'DPanel' )
		_:Dock( TOP )
		_:SetSize( 0, 60 )
		_:DockMargin( 0, 0, 0, 5 )
		_.Paint = function( _, w, h )

			draw.RoundedBox( 0, 0, 0, w, h, Color( 76, 76, 76 ) )
			draw.SimpleText( DarkRP.formatMoney( v.money ) , 'f4.buttons', 10, 20, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			draw.SimpleText( 'Добавляет '..DarkRP.formatMoney( v.money )..' на игровой счет!' , 'f4.text', 10, 40, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

			draw.SimpleText( 'Цена: '..gp_shop.discount_price(v.price, gp_shop.discount)..' руб.' , 'f4.text', w-100-20, h/2, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )


		end
		local buy = _:Add( 'DButton' )
		buy:Dock( RIGHT )
		buy:SetText( '' )
		buy:DockMargin( 10, 10, 10, 10 )
		buy:SetSize( 100, 0 )
		--buy:DockMargin(number marginLeft, number marginTop, number marginRight, number marginBottom)
		buy.Paint = function( _, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color(0,70,150, 255))
			if _:IsHovered() then
				draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 255, 255, 30 ) )
			end		
			local text = 'Приобрести'

			draw.SimpleText( text, 'f4.text', w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end

		buy.DoClick = function()
			Derma_Query( 'Вы действительно хотите купить '..DarkRP.formatMoney( v.money )..' за '..gp_shop.discount_price(v.price, gp_shop.discount)..'₽?', 'Подтверждение', 'Да', function() 
					net.Start( 'gpshop_buy' )
						net.WriteString( 'Money' )
						net.WriteString( k )
					net.SendToServer()
			end, 'Отмена', function() end)
		end

	end

end )
//
--[[
AddTab( 'Донат', 'ui/f4/shopping-bag.png', function( pnl )


	local fill = pnl:Add( 'DPanel' )
	fill:Dock( FILL )
	active = fill
	fill.Paint = function()
	end

	local top = fill:Add( 'DPanel' )
	top:Dock( TOP )
	top:SetSize( 0, ScrH()/12 )
	top.Paint = function( _, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 54, 54, 54 ) )
	end
	local act_b
	for k,v in pairs( d_tabs ) do
		
		local _ = top:Add( 'DButton' )
		_:Dock( LEFT )
		_:SetSize( 130, 0 )
		_:DockMargin( 5, 5, 5, 5 )
		_:SetText( '' )
		if v.name == 'Премиум' then
			act_b = _
		end
		_.Paint = function( _, w, h )

			draw.RoundedBox( 0, 0, 0, w, h, Color( 76, 76, 76 ) )
			draw.SimpleText( v.name, 'f4.buttons', w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			if act_b == _ then
				draw.RoundedBox( 0, 0, h-5, w, 5, Color( 0, 255, 0 ) )	
			end
		end

		_.DoClick = function()

			if IsValid(donact) then
				donact:Remove()
			end
			act_b = _
			v.func( fill )

		end

	end

	local left_b = top:Add( 'DPanel' )
	left_b:Dock( RIGHT )
	left_b:SetSize( ScrW()/10, 0 )
	left_b.Paint = function( _, w, h )

		draw.SimpleText( 'Баланс: '..LocalPlayer():gpshop_GetBalance()..' руб.', 'f4.text', w/2, 35, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

	end

	local add_b = left_b:Add( 'DButton' )
	add_b:Dock( BOTTOM )
	add_b:SetText( '' )
	add_b:DockMargin( 5, 5, 5, 5 )
	add_b.Paint = function( _, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 76, 76, 76 ) )
		draw.SimpleText( 'Пополнить', 'f4.text', w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	add_b.DoClick = function()
		add_menu()
	end

	d_tabs[1].func(fill)

end )
]]--
function SetTab( tab )
	if IsValid(active) then
		active:Remove()
	end
	tab.func( frame )
end

function Open()

	if IsValid(frame) then
		frame:Remove()
	end

	frame = vgui.Create( 'EditablePanel' )
	frame:SetSize( sizex, sizey )
	frame:Center()
	frame:MakePopup()

	frame.Paint = function( _, w, h )
		gp_dermaUtil.blur( _, 5, 10, 255 )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 10, 10, 10, 240 ) )
	end
	
	frame.OnKeyCodePressed = function( self, key )

		if key == KEY_F4 and IsValid( frame ) then 
			frame:Remove()
		end

	end
	
	local left = frame:Add( 'DPanel' )
	left:Dock( LEFT )
	left:SetSize( sizex/3.9, 0 )
	left:DockMargin( 0, 0, 0, 0 )

	left.Paint = function( _, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color(  54, 54, 54, 255 ) )
	end

	for k,v in pairs( tabs ) do
		local _ = left:Add( 'DButton' )
		_:Dock( TOP )
		_:SetSize( 0, 35 )
		_:DockMargin( 5, 5, 5, 0 )
		_:SetText('')
		_.Paint = function( _, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color(  77, 77, 77, 255 ) )
			draw.SimpleText( v.name, 'f4.buttons', 10+24, h/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetMaterial( Material( v.icon ) )
			surface.DrawTexturedRect( 5, 5, 24, 24 )
		end

		_.DoClick = function()
			SetTab(v)
		end
	end

	SetTab(tabs[1])

end

hook.Add( 'PlayerBindPress', 'F4MenuBind', function( ply, bind, pressed )
	if bind == 'gm_showspare2' and pressed then
		if IsValid( gp_F4.frame ) then
			return
		end
		Open()
	end
end )
