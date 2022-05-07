resource.AddFile("materials/newcity/empty_space.png")

resource.AddFile("models/props_unique/atm01.mdl")
resource.AddSingleFile("models/props_unique/atm01.dx80.vtx")
resource.AddSingleFile("models/props_unique/atm01.dx90.vtx")
resource.AddSingleFile("models/props_unique/atm01.mdl")
resource.AddSingleFile("models/props_unique/atm01.phy")
resource.AddSingleFile("models/props_unique/atm01.vtx")
resource.AddSingleFile("models/props_unique/atm01.vvt")

resource.AddFile("materials/models/props_unique/atm.vmt")
resource.AddSingleFile("materials/models/props_unique/atm.vmt")
resource.AddSingleFile("materials/models/props_unique/atm.vtf")
resource.AddSingleFile("materials/models/props_unique/atm_ref.vtf")
resource.AddSingleFile("materials/newcity/empty_space.png")

BraxBank = {}

file.CreateDir("braxnet")
file.CreateDir("braxnet/atm")
file.CreateDir("braxnet/atm/players")
file.CreateDir("braxnet/atm/maps")

CreateConVar("braxnet_atm_startmoney", 0, {FCVAR_ARCHIVE, FCVAR_PROTECTED, FCVAR_SERVER_CAN_EXECUTE}, "User start money")
CreateConVar("braxnet_atm_map", "", {FCVAR_ARCHIVE, FCVAR_PROTECTED, FCVAR_SERVER_CAN_EXECUTE}, "If not blank, it uses this text file coordinates.")
CreateConVar("braxnet_atm_salary", 0, {FCVAR_ARCHIVE, FCVAR_PROTECTED, FCVAR_SERVER_CAN_EXECUTE}, "Payday goes straight into bank account.")
CreateConVar("braxnet_atm_exploitban", 1, {FCVAR_ARCHIVE, FCVAR_PROTECTED, FCVAR_SERVER_CAN_EXECUTE}, "Ban players who try to exploit.")

local map = GetConVarString("braxnet_atm_map") or game.GetMap()

-- Helper functions

function BraxBank.CreateAccount(ply)
	if not file.Exists("braxnet/atm/players/"..ply:UniqueID()..".txt", "DATA") then
		file.Write("braxnet/atm/players/"..ply:UniqueID()..".txt", GetConVarNumber("braxnet_atm_startmoney"))
	end
end

function BraxBank.PlayerMoney(ply)
	if file.Exists("braxnet/atm/players/"..ply:UniqueID()..".txt", "DATA") then
		return tonumber(file.Read("braxnet/atm/players/"..ply:UniqueID()..".txt","DATA"))
	else
		print("Could not find bank for "..ply:Nick())
		BraxBank.CreateAccount(ply)
		return BraxBank.PlayerMoney(ply)
	end
end

function BraxBank.UpdateMoney(ply, amount)
	if file.Exists("braxnet/atm/players/"..ply:UniqueID()..".txt", "DATA") then
		file.Write("braxnet/atm/players/"..ply:UniqueID()..".txt", amount)
	else
		print("Could not find bank for "..ply:Nick())
		BraxBank.CreateAccount(ply)
		BraxBank.UpdateMoney(ply, amount)
	end
end

function BraxBank.TakeAction(ply)
	if GetConVar("braxnet_atm_exploitban"):GetInt() == 0 then
		MsgC(Color(255,0,0), ply:Name().." tried to exploit an ATM!\n")
		return 
	end
	ply:Ban(1440, "[BraxATM] Exploit") 
	ply:Kick("[BraxATM] Exploit")
end

function SaveATMs()
	local atm = ents.FindByClass("brax_atm")
	local cdata = {}
	for k, v in pairs(atm) do
			local vdata = {}
			vdata.Pos = v:GetPos()
			vdata.Ang = v:GetAngles()
			table.insert(cdata, vdata)
	end
	local sdata = util.TableToJSON(cdata)
	file.Write("braxnet/atm/maps/"..map..".txt", sdata)
end

