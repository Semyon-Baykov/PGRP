--  _               _            _   ____              _                      _       __  __           _            
-- | |    ___  __ _| | _____  __| | | __ ) _   _      | | ___  ___  ___ _ __ | |__   |  \/  | __ _ ___| |_ ___ _ __ 
-- | |   / _ \/ _` | |/ / _ \/ _` | |  _ \| | | |  _  | |/ _ \/ __|/ _ \ '_ \| '_ \  | |\/| |/ _` / __| __/ _ \ '__|
-- | |__|  __/ (_| |   <  __/ (_| | | |_) | |_| | | |_| | (_) \__ \  __/ |_) | | | | | |  | | (_| \__ \ ||  __/ |   
-- |_____\___|\__,_|_|\_\___|\__,_| |____/ \__, |  \___/ \___/|___/\___| .__/|_| |_| |_|  |_|\__,_|___/\__\___|_|   
--                                          |___/                      |_|                                          
include("shared.lua");

surface.CreateFont("methFont", {
	font = "Arial",
	size = 30,
	weight = 600,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
});


function ENT:Initialize()	

end;

function ENT:Draw()
	self:DrawModel();
	
	local pos = self:GetPos()
	local ang = self:GetAngles()
	local redpColor = Color(175, 0, 0, 255);
	local ciodineColor = Color(220, 134, 159, 255);
	
	local potTime = "Время: "..self:GetNWInt("time").."s";
	
	if (self:GetNWInt("status") == "inprogress") then
		potTime = "Время: "..self:GetNWInt("time").."s";
	elseif (self:GetNWInt("status") == "ready") then	
		potTime = "Готово! Нажмите Е.";
	end;
	ang:RotateAroundAxis(ang:Up(), 90);
	ang:RotateAroundAxis(ang:Forward(), 90);	
	if LocalPlayer():GetPos():Distance(self:GetPos()) < self:GetNWInt("distance") then
		cam.Start3D2D(pos + ang:Up()*8, ang, 0.10)
			surface.SetDrawColor(Color(0, 0, 0, 200));
			surface.DrawRect(-64, -38, 128, 96);		
		cam.End3D2D();
		cam.Start3D2D(pos + ang:Up()*8, ang, 0.055)
			draw.SimpleTextOutlined("Кристальный мет", "methFont", 0, -56, Color(1, 241, 249, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(25, 25, 25, 100));
			draw.SimpleTextOutlined("______________", "methFont", 0, -54, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(25, 25, 25, 100));

			surface.SetDrawColor(Color(0, 0, 0, 200));
			surface.DrawRect(-104, -32, 204, 24);			
			surface.SetDrawColor(Color(1, 201, 209, 255));
			surface.DrawRect(-101.5, -30, math.Round((self:GetNWInt("time")*198)/self:GetNWInt("maxTime")), 20);		
			
			draw.SimpleTextOutlined("Ингредиенты", "methFont", -101, 8, Color(1, 241, 249, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(25, 25, 25, 100));
			draw.SimpleTextOutlined("______________", "methFont", 0, 10, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(25, 25, 25, 100));

			if (self:GetNWInt("redp")==0) then
				redpColor = Color(100, 100, 100, 255);
			else
				redpColor = Color(175, 0, 0, 255);
			end;
			
			if (self:GetNWInt("ciodine")==0) then
				ciodineColor = Color(100, 100, 100, 255);
			else
				ciodineColor = Color(220, 134, 159, 255);
			end;							
		cam.End3D2D();	
		cam.Start3D2D(pos + ang:Up()*8, ang, 0.040)		
			draw.SimpleTextOutlined("Красный Фосфор ("..self:GetNWInt("redp")..")", "methFont", -138, 50, redpColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(25, 25, 25, 100));
			draw.SimpleTextOutlined("Кристаллизованный йод ("..self:GetNWInt("ciodine")..")", "methFont", -138, 80, ciodineColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(25, 25, 25, 100));		
		cam.End3D2D();			
		cam.Start3D2D(pos + ang:Up()*8, ang, 0.035)		
			draw.SimpleTextOutlined(potTime, "methFont", -152, -32, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(25, 25, 25, 100));		
		cam.End3D2D();		
		
	end;
end;

