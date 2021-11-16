

AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "Fish Finder"
	SWEP.Instructions = "Find at what depth fish live."
	SWEP.Slot = 3
	SWEP.SlotPos = 3
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
end

SWEP.Author = "Tomasas"
SWEP.Contact = ""
SWEP.Purpose = ""

SWEP.ViewModel = "models/weapons/v_hands.mdl"
SWEP.WorldModel = "models/props_lab/monitor01b.mdl"
SWEP.ViewModelFOV = 60
SWEP.DrawCrosshair = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

function SWEP:Initialize()
	self:SetHoldType("slam")
end

local emptyf = function() end//destroy click sound
SWEP.PrimaryAttack = emptyf
SWEP.SecondaryAttack = emptyf

if CLIENT then
	local function CreateModelPanel(model)
		local modelIcon = vgui.Create("DModelPanel", panel)
		modelIcon:SetModel(model)
		modelIcon:SetMouseInputEnabled(false)
		modelIcon:SetVisible(false)
		
		return modelIcon
	end

	function SWEP:DrawWorldModel()
		local bone = self.Owner:LookupBone("ValveBiped.Bip01_R_Hand")
		if !bone then return true end
		local pos, ang = self.Owner:GetBonePosition(bone)
		self:SetModelScale(0.25, 0)
		
		ang:RotateAroundAxis(ang:Right(), 210)
		ang:RotateAroundAxis(ang:Up(), -30)
		pos = pos - ang:Forward()*1.4 + ang:Right()*3.5 + ang:Up()*2
		
		self:SetRenderOrigin(pos)
		self:SetRenderAngles(ang)
		self:DrawModel()
		return true
	end
	
	function SWEP:Deploy(fromNotEngine)
		self.WeaponModel = ClientsideModel("models/weapons/v_hands.mdl", RENDERGROUP_OPAQUE)
		self.WeaponModel:SetCycle(0.5)
		self.WeaponModel:DrawShadow(false)
		self.WeaponModel:SetNoDraw(true)
		
		self.MonitorModel = ClientsideModel("models/props_lab/monitor01b.mdl", RENDERGROUP_OPAQUE)
		self.MonitorModel:DrawShadow(false)
		self.MonitorModel:SetNoDraw(true)
		
		self.FishPanels = {}
		for i=1, FISH_HIGHNUMBER do
			if !TrueFish.FISH_ENABLED[i] or i == FISH_JUNK then continue end
			self.FishPanels[i] = CreateModelPanel(TrueFishGetFishModel(i))
		end
		return true
	end
	
	function SWEP:Holster()
		if LocalPlayer() == self.Owner then
			if IsValid(self.WeaponModel) then
				self.WeaponModel:Remove()
				self.WeaponModel = nil
			end
			if IsValid(self.MonitorModel) then
				self.MonitorModel:Remove()
				self.MonitorModel = nil
			end
			if self.FishPanels then
				for i=1, FISH_HIGHNUMBER do
					if self.FishPanels[i] and self.FishPanels[i]:IsValid() then
						self.FishPanels[i]:Remove()
					end
				end
			end
		end
		return true
	end

	function SWEP:PreDrawViewModel()
		if !self.WeaponModel then self:Deploy(true) end
		local wep = self.Owner:GetViewModel()

		local wepan = wep:GetAngles()
		wepan:RotateAroundAxis(wepan:Forward(), 0)
		local wepos = EyePos() + wepan:Forward()*0 - wepan:Up()*2 + wepan:Right()*TFScreenScale(4)
		self.WeaponModel:SetRenderOrigin(wepos)
		self.WeaponModel:SetRenderAngles(wepan)
		
		local normal = wepan:Right()
		local dotProduct = normal:Dot(wepos)
		local oldEC = render.EnableClipping(true)
		render.PushCustomClipPlane(normal, dotProduct) // render only right arm
		self.WeaponModel:DrawModel()
		render.PopCustomClipPlane()
		render.EnableClipping(oldEC)
		
		local bone = self.WeaponModel:LookupBone("ValveBiped.Bip01_R_Hand")
		local bone2 = self.WeaponModel:LookupBone("ValveBiped.Bip01_R_UpperArm")
		local bone3 = self.WeaponModel:LookupBone("ValveBiped.Bip01_R_Forearm")
		if !bone or !bone2 or !bone3 then return true end
		self.WeaponModel:ManipulateBoneAngles(bone, Angle(0, 0, 180))
		self.WeaponModel:ManipulateBoneAngles(bone2, Angle(0, -40, 0))
		self.WeaponModel:ManipulateBoneAngles(bone3, Angle(0, 70, 0))
		self.WeaponModel:SetupBones()
		local pos, ang = self.WeaponModel:GetBonePosition(bone)
		ang:RotateAroundAxis(ang:Right(), 160)
		ang:RotateAroundAxis(ang:Up(), -30)
		ang:RotateAroundAxis(ang:Forward(), 110)
		
		pos = pos + ang:Forward()*2 + ang:Up()*6.8 + ang:Right()*4
		self.MonitorModel:SetRenderOrigin(pos)
		self.MonitorModel:SetRenderAngles(ang)
		self.MonitorModel:DrawModel()
		ang:RotateAroundAxis(ang:Right(), -90)
		ang:RotateAroundAxis(ang:Up(), 90)
		
		pos = pos - ang:Right()*5 - ang:Forward()*5.5 + ang:Up()*6.3
		
		self.Depth = -1
		
		local tdata = {start = EyePos(), endpos = EyePos()+LocalPlayer():EyeAngles():Forward()*600, mask = 268435488} // measure depth
		local trace = util.TraceLine(tdata)
		tdata.mask = CONTENTS_SOLID
		local trace2 = util.TraceLine(tdata)
		if trace.Hit and (!trace2.Hit or trace2.HitPos.z < trace.HitPos.z) then
			local tdata2 = {start = trace.HitPos, endpos = trace.HitPos-Vector(0, 0, 99999), mask = CONTENTS_SOLID}
			local trace3 = util.TraceLine(tdata2)
			if trace3.Hit then
				self.Depth = math.Clamp(trace.HitPos.z - trace3.HitPos.z, 0, 99999)
			end
		end
		
		local fishes = TrueFishCalculateFish(self.Depth, true)
		
		cam.Start3D2D(pos, ang, 0.025)
			render.SuppressEngineLighting(true)
			cam.IgnoreZ(true)
			
			surface.SetDrawColor(0,0,0,255)
			surface.DrawRect(0,0,360,368)
			
			//surface.SetDrawColor(255,0,0,255) // visible bounds for debugging
			//surface.DrawOutlinedRect(0,0,360,366)
			
			local x, y = -110, 0
			pos = pos - ang:Forward()*1.55 + ang:Right()*0.42
			local fishLen = #fishes < 13 and #fishes or 12
			for i=1, fishLen do
				if self.FishPanels[fishes[i]] and self.FishPanels[fishes[i]]:IsValid() then	
					local ent = self.FishPanels[fishes[i]].Entity
					local ang = Angle(ang)
					pos = pos + ang:Forward()*3					
					ent:SetRenderOrigin(pos)
					if i%3 == 0 then
						pos = pos + ang:Right()*1.9 - ang:Forward()*(3*3)
					end
					
					x = x+118
					surface.SetDrawColor(255, 255, 255, 255)
					draw.DrawText(TrueFishGetFishName(fishes[i]), "SegoeUI_NormalBold_20", x+55, y+40, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
					if i%3 == 0 then
						x = -110
						y = y + 72
					end
					if string.find(TrueFishGetFishModel(fishes[i]), "FoodNHouseholdItems") then
						ent:SetModelScale(0.05)
						ang:RotateAroundAxis(ang:Up(), -135)
						ang:RotateAroundAxis(ang:Right(), -10)
						ent:SetRenderAngles(ang)
					else
						ang:RotateAroundAxis(ang:Forward(), -90)
						ent:SetRenderAngles(ang)
						ent:SetModelScale(0.06)
					end
					ent:DrawModel()
					
				end
			end
			
			if fishLen == 0 then
				draw.DrawText(TrueFishLocal("fish_finder_no_fish"), "SegoeUI_NormalBold_60", 180, 100, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
			draw.SimpleText(TrueFishLocal("fish_finder_depth_text"), "SegoeUI_NormalBold_20", 180, 295, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText(self.Depth > -1 and math.floor(self.Depth) or 0, "SegoeUI_NormalBold_60", 180, 320, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

			
			cam.IgnoreZ(false)
			render.SuppressEngineLighting(false)
		cam.End3D2D()
		
		return true
	end

end