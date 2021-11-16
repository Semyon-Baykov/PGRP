
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

util.AddNetworkString("BuoyMenu")
util.AddNetworkString("BuoyRet")
util.AddNetworkString("BuoySplash")

function ENT:Initialize()	
	self:PhysicsInit(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()    
	if phys:IsValid() then
		phys:Wake()
	end
	self:SetUseType(SIMPLE_USE)
	

end
	
function ENT:Use(activator, caller)
	if !caller:IsValid() or !caller:IsPlayer() then return end
	net.Start("BuoyMenu")
	net.WriteEntity(self)
	net.Send(caller)
	
end

local function BuoyRet(len, ply)
	local ent = net.ReadEntity()
	if !ent:IsValid() or ent:GetClass() != "ent_buoy" or !ent.IsBuoy.Deployed or ent:GetPos():Distance(ply:GetPos()) > 150 then
		TrueFishNotify(ply, TrueFishLocal("buoy_too_far"))
		return
	end
	
	ent.IsBuoy:Undeploy(ply)
end
net.Receive("BuoyRet", BuoyRet)