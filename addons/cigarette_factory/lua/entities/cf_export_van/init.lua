AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

local function SendNotification(ply, notifytype, duration, text)
	net.Start( "cf_notification" )
		net.WriteInt( notifytype, 16 )
		net.WriteInt( duration, 16 )
		net.WriteString( text ) 
	net.Send( ply )
end

local function SetPrice(ent)
	ent.sellingPrice = cf.sellPrice + math.random(-cf.maxPriceDifference, cf.maxPriceDifference)
end

util.AddNetworkString( "cf_update_van_info" )
function updateInfo(entity)
	if(!IsValid(entity)) then return end
	net.Start( "cf_update_van_info" )
		net.WriteInt( entity:EntIndex(), 32 ) 
		net.WriteInt( entity.sellingPrice, 32 ) 			
	net.Broadcast() 
end

function ENT:Initialize()
	self.Entity:SetModel("models/props/cs_militia/van.mdl")
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	
	local phys = self:GetPhysicsObject()

	if phys:IsValid() then
		phys:Wake()
	end
	
	self.sellingPrice = cf.sellPrice
	
	self.canClick = true
	self.shouldOccur = true
	
    local Glass = ents.Create( "prop_dynamic" )
    Glass:SetModel( "models/props/cs_militia/van_glass.mdl" )
    Glass:SetPos( self:GetPos() )
    Glass:SetAngles( self:GetAngles() )
    Glass:SetParent( self )
    self:DeleteOnRemove( Glass )
    Glass:Spawn( )
	
	updateInfo(self)
	
	self.SellSound = Sound("cigarette_factory/cf_sell.wav")
end


function ENT:Use( activator, caller )
	if !IsValid( caller ) or !caller:IsPlayer() then return end
	if(!self.canClick or caller.cfCigsAmount==0) then return end
	
	caller:addMoney(caller.cfCigsAmount*self.sellingPrice)
	SendNotification(caller, 0, 4, cf.SellText1..caller.cfCigsAmount..cf.SellText2..caller.cfCigsAmount*self.sellingPrice..cf.CurrencyText.."!")
	caller.cfCigsAmount = 0
	self:EmitSound(self.SellSound, 80, 100, 1) 
	
	self.canClick = false
	
	timer.Simple( 0.1, function() 
		if(!IsValid(self)) then return end
		self.canClick = true
	end )
end

function ENT:Think()
	if(self.shouldOccur) then
		self.shouldOccur = false
		timer.Simple( cf.priceChangeTime, function() 
			if(IsValid(self)) then
				self.shouldOccur = true 
				SetPrice(self)
				updateInfo(self)
			end
		end )	
	end
end