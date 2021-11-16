AddCSLuaFile( "cf_config.lua" )
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')
include( "cf_config.lua" )

util.AddNetworkString( "cf_update_machine_info" )
function updateClientSide(entity)
	cfPlayers = ents.FindInSphere( entity:GetPos(), 800 ) 
	for _, ply in ipairs( cfPlayers ) do
		if(IsValid(ply) and ply:IsPlayer()) then
			net.Start( "cf_update_machine_info" )
				net.WriteInt( entity:EntIndex(), 32 ) 
				net.WriteInt( entity.productionTime, 32 ) 
				net.WriteInt( entity.tobaccoAmount, 32 ) 
				net.WriteInt( entity.paperAmount, 32 ) 
				net.WriteInt( entity.machineHealth, 32 ) 
				net.WriteBool( entity.switchedOn )
				net.WriteBool( entity.storageUpgrade ) 		
				net.WriteBool( entity.engineUpgrade ) 					
			net.Send( ply )
		end
	end

end

function ENT:Initialize()
	self.Entity:SetModel("models/cigarette_factory/cf_machine.mdl")
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	
	local phys = self:GetPhysicsObject()

	if phys:IsValid() then
		phys:Wake()
	end
	
	local Ang = self:GetAngles()
	Ang:RotateAroundAxis( self:GetUp(), 180 ) 
	self:SetAngles(Ang)
	
	self.switchedOn = false
	self.productionTime = 0
	self.tobaccoAmount = self.tobaccoAmount or 0
	self.paperAmount = self.paperAmount or 0
	self.storageUpgrade = self.storageUpgrade or false
	self.engineUpgrade = self.engineUpgrade or false
	
	self.shouldOccur = true
	self.canClick = true
	self.canFill = true
	
	self.machineHealth = cf.maxMachineHealth
	
	self.EjectSound = Sound("cigarette_factory/cf_machine_eject.wav")
	self.ClickSound = Sound("buttons/lever8.wav")
	self.TakeSound = Sound("npc/turret_floor/deploy.wav")
	self.LoopSound = CreateSound(self, "cigarette_factory/cf_machine_loop.wav")
	
	updateClientSide(self)
end

function ENT:OnTakeDamage( damage ) 
	self.machineHealth = self.machineHealth - damage:GetDamage()
	if(self.machineHealth<=0) then
		self.LoopSound:Stop()
		local explode = ents.Create( "env_explosion" )
		explode:SetPos( self:GetPos() )
		explode:Spawn()
		explode:SetKeyValue( "iMagnitude", "3" ) 
		explode:Fire( "Explode", 0, 0 )
		self:Remove()
	end
	updateClientSide(self)
end

function ENT:Use( activator, caller )
	if(!self.canClick) then return end
	self.canClick = false
	
	timer.Simple( 0.3, function() 
		if(!IsValid(self)) then return end
		self.canClick = true
	end )
	
	if(self.switchedOn) then 
		self.switchedOn = false
		self.LoopSound:Stop()
		self.productionTime = 0
		self:EmitSound(self.ClickSound, 80, 100, 1) 
	else if(self.paperAmount>=cf.paperProductionCost and self.tobaccoAmount>=cf.tobaccoProductionCost) then 
		self.switchedOn = true 
		self.LoopSound:Play()
		self:EmitSound(self.ClickSound, 80, 100, 1) 
		end
	end
	updateClientSide(self)
end

function ENT:OnRemove()
	self.LoopSound:Stop()
end

function ENT:Think()
	if(self.shouldOccur) then
		self.shouldOccur = false
		---
		
		if(self.machineHealth>0) then self.machineHealth = math.min(self.machineHealth + cf.machineRegen, cf.maxMachineHealth) end
		
		if(self.paperAmount<cf.paperProductionCost or self.tobaccoAmount<cf.tobaccoProductionCost) then self.switchedOn = false end
		
		if(self.switchedOn) then
			self.productionTime = self.productionTime + 1
			self.LoopSound:Play()
		else
			self.productionTime = 0
			self.LoopSound:Stop()
		end
		
		if(self.productionTime>=math.ceil(cf.timeToProduce/(self.engineUpgrade and cf.engineUpgradeBoost or 1))) then
			self.tobaccoAmount = math.max(self.tobaccoAmount-cf.tobaccoProductionCost, 0)
			self.paperAmount = math.max(self.paperAmount-cf.paperProductionCost, 0)
			self.productionTime = 0
		
			local fixedAng = self:GetAngles()
			local fixedPos = self:GetPos() + self:GetUp()*9 + self:GetRight()*-33 + self:GetForward()*-6
			fixedAng:RotateAroundAxis( self:GetUp(), 90 ) 
			fixedAng:RotateAroundAxis( self:GetRight(), 90 ) 
			
			CigPack=ents.Create("cf_cigarette_pack")
			CigPack:SetPos(fixedPos)
			CigPack:SetAngles(fixedAng)
			CigPack:SetVelocity(fixedPos)
			CigPack:Spawn()
			self:EmitSound(self.EjectSound, 60, 200, 1) 
			-- self.LoopSound:Stop()
			-- self.LoopSound:Play()
		end
		updateClientSide(self)
		---
		timer.Simple( 1, function() 
			if(IsValid(self)) then
				self.shouldOccur = true 
			end
		end )	
	end
end


local function CreateFillTimer(ent)
	timer.Simple( 0.2, function() 
		if(!IsValid(ent)) then return end	
		ent.canFill = true
	end )
end

function ENT:Touch( entity )
	if(!self.canFill) then return end
	if(entity:GetClass()=="cf_tobacco_pack" and self.tobaccoAmount<cf.maxTobaccoStorage + (self.storageUpgrade and cf.storageUpgradeBoostTobacco or 0)) then
		entity:Remove()
		self.tobaccoAmount = math.min(self.tobaccoAmount+750,cf.maxTobaccoStorage + (self.storageUpgrade and cf.storageUpgradeBoostTobacco or 0))
		updateClientSide(self)
		self.canFill = false
		CreateFillTimer(self)
		self:EmitSound(self.TakeSound, 60, 100, 1) 
		hook.Call( "CF_MachineRefill", nil, self, entity )
	end
	
	if(entity:GetClass()=="cf_roll_paper" and self.paperAmount<cf.maxPaperStorage + (self.storageUpgrade and cf.storageUpgradeBoostPaper or 0)) then
		entity:Remove()
		self.paperAmount = math.min(self.paperAmount+150,cf.maxPaperStorage + (self.storageUpgrade and cf.storageUpgradeBoostPaper or 0))
		updateClientSide(self)
		self.canFill = false
		CreateFillTimer(self)
		self:EmitSound(self.TakeSound, 60, 100, 1) 
		hook.Call( "CF_MachineRefill", nil, self, entity )
	end
	
	if(entity:GetClass()=="cf_storage_upgrade" and !self.storageUpgrade) then
		entity:Remove()
		self.storageUpgrade = true
		updateClientSide(self)
		self.canFill = false
		CreateFillTimer(self)
		self:EmitSound(self.TakeSound, 60, 100, 1) 
		hook.Call( "CF_MachineUpgrade", nil, self, entity )
	end
	
	if(entity:GetClass()=="cf_engine_upgrade" and !self.engineUpgrade) then
		entity:Remove()
		self.engineUpgrade = true
		self.productionTime = 0
		updateClientSide(self)
		self.canFill = false
		CreateFillTimer(self)
		self:EmitSound(self.TakeSound, 60, 100, 1) 
		hook.Call( "CF_MachineUpgrade", nil, self, entity )
	end
end