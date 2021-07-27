if SCB_LOADED then return end

local table = table
local gui = gui
local team = team
local chat = chat
local hook = hook

local tonumber = tonumber
local Color = Color
local SetClipboardText = SetClipboardText
local IsValid = IsValid
local date = os.date
local team_GetColor = team.GetColor

local scb = scb
local config = scb.config

chat.OldOpen = chat.OldOpen or chat.Open
chat.OldClose = chat.OldClose or chat.Close

-- sometimes default chatbox prevents opening the console???
chat.OldClose()

function chat.Open(mode)
	mode = tonumber(mode)

	local dont_open = hook.Run("StartChat", mode ~= 1)
	if dont_open == true then return end

	scb.create_chatbox()

	local chatbox = scb.chatbox
	if chatbox.hidden == false then return end

	chatbox.bteam = mode
	chatbox.text_entry:SetPlaceholder((mode ~= 1 and "(TEAM) " or "") .. "начните писать...")

	chatbox:SetVisible(true)
	chatbox.text_entry:RequestFocus()
	chatbox.text_entry:InvalidateLayout()
	chatbox:MakePopup()

	local childs = chatbox.scroll_panel:GetCanvas():GetChildren()
	for i = 1, #childs do
		local v = childs[i]
		v:Stop()
		v:AlphaTo(255, 0)
	end

	net.Start("SCB.IsTyping")
		net.WriteBool(true)
	net.SendToServer()
end

function chat.Close()
	local chatbox = scb.chatbox
	if not chatbox then return end

	if IsValid(scb.emojis_menu) then
		scb.emojis_menu:Remove()
	end

	chatbox.text_entry:SetValue("")
	chatbox.text_entry:OnTextChanged() -- reset chat history

	local childs = chatbox.scroll_panel:GetCanvas():GetChildren()
	for i = 1, #childs do
		local v = childs[i]
		if v.can_hide == nil then
			v:Stop()
			v:AlphaTo(0, 0)
		end
	end

	chatbox:SetVisible(false)
	chatbox:SetMouseInputEnabled(false)
	chatbox:SetKeyboardInputEnabled(false)

	chatbox.scroll_panel:ScrollToBottom()

	hook.Run("FinishChat")

	net.Start("SCB.IsTyping")
		net.WriteBool(false)
	net.SendToServer()
end

chat.OldGetChatBoxPos = chat.OldGetChatBoxPos or chat.GetChatBoxPos
function chat.GetChatBoxPos()
	if scb.chatbox then
		return scb.chatbox:GetPos()
	end
	return chat.OldGetChatBoxPos()
end

chat.OldGetChatBoxSize = chat.OldGetChatBoxSize or chat.GetChatBoxSize
function chat.GetChatBoxSize()
	if scb.chatbox then
		return scb.chatbox:GetSize()
	end
	return chat.OldGetChatBoxSize()
end

local fade_out_time = GetConVar("scb_message_fade_out_time"):GetFloat()
cvars.AddChangeCallback("scb_message_fade_out_time", function(_, _, value_new)
	fade_out_time = value_new
end)

chat.OldAddText = chat.OldAddText or chat.AddText
local AddText_queue = {}
local allow_parsing = config.parse_in_chat
function chat.AddText(...)
	local args
	if AddText_queue == true then
		args = ...
	else
		chat.OldAddText(...)
		args = {n = select("#", ...), ...}
	end

	if not scb.chatbox then
		table.insert(AddText_queue, args)
		return
	end

	local scroll_panel = scb.chatbox.scroll_panel
	local down = scroll_panel:ShouldScrollDown()

	local line = scroll_panel:Add("SCB.ChatLine")
	line:HideAfterTime(fade_out_time)

	line.parsing = true

	local current_color = line.text_color
	for i = 1, args.n do
		local v = args[i]
		local t = scb.type(v)
		if t == "Color" then
			current_color = v
		elseif t == "string" then
			if allow_parsing then
				line:Parse(v, current_color)
			else
				line:NewLabel(v, current_color)
			end
		elseif scb.isentity(v) and not IsValid(v) and not v:IsWorld() then
			line:NewLabel("NULL", current_color)
		elseif t == "Player" then
			line:NewLabel(v:Name(), team_GetColor(v:Team()))
		elseif t == "Entity" then
			line:NewLabel(v:GetClass(), current_color)
		end
	end

	line.parsing = nil

	line:SizeToChildren(false, true)

	if down then
		scroll_panel:ScrollToBottom()
	end
