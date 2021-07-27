if SCB_LOADED then return end

local scb = scb

local PLAYER = FindMetaTable("Player")
function PLAYER:IsTyping()
	return self:GetNWBool("SCB.IsTyping", false)
end

function PLAYER:SCB_GetTag()
	local tags = scb.tags
	return tags[self:SteamID()] or tags[self:SteamID64()] or tags[self:GetUserGroup()] or false
end

local permissions = scb.config.permissions
function scb.has_permission(ply, permission)
	if not IsValid(ply) then return true end

	permission = permissions[permission]
	return permission[1] or permission[ply:GetUserGroup()] or permission[ply:SteamID()] or permission[ply:SteamID64()]
end