function LoadATMs()
	if not file.Exists("braxnet/atm/maps/"..map..".txt", "DATA") then return end
	local atm = util.JSONToTable(file.Read("braxnet/atm/maps/"..map..".txt"))
	
	for k, v in pairs(atm) do
		local c = ents.Create("brax_atm")
		c:SetPos(v.Pos)
		c:SetAngles(v.Ang)
		c:Spawn()
		c:Activate()
		c:GetPhysicsObject():EnableMotion(false)
	end

end

hook.Add("InitPostEntity", "BraxHookATMSpawn", LoadATMs)

concommand.Add( "braxnet_atm_save", function(p,c,a)
	if not p:IsSuperAdmin() then return end
	SaveATMs()
	p:PrintMessage(HUD_PRINTTALK,"ATM's saved to file")
end)

--[[
	Return codes!!
	1 = NULL
	2 = Deposit, bank does not have money
	3 = Deposit, ok
	4 = Insert, User does not have enough money
	5 = Insert, ok
]]--

-- TAKE MONEY
util.AddNetworkString( "BraxAtmWithdraw" )
net.Receive( "BraxAtmWithdraw", function( length, client )
	
	local WithdrawValue = net.ReadInt(32)
	local UserMoney = BraxBank.PlayerMoney(client)
	
	-- do some simple cheat checks
	local atmcheck = false
	for _,v in pairs(ents.FindByClass("brax_atm")) do
		if IsValid(v) and v:GetClass() == "brax_atm" and v:GetPos():Distance(client:GetShootPos()) < 256 then atmcheck = true end
	end
	if atmcheck == false then BraxBank.TakeAction(client) return end
	if WithdrawValue <= 0 then BraxBank.TakeAction(client) return end
	
	
	if WithdrawValue > UserMoney then
		BraxBankAtmReturnCode(2, client)
		return
	end
	
	local NewVal = UserMoney-WithdrawValue
	
	BraxBank.UpdateMoney(client, NewVal)
	client:addMoney(WithdrawValue)
	--BraxBankAtmUpdate(NewVal, client)
	BraxBankAtmReturnCode(3, client)
end )

-- INSERT MONEY
util.AddNetworkString( "BraxAtmDeposit" )
net.Receive( "BraxAtmDeposit", function( length, client )
	
	local DepositValue = net.ReadInt(32)
	local UserMoney = BraxBank.PlayerMoney(client)
	
	-- do some simple cheat checks
	local atmcheck = false
	for _,v in pairs(ents.FindByClass("brax_atm")) do
		if IsValid(v) and v:GetClass() == "brax_atm" and v:GetPos():Distance(client:GetShootPos()) < 256 then atmcheck = true end
	end
	if atmcheck == false then BraxBank.TakeAction(client) return end
	if DepositValue <= 0 then BraxBank.TakeAction(client) return end
	
	
	if DepositValue > client:getDarkRPVar("money") then
		BraxBankAtmReturnCode(4, client)
		return
	end
	
	local NewVal = UserMoney + DepositValue
	
	BraxBank.UpdateMoney(client, NewVal)	
	client:addMoney(-DepositValue)
	BraxBankAtmReturnCode(5, client)
end )

function BraxBankAtmUpdate(client)
	-- update their displayed money
	BraxBank.CreateAccount(client)
	local m = BraxBank.PlayerMoney(client)

	net.Start( "BraxAtmFetch" )
		net.WriteInt(m, 32)
	net.Send(client)
end

util.AddNetworkString( "BraxAtmReturnCode" )
function BraxBankAtmReturnCode(code, client)
	-- update their displayed money
	net.Start( "BraxAtmReturnCode" )
		net.WriteInt(code, 32)
	net.Send(client)
end

concommand.Add("brax_atm_update", function(p, c, a)
	BraxBankAtmUpdate(p)
end)

util.AddNetworkString( "BraxAtmFetch" )

hook.Add("playerGetSalary","BraxAtmSalary", function(ply, amount)
	if GetConVar("braxnet_atm_salary"):GetInt() > 0 then
		local money = BraxBank.PlayerMoney(ply)
		BraxBank.UpdateMoney(ply, money+amount)
		return false, "Payday! "..DarkRP.formatMoney(amount).." was put in your bank account.", 0
	end
end)