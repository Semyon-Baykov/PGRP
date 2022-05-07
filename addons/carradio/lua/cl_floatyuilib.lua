wyozicr.floatyui = {}
local fui = wyozicr.floatyui

surface.CreateFont("FloatyTiny", {
	font = "monospace",
	antialias = true,
	size = 16,
	weight = 0
})
surface.CreateFont("FloatyVerySmall", {
	font = "monospace",
	antialias = true,
	size = 26,
	weight = 0
})
surface.CreateFont("FloatySmall", {
	font = "monospace",
	antialias = true,
	size = 32,
	weight = 0
})

surface.CreateFont("FloatyMedium", {
	font = "monospace",
	antialias = true,
	size = 46,
	weight = 0
})

surface.CreateFont("FloatyLarge", {
	font = "monospace",
	antialias = true,
	size = 58,
	weight = 0
})

fui.components = {}

function fui.Register(name, table)

	local meta = {}

	table.UIName = name

	if table.Base then
		local basetbl = fui.components[table.Base]
		if not basetbl then
			error("Trying to register FloatyUI with nonexistent base " .. table.Base)
			return
		end

		meta.__index = basetbl
		table.ParentUI = basetbl
	end

	setmetatable(table, meta)
	fui.components[name] = table

end

function fui.Create(name, ...)

	local ntbl = fui.components[name]
	if not ntbl then
		error("Trying to create nonexistent FloatyUI " .. name)
		return
	end

	local tbl = {BaseUI = ntbl}
	setmetatable(tbl, {__index = ntbl})

	tbl:Init(...)
	return tbl
end

do -- Panel

	local PANEL = {}

	function PANEL:Init()
		self.PaintTbl = {}
		self.x = 0
		self.y = 0
		self.w = 0
		self.h = 0

		self.ThrowawayMatrix = Matrix()
	end

	-- Sets local (relative to parent) pos
	function PANEL:SetPos(x, y)
		self.x = x
		self.y = y
	end

	function PANEL:SetSize(w, h)
		self.w = w
		self.h = h
	end

	function PANEL:GetPos()
		local bx, by = 0, 0
		if self.Parent and self.Parent.GetPos then
			bx, by = self.Parent:GetPos()
		end
		return bx + self.x or 0, by + self.y or 0
	end

	function PANEL:GetLocalPos()
		return self.x, self.y
	end

	function PANEL:GetSize()
		return self.w, self.h
	end

	function PANEL:Contains(x, y)
		local sx, sy = self:GetPos()
		local sw, sh = self:GetSize()
		return sx <= x and sy <= y and (sx+sw) >= x and (sy+sh) >= y
	end

	function PANEL:Think(tbl)

		if self.DoClick and tbl.clicked and tbl.mx and tbl.my and self:Contains(tbl.mx, tbl.my) then
			self:DoClick(tbl.mx, tbl.my)
		end

		if not self.Children then return end
		for _, c in pairs(self.Children) do
			c:Think(tbl)
		end
	end

	function PANEL:Paint(tbl)
		if not self.Children then return end

		for _, c in pairs(self.Children) do
			c:Paint(tbl)
		end
	end

	function PANEL:Add(child, ...)
		if not self.Children then self.Children = {} end
		if type(child) == "table" then
			child.Parent = self
			table.insert(self.Children, child)
		else
			local n = fui.Create(child, ...)
			n.Parent = self
			table.insert(self.Children, n)
			return n
		end
	end

	function PANEL:TranslateToFloatyCoords(pos, ang, scale, rayOrigin, rayDirection)

		pos = pos or self.RPos
		ang = ang or self.RAngles
		scale = scale or self.RScale

		rayOrigin = rayOrigin or LocalPlayer():EyePos()
		if not rayDirection then
			local mousex, mousey = gui.MousePos()
			if mousex == 0 and mousey == 0 then -- Screen clicker not enabled; let's fake mouse coords
				mousex, mousey = ScrW()/2, ScrH()/2
			end
			rayDirection = gui.ScreenToVector( mousex, mousey )
		end

		local planePosition = pos
		local planeNormal = ang:Up()

		local is = util.IntersectRayWithPlane(rayOrigin, rayDirection, planePosition, planeNormal)
		if is then

			local diff = is - pos -- Diff from hitpos to origin
			
		    diff:Rotate(Angle(0,-ang.y,0))
		    diff:Rotate(Angle(-ang.p,0,0))
		    diff:Rotate(Angle(0,0,-ang.r))

		    local xchange = diff.x
		    local ychange = diff.y

			if xchange >= 0 and ychange <= 0 then
				xchange = xchange * (1/scale)
				ychange = ychange * (1/scale)
				return xchange, -ychange
			end

		end
	end

	function PANEL:Render(pos, angles, scale) 
		pos = pos or self.RPos
		angles = angles or self.RAngles
		scale = scale or self.RScale

		local mx, my = self:TranslateToFloatyCoords(pos, angles, scale)

		local tbl = self.PaintTbl

		tbl.pos = pos
		tbl.ang = angles
		tbl.scale = scale
		tbl.mx = mx
		tbl.my = my
		tbl.mousedown = LocalPlayer():KeyDown(IN_ATTACK)

		self:Think(tbl) -- Meh, could be elsewhere

        render.PushFilterMin( TEXFILTER.ANISOTROPIC )
        render.PushFilterMag( TEXFILTER.ANISOTROPIC )

		cam.Start3D2D(pos, angles, scale)

			self:Paint(tbl)

		cam.End3D2D()

		tbl.clicked = false

        render.PopFilterMin()
        render.PopFilterMag()

	end

	function PANEL:SetRenderData(pos, ang, scale)
		self.RPos = pos
		self.RAngles = ang
		self.RScale = scale
	end

	function PANEL:ToString()
		local x, y = self:GetPos()
		local w, h = self:GetSize()
		return "FloatyUI [" .. tostring(self.UIName) .. " " .. tostring(x) .. "x" .. tostring(y) .. " " .. tostring(w) .. "x" .. tostring(h) .. "]"
	end

	fui.Register("Panel", PANEL)

