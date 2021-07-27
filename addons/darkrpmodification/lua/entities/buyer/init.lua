AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')
include('shared.lua')
util.AddNetworkString('GPoratlRP_OpenMenuMining')
util.AddNetworkString('GPoratlRP_SellAll')

local rockprice = 50
local ironprice = 500
local goldprice = 1000


 function ENT:Initialize()
	self:SetModel('models/Humans/Group02/Male_05.mdl')
	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()
	self:SetNPCState(NPC_STATE_SCRIPT)
	self:SetSolid(SOLID_BBOX)
	self:SetUseType(SIMPLE_USE)
	self:SetBloodColor(BLOOD_COLOR_RED)
	self:SetNWInt("distance", 500)
	

end;

function ENT:AcceptInput(name, activator, caller)	
	
	net.Start('GPoratlRP_OpenMenuMining')
		
	net.Send(caller)	

end

net.Receive('GPoratlRP_SellAll',function(_,ply)

	local golds, uran, rock = ply:GetNWInt( 'gp_mining_'..1 ), ply:GetNWInt( 'gp_mining_'..2 ), ply:GetNWInt( 'gp_mining_'..3 )

	if rock > 0 then
		local s = gp_mining.tbl[3].price*rock
		ply:addMoney(s)
		ply:SetNWInt( 'gp_mining_'..3, 0 )
		ply:ChatAddText(Color( 255, 196, 0 ), '[GPRP Mine] ', Color(255, 255, 255), 'Вы продали весь камень и получили '..DarkRP.formatMoney(s))
	end
	if golds > 0 then
		local s = gp_mining.tbl[1].price*golds
		ply:addMoney(s)
		ply:SetNWInt( 'gp_mining_'..1, 0 )
		ply:ChatAddText(Color( 255, 196, 0 ), '[GPRP Mine] ', Color(255, 255, 255), 'Вы продали всю золотую руду и получили '..DarkRP.formatMoney(s))
	end
	if uran > 0 then
		local s = gp_mining.tbl[2].price*uran
		ply:addMoney(s)
		ply:SetNWInt( 'gp_mining_'..2, 0 )
		ply:ChatAddText(Color( 255, 196, 0 ), '[GPRP Mine] ', Color(255, 255, 255), 'Вы продали весь уран и получили '..DarkRP.formatMoney(s))
	end

end)