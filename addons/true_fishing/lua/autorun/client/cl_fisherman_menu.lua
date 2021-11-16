local rt_Store	= render.GetScreenEffectTexture(1)
local mat_Copy	= Material("pp/copy")
local blur = Material("pp/blurscreen")

local menu
local function FishNPCMenu(len)
	if menu and menu.Remove then menu:Remove() end

	local npc = net.ReadEntity()
	if !npc:IsValid() or npc:GetClass() != "npc_fishshop" then
		print("Fishing NPC was invalid.")
		return
	end

	
	local num = net.ReadUInt(6)
	for i=1, num do
		local id = net.ReadUInt(6)
		TrueFish.FISH_PRICE[id] = net.ReadUInt(16)
		TrueFish.FISH_ENABLED[id] = net.ReadBool()
	end
	
	local num = net.ReadUInt(6)
	for i=1, num do
		local id = net.ReadUInt(6)
		TrueFish.GEAR_PRICE[id] = net.ReadUInt(16)
		TrueFish.GEAR_ENABLED[id] = net.ReadBool()
	end

	local FishToSell = {}
	while true do
		local ind = net.ReadUInt(6)
		if ind == 0 then break end
		FishToSell[ind] = FishToSell[ind] and FishToSell[ind] + net.ReadUInt(8) or net.ReadUInt(8)
	end
	
	
	local TotalSalePrice = 0
	for i=1, FISH_HIGHNUMBER do
		if FishToSell[i] then
			TotalSalePrice = TotalSalePrice + FishToSell[i] * TrueFish.FISH_PRICE[i]
		end
	end
	TotalSalePrice = math.floor(TotalSalePrice)
	
	local SaleAmount = 2

	menu = vgui.Create("DFrame")
	menu:SetTitle("")
	menu:ShowCloseButton(false)
	menu:SetDraggable(false)
	menu:SetSize(TFScreenScale(450), TFScreenScale(282))
	menu:Center()
	menu:MakePopup()
	menu.Paint = function(self)
		
		DisableClipping(true)
		local rt_Scene = render.GetRenderTarget()
		render.CopyRenderTargetToTexture(rt_Store)
		
		local layers = 10
		local density = 5
		surface.SetMaterial(blur)	
		surface.SetDrawColor(255, 255, 255, 255)
		local x, y = self:LocalToScreen(0, 0)
		for i = 1, layers do
			blur:SetFloat("$blur", (i / layers) * density)
			blur:Recompute()
			render.UpdateScreenEffectTexture()
			surface.DrawTexturedRect(-x, -y, ScrW(), ScrH())
		end
		
		surface.SetDrawColor(51, 51, 51, 255)
		surface.DrawRect(0, 40, self:GetWide(), self:GetTall()-80)
		
		render.ClearStencil()
		render.SetStencilEnable(true)
		render.SetStencilTestMask(1)
		render.SetStencilWriteMask(1)
		render.SetStencilReferenceValue(1)
		render.SetStencilCompareFunction(STENCIL_NEVER)
		render.SetStencilPassOperation(STENCIL_KEEP)
		render.SetStencilFailOperation(STENCIL_REPLACE)

		// draw mask here
		draw.NoTexture()
		
		surface.DrawRect(0, 40, self:GetWide(), self:GetTall()-80)
		
		// draw screen back with a cutout from the mask
		render.SetStencilCompareFunction(STENCIL_NOTEQUAL)
		render.SetStencilPassOperation(STENCIL_KEEP)
		render.SetStencilFailOperation(STENCIL_REPLACE)
		
		render.SetRenderTarget(rt_Scene)
		mat_Copy:SetTexture("$basetexture", rt_Store)
		render.SetMaterial(mat_Copy)
		render.DrawScreenQuad()
		
		// need to reset settings
		render.SetStencilEnable(false)
		render.SetStencilTestMask(0)
		render.SetStencilWriteMask(0)
		render.SetStencilReferenceValue(0)
		DisableClipping(false)
		
			
		draw.RoundedBoxEx(8, 0, 0, self:GetWide(), 40, Color(30, 140, 200, 255), true, true)
		draw.SimpleText(TrueFishLocal("fish_market"), "FishingSS9", self:GetWide()*0.5, 0, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
		
		draw.RoundedBoxEx(8, 0, self:GetTall()-40, self:GetWide(), 40, Color(30, 140, 200, 255), false, false, true, true)

	end
	
	local panelListPaint = function(self)
		surface.SetDrawColor(34, 37, 47, 150)
		surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
		//surface.SetDrawColor(50, 50, 50, 255)
		//surface.DrawOutlinedRect(0, 0, self:GetWide(), self:GetTall())
	end
	
	local gap = menu:GetWide()*0.01 //0.01225
	local panelSize = menu:GetWide()*0.321 //0.318
	
	local left = vgui.Create("DPanelList", menu)
	left:EnableVerticalScrollbar(true)
	left:SetSize(panelSize, menu:GetTall()-80)
	left:SetPos(gap, 40)
	left:SetSpacing(1)
	left.Paint = panelListPaint
	local sbarLeft = left.VBar
	function sbarLeft:Paint( w, h )
	end
	sbarLeft.btnUp.Paint = sbarLeft.Paint
	sbarLeft.btnDown.Paint = sbarLeft.Paint
	function sbarLeft.btnGrip:Paint( w, h )
		draw.RoundedBox(4, 0, 0, w-1, h, Color(200, 200, 200, 10))
	end
	
	local middle = vgui.Create("DPanelList", menu)
	middle:EnableVerticalScrollbar(true)
	middle:SetSize(panelSize, menu:GetTall()-80)
	local x, y = left:GetPos()
	middle:SetPos(x+left:GetWide()+gap, 40)
	middle:SetSpacing(1)
	middle.Paint = panelListPaint
	local sbarMiddle = middle.VBar
	function sbarMiddle:Paint( w, h )
	end
	sbarMiddle.btnUp.Paint = sbarLeft.Paint
	sbarMiddle.btnDown.Paint = sbarLeft.Paint
	function sbarMiddle.btnGrip:Paint( w, h )
		draw.RoundedBox(4, 0, 0, w-1, h, Color(200, 200, 200, 10))
	end
	
	local right = vgui.Create("DPanelList", menu)
	right.Paint = function(self)
		surface.SetDrawColor(34, 37, 47, 150)
		surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
		if TotalSalePrice == 0 then
			draw.DrawText(TrueFishLocal("no_fish_to_sell"), "FishingSS9", self:GetWide()*0.5, self:GetTall()*0.5, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	end
	right:EnableVerticalScrollbar(true)
	right:SetSize(panelSize, menu:GetTall()-80)
	x, y = middle:GetPos()
	right:SetPos(x+middle:GetWide()+gap, 40)
	right:SetSpacing(1)
	local sbarRight = right.VBar
	function sbarRight:Paint( w, h )
	end
	sbarRight.btnUp.Paint = sbarLeft.Paint
	sbarRight.btnDown.Paint = sbarLeft.Paint
	function sbarRight.btnGrip:Paint( w, h )
		draw.RoundedBox(4, 0, 0, w-1, h, Color(200, 200, 200, 10))
	end
	

	local exitbtn = vgui.Create("DButton", menu)
	exitbtn:SetSize(22, 22)
	exitbtn:SetFont("FishingSS9")
	exitbtn:SetText("X")
	exitbtn:SetColor(Color(250, 250, 250, 255))
	exitbtn:SetPos(menu:GetWide() - 22, 0)
	exitbtn.Paint = function(self)
		draw.RoundedBoxEx(8, 0, 0, self:GetWide(), 40, Color(70, 84, 122, 255), false, true)
	end
	exitbtn.DoClick = function(self) exitbtn:GetParent():Close() end
	
	local function CreateModelPanel(panel, model, mat, i)
	
		local modelIcon = vgui.Create("DModelPanel", panel)
		function modelIcon:SetModel( strModelName )
			if ( IsValid( self.Entity ) ) then
				self.Entity:Remove()
				self.Entity = nil		
			end
			if ( !ClientsideModel ) then return end			
			self.Entity = ClientsideModel(strModelName, RENDER_GROUP_OPAQUE_ENTITY)
			if ( !IsValid(self.Entity) ) then return end			
			self.Entity:SetNoDraw( true )
		end
		modelIcon:SetModel(model)
		if mat then
			modelIcon:GetEntity():SetMaterial(mat)
		end
		function modelIcon:LayoutEntity(Entity)
			self:RunAnimation()
		end
		local min, max = modelIcon:GetEntity():GetRenderBounds()
		modelIcon:SetCamPos(min:Distance(max)*Vector(0.5, 0.5, 0.5))
		modelIcon:SetLookAt((max + min)/2)
		modelIcon:SetFOV(65)
		modelIcon:SetSize(TFScreenScale(32), TFScreenScale(32))
		modelIcon:SetPos(5, panel:GetTall()*0.5 - modelIcon:GetTall()*0.5)
		if i == FISH_GEAR_ROD then // pain in teh arse with dis fishing rod
			modelIcon:SetLookAt(min)
			local dir = (modelIcon:GetCamPos()-modelIcon:GetLookAt()):GetNormal()
			modelIcon:SetFOV(15)
			modelIcon:SetCamPos(modelIcon:GetCamPos()-dir*50)
			modelIcon.Entity:SetAngles(Angle(-35, 35, 180))
		elseif string.find(model, "FoodNHouseholdItems") then
			modelIcon:SetFOV(55)
			modelIcon.Entity:SetAngles(Angle(35, 0, -90))
		end
		modelIcon:SetMouseInputEnabled(false)
	
		return modelIcon
	end
	

	local function AddSellItem(parent, i)
		local panel = vgui.Create("DPanel", parent)
		panel:SetTall(TFScreenScale(40))
		panel.Paint = function(self)
			surface.SetDrawColor(39, 42, 51, 200)
			surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
			surface.SetDrawColor(50, 50, 50, 255)
			surface.DrawOutlinedRect(0, 0, self:GetWide(), self:GetTall())
			draw.SimpleText(TrueFishGetFishName(i), "FishingSS6", self:GetWide()*0.5, 0, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
			draw.SimpleText(TrueFishLocal("reward_txt", math.floor(TrueFish.FISH_PRICE[i])), "FishingSS9_NumberFix", self:GetWide()-5, self:GetTall()*0.5, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		end
		
		local modelIcon = CreateModelPanel(panel, TrueFishGetFishModel(i))
		
		parent:AddItem(panel)
	end
	
	for i=1, FISH_HIGHNUMBER do
		if !TrueFish.FISH_ENABLED[i] then continue end
		AddSellItem(left, i)
	end

	local function AddBuyItem(parent, i)
		local panel = vgui.Create("DPanel", parent)
		panel:SetTall(TFScreenScale(40))
		local button
		panel.Paint = function(self)
			surface.SetDrawColor(39, 42, 51, 200)
			surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
			surface.SetDrawColor(50, 50, 50, 255)
			surface.DrawOutlinedRect(0, 0, self:GetWide(), self:GetTall())
			draw.SimpleText(TrueFishGetGearName(i), "FishingSS6", self:GetWide()*0.5, 0, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
			local bX, bY = button:GetPos()
			draw.SimpleText(TrueFishLocal("price_txt", TrueFish.GEAR_PRICE[i]), "FishingSS6", bX+button:GetWide()-1, bY, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
		end
		
		local modelIcon = CreateModelPanel(panel, TrueFishGetGearModel(i), TrueFishGetGearMaterial(i), i)
		modelIcon:SetDirectionalLight( BOX_TOP, Color( 255, 255, 255 ) )
		modelIcon:SetDirectionalLight( BOX_FRONT, Color( 0, 0, 0 ) )
		
		button = vgui.Create("DButton", panel)
		button:SetSize(TFScreenScale(35), TFScreenScale(10))
		button:SetFont("FishingSS9")
		button:SetText(TrueFishLocal("purchase_txt"))
		button:SetColor(Color(250, 250, 250, 255))
		button:SetPos(parent:GetWide()-5-button:GetWide(), panel:GetTall()-button:GetTall()-5)
		button.Paint = function(self)
			surface.SetDrawColor(self.Hovered and Color(99, 102, 111, 200) or Color(69, 72, 81, 200))
			surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
			surface.SetDrawColor(46, 58, 84, 255)
			surface.DrawOutlinedRect(0, 0, self:GetWide(), self:GetTall())
		end
		button.DoClick = function(self)
			net.Start("Fish_buy")
			net.WriteEntity(npc)
			net.WriteUInt(i, 6)
			net.SendToServer()
			menu:Remove()
		end
		
		/*if !TrueFish.GEAR_ENABLED[i] then // need an overlay for disabled to go over the model icon too
			local overlay = vgui.Create("DPanel", panel)
			overlay:SetSize(panel:GetSize())
			overlay.Paint = function(self)
				surface.SetDrawColor(255, 0, 0, 100)
				surface.DrawRect(1, 1, self:GetWide()-2, self:GetTall()-2)
				draw.SimpleTextOutlined("Out Of Stock", "FishingSS9", self:GetWide()*0.5, self:GetTall()*0.5, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
			end
		end*/
		
		parent:AddItem(panel)
	end
	for i=1, FISH_GEAR_HIGHNUMBER do
		if !TrueFish.GEAR_ENABLED[i] then continue end
		AddBuyItem(middle, i)
	end

	local function AddYourItem(parent, i)
		local panel = vgui.Create("DPanel", parent)
		panel:SetTall(TFScreenScale(40))
		panel.Paint = function(self)
			surface.SetDrawColor(39, 42, 51, 200)
			surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
			surface.SetDrawColor(50, 50, 50, 255)
			surface.DrawOutlinedRect(0, 0, self:GetWide(), self:GetTall())
			draw.SimpleText(TrueFishGetFishName(i), "FishingSS6", self:GetWide()*0.5, 0, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
			draw.SimpleText("x"..FishToSell[i], "FishingSS9", self:GetWide()-5, self:GetTall()*0.5, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		end
		
		local modelIcon = CreateModelPanel(panel, TrueFishGetFishModel(i))
		
		parent:AddItem(panel)
	end
	
	if TotalSalePrice > 0 then
		for i=1, FISH_HIGHNUMBER do
			if FishToSell[i] then
				AddYourItem(right, i)
			end
		end
		
		local panel = vgui.Create("DPanel", right)
		surface.SetFont("FishingSS9_NumberFix")
		local txt = TrueFishLocal("fish_sells_for", TotalSalePrice)
		local x, y = surface.GetTextSize(txt)
		panel:SetTall(y*2+5)
		panel.Paint = function(self)
			draw.SimpleText(txt, "FishingSS9_NumberFix", self:GetWide()-3, 0, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT)
			surface.SetDrawColor(255, 255, 255, 255)
			surface.DrawLine(self:GetWide()-3, y, self:GetWide()-3-x, y)
		end
		
		surface.SetFont("FishingSS9_NumberFix")
		local x, y = surface.GetTextSize(txt)
		local button = vgui.Create("DButton", panel)
		button:SetSize(x, y)
		button:SetFont("FishingSS9")
		button:SetText(TrueFishLocal("sell_all"))
		button:SetColor(Color(250, 250, 250, 255))
		button:SetPos(right:GetWide()-button:GetWide()-3, panel:GetTall()-button:GetTall())
		button.Paint = function(self)
			surface.SetDrawColor(self.Hovered and Color(99, 102, 111, 200) or Color(69, 72, 81, 200))
			surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
			surface.SetDrawColor(46, 58, 84, 255)
			surface.DrawOutlinedRect(0, 0, self:GetWide(), self:GetTall())
		end
		button.DoClick = function(self)
			net.Start("Fish_sell")
			net.WriteEntity(npc)
			net.SendToServer()
			menu:Remove()
		end
		right:AddItem(panel)
	end


end
//FishNPCMenu()
net.Receive("FishNPCMenu", FishNPCMenu)