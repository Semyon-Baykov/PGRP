module( 'gp_mp', package.seeall )

local meta = FindMetaTable( 'Entity' )

util.AddNetworkString( 'gp_mp' )
util.AddNetworkString( 'gp_mp.unarrest' )
util.AddNetworkString( 'gp_mp.fix' )

function meta:UpdateInfo()

	self:SetNWString( 'gp_mp.info', util.TableToJSON( self.info ) )

end

function meta:Initialize_sv()

	self.info = self.info or {}
	self.info.cash = self.info.cash or 0
	self.info.arrested = self.info.arrested or false
	self.info.tier = self.info.tier or 1
	self.info.stopped = self.info.stopped or false
	self.info.broken = self.info.broken or false
	if self:Getowning_ent() != NULL then
        self.info.owner = self:Getowning_ent()
    end
	self:UpdateInfo()

end

function meta:SetCash( num )

	self.info.cash = num
	self:UpdateInfo()

end

function meta:UpdateTier( ply,tiers )

	if ply:GetPos():Distance( self:GetPos() ) > 70 then
		return
	end

	local tier = self.info.tier

	if tier >= 3 then return end
	if tiers > 3 then return end

	if not ply:canAfford( tbl[tiers].price ) then
		return
	end
	ply:addMoney( -tbl[tiers].price )
	self.info.tier = tiers
	self:UpdateInfo()
	DarkRP.notify( ply, 2, 4, 'Вы заплатили '..DarkRP.formatMoney( tbl[tiers].price )..' за улучшение денежного принтера!' )

end

local function calc_volume( tier )

	return tier == 1 and 75 or tier == 2 and 65 or tier == 3 and 55

end

local function calc_speed( tier )

	return tier == 1 and 35 or tier == 2 and 25 or tier == 3 and 15 

end

function meta:PrintingSound()

	local tier = self.info.tier

	self.sound = CreateSound( self, Sound( 'ambient/levels/labs/equipment_printer_loop1.wav' ) )
	self.sound:SetSoundLevel( calc_volume( tier ) )
	self.sound:PlayEx( 1, 50*tier )

end

function meta:BrokePrinter()

	if self.info.broken then
		return
	end

	if self:Getowning_ent() then
		DarkRP.notify( self:Getowning_ent(), 1, 4, 'Один из ваших денежных принтеров сломался!' )
	end
	self.info.broken = true
	self:UpdateInfo()

end

function meta:FixPrinter( ply )

	if self.info.broken then	
		if not ply:canAfford( 100 ) then
			return
		end
		ply:addMoney( -100 )
		self.info.broken = false
		self:UpdateInfo()
	end

end


function meta:StartPrint()

	if self.info.printing then
		return
	end
	if self.info.fired then
		return
	end
	if self.info.arrested then
		return
	end
	if self.info.broken then
		return
	end

	if self.info.stopped then
		self.info.stopped = false
		self:UpdateInfo()
	end


	local tier = self.info.tier
	local time = calc_speed( tier )

	
	self.info.printing = true
	self.info.time = time
	self:UpdateInfo()
	timer.Simple(1,function() self:PrintingSound() end)
	timer.Create( self:EntIndex()..'_timer', 1, time, function()

		self:SetNWInt( 'gp_mp.time', self:GetNWInt( 'gp_mp.time', 0 ) + 1 )

	end )
	self:ResetSequence(1)
	timer.Simple( time, function()
		if self:IsValid() and not self.fired == true and not self.arrested == true then
			self:ResetSequence(0)
			timer.Remove( self:EntIndex()..'_timer' )
			self:SetNWInt( 'gp_mp.time', 0 )
			self.info.printing = false
			self:UpdateInfo()
			if self.sound then
				self.sound:Stop()
				self.sound = nil
			end
			self:EmitSound( 'items/ammocrate_open.wav' , 75, 100, 1 )
			self:SetCash( self:GetCash()+500 )
			local rand =  math.random( 1, 9*(tier/1.5) )
			if rand == 1 then
				self:BrokePrinter()
				return
			end
			if self.info.stopped == false then
				self:StartPrint()
			end
		end

	end )

end

