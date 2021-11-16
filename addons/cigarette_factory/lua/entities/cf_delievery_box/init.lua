AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')
include('cf_config.lua')

local function SendNotification(ply, notifytype, duration, text)
	net.Start( "cf_notification" )
		net.WriteInt( notifytype, 16 )
		net.WriteInt( duration, 16 )
		net.WriteString( text ) 
	net.Send( ply )
end

util.AddNetworkString( "cf_update_box_info" )
function updateClientInfo(entity)
	cfPlayers = ents.FindInSphere( entity:GetPos(), 800 ) 
	for _, ply in ipairs( cfPlayers ) do
		if(IsValid(ply) and ply:IsPlayer()) then
			net.Start( "cf_update_box_info" )
				net.WriteInt( entity:EntIndex(), 32 ) 
				net.WriteInt( entity.cigsStored, 32 ) 			
			net.Broadcast() 
		end
	end
end

function ENT:Initialize()
	self.Entity:SetModel("models/props_junk/cardboard_box003a.mdl")
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	
	local phys = self:GetPhysicsObject()

	if phys:IsValid() then
		phys:Wake()
	end
	
	self.cigsStored = self.cigsStored or 0
	self.canFill = true
	self.canClick = true
	self.shouldOccur = true
	
	self.takeCigSound = Sound("physics/cardboard/cardboard_box_impact_bullet1.wav")
	self.pickUpSound = Sound("physics/cardboard/cardboard_box_break3.wav")
	
	updateClientInfo(self)
	
end

function ENT:Touch( entity )
	if(!self.canFill) then return end
	if(entity:GetClass()=="cf_cigarette_pack" and self.cigsStored<cf.maxCigsBox) then
		entity:Remove()
		self.cigsStored = math.min(self.cigsStored+1, cf.maxCigsBox)
		updateClientInfo(self)
		self.canFill = false
		self:EmitSound(self.takeCigSound, 60, 100, 1) 
		timer.Simple( 0.05, function() 
			self.canFill = true
		end )
	end
end

function ENT:Think()
	if(self.shouldOccur) then
		updateClientInfo(self)
		self.shouldOccur = false
		timer.Simple( 2, function() 
			if(IsValid(self)) then
				self.shouldOccur = true 
			end
		end )	
	end
end

function ENT:Use( activator, caller )
	if !IsValid( caller ) or !caller:IsPlayer() then return end
	if(!self.canClick) then return end
	
	if(!cf.InstantSellMode) then
		if(caller.cfCigsAmount<=cf.maxCigsOnPlayer and self.cigsStored>0) then
			local difference = cf.maxCigsOnPlayer-caller.cfCigsAmount
			if(difference>=self.cigsStored) then
				caller.cfCigsAmount = caller.cfCigsAmount + self.cigsStored
				SendNotification(caller, 0, 4, cf.Notification3..self.cigsStored..cf.Notification4)
				self:Remove()
			else
				caller.cfCigsAmount = caller.cfCigsAmount + difference
				self.cigsStored = self.cigsStored - difference
				SendNotification(caller, 0, 4, cf.Notification1..cf.maxCigsOnPlayer..cf.Notification2)
			end
			self:EmitSound(self.pickUpSound, 60, 100, 1)  
		end
	else
		if(self.cigsStored>0) then
			caller:addMoney(self.cigsStored*cf.sellPrice)
			SendNotification(caller, 0, 4, cf.SellText1..self.cigsStored..cf.SellText2..self.cigsStored*cf.sellPrice..cf.CurrencyText.."!")
			self:EmitSound(Sound("cigarette_factory/cf_sell.wav"), 80, 100, 1) 
			self:Remove()
		end
	end
	
	self.canClick = false
	updateClientInfo(self)
	
	timer.Simple( 0.3, function() 
		if(!IsValid(self)) then return end
		self.canClick = true
	end )
end