end

do -- Label

	local PANEL = {}
	PANEL.Base = "Panel"

	function PANEL:Init(text, font, clr, halign, valign)
		font = font or "FloatySmall"
		clr = clr or Color(255, 255, 255)
		halign = halign or TEXT_ALIGN_LEFT
		valign = valign or TEXT_ALIGN_BOTTOM

		self.Text = text
		self.Font = font
		self.Color = clr
		self.HAlign = halign
		self.VAlign = valign
	end

	function PANEL:Paint()
		local x, y = self:GetPos()
		draw.SimpleText(self.Text or "Text", self.Font, x, y, self.Color, self.HAlign, self.VAlign)
	end

	function PANEL:GetTextSize()
		surface.SetFont(self.Font)
		return surface.GetTextSize(self.Text or "Text")
	end

	fui.Register("Label", PANEL)
	
end

do -- Slider

	local PANEL = {}
	PANEL.Base = "Panel"

	function PANEL:Init()

		local sliderself = self

		self.Tab = self:Add("Panel")
		self.Tab.Think = function(self, tbl)

			self:SetSize(45, 50)

			if tbl.mousedown and tbl.mx and tbl.my and (self:Contains(tbl.mx, tbl.my) or (self.LastMX and self.LastMY)) then
				if self.LastMX and self.LastMY then
					local diffx, diffy = tbl.mx-self.LastMX, tbl.my-self.LastMY

					local px, py = self:GetLocalPos()
					local mysize = self:GetSize()
					local parsize = sliderself:GetSize(self) - mysize

					self:SetPos(math.Clamp(px + diffx, 0, parsize), py)
					sliderself:NotifyListeners(sliderself:GetFracValue())
				end

				self.LastMX = tbl.mx
				self.LastMY = tbl.my
			else
				self.LastMX = nil
				self.LastMY = nil
			end
		end
		self.Tab.Paint = function(self, tbl)
			local x, y = self:GetPos()
			local w, h = self:GetSize()

			local hovered = tbl.mx and tbl.my and self:Contains(tbl.mx, tbl.my)

			surface.SetDrawColor(hovered and Color(127, 0, 0) or Color(255, 255, 255))
			surface.DrawRect(x, y, w, h)
		end 
	end

	function PANEL:Paint(tbl)

		local x, y = self:GetPos()
		local w, h = self:GetSize()

		surface.SetDrawColor(Color(255, 0, 0))
		surface.DrawRect(x, y + h/2-2, w, 4)
		
		self.ParentUI.Paint(self, tbl)
	end

	function PANEL:GetFracValue()
		return (self.Tab:GetPos() + self.Tab:GetSize()/2) / self:GetSize()
	end

	function PANEL:SetFracValue(val)
		self.Tab:SetPos(self:GetSize()/2 - self.Tab:GetSize(), 0)
		self:NotifyListeners(val)
	end

	function PANEL:NotifyListeners(newval)
		if self.OnChange then
			self:OnChange(newval)
		end
	end

	fui.Register("Slider", PANEL)
	
end
