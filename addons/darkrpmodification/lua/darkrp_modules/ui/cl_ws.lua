module( 'gp_wepselector', package.seeall )
local width = 160
local pos_x = ScrW()/2
local pos_y = 10
local slots = {}
local selected = nil
local tab = 0
local slot = 1
local showed = 0
local act = -math.huge

surface.CreateFont('gp_wepselector', {
	font = 'Roboto',
	size = 17,
	weight = 300,
	antialias = true,
	extended = true,
	shadow = true
})

local function get_active_tool(ply, tool)
	-- find toolgun
	local activeWep = ply:GetActiveWeapon()
	if not IsValid(activeWep) or activeWep:GetClass() ~= "gmod_tool" or activeWep.Mode ~= tool then return end

	return activeWep:GetToolObject(tool)
end



local function update()
	table.Empty(slots)

	for k,v in pairs( LocalPlayer():GetWeapons() ) do
		local slot = v:GetSlot()
		slots[slot] = slots[slot] or {}
		table.insert( slots[slot], {
			slotpos = v:GetSlotPos(), 
			wepclass = v:GetClass(),
			name = v:GetPrintName()
		} )
	end


	for k,v in pairs( slots ) do
		table.sort(v, function(a, b) return a.slotpos < b.slotpos end)
	end
end

local function findTS()
	if showed > 0 then return end

	local class = IsValid(LocalPlayer():GetActiveWeapon()) and LocalPlayer():GetActiveWeapon():GetClass()
	selected = LocalPlayer():GetActiveWeapon()
	for k1, v1 in pairs(slots) do

		for k2, v2 in pairs(v1) do

			if v2.wepclass == class then

				tab = k1

				slot = k2

				return

			end

		end
	end
end

local function next_wep()

	update()

	if #slots < 1 then
		return true
	end
	
	findTS()

	slot = slot + 1

	if slot > (slots and #slots[tab] or -1) then
		repeat
			tab = tab + 1
			if tab > 5 then
				tab = 0
			end
		until slots[tab]
		slot = 1
	end 
	if GetConVarNumber("hud_fastswitch") > 0 then
		SelectWeaponW(slots[tab][slot].wepclass)
	else
		showed = 1
		act = RealTime()
	end
end
local function prev_wep()

	update()

	if #slots < 1 then
		return true
	end
	
	findTS()

	slot = slot - 1

	if slot < 1 then
		repeat
			tab = tab - 1
			if tab < 0 then
				tab = 5
			end
		until slots[tab]
		slot = #slots[tab]
	end 
	if GetConVarNumber("hud_fastswitch") > 0 then
		SelectWeaponW(slots[tab][slot].wepclass)
	else
		showed = 1
		act = RealTime()
	end
end

local function setslot( s )

	local sslot = tonumber( s:sub(5,5) ) or 1

	if sslot < 1 or sslot > 6 then return true end

	sslot = sslot - 1

	update()

	if not slots[sslot] then return true end

	findTS()

	if tab == sslot and slots[tab] then

		slot = slot + 1

		if slot > #slots[tab] then
			slot = 1
		end
 	else
 		tab = sslot
 		slot = 1
 	end

	if GetConVarNumber("hud_fastswitch") > 0 then
		SelectWeaponW(slots[tab][slot].wepclass)
	else
		showed = 1
		act = RealTime()
		surface.PlaySound( 'items/flashlight1.wav' )
	end

end

function SelectWeaponW( classname )

	local wep = LocalPlayer():GetWeapon(classname)
	if wep:IsValid() and LocalPlayer():GetActiveWeapon() ~= wep then
		input.SelectWeapon( wep )
		surface.PlaySound( 'ambient/water/rain_drip3.wav' )
		showed = 0
	else
		surface.PlaySound( 'ambient/water/rain_drip3.wav' )
		showed = 0
	end

end

local function geteye( ply )

	if ply:GetEyeTrace().Entity == NULL then return end

	return ply:GetEyeTrace().Entity:GetClass()  ~= 'worldspawn'

end
hook.Add( 'PlayerBindPress', 'gp_wepselector', function( ply, bind, pressed )

	if not IsValid(ply) then return end
	if not pressed or ply:InVehicle() then return end


	local tool = get_active_tool( ply, 'submaterial' )
	local tool2 = get_active_tool( ply, 'wire_adv' )
	local eye = geteye(ply)

	if (tool or tool2) and eye then return end

	if not (ply:GetActiveWeapon():IsValid() and ply:GetActiveWeapon():GetClass() == "weapon_physgun" and ply:KeyDown(IN_ATTACK)) then

		bind = bind:lower()
		if bind:find("invnext", nil, true) then
			next_wep()
			return true
		end
		if bind:find("invprev", nil, true) then
			prev_wep()
			return true
		end
		if string.sub(bind, 1, 4) == "slot" then
			setslot(bind)
			return true
		end
		if bind:find("+attack", nil, true) and showed > 0 then
			if slots and slots[tab] and slots[tab][slot] and slots[tab][slot].wepclass then
				SelectWeaponW(slots[tab][slot].wepclass)
				return true
			end
		end

	end

end )

local function GetActive()

	if LocalPlayer():GetActiveWeapon() == NULL then return end

	return LocalPlayer():GetActiveWeapon() and LocalPlayer():GetActiveWeapon():GetClass() or false

end

hook.Add( 'HUDPaint', 'gp_wepselector', function()
	
	if not IsValid(LocalPlayer()) then

		return

	end

	if not LocalPlayer():Alive() then return end

	update()

	local a = 0
	local calcwidth = 0
	for k,v in pairs( slots ) do

		calcwidth = calcwidth + width

	end

	if RealTime() - act > 2 then
		
		showed = Lerp(FrameTime()*5, showed, 0)

	end
	
	surface.SetAlphaMultiplier(showed)

	local pos = (ScrW() - calcwidth)/2
	for k,v in pairs( slots ) do
		if v[1].wepclass then
			a = a + 1
		end
		for j,i in pairs( v ) do
			local posx = pos + (width+10)*a-width-10
			local posy = pos_y+(45*j)-30
			local actived = v[j].wepclass == GetActive() and Color(0,70,150, 225) or Color(0,0,0, 210)

			draw.RoundedBox(0, posx, posy, width, 40, actived)
			draw.SimpleText( v[j].name, 'gp_wepselector', pos + (width+10)*a-width+70, pos_y+(45*j)-10, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER  )
			
			if tab == k and slot == j then
				draw.RoundedBox(0, pos + (width+10)*a-width-10, pos_y+(45*j)+5, width, 5, Color( 0, 168, 236 ))
			end
		end
	end
	surface.SetAlphaMultiplier(1)
end )

