local PANEL = {}

local empty_color = Color(155, 89, 182)
function PANEL:Init(revert)
	self:SetPaintBackground(false)
	self.bgcolor = empty_color
	self.font = aphone:GetFont("MediumHeader")

	local self_pnl = self

	self.avatar_maindock = vgui.Create("DPanel", self)
	self.avatar_maindock:Dock(revert and RIGHT or LEFT)
	self.avatar_maindock:SetWide(aphone.GUI.ScaledSizeX(48))
	self.avatar_maindock:SetPaintBackground(false)

	self.avatar = vgui.Create("aphone_CircleAvatar", self.avatar_maindock)
	self.avatar:Dock(BOTTOM)
	self.avatar:SetTall(self.avatar_maindock:GetWide())
	self.avatar:SetPlayer(LocalPlayer(), 64)

	self.text_maindock = vgui.Create("DPanel", self)
	self.text_maindock:Dock(FILL)
	self.text_maindock:SetPaintBackground(false)
	self.text_maindock:DockMargin(aphone.GUI.ScaledSize(!revert and 10 or 0, 0, revert and 10 or 0, 0))

	function self.text_maindock:Paint(w, h)
		if !self_pnl.wrapped_text then
			self_pnl.wrapped_text = aphone.GUI.WrapText(self_pnl.text, self_pnl.font, w-32)

			// Font already set by wraptext
			local _, h1_y = surface.GetTextSize(self_pnl.wrapped_text)
			local h2 = IsValid(self_pnl.avatar) and self_pnl.avatar:GetTall() or 0

			h1_y = h1_y + 32

			self_pnl:SetTall(h1_y > h2 and h1_y or h2)
		end
		draw.RoundedBox(16, 0, 0, w, h, self:GetParent().bgcolor)
		draw.DrawText(self_pnl.wrapped_text or "Placeholder", self_pnl.font, 16, 16, color_white, 0)
	end

	self:aphone_RemoveCursor()

	self.revert = revert
end

function PANEL:KillAvatar()
	self.avatar_maindock:Remove()

	if !self.revert then
		self.text_maindock:DockMargin(aphone.GUI.ScaledSizeX(10), 0, aphone.GUI.ScaledSizeX(48), 0)
	else
		self.text_maindock:DockMargin(aphone.GUI.ScaledSizeX(48), 0, aphone.GUI.ScaledSizeX(10), 0)
	end
end

function PANEL:SetText(t)
	self.text = t
	self.wrapped_text = nil
end

function PANEL:SetAvatar(ply, size)
	self.avatar:SetPlayer(ply, size)
end

function PANEL:GetText()
	return self.text
end

function PANEL:SetFont(n)
	self.text:SetFont(n)
	self:RecalculateHeight()
end

function PANEL:SetBackgroundColor(clr)
	self.bgcolor = clr
end

function PANEL:Left_Avatar(b)
	self:Clear()
	self:Init(b)
end

vgui.Register("aphone_Message", PANEL, "DPanel")