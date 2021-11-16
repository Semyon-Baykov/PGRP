
include('shared.lua')

	
ENT.RenderGroup = RENDERGROUP_OPAQUE

local IsOpen = false
local function BuoyMenu()
	local ent = net.ReadEntity()
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
	if ent:GetClass() == "ent_buoy" then
		local num = #buttons + 1
		buttons[num] = vgui.Create("DButton")
		buttons[num]:SetText("")
		buttons[num].Text = TrueFishLocal("retrieve_fish_cage")
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
			net.Start("BuoyRet")
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
net.Receive("BuoyMenu", BuoyMenu)

net.Receive("BuoySplash", function()
	local ent = net.ReadEntity()
	if IsValid(ent) then
		ent.Splashing = true
	end
end)

function ENT:Initialize()
end

ENT.NextSplash = 0
function ENT:Draw()
	local ctime = CurTime()
	if self.Splashing and self:WaterLevel() > 0 and self.NextSplash < ctime then
		local pos = self:GetPos()
		local effectdata = EffectData()
		effectdata:SetOrigin(pos)
		effectdata:SetNormal(pos)
		effectdata:SetRadius(8)
		effectdata:SetScale(9)
		util.Effect("watersplash", effectdata)
		self.NextSplash = ctime+1
	end

	self:DrawModel()
	
end
