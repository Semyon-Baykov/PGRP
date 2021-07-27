if SCB_LOADED then return end

local types = {
	sv_ = SERVER and include or function() end,
	cl_ = SERVER and AddCSLuaFile or include,
	sh_ = function(name)
		if SERVER then
			AddCSLuaFile(name)
		end
		return include(name)
	end
}

local load_file = function(name, no, type)
	if not no then
		name = "scb/" .. name
	end

	local func = types[type or name:GetFileFromFilename():sub(1, 3)] or types["sh_"]
	if func then
		return func(name)
	end
end

scb = {
	config = {}
}

function scb.print(...)
	MsgC(
		Color(236, 240, 241), "(",
		Color(65, 185, 255), "SCB",
		Color(236, 240, 241), ") ",
		Color(236, 240, 241), ...
	) Msg("\n")
end

scb.print("Loading...")

	file.CreateDir("scb")

	require("sui")
	if CLIENT then
		scb.SUI = sui.new("SCB")
	end

	load_file("libs/sh_types.lua")
	scb.mp = load_file("libs/message_pack/sh_messagepack.lua")

	load_file("sh_scb_config.lua", true)

	for _, permissions in pairs(scb.config.permissions) do
		for k, v in ipairs(permissions) do
			if v ~= true then
				permissions[v], permissions[k] = true, nil
			end
		end
	end

	if SERVER then
		for _, f in ipairs(file.Find("scb/settings/tabs/*.lua", "LUA")) do
			AddCSLuaFile("scb/settings/tabs/" .. f)
		end
	end

	load_file("cl_util.lua")
	load_file("settings/cl_settings.lua")
	load_file("sh_chatbox.lua")
	load_file("sv_chatbox.lua")
	load_file("cl_chatbox.lua")
	load_file("cl_overrides.lua")

	if SERVER then
		AddCSLuaFile("scb/cl_emojis_data.lua", "GAME")

		-- emojis need to be loaded once the player joins, so things like this https://www.gmodstore.com/market/view/4868 could break it
		local AddWorkshop = resource.OldAddWorkshop or resource.AddWorkshop
		AddWorkshop("1998633255")
	end

	for _, f in ipairs(file.Find("scb/vgui/*.lua", "LUA")) do
		load_file("vgui/" .. f, false, "cl_")
	end

scb.print("Loaded!")

SCB_LOADED = true