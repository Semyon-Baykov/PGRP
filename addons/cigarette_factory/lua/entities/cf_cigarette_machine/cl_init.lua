include('shared.lua')   
include("cf_config.lua")

local TobaccoTexture = Material("materials/icons/cf_tobacco.png", "smooth")
local PaperTexture = Material("materials/icons/cf_paper.png", "smooth")
local StorageUpgradeTexture = Material("materials/icons/cf_storage_upgrade.png", "smooth")
local EngineUpgradeTexture = Material("materials/icons/cf_engine_upgrade.png", "smooth")

function ENT:Draw()  
	self:DrawModel()
	
	local dist = self:GetPos():Distance( LocalPlayer():GetPos() )
	if(dist)>700 then return end
	
	self.tobaccoAmount = self.tobaccoAmount or 0
	self.paperAmount = self.paperAmount or 0
	self.machineHealth = self.machineHealth or 0
	
	local fixedAng = self:GetAngles()
	fixedAng:RotateAroundAxis( self:GetUp(), -90 ) 
	fixedAng:RotateAroundAxis( self:GetRight(), 56 ) 
	
	local fixedPos = self:GetPos() + self:GetUp()*23.7 + self:GetRight()*-27 + self:GetForward()*-15.2
	cam.Start3D2D(fixedPos, fixedAng, 0.1)
		draw.RoundedBox(1,0,0,234,150, Color(0,0,0,225)) 
		surface.SetDrawColor( Color(255,255,255,15) ) 
		surface.DrawOutlinedRect( 10, 10, 214, 131 ) 
		
		draw.RoundedBox(3,206,54,8,54, Color(255,255,255,15)) 
		
		draw.SimpleText( cf.MachineHealth, "cf_machine_small", 210, 106, Color( 255, 255, 255, 155 ), TEXT_ALIGN_CENTER) 
		draw.RoundedBox(3,207,107-52*(self.machineHealth/cf.maxMachineHealth),6,52*(self.machineHealth/cf.maxMachineHealth), Color(255,255,255,155)) 
		
		if(!self.switchedOn) then
			self.productionProgress = 0
			draw.SimpleText( cf.ProductionOffText, "cf_machine_main", 114, 100, Color( 255, 255, 255, 155 ), TEXT_ALIGN_CENTER) 
		else
			draw.SimpleText( cf.ProducingText, "cf_machine_main", 114, 100, Color( 255, 255, 255, 155 ), TEXT_ALIGN_CENTER) 
			self.productionProgress = self.productionProgress or 0
			self.productionProgress = Lerp(2*FrameTime(), self.productionProgress, self.productionTime)
			draw.RoundedBox(3,22,124,190,6, Color(255,255,255,25)) 
			draw.RoundedBox(3,22,124,(190/(math.ceil(cf.timeToProduce/(self.engineUpgrade and cf.engineUpgradeBoost or 1))-1))*self.productionProgress,6, Color(255,255,255,155)) 
		end
		
		surface.SetDrawColor( self.tobaccoAmount>=cf.tobaccoProductionCost and Color(255,255,255,35) or Color(255,0,0,35) ) 
		surface.SetMaterial( TobaccoTexture )
		surface.DrawTexturedRect( 40, 20, 64, 64 ) 
		surface.SetDrawColor( self.paperAmount>=cf.paperProductionCost and Color(255,255,255,35) or Color(255,0,0,35) ) 
		surface.SetMaterial( PaperTexture )
		surface.DrawTexturedRect( 120, 20, 64, 64 ) 
		
		if(self.tobaccoAmount>=cf.tobaccoProductionCost) then
			draw.SimpleText( self.tobaccoAmount.."/"..cf.maxTobaccoStorage + (self.storageUpgrade and cf.storageUpgradeBoostTobacco or 0), "cf_machine_small", 72, 52, Color( 255, 255, 255, 225 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		else
			draw.SimpleText( cf.RefillNeededText, "cf_machine_small", 72, 52, Color( 255, 80, 80, 155 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)	
		end
		
		if(self.paperAmount>=cf.paperProductionCost) then
			draw.SimpleText( self.paperAmount.."/"..cf.maxPaperStorage + (self.storageUpgrade and cf.storageUpgradeBoostPaper or 0), "cf_machine_small", 152, 52, Color( 255, 255, 255, 225 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		else
			draw.SimpleText( cf.RefillNeededText, "cf_machine_small", 152, 52, Color( 255, 80, 80, 155 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)	
		end
		
		surface.SetDrawColor( self.storageUpgrade and Color(255,255,255,35) or Color(255,255,255,2) ) 
		surface.SetMaterial( StorageUpgradeTexture )
		surface.DrawTexturedRect( 202, 14, 16, 16 ) 

		surface.SetDrawColor( self.engineUpgrade and Color(255,255,255,35) or Color(255,255,255,2) ) 
		surface.SetMaterial( EngineUpgradeTexture )
		surface.DrawTexturedRect( 202, 34, 16, 16 ) 
		
	cam.End3D2D()
end  