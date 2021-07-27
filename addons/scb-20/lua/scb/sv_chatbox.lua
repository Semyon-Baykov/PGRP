if SCB_LOADED then return end

local util = util
local net = net
local file = file

local scb = scb

do
	util.AddNetworkString("SCB.SendMessage")
	util.AddNetworkString("SCB.SendMessageTeam")
	util.AddNetworkString("SCB.IsTyping")

	local cool_downs = {}

	local can_say = function(ply)
		local current_time = SysTime()
		local cool_down = cool_downs[ply]
		if not cool_down or current_time > cool_down then
			cool_downs[ply] = current_time + 0.66 -- https://github.com/ValveSoftware/source-sdk-2013/blob/0d8dceea4310fde5706b3ce1c70609d72a38efdf/sp/src/game/server/client.cpp#L747
			return true
		end
		return false
	end

	local say = function(ply, team)
		if not can_say(ply) then return end

		local text = net.ReadData(net.ReadUInt(8))
		text = text:sub(1, 126)
		if text ~= "" then
			ply:Say(text, team)
		end
	end

	net.Receive("SCB.SendMessage", function(_, ply)
		say(ply)
	end)

	net.Receive("SCB.SendMessageTeam", function(_, ply)
		say(ply, true)
	end)

	net.Receive("SCB.IsTyping", function(_, ply)
		ply:SetNWBool("SCB.IsTyping", net.ReadBool())
	end)
end

local emojis, tags

do
	util.AddNetworkString("SCB.SendEmojis")
	util.AddNetworkString("SCB.AddEmoji")
	util.AddNetworkString("SCB.RemoveEmoji")

	if not file.Exists("scb/custom_emojis.txt", "DATA") then
		file.Write("scb/custom_emojis.txt", scb.mp.pack({}))
	end

	emojis = scb.mp.unpack(file.Read("scb/custom_emojis.txt"))

	local save = function()
		file.Write("scb/custom_emojis.txt", scb.mp.pack(emojis))
	end

	do -- old emojis
		if scb.istable(select(2, next(emojis))) then
			for k, v in pairs(emojis) do
				emojis[k] = v.url
			end
		end
		save()
	end

	net.Receive("SCB.AddEmoji", function(len, ply)
		if not scb.has_permission(ply, "menu") then return end

		local emoji = net.ReadString()
		local url = net.ReadString()
		emojis[emoji] = url

		local old = net.ReadString()
		if old ~= "" then
			emojis[old] = nil
		end

		net.Start("SCB.AddEmoji")
			net.WriteString(emoji)
			net.WriteString(url)
			net.WriteString(old)
		net.Broadcast()

		save()
	end)

	net.Receive("SCB.RemoveEmoji", function(len, ply)
		if not scb.has_permission(ply, "menu") then return end

		local name = net.ReadString()

		emojis[name] = nil

		net.Start("SCB.RemoveEmoji")
			net.WriteString(name)
		net.Broadcast()

		save()
	end)
end

do
	util.AddNetworkString("SCB.SendTags")
	util.AddNetworkString("SCB.AddTag")
	util.AddNetworkString("SCB.RemoveTag")

	if not file.Exists("scb/tags.txt", "DATA") then
		file.Write("scb/tags.txt", scb.mp.pack({
			superadmin = ":crown: {#d4af37 Owner} :crown:",
			admin = "[{blue Admin}]",
			moderator = "[{green Moderator}]"
		}))
	end

	tags = scb.mp.unpack(file.Read("scb/tags.txt"))

	local save = function()
		file.Write("scb/tags.txt", scb.mp.pack(tags))
	end

	net.Receive("SCB.AddTag", function(len, ply)
		if not scb.has_permission(ply, "menu") then return end

		local key = net.ReadString()
		local tag = net.ReadString()
		tags[key] = tag

		local old = net.ReadString()

		net.Start("SCB.AddTag")
			net.WriteString(key)
			net.WriteString(tag)
			net.WriteString(old)
		net.Broadcast()

		if old ~= "" then
			tags[old] = nil
		end

		save()
	end)

	net.Receive("SCB.RemoveTag", function(len, ply)
		if not scb.has_permission(ply, "menu") then return end

		local name = net.ReadString()

		tags[name] = nil

		net.Start("SCB.RemoveTag")
			net.WriteString(name)
		net.Broadcast()

		save()
	end)
