AddCSLuaFile()

ENT.Type = "anim"

ENT.PrintName		= "C4"
ENT.Author			= ""
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""
ENT.Category 		= "GPRP"

ENT.AdminSpawnable 	= false
ENT.Spawnable 		= true

if SERVER then
	function ENT:Initialize()
 
		self:SetModel( "models/weapons/w_c4_planted.mdl" )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_NONE )
		self:SetSolid( SOLID_VPHYSICS )
		self.Beep = 0
        local phys = self:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:Wake()
		end

		self:SetUseType( SIMPLE_USE )

	end
 
	function ENT:Use( activator, caller )
			self:OpenC4Menu( activator )
	end
	
	function ENT:Think()



		if self:GetNWBool( 'c4_timer_started', false ) == false then
			return
		end 
		local etime = self:GetNWInt( 'c4_ExplodeTime' )
		if CurTime() > self.Beep then
			sound.Play( Sound("weapons/c4/c4_beep1.wav"), self:GetPos(), 75, 100 )
		    local btime = (etime - CurTime())/30

			self.Beep = CurTime() + btime
		end



	end
else
	function ENT:Draw()
    	self:DrawModel()

    	local Pos = self:GetPos()
	    local Ang = self:GetAngles()

	    surface.SetFont("ChatFont")
	    local text = self:GetNWInt( 'c4_StartTime', 1 )
	    local TextWidth = surface.GetTextSize(text)
	    Ang:RotateAroundAxis(Ang:Up(), -90)
	    if text > 1 then
		    cam.Start3D2D(Vector( Pos.x, Pos.y, Pos.z ) + Ang:Up() * 8.9, Ang, 0.1)
		        draw.WordBox(2, -TextWidth+55, -40, text, "ChatFont", Color(140, 0, 0, 100), Color(255, 255, 255, 255))
		    cam.End3D2D()
		end

   	end

end