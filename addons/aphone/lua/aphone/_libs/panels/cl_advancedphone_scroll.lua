// Patch ScrollPanel with stencil
local SCROLL = FindMetaTable("Panel")

function SCROLL:aphone_PaintScroll()
	if self:GetName() != "DScrollPanel" then return end

	local vbar = self:GetVBar()
	vbar:SetWide(4)

	function vbar:Paint() end
	function vbar.btnUp:Paint() end
	function vbar.btnDown:Paint() end

	local s = self.OnMouseWheeled

	function self:OnMouseWheeled(delta)
		// s function return a value, so we return the same thing, also we use the result to check if we can put our cd or self is disabled ( Look into DVScrollBar )
		local return_val = s(self, delta)

		if s(self, delta) then
			vbar.btnGrip.aphone_BarCD = CurTime()
		end

		return return_val
	end

	function vbar.btnGrip:Paint(w, h)
		local a = CurTime() - (self.aphone_BarCD or 0) - 1
		if a > 0.5 then return end

		draw.RoundedBox(w / 2, 0, 0, w, h, Color(255, 255, 255, a < 0 and 255 or (1 - a * 2) * 255))
	end
	self:aphone_RemoveCursor()
end