end

hook.Add("OnEntityCreated", "SCB.SendEmojis", function(ent)
	if not ent:IsPlayer() or not ent:IsValid() then return end

	do
		local emojis_data = scb.mp.pack(emojis)
		emojis_data = util.Compress(emojis_data)
		local length = #emojis_data

		net.Start("SCB.SendEmojis")
			net.WriteUInt(length, 17)
			net.WriteData(emojis_data, length)
		net.Send(ent)
	end

	do
		local tags_data = scb.mp.pack(tags)
		tags_data = util.Compress(tags_data)
		local length = #tags_data

		net.Start("SCB.SendTags")
			net.WriteUInt(length, 17)
			net.WriteData(tags_data, length)
		net.Send(ent)
	end
end)

-- -- https://github.com/iamcal/emoji-data
-- local function make_table(t)
-- 	local str = ""
-- 	for key, value in pairs(t) do
-- 		if (isnumber(key) or isbool(key)) then
-- 			key = "[" .. tostring(key) .. "]" .. "="
-- 		elseif isstring(key) then
-- 			key = "[\"" .. key .. "\"]" .. "="
-- 		end
-- 		if istable(value) then
-- 			str = str .. key .. '{' .. make_table(value)
-- 			str = str .. "},"
-- 		else
-- 			str = str .. key .. ('"' .. tostring(value) .. '"') .. ","
-- 		end
-- 	end
-- 	return str
-- end

-- local generate_emojis = function()
-- 	local pack = scb.mp.pack
-- 	local file = file

-- 	file.CreateDir("scb-generated-data")
-- 	file.CreateDir("scb-generated-data/emojis")

-- 	local categories = {
-- 		["Smileys & Emotion"] = "1",
-- 		["People & Body"] = "1",
-- 		["Animals & Nature"] = "2",
-- 		["Food & Drink"] = "3",
-- 		["Activities"] = "4",
-- 		["Travel & Places"] = "5",
-- 		["Objects"] = "6",
-- 		["Symbols"] = "7",
-- 		["Flags"] = "8",
-- 	}

-- 	local names_replacements = {
-- 		["+1"] = "thumbsup",
-- 		["-1"] = "thumbsdown",
-- 	}

-- 	local base_categories = util.JSONToTable(file.Read("scb-generated-data/base_categories.json"))
-- 	local smileys_category_n = #base_categories["Smileys & Emotion"]

-- 	local base_data = util.JSONToTable(file.Read("scb-generated-data/base_emojis.json"))
-- 	local new_data = {}
-- 	for k, v in ipairs(base_data) do
-- 		local image = v.image
-- 		if not image or image == "" then continue end
-- 		if not v.has_img_twitter then continue end
-- 		local short_name = v.short_name
-- 		if not short_name or short_name == "" then continue end
-- 		local category = categories[v.category]
-- 		if not category then continue end
-- 		short_name = names_replacements[short_name] or short_name:gsub("-", "_")
-- 		if v.category == "Flags" and not short_name:find("flag") then
-- 			short_name = "flag_" .. short_name
-- 		end
-- 		if v.id_number == "68909074" then continue end
-- 		local sort_order = v.sort_order
-- 		if v.category == "People & Body" then
-- 			sort_order = sort_order + smileys_category_n
-- 		end
-- 		new_data[short_name] = category .. sort_order
-- 		file.Write("scb-generated-data/emojis/" .. short_name .. ".png" , file.Read("img-twitter-64/" .. image))
-- 	end

-- 	file.Write("scb-generated-data/cl_emojis_data.txt", "return {" .. make_table(new_data) .. "}")
-- end
-- generate_emojis()