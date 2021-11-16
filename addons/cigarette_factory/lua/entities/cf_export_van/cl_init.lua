include('shared.lua')   

local function DrawInfo(ent)
	ent.sellingPrice = ent.sellingPrice or cf.sellPrice
	draw.RoundedBox(4,0,0,200,58, Color(0,0,0,225)) 
	draw.RoundedBoxEx(4,0,0,200,24, Color(255,255,255,10), true,true,false,false) 
	draw.SimpleText( cf.VanText, "cf_machine_main", 100, 0, Color( 255, 255, 255, 155 ), TEXT_ALIGN_CENTER) 
	draw.SimpleText( cf.VanDescText1..ent.sellingPrice..cf.CurrencyText..cf.VanDescText2, "cf_machine_small", 100, 30, Color( 255, 255, 255, 155 ), TEXT_ALIGN_CENTER) 
end

function ENT:Draw()  
	self:DrawModel()
	
	local fixedAng = self:GetAngles()
	fixedAng:RotateAroundAxis( self:GetRight(), -90 ) 
	fixedAng:RotateAroundAxis( self:GetForward(), 90 ) 
	
	local fixedPos = self:GetPos() + self:GetUp()*60 + self:GetRight()*20 + self:GetForward()*46
	cam.Start3D2D(fixedPos, fixedAng, 0.26)
		DrawInfo(self)
	cam.End3D2D()
	
	local fixedAng = self:GetAngles()
	fixedAng:RotateAroundAxis( self:GetRight(), 90 ) 
	fixedAng:RotateAroundAxis( self:GetForward(), 90 ) 
	
	local fixedPos = self:GetPos() + self:GetUp()*60 + self:GetRight()*-32 + self:GetForward()*-46
	cam.Start3D2D(fixedPos, fixedAng, 0.26)
		DrawInfo(self)
	cam.End3D2D()
end  