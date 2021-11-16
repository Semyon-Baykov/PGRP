
include('shared.lua')

	
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

local IsOpen = false
local function FishingPotMenu()
	local ent, buoy, deployed, canhook, unhook, hasfish, needsbait = net.ReadEntity(), net.ReadEntity(), net.ReadBool(), net.ReadBool(), net.ReadBool(), net.ReadBool(), net.ReadBool()
	if IsOpen or !ent:IsValid() then return end
	
	IsOpen = true
	gui.EnableScreenClicker(true)
	local min, max
	if buoy and buoy:IsValid() then
		min, max = buoy:WorldSpaceAABB()
	else
		min, max = ent:WorldSpaceAABB()
	end
	local pos = ((min + max) * 0.5):ToScreen()
	pos.x = math.Clamp(pos.x, 250, ScrW()-250)
	pos.y = math.Clamp(pos.y, 176, ScrH()-176)

	local buttons = {}
	if /*ent:GetClass() == "fishing_pot_medium" and*/ !deployed and !hasfish and !needsbait then
		local num = #buttons + 1
		buttons[num] = vgui.Create("DButton")
		buttons[num]:SetText("")
		buttons[num].Text = TrueFishLocal("deploy_fish_cage")
		buttons[num].Paint = function(self)
			local colorHover = self.IsHoveringOver and 220 or 255
			surface.SetDrawColor(colorHover, colorHover, colorHover, 255)
			surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
			
			surface.SetDrawColor(0, 0, 0, 255)
			surface.DrawOutlinedRect(0, 0, self:GetWide(), self:GetTall())
			
			draw.SimpleTextOutlined(self.Text, "SegoeUI_Normal", self:GetWide()*0.5, self:GetTall()*0.5-1, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 0.35, Color(35, 35, 35, 255))
		end
		buttons[num].PaintOver = function() end
		buttons[num].OnCursorEntered = function(self) self.IsHoveringOver = true end
		buttons[num].OnCursorExited = function(self) self.IsHoveringOver = false end
		
		buttons[num].DoClick = function(self)
			net.Start("m_p_deploy")
			net.WriteEntity(ent)
			net.SendToServer()
			for k,v in pairs(buttons) do
				v:Remove()
			end
			IsOpen = false
			gui.EnableScreenClicker(false)
		end
	end
	
	if /*ent:GetClass() == "fishing_pot_medium" and*/ !deployed and hasfish then
		local num = #buttons + 1
		buttons[num] = vgui.Create("DButton")
		buttons[num]:SetText("")
		buttons[num].Text = TrueFishLocal("collect_fish")
		buttons[num].Paint = function(self)
			local colorHover = self.IsHoveringOver and 220 or 255
			surface.SetDrawColor(colorHover, colorHover, colorHover, 255)
			surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
			
			surface.SetDrawColor(0, 0, 0, 255)
			surface.DrawOutlinedRect(0, 0, self:GetWide(), self:GetTall())
			
			draw.SimpleTextOutlined(self.Text, "SegoeUI_Normal", self:GetWide()*0.5, self:GetTall()*0.5-1, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 0.35, Color(35, 35, 35, 255))
		end
		buttons[num].PaintOver = function() end
		buttons[num].OnCursorEntered = function(self) self.IsHoveringOver = true end
		buttons[num].OnCursorExited = function(self) self.IsHoveringOver = false end
		
		buttons[num].DoClick = function(self)
			net.Start("m_p_collect")
			net.WriteEntity(ent)
			net.SendToServer()
			for k,v in pairs(buttons) do
				v:Remove()
			end
			IsOpen = false
			gui.EnableScreenClicker(false)
		end
	end
	
	if canhook or unhook then
		local num = #buttons + 1
		buttons[num] = vgui.Create("DButton")
		buttons[num]:SetText("")
		buttons[num].Text = unhook and TrueFishLocal("untie_fish_cage") or TrueFishLocal("tie_down_fish_cage")
		buttons[num].Paint = function(self)
			local colorHover = self.IsHoveringOver and 220 or 255
			surface.SetDrawColor(colorHover, colorHover, colorHover, 255)
			surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
			
			surface.SetDrawColor(0, 0, 0, 255)
			surface.DrawOutlinedRect(0, 0, self:GetWide(), self:GetTall())
			
			draw.SimpleTextOutlined(self.Text, "SegoeUI_Normal", self:GetWide()*0.5, self:GetTall()*0.5-1, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 0.35, Color(35, 35, 35, 255))
		end
		buttons[num].PaintOver = function() end
		buttons[num].OnCursorEntered = function(self) self.IsHoveringOver = true end
		buttons[num].OnCursorExited = function(self) self.IsHoveringOver = false end
		
		buttons[num].DoClick = function(self)
			net.Start("m_p_hook")
			net.WriteEntity(ent)
			net.SendToServer()
			for k,v in pairs(buttons) do
				v:Remove()
			end
			IsOpen = false
			gui.EnableScreenClicker(false)
		end
	end
	
		local num = #buttons + 1
		buttons[num] = vgui.Create("DButton")
		buttons[num]:SetText("")
		buttons[num].Text = TrueFishLocal("close_menu")
		buttons[num].Paint = function(self)
			local colorHover = self.IsHoveringOver and 220 or 255
			surface.SetDrawColor(colorHover, colorHover, colorHover, 255)
			surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
			
			surface.SetDrawColor(0, 0, 0, 255)
			surface.DrawOutlinedRect(0, 0, self:GetWide(), self:GetTall())
			
			draw.SimpleTextOutlined(self.Text, "SegoeUI_Normal", self:GetWide()*0.5, self:GetTall()*0.5-1, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 0.35, Color(35, 35, 35, 255))
		end
		buttons[num].PaintOver = function() end
		buttons[num].OnCursorEntered = function(self) self.IsHoveringOver = true end
		buttons[num].OnCursorExited = function(self) self.IsHoveringOver = false end
		
		buttons[num].DoClick = function(self)
			for k,v in pairs(buttons) do
				v:Remove()
			end
			IsOpen = false
			gui.EnableScreenClicker(false)
		end
	
	
	local longest = 0
	for k,v in pairs(buttons) do
		surface.SetFont("SegoeUI_Normal")
		local txtsize = surface.GetTextSize(v.Text)
		longest = txtsize > longest and txtsize or longest
	end
	longest = longest + 8
	for k,v in pairs(buttons) do
		v:SetSize(longest, 25)
		v:SetPos(pos.x-longest*0.5, pos.y+(k*25))
		v:MakePopup()
		v:SetKeyboardInputEnabled(true)
	end