function meta:StopPrint( ply )

	if ply:GetPos():Distance( self:GetPos() ) > 70 then
		return
	end

	if self.info.stopped == false then
		self.info.stopped = true
		self:UpdateInfo()
		self:EmitSound( 'buttons/weapon_cant_buy.wav' , 75, 100, 1 )
	end

end

function meta:boom_mp()
	
	local vPoint = self:GetPos()
    local effectdata = EffectData()
    effectdata:SetStart( vPoint )
    effectdata:SetOrigin( vPoint )
    effectdata:SetScale( 1 )
    util.Effect( 'Explosion', effectdata )
    for k,v in pairs( ents.FindInSphere(self:GetPos(), 100 ) ) do
    	if v:GetClass() == 'money_printer2' then
    		v:Fire_mp()
    	end
    end
end

function meta:Fire_mp()

	if self.info.fired == true then return end

	self:Ignite( 15, 15 )
	self.info.fired = true
	timer.Simple( 15, function()

		if self:IsValid() then
		   	self:Remove()
		   	if self.info.cash > 0 then
		   		local MoneyPos = self:GetPos()
		   		DarkRP.createMoneyBag(Vector(MoneyPos.x + 15, MoneyPos.y, MoneyPos.z + 15), self.info.cash)
		   		self.info.cash = 0
		   	end
		   	self:boom_mp()
		end

	end )

end

function meta:CashOut( ply )

	if ply:GetPos():Distance( self:GetPos() ) > 70 then
		return
	end
	
	if self.info.arrested then
		return
	end

	if self.info.cash == 0 then return end

	ply:addMoney( self.info.cash )
	DarkRP.notify( ply, 2, 4, 'Вы собрали '..DarkRP.formatMoney( self:GetCash() )..' с денежного принтера!' )
	self:SetCash( 0 )
	self:EmitSound( 'items/ammocrate_close.wav' , 75, 100, 1 )

end

function meta:Arrest_mp()

	if self.info.arrested then 
		return 
	end

	if self.sound then
		self.sound:Stop()
		self.sound = nil
	end

	self.info.arrested = true
	self.info.printing = false
	self:UpdateInfo()

end
local function unarrest_cl( time, ply, ent )

	net.Start( 'gp_mp.unarrest' )
		net.WriteInt( time, 16 )
		net.WriteEntity( ent )
	net.Send( ply )

end
function meta:UnArrest_mp( ply )

	if not self.info.arrested then 
		return 
	end
	if self.CanUnArrest then
		return
	end
	
	if ply:GetPos():Distance( self:GetPos() ) > 70 then
		return
	end

	unarrest_cl(7, ply, self)
	timer.Simple( 7, function()
		if ply:GetPos():Distance( self:GetPos() ) > 70 then
			return
		end
		if ply:GetEyeTrace().Entity != self then
			return
		end
		self.info.arrested = false
		self:UpdateInfo()
	end )

end



function meta:OpenMenu( ply )
	
	if ply:GetPos():Distance( self:GetPos() ) > 70 then
		return
	end
	
	if self.info.arrested then
		return
	end

	net.Start( 'gp_mp' )
		net.WriteEntity( self )
	net.Send( ply )	

end


net.Receive( 'gp_mp', function( _, ply )



	local event = net.ReadString()
	local ent = net.ReadEntity()
	local tier = net.ReadInt( 3 )

	if ply:GetPos():Distance( ent:GetPos() ) > 70 then
		return
	end

	if event == 'withdraw' then
		ent:CashOut(ply)
	elseif event == 'startstop' then
		if ent.info.printing == true then
			ent:StopPrint( ply )
		else
			ent:StartPrint()
		end
	elseif event == 'upg' then
		ent:UpdateTier( ply, tier )
	end

end )

net.Receive( 'gp_mp.fix', function( _, ply )

	local ent = net.ReadEntity()

	ent:FixPrinter( ply )	

end )

hook.Add( 'PlayerDisconnected', 'gpmp_fix', function( ply )

	for k,v in pairs( ents.FindByClass( 'money_printer2' ) ) do
		if v:Getowning_ent() == ply then
			v:Remove()
		end
	end

end )