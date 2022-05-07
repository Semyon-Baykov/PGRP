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

	
	ang:RotateAroundAxis(ang:Up(), 90);
	ang:RotateAroundAxis(ang:Forward(), 90);	
	if LocalPlayer():GetPos():Distance(self:GetPos()) < self:GetNWInt("distance") then
		cam.Start3D2D(pos + ang:Up(), Angle(0, LocalPlayer():EyeAngles().y-90, 90), 0.125)
				if !self:GetNWBool("salesman") then
					draw.SimpleTextOutlined((self:GetNWInt("value")*self:GetNWInt("valueMod")).."$", "methFont", 8, -98, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(25, 25, 25, 100));
				else
					draw.SimpleTextOutlined("Возьми мет и отнеси скупщику!", "methFont", 8, -98, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(25, 25, 25, 100));
				end;
		cam.End3D2D()		
		cam.Start3D2D(pos + ang:Up(), Angle(0, LocalPlayer():EyeAngles().y-90, 90), 0.1)
				draw.SimpleTextOutlined("Кристальный мет ("..self:GetNWInt("amount").." lbs)", "methFont", 8, -96, Color(1, 241, 249, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(25, 25, 25, 100));
		cam.End3D2D();
	end;
end;

-- maxAmount = 60
-- amount = x

