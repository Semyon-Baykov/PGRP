local Menu = {}

Menu.superadmin = {"superadmin"}
Menu.admin 		= {"admin"}

local function Option(title, icon, cmd, check)
	table.insert(Menu, {title = title, icon = icon, cmd = cmd, check = check})
end

local function SubMenu(title, icon, func, check)
	table.insert(Menu, {title = title, icon = icon, func = func, check = check})
end

local function Spacer(check)
	table.insert(Menu, {check = check})
end

local function Request(title, text, func)
	return function()
		Derma_StringRequest(DarkRP.getPhrase(title) or title, DarkRP.getPhrase(text) or text, nil, function(s)
			func(s)
		end)
	end
end

local function isGlavno()
	if LocalPlayer():Team() == TEAM_NRG1 and LocalPlayer():rg_GetLVL() > 11 then
		return true
	else
		return false
	end
end

local function isNachalOrMayor()
	if LocalPlayer():Team() == TEAM_CHIEF or LocalPlayer():Team() == TEAM_MAYOR then return true end
end

local function isEntFreezeAllowed()
	if LocalPlayer():Team() == TEAM_BITCOIN or LocalPlayer():Team() == TEAM_CIGAR then return true end
end

local function isCP()
	return LocalPlayer():isCP()
end

local function isRGCmd()
	return LocalPlayer():rg_IsCMD()
end

local function isMayor()
	return LocalPlayer():isMayor()
end

local function isSuperAdmin()
	return table.HasValue(Menu.superadmin, LocalPlayer():GetUserGroup())
end

local function isAdmin()
	return table.HasValue(Menu.admin, LocalPlayer():GetUserGroup())
end

local function isGang()
	return LocalPlayer():Team() == TEAM_GANG or LocalPlayer():Team() == TEAM_MOB 
end

local function add(t)
	table.insert(Menu, t)
end

local function isphoneon()
	return LocalPlayer():GetNWBool( 'phone_status', false ) == true
end

local function isphoneoff()
	return LocalPlayer():GetNWBool( 'phone_status', false ) == false
end