end
net.Receive("MediumPotMenu", FishingPotMenu)


net.Receive("FishPotUpdate", function()
	local ent = net.ReadEntity()
	if !ent:IsValid() then return end
	local mode = net.ReadUInt(2)
	if mode == 0 and !TrueFish.CAGE_NO_FISH_MODEL then
		ent:AddFish(net.ReadUInt(6))
	elseif mode == 1 then
		local toRemove = {}
		while true do
			local id, num = net.ReadUInt(6), net.ReadUInt(8)
			if id == 0 then break end
			toRemove[#toRemove+1] = {id, num}
		end
		for i=1, #toRemove do
			for k,v in pairs(ent.FishToDisplay) do
				if (toRemove[i][1] == v.FishID and toRemove[i][2] > 0) then
					v:Remove()
					ent.FishToDisplay[k] = nil
					toRemove[i][2] = toRemove[i][2]-1
				end
			end
		end
	elseif mode == 2 then
		ent:AddBait()
	elseif mode == 3 then
		if ent.Bait and ent.Bait:IsValid() then
			ent.Bait:Remove()
		end
		ent.Bait = nil
	end
end)

function ENT:AddFish(fish)
	local pos = self:GetPos() + self:GetUp()
	local rh, num = self:GetRight(), #self.FishToDisplay%10
	if num < 5 then
		num = num + 1
		self.FishToDisplay[num] = ClientsideModel(TrueFishGetFishModel(fish), RENDERGROUP_OPAQUE)
		self.FishToDisplay[num].FishID = fish
		self.FishToDisplay[num]:SetAngles(Angle(math.random(1,360), math.random(1,360), math.random(1,360)))
		self.FishToDisplay[num]:SetPos(pos - (rh*(num*5.5-10)))
		self.FishToDisplay[num]:SetParent(self)
		self.FishToDisplay[num]:DrawShadow(false)
		self.FishToDisplay[num]:SetNoDraw(true)
	else
		num = num + 1
		self.FishToDisplay[num] = ClientsideModel(TrueFishGetFishModel(fish), RENDERGROUP_OPAQUE)
		self.FishToDisplay[num].FishID = fish
		self.FishToDisplay[num]:SetAngles(Angle(math.random(1,360), math.random(1,360), math.random(1,360)))
		self.FishToDisplay[num]:SetPos(pos + (rh*(num*5.5-40)))
		self.FishToDisplay[num]:SetParent(self)
		self.FishToDisplay[num]:DrawShadow(false)
		self.FishToDisplay[num]:SetNoDraw(true)
	end
end

function ENT:AddBait()
	self.Bait = ClientsideModel("models/props_junk/garbage_bag001a.mdl", RENDERGROUP_OPAQUE)
	self.Bait:SetMaterial("models/flesh")
	local ang = self:GetAngles()
	self.Bait:SetPos(self:GetPos() - ang:Up()*9.5)
	ang:RotateAroundAxis(ang:Right(), -90)
	self.Bait:SetAngles(ang)
	self.Bait:SetParent(self)
	self.Bait:DrawShadow(false)
	self.Bait:SetNoDraw(true)
end

function ENT:Initialize()
	self.FishToDisplay = {}
end

local cw, ccw, mat = MATERIAL_CULLMODE_CW, MATERIAL_CULLMODE_CCW,
CreateMaterial("CagePotMaterial", "VertexLitGeneric", {["$translucent"] = 1, ["$surfaceprop"] = "metal", ["$basetexture"] = "Metal/metalfence007a"})
function ENT:Draw()
	if !TrueFish.CAGE_NO_FISH_MODEL then
		for k,v in pairs(self.FishToDisplay) do
			if v:IsValid() then
				v:DrawModel()
			end
		end
	end
	if self.Bait and self.Bait:IsValid() then
		self.Bait:DrawModel()
	end

	render.MaterialOverride(mat)
	render.CullMode(cw)
	self:DrawModel()
	render.CullMode(ccw)
	self:DrawModel()
	render.MaterialOverride()	
end

ENT.DrawTranslucent = ENT.Draw

function ENT:OnRemove()
	for k,v in pairs(self.FishToDisplay) do
		v:Remove()
	end
	if self.Bait and self.Bait:IsValid() then
		self.Bait:Remove()
	end
end