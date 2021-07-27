local PANEL = {}

function PANEL:Init(revert)
	self:SetText("")
	self:SetPaintBackground(false)
	self.phone_rb = aphone.GUI.RoundedBox(self:GetWide() * 0.6, 0, self:GetWide() * 0.35, self:GetTall(), 8)
	self:aphone_RemoveCursor()
end

function PANEL:SetImgur(id)
	self.imgurid = id
end

function PANEL:Left_Avatar(b)
	self:Clear()
	self.revert = b
	self.phone_rb = nil
end

function PANEL:PerformLayout(w, h)
	self.phone_rb = nil
end

local stencil_clr = Color(1, 1, 1, 1)
local black_40_180 = Color(40, 40, 40, 180)
function PANEL:Paint(w, h)
	if self.imgurid then
		local mat = aphone.GetImgurMat(self.imgurid)

		if !self.phonerb then
			if self.revert then
				self.phone_rb = aphone.GUI.RoundedBox(math.floor(w * 0.6), 0, math.floor(w * 0.35), h, 8)
			else
				self.phone_rb = aphone.GUI.RoundedBox(math.floor(w * 0.05), 0, math.floor(w * 0.35), h, 8)
			end
		end

		if mat and !mat:IsError() then
			aphone.Stencils.Start()
				surface.SetDrawColor(stencil_clr)
				surface.DrawPoly(self.phone_rb)
			aphone.Stencils.AfterMask(false)
				surface.SetMaterial(aphone.GetImgurMat(self.imgurid))
				surface.SetDrawColor(color_white)

				if self.revert then
					surface.DrawTexturedRect(w * 0.6, 0, w * 0.35, h)
				else
					surface.DrawTexturedRect(w * 0.05, 0, w * 0.35, h)
				end
			aphone.Stencils.End()
			return
		end
	end

    surface.SetDrawColor(black_40_180)
    surface.DrawRect(0, 0, w, h)

    if !self.circle1 then
        self.circle1 = aphone.GUI.GenerateCircle(w / 2, h / 2, w / 4)
        self.circle2 = aphone.GUI.GenerateCircle(w / 2, h / 2, w / 4-6)
    end

    local rad = CurTime() * 6

    aphone.Stencils.Start()
        surface.SetDrawColor(stencil_clr)
        surface.DrawPoly(self.circle1)
    aphone.Stencils.AfterMask(false)
        surface.DrawPoly(self.circle2)

        surface.SetDrawColor(aphone:Color("GPS_Line"))
        draw.SimpleText("d", aphone:GetFont("SVG_60"), math.cos( rad ) * (w / 4) + w / 2, math.sin(rad) * (w / 4) + h / 2, aphone:Color("GPS_Line"), 1, 1)
    aphone.Stencils.End()
end

vgui.Register("aphone_MessageImage", PANEL, "DButton")