local function set_radio_channel()

	local frame = vgui.Create( 'gpFrame' )
	frame:SetSize( 500, 170 )
	frame:Center()
	frame:MakePopup()
	frame:SetTitle( 'Сменить канал' )
	frame.PaintOver = function( _, w, h )

		draw.SimpleText( 'Введите желаемую частоту','Trebuchet24', w/2, 50, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

	end

	for k,v in pairs( gp_radio.tbl ) do
		if v.jobs[LocalPlayer():Team()] then
			frame:SetSize( 500, 200 )
			local as = frame:Add( 'gpButton' )
			as:SetSize( 0, 25 )
			as:Dock( BOTTOM )
			as:setText( k )
			as:DockMargin( 5, 0, 5, 5)
			as.DoClick = function()
				RunConsoleCommand( 'gp_radio_setchannel', k )
				frame:Remove()
			end
		end
	end

	local dnumb = frame:Add( 'DNumberWang' )
	dnumb:Dock( TOP )
	dnumb:SetSize( 0, 25 )
	dnumb:DockMargin( 25, 55, 25, 0 )

	local as = frame:Add( 'gpButton' )
	as:SetSize( 0, 25 )
	as:Dock( BOTTOM )
	as:setText( 'Сменить канал' )
	as:DockMargin( 5, 0, 5, 5)

	as.DoClick = function()
		frame:Remove()
		RunConsoleCommand( 'gp_radio_setchannel', dnumb:GetValue() )
	end
 	

end

--[[-------------------------------------------------------
	CMD Start
---------------------------------------------------------]]
Option('Включить рацию', 'icon16/phone_add.png', function() RunConsoleCommand( 'gp_toggle_radio' ) end, function() return LocalPlayer():GetNWBool( 'gp_radio', false ) and (LocalPlayer():GetNWBool( 'gp_radio_off', false ) == true) end )
Option('Выключить рацию', 'icon16/phone_delete.png', function() RunConsoleCommand( 'gp_toggle_radio' ) end, function() return LocalPlayer():GetNWBool( 'gp_radio', false ) and (LocalPlayer():GetNWBool( 'gp_radio_off', false ) == false) end )
Option('Сменить канал', 'icon16/phone.png', function() set_radio_channel() end, function() return LocalPlayer():GetNWBool( 'gp_radio', false ) end )

Spacer( function() return LocalPlayer():GetNWBool( 'gp_radio', false ) end )

Option('Управление росгвардией', "icon16/user_add.png", function()
	RunConsoleCommand("rg_cmd")
end, isRGCmd)

Spacer(isRGCmd)


Option('Вызвать всех сотрудников', 'icon16/error.png', function()
	for k, v in pairs(player.GetAll()) do
		if v:Team() == TEAM_NRG1 then
			LocalPlayer():ConCommand( "sendpos "..v:UserID() )
			v:PrintMessage( HUD_PRINTTALK, 'Один из офицеров срочно вызвает всех сотрудников к себе!' )
		end
	end
end, isGlavno)

Spacer(isGlavno)

Option('Вызвать всех полицейских', 'icon16/error.png', function()
	for k, v in pairs(player.GetAll()) do
		if v:Team() == TEAM_POLICE or v:Team() == TEAM_DPS or v:Team() == TEAM_PPS or v:Team() == TEAM_CHIEF or v:Team() == TEAM_FBI or v:Team() == TEAM_OMON then
			LocalPlayer():ConCommand( "sendpos "..v:UserID() )
			v:PrintMessage( HUD_PRINTTALK, 'Начальство срочно вызывает вас к себе!' )
		end
	end
end, isNachalOrMayor)

Spacer(isNachalOrMayor)

Option('Зафризить предмет, на который вы смотрите', 'icon16/stop.png', function()
	LocalPlayer():ConCommand( 'say !entfreeze' )
end, isEntFreezeAllowed)
Option('Расфризить предмет, на который вы смотрите', 'icon16/stop.png', function()
	LocalPlayer():ConCommand( 'say !entunfreeze' )
end, isEntFreezeAllowed)

Spacer(isEntFreezeAllowed)

Option('Меню банды', "icon16/user_add.png", function()
	RunConsoleCommand("gp_gangsys_menu")
end, isGang)

Spacer(isGang)

Option(C_LANGUAGE_MONEY_DROP, "icon16/money_delete.png", Request(C_LANGUAGE_MONEY_DROP, C_LANGUAGE_ENTER_AMOUNT, function(s)
	RunConsoleCommand("darkrp", "dropmoney", s)
end))

Option(C_LANGUAGE_MONEY_GIVE, "icon16/money_add.png", Request(C_LANGUAGE_MONEY_GIVE, C_LANGUAGE_ENTER_AMOUNT, function(s)
	RunConsoleCommand("darkrp", "give", s)
end))

SubMenu(C_LANGUAGE_MONEY_CHEQUE, "icon16/report_edit.png", function(self)
	for k, v in pairs(player.GetAll()) do
		if v == LocalPlayer() then continue end
			self:AddOption(v:Name(), Request(C_LANGUAGE_MONEY_CHEQUE, C_LANGUAGE_ENTER_AMOUNT, function(s) 
				RunConsoleCommand("darkrp", "cheque", v:UserID(), s)
			end)):SetColor(v:getJobTable().color)
	end
end)
Spacer()

Option('Свод законов', "icon16/book.png", function()
	showlawlist()
end)


Spacer()

SubMenu( "Отправить местоположение", "icon16/map.png", function( self )

	local t = table.Copy( player.GetAll() )

	table.RemoveByValue( t, LocalPlayer() )

	for k,v in pairs( t ) do

		self:AddOption( v:Nick(), function()

			if IsValid( v ) then
				LocalPlayer():ConCommand( "sendpos "..v:UserID() )
			end

		end):SetColor( team.GetColor( v:Team() ) )

	end



end )


--[[
	Option('Включить телефон', 'icon16/phone_add.png', function() RunConsoleCommand( "say", "/toggleon_phone" ) end, isphoneoff)
	Option('Выключить телефон', 'icon16/phone_delete.png', function() RunConsoleCommand( "say", "/toggleoff_phone" ) end,isphoneon)


	SubMenu( "Позвонить", "icon16/phone.png", function(self)

	local j = table.Copy( player.GetAll() )

	table.RemoveByValue( j, LocalPlayer() )

	for k,v in pairs( j ) do

		self:AddOption( v:Nick(), function()

			if IsValid( v ) then
				LocalPlayer():ConCommand( "darkrp call "..v:UserID() )
			end

		end):SetColor( team.GetColor( v:Team() ) )


	end



end )

Option( "Изменить рингтон", "icon16/phone_sound.png", function()
	phone.SelectRingtone()
end )
]]--
Spacer()

Option(C_LANGUAGE_DROP, "icon16/gun.png", function()
	RunConsoleCommand("darkrp", "dropweapon")
end)
Option('Купить патроны к текущему оружию', "icon16/gun.png", function()
	RunConsoleCommand('darkrp','buyammo',game.GetAmmoName(LocalPlayer():GetActiveWeapon():GetPrimaryAmmoType()) )
end)

Option(C_LANGUAGE_REQUEST_LICENSE, "icon16/page_add.png", function()
	RunConsoleCommand("darkrp", "requestlicense")
end)

Option(C_LANGUAGE_WRITE, "icon16/book_edit.png", Request(C_LANGUAGE_WRITE, C_LANGUAGE_WRITE_DESCRIPTION, function(s)
	RunConsoleCommand("darkrp", "write", s)
end))

Option( 'Доступ к пропам', 'icon16/user_add.png', function()
	RunConsoleCommand( 'cppi_friends' )
end )

Spacer()
--[[
Option(C_LANGUAGE_RPNAME, "icon16/user_edit.png", Request(C_LANGUAGE_RPNAME, C_LANGUAGE_RPNAME_DESCRIPTION, function(s)
	RunConsoleCommand("darkrp", "rpname", s)
end))
--]]
Option('Улучшения персонажа', "icon16/user.png", function()
	RunConsoleCommand("gp_upg")
end)
Option(C_LANGUAGE_CUSTOM_JOB, "icon16/user_add.png", Request(C_LANGUAGE_CUSTOM_JOB, C_LANGUAGE_CUSTOM_JOB_DESCRIPTION, function(s)
	RunConsoleCommand("darkrp", "job", s)
end))

SubMenu(C_LANGUAGE_DEMOTE, "icon16/user_delete.png", function(self)
	for k, v in pairs(player.GetAll()) do
		if v == LocalPlayer() then continue end
		self:AddOption(v:Name(), Request(C_LANGUAGE_DEMOTE, C_LANGUAGE_ENTER_REASON, function(s) 
			RunConsoleCommand("darkrp", "demote", v:UserID(), s)
		end)):SetColor(v:getJobTable().color)
	end
end)

Option(C_LANGUAGE_UNOWN_ALL, "icon16/door.png", function()
	RunConsoleCommand("darkrp", "unownalldoors")
end)

Spacer(isCP)

Option(C_LANGUAGE_GIVE_LICENSE, "icon16/script.png", function(self)
	RunConsoleCommand("darkrp", "givelicense")
end, function()
	local ply = LocalPlayer()
	local noMayorExists = fn.Compose{fn.Null, fn.Curry(fn.Filter, 2)(ply.isMayor), player.GetAll}
	local noChiefExists = fn.Compose{fn.Null, fn.Curry(fn.Filter, 2)(ply.isChief), player.GetAll}

	local canGiveLicense = fn.FOr{
		ply.isMayor,
		fn.FAnd{ply.isChief, noMayorExists},
		fn.FAnd{ply.isCP, noChiefExists, noMayorExists}
	}

	return canGiveLicense(ply)
end)

SubMenu(C_LANGUAGE_WANTED, "icon16/add.png", function(self)
	for k, v in pairs(player.GetAll()) do
		if v == LocalPlayer() then continue end
		if !v:isWanted() then
			self:AddOption(v:Name(), Request(C_LANGUAGE_WANTED, C_LANGUAGE_ENTER_REASON, function(s) 
				RunConsoleCommand("darkrp", "wanted", v:UserID(), s)
			end)):SetColor(v:getJobTable().color)
		end
	end
end, isCP)

SubMenu(C_LANGUAGE_UNWANTED, "icon16/delete.png", function(self)
	for k, v in pairs(player.GetAll()) do
		if v:isWanted() then
			self:AddOption(v:Name(), function() RunConsoleCommand("darkrp", "unwanted", v:UserID(), s) end):SetColor(v:getJobTable().color)
		end
	end
end, isCP)

SubMenu(C_LANGUAGE_WARRANT, "icon16/briefcase.png", function(self)
	for k, v in pairs(player.GetAll()) do
		if v == LocalPlayer() then continue end
		self:AddOption(v:Name(), Request(C_LANGUAGE_WARRANT, C_LANGUAGE_ENTER_REASON, function(s) 
			RunConsoleCommand("darkrp", "warrant", v:UserID(), s)
		end)):SetColor(v:getJobTable().color)
	end
end, isCP)

Spacer(function() return LocalPlayer():isMayor() end)

Option(C_LANGUAGE_LOCKDOWN, "icon16/tick.png", Request(C_LANGUAGE_LOCKDOWN, 'Введите причину', function(s)
	RunConsoleCommand("darkrp", "lockdown", s)
end), isMayor)

Option(C_LANGUAGE_UNLOCKDOWN, "icon16/cross.png", function(s)
	RunConsoleCommand("darkrp", "unlockdown")
end, isMayor)


Option(C_LANGUAGE_LOTTERY, "icon16/sport_8ball.png", Request(C_LANGUAGE_LOTTERY, C_LANGUAGE_ENTER_AMOUNT, function(s)
	RunConsoleCommand("darkrp", "lottery", s)
end), isMayor)

Option(C_LANGUAGE_ADDLAW, "icon16/application_form_add.png", Request(C_LANGUAGE_ADDLAW, C_LANGUAGE_ADDLAW_DESCRIPTION, function(s)
	RunConsoleCommand("darkrp", "addlaw", s)
end), isMayor)

Option(C_LANGUAGE_REMOVELAW, "icon16/application_form_delete.png", Request(C_LANGUAGE_REMOVELAW, C_LANGUAGE_REMOVELAW_DESCRIPTION, function(s)
	RunConsoleCommand("darkrp", "removelaw", s)
end), isMayor)

--[[
Option(C_LANGUAGE_BROADCAST, "icon16/ipod_cast.png", Request(C_LANGUAGE_BROADCAST, C_LANGUAGE_BROADCAST_DESCRIPTION, function(s)
	RunConsoleCommand("darkrp", "broadcast", s)
end), isMayor)
--]]
Option(C_LANGUAGE_AGENDA, "icon16/application.png", Request(C_LANGUAGE_AGENDA, C_LANGUAGE_AGENDA_DESCRIPTION, function(s)
	RunConsoleCommand("darkrp", "agenda", s)
end), function()
	for k, v in pairs(DarkRPAgendas) do
		if type(v.Manager) == "table" then
			if table.HasValue(v.Manager, LocalPlayer():Team()) then
				return true
			end
		elseif v.Manager == LocalPlayer():Team() then
			return true
		end
	end
end)

--[[-------------------------------------------------------
	CMD End
---------------------------------------------------------]]

local menu
hook.Add("OnContextMenuOpen", "CMenuOnContextMenuOpen", function()
	if not g_ContextMenu:IsVisible() then
		local orig = g_ContextMenu.Open
		g_ContextMenu.Open = function(self, ...)
			self.Open = orig
			orig(self, ...)

			menu = vgui.Create("CMenuExtension")
			menu:SetDrawOnTop(false)

			for k, v in pairs(Menu) do
				if not v.check or v.check() then
					if v.cmd then
						menu:AddOption(v.title, isfunction(v.cmd) and v.cmd or function() RunConsoleCommand(v.cmd) end):SetImage(v.icon)
					elseif v.func then
						local m, s = menu:AddSubMenu(v.title)
						s:SetImage(v.icon)
						v.func(m)
					else
						menu:AddSpacer()
					end
				end
			end

			menu:Open()
			menu:CenterHorizontal()
			menu.y = ScrH()
			menu:MoveTo(menu.x, ScrH() - menu:GetTall() - 8, .1, 0)
			menu:MakePopup()
		end
	end
end)

hook.Add( "CloseDermaMenus", "CMenuCloseDermaMenus", function()
	if menu && menu:IsValid() then
		menu:MakePopup()
	end
end)

hook.Add("OnContextMenuClose", "CMenuOnContextMenuClose", function()
	menu:Remove()
end)


local PANEL = {}

AccessorFunc( PANEL, "m_bBorder", 			"DrawBorder" 	)
AccessorFunc( PANEL, "m_bDeleteSelf", 		"DeleteSelf" 	)
AccessorFunc( PANEL, "m_iMinimumWidth", 	"MinimumWidth" 	)
AccessorFunc( PANEL, "m_bDrawColumn", 		"DrawColumn" 	)
AccessorFunc( PANEL, "m_iMaxHeight", 		"MaxHeight" 	)
AccessorFunc( PANEL, "m_pOpenSubMenu", 		"OpenSubMenu" 	)

function PANEL:Init()

	self:SetIsMenu( true )
	self:SetDrawBorder( true )
	self:SetPaintBackground( true )
	self:SetMinimumWidth( 100 )
	self:SetDrawOnTop( true )
	self:SetMaxHeight( ScrH() * 0.9 )
	self:SetDeleteSelf( true )
	self:SetPadding( 0 )
	RegisterDermaMenuForClose( self )
	
end

function PANEL:AddPanel( pnl )

	self:AddItem( pnl )
	pnl.ParentMenu = self
	
end

function PANEL:AddOption( strText, funcFunction )

	local pnl = vgui.Create( "DMenuOption", self )
	pnl:SetMenu( self )
	pnl:SetText( strText )
	if ( funcFunction ) then pnl.DoClick = funcFunction end
	
	self:AddPanel( pnl )
	
	return pnl

end

function PANEL:AddCVar( strText, convar, on, off, funcFunction )

	local pnl = vgui.Create( "DMenuOptionCVar", self )
	pnl:SetMenu( self )
	pnl:SetText( strText )
	if ( funcFunction ) then pnl.DoClick = funcFunction end

	pnl:SetConVar( convar )
	pnl:SetValueOn( on )
	pnl:SetValueOff( off )

	self:AddPanel( pnl )

	return pnl

end

function PANEL:AddSpacer( strText, funcFunction )

	local pnl = vgui.Create( "DPanel", self )
	pnl.Paint = function( p, w, h )
		derma.SkinHook( "Paint", "MenuSpacer", p, w, h )
	end

	pnl:SetTall( 1 )
	self:AddPanel( pnl )

	return pnl

end

function PANEL:AddSubMenu( strText, funcFunction )

	local pnl = vgui.Create( "DMenuOption", self )
	local SubMenu = pnl:AddSubMenu( strText, funcFunction )

	pnl:SetText( strText )
	if ( funcFunction ) then pnl.DoClick = funcFunction end

	self:AddPanel( pnl )

	return SubMenu, pnl

end

function PANEL:Hide()

	local openmenu = self:GetOpenSubMenu()
	if ( openmenu ) then
		openmenu:Hide()
	end
	
	self:SetVisible( false )
	self:SetOpenSubMenu( nil )
	
end

function PANEL:OpenSubMenu( item, menu )

	local openmenu = self:GetOpenSubMenu()
	if ( IsValid( openmenu ) ) then

		if ( menu && openmenu == menu ) then return end

		self:CloseSubMenu( openmenu )
		
	end

	if ( !IsValid( menu ) ) then return end

	local x, y = item:LocalToScreen( self:GetWide(), 0 )
	menu:Open( x - 3, y, false, item )

	self:SetOpenSubMenu( menu )

end

function PANEL:CloseSubMenu( menu )

	menu:Hide()
	self:SetOpenSubMenu( nil )

end

function PANEL:Paint( w, h )

	if ( !self:GetPaintBackground() ) then return end

	derma.SkinHook( "Paint", "Menu", self, w, h )
	return true

end

function PANEL:ChildCount()
	return #self:GetCanvas():GetChildren()
end

function PANEL:GetChild( num )
	return self:GetCanvas():GetChildren()[ num ]
end

function PANEL:PerformLayout()

	local w = self:GetMinimumWidth()

	for k, pnl in pairs( self:GetCanvas():GetChildren() ) do
	
		pnl:PerformLayout()
		w = math.max( w, pnl:GetWide() )
	
	end

	self:SetWide( w )
	
	local y = 0
	
	for k, pnl in pairs( self:GetCanvas():GetChildren() ) do
	
		pnl:SetWide( w )
		pnl:SetPos( 0, y )
		pnl:InvalidateLayout( true )
		
		y = y + pnl:GetTall()
	
	end
	
	y = math.min( y, self:GetMaxHeight() )
	
	self:SetTall( y )

	derma.SkinHook( "Layout", "Menu", self )
	
	DScrollPanel.PerformLayout( self )

end

function PANEL:Open( x, y, skipanimation, ownerpanel )

	RegisterDermaMenuForClose( self )

	local maunal = x && y

	x = x or gui.MouseX()
	y = y or gui.MouseY()

	local OwnerHeight = 0
	local OwnerWidth = 0

	if ( ownerpanel ) then
		OwnerWidth, OwnerHeight = ownerpanel:GetSize()
	end

	self:PerformLayout()

	local w = self:GetWide()
	local h = self:GetTall()

	self:SetSize( w, h )

	if ( y + h > ScrH() ) then y = ( ( maunal && ScrH() ) or ( y + OwnerHeight ) ) - h end
	if ( x + w > ScrW() ) then x = ( ( maunal && ScrW() ) or x ) - w end
	if ( y < 1 ) then y = 1 end
	if ( x < 1 ) then x = 1 end

	self:SetPos( x, y )
	self:MakePopup()
	self:SetVisible( true )
	self:SetKeyboardInputEnabled( false )

end

function PANEL:OptionSelectedInternal( option )

	self:OptionSelected( option, option:GetText() )

end

function PANEL:OptionSelected( option, text ) end

function PANEL:ClearHighlights()

	for k, pnl in pairs( self:GetCanvas():GetChildren() ) do
		pnl.Highlight = nil
	end

end

function PANEL:HighlightItem( item )

	for k, pnl in pairs( self:GetCanvas():GetChildren() ) do
		if ( pnl == item ) then
			pnl.Highlight = true
		end
	end

end

derma.DefineControl( "CMenuExtension", "A Menu", PANEL, "DScrollPanel" )