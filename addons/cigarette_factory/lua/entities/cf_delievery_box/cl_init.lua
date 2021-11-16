include('shared.lua') 
include('cf_config.lua') 

function ENT:Draw()  
	self:DrawModel()
	
	local dist = self:GetPos():Distance( LocalPlayer():GetPos() )
	if(dist)>700 then return end
	
	local fixedAng = self:GetAngles()
	fixedAng:RotateAroundAxis( self:GetUp(), 90 ) 
	
	self.cigsStored = (self.cigsStored!=nil and self.cigsStored or "unknown")
	local fixedPos = self:GetPos() + self:GetUp()*4.6 + self:GetRight()*8.5 + self:GetForward()*-1
	cam.Start3D2D(fixedPos, fixedAng, 0.1)
			draw.RoundedBox(4,0,0,200,(self.cigsStored!="unknown" and 100 or 62), Color(0,0,0,225)) 
			draw.RoundedBoxEx(4,0,0,200,24, Color(255,255,255,25), true,true,false,false) 
			draw.SimpleText( cf.BoxText, "cf_machine_main", 100, 0, Color( 255, 255, 255, 155 ), TEXT_ALIGN_CENTER) 
			draw.SimpleText( cf.BoxDescText1, "cf_machine_small", 100, 26, Color( 255, 255, 255, 155 ), TEXT_ALIGN_CENTER) 
			draw.SimpleText( cf.BoxDescText2, "cf_machine_small", 100, 42, Color( 255, 255, 255, 155 ), TEXT_ALIGN_CENTER) 
			if(self.cigsStored!="unknown") then
				draw.SimpleText( cf.BoxDescText3..self.cigsStored.."/"..math.max(cf.maxCigsBox, self.cigsStored), "cf_machine_main", 100, 60, Color( 255, 255, 255, 155 ), TEXT_ALIGN_CENTER) 
				draw.SimpleText( cf.BoxDescText4..self.cigsStored*cf.sellPrice..cf.CurrencyText, "cf_machine_small", 100, 80, Color( 255, 255, 255, 155 ), TEXT_ALIGN_CENTER) 
			end
	cam.End3D2D()
end  