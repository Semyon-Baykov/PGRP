-- This is the file used for all extra things. Generally this is just some codes for the SWEPs.
-- The code has been made by Diablos and has been updated during June 2018 ; all materials/models have been made by PYRO.
-- Do not redistribute this code anywhere. Thanks.

CreateConVar("fidgetspinner_soundeffects", "1", FCVAR_ARCHIVE, "Should sound effects be here for the fidget spinners SWEPs?")
CreateConVar("fidgetspinner_fastdl", "1", FCVAR_ARCHIVE, "Should a fast DL be here for downloading the fidget spinners contents?")

local sdeffectval = GetConVar("fidgetspinner_soundeffects"):GetInt()
if sdeffectval != 0 then
	sound.Add({name = "fidget_spinner_sound", channel = CHAN_STATIC, volume = 1.0, level = 80, pitch = 100, sound = "fidgetspinner/fidgetspinner.mp3"})
	sound.Add({name = "loop_spinner_sound", channel = CHAN_STATIC, volume = 1.0, level = 80, pitch = 100, sound = "fidgetspinner/loop.mp3"})
	sound.Add({name = "shuriken_spinner_sound", channel = CHAN_STATIC, volume = 1.0, level = 80, pitch = 100, sound = "fidgetspinner/throw.mp3"})
end

if SERVER then
	local convarval = GetConVar("fidgetspinner_fastdl"):GetInt()
	if convarval != 0 then
		-- Fuck Off!
	end

	util.AddNetworkString("FidgetSpinnerColor")

	net.Receive("FidgetSpinnerColor", function(len, ply)
		local wep = net.ReadEntity()
		local r, g, b = net.ReadUInt(8), net.ReadUInt(8), net.ReadUInt(8)
		wep:SetColor(Color(r, g, b))
	end)
end
if CLIENT then
	surface.CreateFont("DiablosShurikenFont", { font = "Calibri", size = 18, weight = 400 })

	local function DiablosShurikenColor(self)
		if self.Hovered then
			if self:IsDown() then
				self:SetTextColor(Color(0, 0, 0, 255))
			else
				self:SetTextColor(Color(25, 25, 25, 200))
			end
		else
			self:SetTextColor(Color(255, 255, 255, 255))
		end
	end

	local colors = {
		frame = Color(50, 50, 50, 200),
		header = Color(60, 60, 60, 200),
		white = Color(220, 220, 220, 200),
		chat1 = Color(100, 200, 100),
		chat2 = Color(100, 180, 200),
	}

	local tableverif = {
		["fidgetspinner"] = true,
		["freespinner"] = true,
		["shurikenspinner"] = true
	}

	local frame

--[[	local function FidgetSpinnerColor()
		local activewep = LocalPlayer():GetActiveWeapon()
		local inicol = activewep:GetColor()

		frame = vgui.Create("DFrame")
		frame:SetPos(ScrW() - 600, ScrH() * .2)
		frame:SetSize(500, 300)
		frame:SetTitle("")
		frame:ShowCloseButton(false)
		frame.Paint = function(s, w, h)
			surface.SetDrawColor(colors.frame) surface.DrawRect(0, 0, w, h)
			surface.SetDrawColor(colors.header) surface.DrawRect(0, 0, w, 30)
			draw.SimpleText("Fidget Spinner Color", "DiablosShurikenFont", 7, 7, colors.white, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
		end

		frame:MakePopup()

		local cancel = vgui.Create("DButton", frame)
		cancel:SetPos(480, 5)
		cancel:SetSize(20, 20)
		cancel:SetText("X")
		cancel:SetFont("DiablosShurikenFont")
		cancel.DoClick = function()
			frame:Close()
			activewep:SetColor(Color(inicol.r, inicol.g, inicol.b))
		end
		cancel.Paint = function(s, w, h)
			DiablosShurikenColor(s)
		end

		local colorpick = vgui.Create("DColorMixer", frame)
		colorpick:SetPos(30, 60)
		colorpick:SetSize(440, 210)
		colorpick:SetPalette(true)
		colorpick:SetAlphaBar(false)
		colorpick:SetWangs(true)
		colorpick:SetColor(Color(inicol.r, inicol.g, inicol.b))
		colorpick.ValueChanged = function(co)
			local col = co:GetColor()
			activewep:SetColor(Color(col.r, col.g, col.b))
		end

		local apply = vgui.Create("DButton", frame)
		apply:SetPos(420, 140)
		apply:SetSize(50, 80)
		apply:SetText("OK")
		apply:SetFont("DiablosShurikenFont")
		apply.Paint = function(s, w, h)
			DiablosShurikenColor(s)
			surface.SetDrawColor(colors.white) surface.DrawRect(0, 0, w, h)
		end
		apply.DoClick = function()
			local wep = LocalPlayer():GetActiveWeapon()
			if !IsValid(wep) then return end
			if not tableverif[wep:GetClass()] then return end
			local color = colorpick:GetColor()
			net.Start("FidgetSpinnerColor")
				net.WriteEntity(wep)
				net.WriteUInt(color.r, 8)
				net.WriteUInt(color.g, 8)
				net.WriteUInt(color.b, 8)
			net.SendToServer()
			frame:Close()
			chat.AddText(colors.chat1, "[Fidget Spinner]: ", colors.chat2, "The color of your fidget spinner has successfully changed!")
		end
	end

	list.Set("DesktopWindows", "FidgetSpinner", {
		title = "Fidget Color",
		icon = "fidgeticon/fidgeticon.png",
		init = function(icn, win)
			icn.DoClick = function(self)
				local ply = LocalPlayer()
				if not IsValid(ply) then return end
				local activewep = ply:GetActiveWeapon()
				if not IsValid(activewep) then return end
				if not tableverif[activewep:GetClass()] then 
					chat.AddText(colors.chat1, "[Fidget Spinner]: ", colors.chat2, "You must have a fidget spinner in your right hand!")
					return
				end
				if IsValid(frame) then return end
				FidgetSpinnerColor()
			end
		end
	}) ]]--
end

local function RemoveSpinnersENTs(ply, cmd, args)
	if ply:IsPlayer() and not ply:IsSuperAdmin() then return end
	for _, v in pairs(ents.FindByClass("ent_shurikenspinner")) do if IsValid(v) then v:Remove() end end
end

concommand.Add("removeallspinners", RemoveSpinnersENTs)