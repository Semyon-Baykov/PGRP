AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

util.AddNetworkString("APhone_OpenPaint")

function ENT:Initialize()
	self:SetModel("models/humans/group01/female_01.mdl")
	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()
	self:SetNPCState(NPC_STATE_SCRIPT)
	self:SetSolid(SOLID_BBOX)
	self:CapabilitiesAdd(CAP_ANIMATEDFACE + CAP_TURN_HEAD)
	self:SetUseType(SIMPLE_USE)
	self:DropToFloor()

	self:SetMaxYawSpeed(90)
end

function ENT:Use(ply)
	net.Start("APhone_OpenPaint")
	net.Send(ply)
end