end

local gamemodes_OnPlayerChat = {}
do
	local add_say = function(key, func)
		gamemodes_OnPlayerChat[key] = func
	end

	local line_DoRightClick = function(s)
		local d_menu = DermaMenu()

		local text = s.text
		d_menu:AddOption("Скопировать полностью", function()
			SetClipboardText(text)
		end)

		local message = s.message
		d_menu:AddOption("Скопировать сообщение", function()
			SetClipboardText(message)
		end)

		local steamid = s.steamid
		if steamid then
			d_menu:AddSpacer()

			d_menu:AddOption("Скопировать SteamID", function()
				SetClipboardText(util.SteamIDFrom64(steamid))
			end)

			d_menu:AddOption("Скопировать SteamID64", function()
				SetClipboardText(steamid)
			end)

			d_menu:AddOption("Открыть профиль", function()
				gui.OpenURL("https://steamcommunity.com/profiles/" .. steamid)
			end)
		end

		d_menu:AddSpacer()
		local time = s.time
		d_menu:AddOption("Скопировать время", function()
			SetClipboardText(time)
		end)

		d_menu:Open()
		d_menu:MakePopup()
	end

	local show_timestamps = GetConVar("scb_show_timestamps"):GetBool()
	cvars.AddChangeCallback("scb_show_timestamps", function(_, _, value_new)
		show_timestamps = tobool(value_new)
	end)

	local show_avatars = GetConVar("scb_show_avatars"):GetBool()
	cvars.AddChangeCallback("scb_show_avatars", function(_, _, value_new)
		show_avatars = tobool(value_new)
	end)

	local default_say = function(ply, text, bteam, is_dead, name_replacement, name_color_replacement, text_color)
		local is_console = not ply:IsValid()

		local scroll_panel = scb.chatbox.scroll_panel
		local down = scroll_panel:ShouldScrollDown()

		local line = scroll_panel:Add("SCB.ChatLine")
		line:HideAfterTime(fade_out_time)

		line.parsing = true
		line.time = date(config.timestamps_format)

		if show_timestamps then
			line:SetFont(SCB_16)
			line:NewLabel(line.time .. " ", Color(164, 164, 164))
			line:SetFont(SCB_18)
		end

		local name, name_color
		if not is_console then
			if show_avatars then
				line:NewAvatar(ply)
			end

			if is_dead then
				line:NewLabel("*DEAD* ", Color(244, 67, 54))
			end

			if bteam then
				line:NewLabel("(TEAM) ", Color(76, 175, 80))
			end

			local tag = ply:SCB_GetTag()
			if tag then
				line.emoji_size = 18
				line:Parse(tag .. " ")
				line.emoji_size = 24
			end

			if name_replacement then
				name = name_replacement
			else
				name = ply:Name()
			end

			if name_color_replacement then
				name_color = name_color_replacement
			else
				name_color = team_GetColor(ply:Team())
			end

			line.steamid = ply:SteamID64()
		else
			line:NewLabel("*")
			name, name_color = "Console", Color(13, 130, 223)
		end

		line:NewLabel(name, name_color)
		line:NewLabel(": ")
		line:SetPlayer(ply)
		line:Parse(text, text_color)

		line.message = text
		line.DoRightClick = line_DoRightClick

		if down then
			scroll_panel:ScrollToBottom()
		end

		chat.OldAddText(Color(164, 164, 164), line.time .. " - ", name_color, name, line.text_color, ": ", text_color, text)

		return true
	end
	add_say(1, default_say)

	add_say("darkrp", function(ply, text, _, is_dead, prefix, col1, col2)
		return default_say(ply, text, false, is_dead, prefix, col1, col2 ~= color_white and col2 or nil)
	end)

	add_say("terrortown", function(ply, text, bteam, is_dead)
		if not IsValid(ply) then
			return default_say(ply, text, bteam, is_dead)
		end

		local is_spec = ply:Team() == TEAM_SPEC
		if is_spec then
			is_dead = true
		end

		if bteam and ((not is_spec and not ply:IsSpecial()) or is_spec) then
			bteam = false
		end

		local name_color
		if ply:GetTraitor() then
			name_color = Color(244, 67, 54)
		elseif ply:GetDetective() then
			name_color = Color(13, 130, 223)
		end

		return default_say(ply, text, bteam, is_dead, nil, name_color)
	end)
