util.AddNetworkString("aphone_Phone")

/*
1 = Trying to call,
2 = Accept,
3 = Refuse / Stop Call,
4 = Accept + FaceCam,
*/

// We need it global, so if the server got refreshed, we don't lost traces and soft-lock players
aphone.Call = aphone.Call or {}
aphone.Call.Table = aphone.Call.Table or {}

local function end_call(ply)
	if ply.aphoneCallID then
		local t = aphone.Call.Table[ply.aphoneCallID]

		aphone.Call.Table[ply.aphoneCallID] = nil

		if IsValid(t.ent1) then
			t.ent1.aphone_PVS = nil
			t.ent1.aphoneCallID = nil
		end

		if IsValid(t.ent2) then
			t.ent2.aphone_PVS = nil
			t.ent2.aphoneCallID = nil
		end

		net.Start("aphone_Phone")
			net.WriteUInt(5, 4)
		net.Send({t.ent1, t.ent2})
	end
end

// We want to end_call on the other guy and not the disconnected guy so we don't make end_call more complex than necessary with a lot of IsValid etc...
hook.Add("PlayerDisconnected", "aphone_ResetCall", function(ply)
	end_call(ply)
end)

hook.Add("PlayerCanHearPlayersVoice", "aphone_VoiceManagement", function(l, t)
	if l.aphoneCallID and t.aphoneCallID and l.aphoneCallID == t.aphoneCallID and !aphone.Call.Table[t.aphoneCallID].pending then
		return true
	end
end)

// Add PVS to players so they don't got issues
hook.Add("SetupPlayerVisibility", "aphone_PVSOnFaceCam", function(p)
	if aphone.Call.Table[p.aphoneCallID] then
		local t = aphone.Call.Table[p.aphoneCallID]
		AddOriginToPVS(p == t.ent1 and t.ent2:GetPos() or t.ent1:GetPos())
	end
end)

net.Receive("aphone_Phone", function(_, ply)
	if !aphone.NetCD(ply, "Call", 0.5) then return end
	local id = net.ReadUInt(4)
	local info = aphone.Call.Table[ply.aphoneCallID]

	if id == 1 and !ply.aphoneCallID then
		-- Start call
		local ent = net.ReadEntity()
		if !IsValid(ent) or !ent:IsPlayer() or ent == ply then return end

		if ent.aphoneCallID then
			net.Start("aphone_Phone")
				net.WriteUInt(3, 4)
			net.Send(ply)
			return
		end

		local id_tbl = table.insert(aphone.Call.Table, {
			pending = true,
			ent1 = ply,
			ent2 = ent,
		})
		ply.aphoneCallID = id_tbl
		ent.aphoneCallID = id_tbl

		net.Start("aphone_Phone")
			net.WriteUInt(1, 4)
			net.WriteEntity(ply)
			net.WriteEntity(ent)
			net.WriteBool(false)
		net.Send({ent, ply})

		// Not answering ?
		timer.Create("APhone_CallTimer_" .. ply:UserID(), 30, 1, function()
			if IsValid(ply) and ply.aphoneCallID and aphone.Call.Table[ply.aphoneCallID].pending then
				end_call(ply)
			end
		end)

		hook.Run("aphone_calls", 1, ply, ent)
	elseif id == 2 and info.ent2 == ply then
		-- Accept call
		local idcall = ply.aphoneCallID
		if aphone.Call.Table[idcall].special_call then
			local first_caller = aphone.Call.Table[idcall].ent1
			end_call(ply)

			// Init a new call
			for k, v in pairs(aphone.Call.Table) do
				if IsValid(v.ent1) and v.ent1 == first_caller then
					end_call(v.ent2)
				end
			end

			net.Start("aphone_Phone")
				net.WriteUInt(1, 4)
				net.WriteEntity(ply)
				net.WriteEntity(first_caller)
				net.WriteBool(true)
			net.Send({first_caller, ply})

			idcall = table.insert(aphone.Call.Table, {
				ent1 = first_caller,
				ent2 = ply,
			})
			ply.aphoneCallID = idcall
			first_caller.aphoneCallID = idcall
			hook.Run("aphone_calls", 2, info.ent1, info.ent2)
			timer.Remove("APhone_CallGroup_" .. info.ent1:UserID())

			return
		else
			hook.Run("aphone_calls", 2, info.ent1, info.ent2)

			net.Start("aphone_Phone")
				net.WriteUInt(2, 4)
			net.Send({info.ent1,  info.ent2})

			aphone.Call.Table[info.ent1.aphoneCallID].pending = false
			aphone.Call.Table[info.ent2.aphoneCallID].pending = false
		end

	elseif id == 3 and (info.ent1 == ply or info.ent2 == ply) then
		-- End call
		hook.Run("aphone_calls", 3, info.ent1, info.ent2)
		timer.Remove("APhone_CallTimer_" .. info.ent1:UserID())

		end_call(ply)
	elseif id == 4 then
		-- Facetime
		net.Start("aphone_Phone")
			net.WriteUInt(4, 4)
		net.Send(info.ent1 == ply and info.ent2 or info.ent1)
	end
end)

util.AddNetworkString("aphone_SpecialCall")
net.Receive("aphone_SpecialCall", function(_, ply)
	if !aphone.NetCD(ply, "SpecialCall", aphone.SpecialCallsCooldown or 30) then return end
	local id_tbl = net.ReadUInt(8)

	if !aphone.SpecialCalls[id_tbl] or ply.aphoneCallID then return end

	local valid_ply = {}
	local atleast_one

	for k, v in ipairs(player.GetHumans()) do
		if (aphone.SpecialCalls[id_tbl].teams[v:Team()] or aphone.SpecialCalls[id_tbl].teams[team.GetName(v:Team())]) and !v.aphoneCallID and v != ply then
			table.insert(valid_ply, v)

			// Add into call table
			local call_id = table.insert(aphone.Call.Table, {
				pending = true,
				ent1 = ply,
				ent2 = v,
				special_call = id_tbl,
			})

			ply.aphoneCallID = call_id
			v.aphoneCallID = call_id

			net.Start("aphone_Phone")
				net.WriteUInt(6, 4)
				net.WriteUInt(id_tbl, 8)
			net.Send(v)

			atleast_one = true

			hook.Run("aphone_calls", 1, ply, v)
		end
	end

	if atleast_one then
		net.Start("aphone_Phone")
			net.WriteUInt(6, 4)
			net.WriteUInt(id_tbl, 8)
			net.WriteBool(true)
		net.Send(ply)

		timer.Create("APhone_CallGroup_" .. ply:UserID(), 30, 0, function()
			if IsValid(ply) and ply.aphoneCallID then
				local info = aphone.Call.Table[ply.aphoneCallID]

				if !info or !info.special_call or info.ent1 != ply then return end

				for k, v in pairs(aphone.Call.Table) do
					if IsValid(v.ent1) and v.ent1 == ply then
						end_call(v.ent2)
					end
				end
			end
		end)
	end
end)
