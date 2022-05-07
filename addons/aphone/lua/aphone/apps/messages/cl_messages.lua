sql.Query( "CREATE TABLE IF NOT EXISTS aphone_Messages(user INTEGER, body TEXT, ip TEXT, local_sender INTEGER, timestamp INTEGER)")
sql.Query( "CREATE TABLE IF NOT EXISTS aphone_Friends(user INTEGER, body TEXT, ip TEXT, local_sender INTEGER, timestamp INTEGER, last_name TEXT, likes INTEGER DEFAULT 0, id INTEGER DEFAULT 0, local_vote INTEGER DEFAULT 0)")

aphone.Messages = aphone.Messages or {}

local function cache_message(userid, body, local_sender, timestamp, is_friends, msg_id)
	timestamp = timestamp or os.time()
	if !is_friends then
		sql.Query("INSERT INTO aphone_Messages(user, body, ip, local_sender, timestamp) VALUES(" .. userid .. ", " .. sql.SQLStr(body) .. "," .. sql.SQLStr(game.GetIPAddress()) .. "," .. (local_sender and 1 or 0) .. "," .. timestamp .. ")")
	else
		sql.Query("INSERT INTO aphone_Friends(user, body, ip, local_sender, timestamp, last_name, id) VALUES(" .. userid .. ", " .. sql.SQLStr(body) .. ", " .. sql.SQLStr(game.GetIPAddress()) .. ", " .. (userid == LocalPlayer():aphone_GetID() and 1 or 0) .. ", " .. timestamp .. ", '" .. is_friends .. "'," .. msg_id .. ")")
	end
end

function aphone.Contacts.Send(userid, body, is_friends)
	net.Start("aphone_NewMessage")
		net.WriteBool(is_friends)

		if !is_friends then
			net.WriteUInt(userid, 32)
		end

		net.WriteString(body)
	net.SendToServer()

	if !is_friends then
		cache_message(userid, body, true, os.time())
	end
end

net.Receive("aphone_CacheClientMessages", function()
	local loop_value = net.ReadUInt(16)
	local is_friends = net.ReadBool()
	local ply_id = LocalPlayer():aphone_GetID()

	for i = 1, loop_value do
		local user1 = net.ReadUInt(24)
		local user2 = !is_friends and net.ReadUInt(24) or nil
		local body = net.ReadString()
		local timestamp = net.ReadUInt(32)

		if is_friends then
			local name = net.ReadString()
			cache_message(user1, body, user1 == ply_id, timestamp, name, net.ReadUInt(32))
		else
			cache_message(user1 != ply_id and user1 or user2, body, user1 == ply_id, timestamp)
		end
	end
end)

net.Receive("aphone_CacheLikes", function()
	local loop_value = net.ReadUInt(16)

	for i = 1, loop_value do
		local q = "UPDATE aphone_Friends SET likes = " .. net.ReadUInt(32) .. " WHERE id = " .. net.ReadUInt(32)
		sql.Query(q)
	end
end)

net.Receive("aphone_SyncOneMessage", function()
	local uid = net.ReadEntity()
	local body = net.ReadString()
	local is_friends = net.ReadBool()

	if !is_friends then
		if !aphone:GetParameters("Core", "SilentMode", false) and IsValid(LocalPlayer()) and LocalPlayer():HasWeapon("aphone") then
			aphone.playringtone()
		end

		if aphone.InsertNewMessage then
			aphone.InsertNewMessage(uid, body)
		end

		cache_message(uid:aphone_GetID(), body, false)
	else
		local time = net.ReadUInt(32)
		local msg_id = net.ReadUInt(32)
		cache_message(uid:aphone_GetID(), body, false, time, uid:GetName(), msg_id)

		if aphone.InsertNewMessage_Friend then
			aphone.InsertNewMessage_Friend(uid:aphone_GetID(), body, msg_id, uid:GetName(), 0, 0)
		end
	end
end)

local red = Color(255, 82, 82)
net.Receive("aphone_AddLike", function()
	local b = net.ReadBool()
	local id = net.ReadUInt(29)
	local user = net.ReadUInt(24)
	local local_vote = (user == LocalPlayer():aphone_GetID())
	local q

	if local_vote then
		q = "UPDATE aphone_Friends SET likes = likes " .. (b and "+ 1" or "- 1") .. ", local_vote = " .. (b and 1 or 0 ) .. " WHERE id = " .. id
	else
		q = "UPDATE aphone_Friends SET likes = likes " .. (b and "+ 1" or "- 1") .. " WHERE id = " .. id
	end

	sql.Query(q)

	if aphone.Friends_PanelList and aphone.Friends_PanelList[id] and IsValid(aphone.Friends_PanelList[id]) then
		local pnl = aphone.Friends_PanelList[id].like_count
		pnl:SetText(tonumber(pnl:GetText()) + (b and 1 or -1))

		if local_vote then
			local like_logo = aphone.Friends_PanelList[id].like_logo
			like_logo:SetTextColor(!b and aphone:Color("Black1") or red)
		end
	end
end)