end

local OnPlayerChat_queue = {}
hook.Add("OnPlayerChat", "SCB", function(...)
	table.insert(OnPlayerChat_queue, {n = select("#", ...), ...})
	return true
end)

hook.Add("HUDPaint", "SCB", function()
	chat.Open(1)

	for _, v in ipairs(AddText_queue) do
		AddText_queue = true
		chat.AddText(v)
	end
	AddText_queue = nil

	hook.Remove("OnPlayerChat", "SCB")
	OnPlayerChat = gamemodes_OnPlayerChat[engine.ActiveGamemode()] or gamemodes_OnPlayerChat[1]
	function GAMEMODE:OnPlayerChat(...)
		return OnPlayerChat(...)
	end
	for _, v in ipairs(OnPlayerChat_queue) do
		OnPlayerChat(unpack(v, 1, v.n))
	end
	OnPlayerChat_queue = nil

	chat.Close()
	hook.Remove("HUDPaint", "SCB")
end)

hook.Add("PlayerButtonDown", "SCB", function()
	local chatbox = scb.chatbox
	if chatbox and not chatbox.hidden then
		chatbox.text_entry:RequestFocus()
	end
end)

-- https://github.com/ValveSoftware/source-sdk-2013/blob/0d8dceea4310fde5706b3ce1c70609d72a38efdf/mp/src/game/client/clientmode_shared.cpp#L651
timer.Simple(5, function()
	local binds = {
		messagemode = 1,
		say = 1,

		messagemode2 = 0,
		say_team = 0
	}

	local old_PlayerBindPress = GAMEMODE.PlayerBindPress
	function GAMEMODE:PlayerBindPress(ply, bind, pressed)
		if old_PlayerBindPress(self, ply, bind, pressed) == true then
			return true
		end

		local team_mode = binds[bind]
		if team_mode then
			if pressed then
				chat.Open(team_mode)
			end
			return true
		end
	end
end)

timer.Simple(5, function()
	local types = {
		namechange = 1,
		servermsg = 1,
		teamchange = 1,
		none = 1,
	}

	if not config.enable_custom_join_leave_messages then
		types.joinleave = 1
	end

	local old_ChatText = GAMEMODE.ChatText
	function GAMEMODE:ChatText(index, name, text, type, ...)
		if old_ChatText(self, index, name, text, type) == true then
			return true
		end

		if types[type] then
			chat.AddText(text)
			return true
		end

		if type == "joinleave" then
			return true
		end
	end
end)

if config.enable_custom_join_leave_messages then
	local show_var = GetConVar("scb_joindisconnect_message")

	local printed_join = {}
	gameevent.Listen("player_connect_client")
	hook.Add("player_connect_client", "SCB.JoinMessage", function(data)
		if not show_var:GetBool() then return end

		if data.bot == 1 then
			chat.AddText(Color(23, 115, 196), data.name, color_white, " joined the game")
			return
		end

		local steamid = data.networkid
		if not printed_join[steamid] then
			printed_join[steamid] = true

			timer.Simple(4, function()
				printed_join[steamid] = nil
			end)

			chat.AddText(Color(23, 115, 196), scb.escape(data.name), color_white, " is connecting")
		end
	end)

	local printed_left = {}
	gameevent.Listen("player_disconnect")
	hook.Add("player_disconnect", "SCB.LeaveMessage", function(data)
		if not show_var:GetBool() then return end

		if data.bot == 1 then
			chat.AddText(Color(244, 67, 54), data.name, color_white, " left the game")
			return
		end

		local steamid = data.networkid
		if not printed_left[steamid] then
			printed_left[steamid] = true

			timer.Simple(4, function()
				printed_left[steamid] = nil
			end)

			chat.AddText(Color(244, 67, 54), scb.escape(data.name), color_white, " left the game: " .. scb.escape(data.reason))
		end
	end)
end

hook.Add("HUDShouldDraw", "SCB", function(name)
	if name == "CHudChat" then
		return false
	end
end)