include('shared.lua')   
include("cf_config.lua")

function ENT:Draw()  
	self:DrawModel()
	
	local dist = self:GetPos():Distance( LocalPlayer():GetPos() )
	if(dist)>700 then return end
	
	local fixedAng = self:GetAngles()
	fixedAng:RotateAroundAxis( self:GetRight(), -90 ) 
	
	local fixedPos = self:GetPos() + self:GetUp()*9 + self:GetRight()*-4 + self:GetForward()*3.7
	cam.Start3D2D(fixedPos, fixedAng, 0.1)
			draw.RoundedBox(4,0,0,170,60, Color(0,0,0,225)) 
			draw.RoundedBoxEx(4,0,0,170,24, Color(255,255,255,25), true,true,false,false) 
			draw.SimpleText( cf.StorageText, "cf_machine_main", 85, 0, Color( 255, 255, 255, 155 ), TEXT_ALIGN_CENTER) 
			draw.SimpleText( cf.StorageDescText, "cf_machine_small", 85, 30, Color( 255, 255, 255, 155 ), TEXT_ALIGN_CENTER) 
	cam.End3D2D()
end  