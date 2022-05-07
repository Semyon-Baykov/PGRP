thirdPerson = {}
 
local toggleCamLock = false

local x = CreateClientConVar('sup_thirdperson_x', '120')
local y = CreateClientConVar('sup_thirdperson_y', '0')
local z = CreateClientConVar('sup_thirdperson_z', '15')
local enable = CreateClientConVar( 'enable_thirdperson', '0' )

local xmin, xmax = 40, 120
local ymin, ymax = -40, 40
local zmin, zmax = -15, 15

local fov = 90
local dist = 0

local function isThirdPerson(pl)
	pl = pl or LocalPlayer()
	if ((IsValid(pl:GetViewEntity()) and pl:GetViewEntity():GetClass() == "gmod_cameraprop") or (IsValid(pl:GetActiveWeapon()) and pl:GetActiveWeapon():GetClass() == "gmod_camera")) then return false end
	
	return tobool(enable:GetInt()) and (not pl:InVehicle()) and (pl:GetObserverMode() == OBS_MODE_NONE) and pl:Alive()
end

thirdPerson.isEnabled = isThirdPerson
local view = {}
local freecam_ang
local lastAim = nil
local htfilter = function(ent)
	return !(ent:GetParent() == LocalPlayer() or ent:IsPlayer())
end

hook.Add('CalcView', 'ThirdPerson.CalcView', function(pl, pos, angles)
	local tp = isThirdPerson(pl)
	if ((tp or dist > 0) and pl.camera_ang) then
		if (tp) then
			dist = math.min(dist + (1 - dist) * FrameTime() * 9, 1)
			if (dist > .99) then dist = 1 end
		else
			dist = math.max(dist - dist * FrameTime() * 9, 0)
			if (dist < .01) then dist = 0 end
		end

		local toggleCamLock = toggleCamLock
		if (pl:KeyDown(IN_WALK)) then toggleCamLock = !toggleCamLock end

		if (freecam_ang and !toggleCamLock) then
			pl.camera_ang = Angle(freecam_ang.p, freecam_ang.y, freecam_ang.r)
			freecam_ang = nil
		elseif (!freecam_ang and toggleCamLock) then
			freecam_ang = Angle(pl.camera_ang.p, pl.camera_ang.y, pl.camera_ang.r)
		end

		pos = pos + (pl.camera_ang:Forward() * dist * (-math.Clamp(x:GetInt(), xmin, xmax))) + (pl.camera_ang:Right() * dist * (math.Clamp(y:GetInt(), ymin, ymax))) + (pl.camera_ang:Up() * dist * (math.Clamp(z:GetInt(), zmin, zmax)))

		local hulltr = util.TraceHull({
			start = pl:GetShootPos(),
			endpos = pos,
			filter = htfilter,
			mask = MASK_SHOT_HULL,
			mins = Vector(-10, -10, -10),
			maxs = Vector(10, 10, 10)
		})

		if (hulltr.Hit) then
			pos = hulltr.HitPos + (pl:GetShootPos() - hulltr.HitPos):GetNormal() * 10
		end

		local aimtr = util.TraceLine({
			start = pl:EyePos(),--pos + (pl.camera_ang:Forward() * (-z:GetInt() + 45)),
			endpos = pos + (pl.camera_ang:Forward() * 100000),
			filter = htfilter
		})

		view.origin = pos
		view.fov = fov
		view.angles = pl.camera_ang
		view.drawviewer = true

		if (tp and pl:GetMoveType() == MOVETYPE_NOCLIP) then
			pl:SetEyeAngles(freecam_ang or pl.camera_ang)
		elseif (tp and !toggleCamLock) then
			local newAng = (aimtr.HitPos - pl:EyePos()):Angle()
			sp = aimtr.HitPos
			pl:SetEyeAngles(newAng)
		end

		return view
	else
		if (view and view.drawviewer) then
			view.drawviewer = false
			return view
		end
	end
end)


hook.Add("CreateMove", "ThirdPerson.CreateMove", function(cmd)
	local pl = LocalPlayer()

	if (isThirdPerson(pl) and pl.camera_ang and pl:GetMoveType() != MOVETYPE_NOCLIP) then
		local realAng = freecam_ang or pl.camera_ang
		local plAng = pl:GetAimVector():Angle()

		local curVec = Vector(cmd:GetForwardMove(), cmd:GetSideMove(), cmd:GetUpMove())
		curVec:Rotate(plAng - realAng)

		cmd:SetForwardMove(curVec.x)
		cmd:SetSideMove(curVec.y)
		cmd:SetUpMove(curVec.z)

		return false
	end
end)

hook.Add("InputMouseApply", "ThirdPerson.InputMouseApply", function(cmd, x, y, ang)
	local pl = LocalPlayer()

	if (isThirdPerson(pl)) then
		if (!pl.camera_ang) then
			pl.camera_ang = pl:EyeAngles()
		end

		pl.camera_ang.p = math.Clamp(math.NormalizeAngle(pl.camera_ang.p + y / 50), -90, 90)
		pl.camera_ang.y = math.NormalizeAngle(pl.camera_ang.y - x / 50)

		return true
	else
		pl.camera_ang = pl:EyeAngles()
	end
end)

-- hook('ShouldDrawLocalPlayer', 'ThirdPersonDrawPlayer', function()
-- 	if cvar.GetValue('enable_thirdperson') then
-- 		return isThirdPerson(LocalPlayer())
-- 	end
-- end)

local lastPress
hook.Add("PlayerBindPress", "ThirdPerson.PlayerBindPress", function(pl, bind, pressed)
	if (pressed and bind:lower() == "+walk") then
		local st = SysTime()

		if (lastPress and lastPress > st - 0.75) then
			toggleCamLock = !toggleCamLock
		end

		lastPress = st
	end
end)


local fr, chk, lbl 

hook.Add('OnContextMenuOpen', 'rp.ThirdPerson.OnContextMenuOpen', function()

	local pl = LocalPlayer()

	local chk = vgui.Create( 'DCheckBox', g_ContextMenu )
	chk:SetPos(10, 150)
	chk:SetSize( 20, 20 )
	chk:SetConVar('enable_thirdperson')
	chk:SetMouseInputEnabled(true)

	local label = vgui.Create( 'DLabel', g_ContextMenu )
	label:SetPos( 35 ,149 )
	label:SetFont( 'Trebuchet24' )
	label:SetTextColor( color_white ) 
	label:SetText( 'Включить вид от 3-его лица' )
	label:SizeToContents()
	



end)


hook.Add('OnContextMenuClose', 'rp.ThirdPerson.OnContextMenuClose', function()
	if (IsValid(fr)) then
		fr:Remove()
	end

	if (IsValid(chk)) then
		chk:Remove()
	end
end)
