
include('shared.lua')

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

local IsOpen = false
local function FishMenu(len)

	local ent, canhook, unhook, discard = net.ReadEntity(), net.ReadBool(), net.ReadBool(), net.ReadBool()
	if !ent or !ent:IsValid() then return end

	IsOpen = true
	gui.EnableScreenClicker(true)
	local min, max = ent:WorldSpaceAABB()

	local pos = ((min + max) * 0.5):ToScreen()
	pos.x = math.Clamp(pos.x, 250, ScrW()-250)
	pos.y = math.Clamp(pos.y, 176, ScrH()-176)

	local buttons = {}

	if discard then
		for i=1, FISH_HIGHNUMBER do
			if ent.Fishes[i] and ent.Fishes[i] > 0 then
				local num = #buttons + 1
				buttons[num] = vgui.Create("DButton")
				buttons[num]:SetText("")
				buttons[num].Text = TrueFishLocal("discard_fish", TrueFishGetFishName(i))
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
					if ent:IsValid() then
						net.Start("DiscardFish")
						net.WriteEntity(ent)
						net.WriteInt(i, 16)
						net.SendToServer()
					end
					for k,v in pairs(buttons) do
						v:Remove()
					end
					IsOpen = false
					gui.EnableScreenClicker(false)
				end
			end
		end
	end
	if canhook or unhook then
		local num = #buttons + 1
		buttons[num] = vgui.Create("DButton")
		buttons[num]:SetText("")
		buttons[num].Text = unhook and TrueFishLocal("untie_fish_container") or TrueFishLocal("tie_down_fish_container")
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
net.Receive("FishMenu", FishMenu)


local InfoToLoad = {}
local function GetFishs(len)
	local num = net.ReadUInt(13)
	local ent = ents.GetByIndex(num)

	if ent:IsValid() then
		ent.Fishes = {}
		while true do
			local id = net.ReadUInt(6)
			if id == 0 then break end
			local amt = net.ReadUInt(8)
			ent.Fishes[id] = amt
		end
	else
		InfoToLoad[num] = {}
		while true do
			local id = net.ReadUInt(6)
			if id == 0 then break end
			local amt = net.ReadUInt(8)
			InfoToLoad[num] = amt
		end
	end
end
net.Receive("SendFish", GetFishs)

local function GetFishesSpawn(len)
	local size = net.ReadUInt(13)
	
	local ent, num
	for i=1, size do
		num = net.ReadUInt(13)
		ent = ents.GetByIndex(num)
		if ent:IsValid() then
			ent.Fishes = {}
			while true do
				local id = net.ReadUInt(6)
				if id == 0 then break end
				local amt = net.ReadUInt(8)
				ent.Fishes[id] = amt
			end
		else
			InfoToLoad[num] = {}
			while true do
				local id = net.ReadUInt(6)
				if id == 0 then break end
				local amt = net.ReadUInt(8)
				InfoToLoad[num] = amt
			end
		end
	end
end
net.Receive("SendFishSpawn", GetFishesSpawn)

function ENT:Initialize()
	local ind = self:EntIndex()
	if InfoToLoad[ind] then
		self.Fishes = InfoToLoad[ind]
		InfoToLoad[ind] = nil
	else
		self.Fishes = {}
	end
end


local textColor = Color(255, 255, 255, 255)
function ENT:Draw()
	self:DrawModel()
	
	
	if LocalPlayer():GetEyeTrace().Entity == self then
		local space = self:GetSpace()
		if space == 0 then return end
		local plypos, pos = LocalPlayer():GetPos(), self:GetPos()
		plypos.z = plypos.z+15
		pos.z = pos.z + 15
		local faceplant = (plypos-pos):Angle()
		local camPos = pos+faceplant:Forward()*25
		faceplant.p = 180
		faceplant.y = faceplant.y-90
		faceplant.r = faceplant.r-90
		cam.Start3D2D(camPos, faceplant, 0.25)
			cam.IgnoreZ(true)
			local a = -1
			local num
			for i=1, FISH_HIGHNUMBER do
				if self.Fishes[i] and self.Fishes[i] > 0 then
					num = self.Fishes[i]
					draw.SimpleText(table.concat({num, TrueFishGetFishName(i)}, " "), "SegoeUI_Normal", 0, a*15, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					a = a+1
				end
			end
			
			if a == -1 then
				draw.SimpleText(TrueFishLocal("empty_container_text"), "SegoeUI_Normal", 0, a*15, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				a = a+1
			end
			
			surface.SetDrawColor(200, 200, 200, 255)
			surface.DrawRect(-25, a*15, 50*space/TrueFish.FISH_CONTAINER_LIMIT, 5)
			surface.SetDrawColor(255, 255, 255, 200)
			surface.DrawOutlinedRect(-25, a*15, 50, 5)
			cam.IgnoreZ(false)
		cam.End3D2D()
	end
end
ENT.DrawTranslucent = ENT.Draw
