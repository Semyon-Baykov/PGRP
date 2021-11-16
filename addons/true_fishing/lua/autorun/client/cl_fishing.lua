
function TFScreenScale(num)
	if ScrW()/ScrH() > 3 then // trying to fix triple monitor resolution scaling
		return num * 3
	else
		return ScreenScale(num)
	end
end

local font = system.IsOSX() and "Trebuchet" or "Segoe UI"
surface.CreateFont("SegoeUI_NormalBold_60", {
	font 		= font,
	size 		= 60,
	weight 		= 650,
	blursize 	= 0,
	scanlines 	= 0,
	antialias 	= true
})
surface.CreateFont("SegoeUI_NormalBold_20", {
	font 		= font,
	size 		= 20,
	weight 		= 650,
	blursize 	= 0,
	scanlines 	= 0,
	antialias 	= true
})
surface.CreateFont("SegoeUI_NormalBoldScaled", {
	font 		= font,
	size 		= TFScreenScale(8.5),
	weight 		= 800,
	blursize 	= 0,
	scanlines 	= 0,
	antialias 	= true
})
surface.CreateFont("SegoeUI_Normal", {
	font 		= font,
	size 		= 26,
	weight 		= 400,
	blursize 	= 0,
	scanlines 	= 0,
	antialias 	= true
})
surface.CreateFont("SegoeUI_18", {
	font 		= font,
	size 		= 18,
	weight 		= 400,
	blursize 	= 0,
	scanlines 	= 0,
	antialias 	= true
})
surface.CreateFont("FishingS16", {
	font = font, 
	size = 16, 
	weight = 500,
	antialias = true
})
surface.CreateFont("FishingS20", {
	font = font, 
	size = 20, 
	weight = 600,
	antialias = true
})
surface.CreateFont("FishingS30", {
	font = font, 
	size = 30, 
	weight = 600,
	antialias = true,
})
surface.CreateFont("FishingS85", {
	font = font, 
	size = 85, 
	weight = 500,
	antialias = true
})
surface.CreateFont("FishingS55", {
	font = font, 
	size = 55, 
	weight = 500,
	antialias = true
})
surface.CreateFont("FishingSS6", {
	font = font, 
	size = TFScreenScale(8.5), 
	weight = 540,
	antialias = true
})
surface.CreateFont("FishingSS9", {
	font = font, 
	size = TFScreenScale(9), 
	weight = 600,
	antialias = true
})
surface.CreateFont("FishingSS9_NumberFix", {
	font = font, 
	size = TFScreenScale(9), 
	weight = 650,
	antialias = true
})

net.Receive("FishConfigUpdate", function()
	LocalPlayer().TrueFishSynced = true
	
	local num = net.ReadUInt(6)	
	for i=1, num do
		TrueFish[net.ReadString()] = net.ReadType()
	end
end)

hook.Add("Move", "TrueFishSync", function() // ayy this works pretty well
	if !LocalPlayer().TrueFishSynced then
		net.Start("FishAskConfig")
		net.SendToServer()

		hook.Remove("Move", "TrueFishSync")
	end
end)

local configVariables = {}
local function addConfig(tbl)
	table.insert(configVariables, tbl)
end
addConfig{"Language to be used everywhere, except this config menu.", "LOCALISATION_LANGUAGE"}
addConfig{"Restrict the Fisherman NPC to a specific job, preventing other jobs from fishing.", "FISHING_JOB_RESTRICTION"}
addConfig{"Allows players' PhysGun to pick up Fish Cages and Containers.", "CAN_PHYSGUN_GEAR"}
addConfig{"Fish cages and buoys will be frozen when deployed.", "OPTIMIZED_FISHING"}
addConfig{"Fish cages will not render fish models.", "CAGE_NO_FISH_MODEL"}
addConfig{"Fish cage's buoy will make water splash when the fish cage is full of fish.", "CAGE_BUOY_SPLASHING"}
addConfig{"Limits the amount of fishes a Medium Fish Cage can catch.", "MEDIUM_CAGE_FISH_LIMIT"}
addConfig{"Limits the amount of fishes a Large Fish Cage can catch.", "LARGE_CAGE_FISH_LIMIT"}
addConfig{"Limits the amount of fishes a Fish Container can hold.", "FISH_CONTAINER_LIMIT"}
addConfig{"Fish from cages will be directly collected by the player, instead of the Fish Container.", "CONTAINERS_DISABLED"}
addConfig{"Limits the amount of Medium Fish Cages a player can buy.", "MEDIUM_CAGE_LIMIT"}
addConfig{"Limits the amount of Large Fish Cages a player can buy.", "LARGE_CAGE_LIMIT"}
addConfig{"Limits the amount of Fish Containers a player can buy.", "CONTAINER_LIMIT"}
addConfig{"Both Medium and Large Fish Cages will share the same limit. However, Medium Fish Cage limit will be used.", "CAGE_SHARED_LIMIT"}
addConfig{"Limits the amount of fish a player can carry when fish isn't added to a Fish Container.", "FISH_CARRY_LIMIT"}
addConfig{"Fish caught while fishing with a rod will be collected by the player instead of a Fish Container.", "ROD_NO_CONTAINER"}
addConfig{"Fishing Rods will use a physical hook, fish caught will be hooked for the player to pick up.", "ROD_PHYSICS_FISHING"}
addConfig{"Fishing Rods will use a different catch time, instead of the one based on fish types.", "ROD_SEPERATE_CATCH_TIME_ENABLED"}
addConfig{"Fishing Rod catch time (s). The above setting must be enabled for this to work.", "ROD_SEPERATE_CATCH_TIME"}
addConfig{"Limits how much time a player has to react (in %) when using a Fishing Rod to catch a fish. Ex: 10% of 10s catch time would give the player 1 second to react.", "ROD_CATCH_WINDOW", function(val) return val*100 end, function(val) return val/100 end}
addConfig{"Limits the amount of times a player can fish with one Fish Bait use, when using a Fishing Rod.", "ROD_FISH_BAIT_AMOUNT"}
addConfig{"Limit the chance (in %) Fishing Rods will catch a bag with money.", "ROD_MONEYBAG_CHANCE"}
addConfig{"Limit the amount of money inside a money bag, that you can catch with a Fishing Rod.", "ROD_MONEYBAG_MONEY"}
addConfig{"Allow only the Fish Container owner to discard the fish.", "FISH_CONTAINER_OWNER_DISCARD"}
addConfig{"Automatically remove unused Fish Bait after X seconds of inuse. Use 0 seconds if you don't want them to be removed.", "FISH_BAIT_AUTOREMOVE"}
//addConfig{"", ""}

local menu
net.Receive("FishConfigMenu", function(len)
	//print("Size: "..(len/8).."B")
	TrueFish = net.ReadTable()

	local function NetworkChanges(var, val)
		//print(var,val)
		net.Start("FishConfigVarChange")
		net.WriteString(var)
		net.WriteType(val)
		net.SendToServer()
	end
	local function NetworkFishChanges(var)
		//print(var)
		net.Start("FishVarChange")
		net.WriteString(var)
		net.WriteTable(TrueFish[var])
		net.SendToServer()
	end

	if menu and menu.IsValid then menu:Remove() menu = nil end

	local sizeX, sizeY = 700, 600
	menu = vgui.Create("DFrame")
	menu:SetTitle("")
	menu:ShowCloseButton(false)
	menu:SetSize(sizeX, sizeY)
	menu:Center()
	menu:MakePopup()
	menu.Paint = function(self)
		
		draw.RoundedBoxEx(8, 0, 0, self:GetWide(), 40, Color(47, 54, 76, 255), true, true)
		draw.SimpleText("Fishing Configuration", "FishingS30", self:GetWide()*0.5, 4, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
		draw.SimpleText("by Tomasas", "FishingS16", self:GetWide()*0.99, 22, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT)
		draw.RoundedBoxEx(8, 0, self:GetTall()-40, self:GetWide(), 40, Color(47, 54, 76, 255), false, false, true, true)
		surface.SetDrawColor(30, 34, 43, 255)
		surface.DrawRect(0, 40, self:GetWide(), self:GetTall()-80)
		
		surface.SetDrawColor(50, 50, 50, 255)
		surface.DrawOutlinedRect(0, 40, self:GetWide(), self:GetTall()-80)

	end

	local panelListPaint = function(self)
		surface.SetDrawColor(34, 37, 47, 255)
		surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
		surface.SetDrawColor(50, 50, 50, 255)
		surface.DrawOutlinedRect(0, 0, self:GetWide(), self:GetTall())
	end
	local left = vgui.Create("DPanelList", menu) // devide to left
	left:EnableVerticalScrollbar(true)
	left:SetSize(menu:GetWide()*0.5-5, menu:GetTall()-80)
	left:SetPos(0, 40)
	left.Paint = panelListPaint

	local sbarLeft = left.VBar
	function sbarLeft:Paint( w, h )
	end
	sbarLeft.btnUp.Paint = sbarLeft.Paint
	sbarLeft.btnDown.Paint = sbarLeft.Paint
	function sbarLeft.btnGrip:Paint( w, h )
		draw.RoundedBox(4, 0, 0, w-1, h, Color(200, 200, 200, 10))
	end

	local right = vgui.Create("DPanelList", menu) // devide to right
	right:EnableVerticalScrollbar(true)
	right:SetSize(menu:GetWide()*0.5-5, menu:GetTall()-80)
	right:SetPos(left:GetPos()+left:GetWide()+10, 40)
	right.Paint = panelListPaint

	local sbarRight = right.VBar
	sbarRight.Paint = sbarLeft.Paint
	sbarRight.btnUp.Paint = sbarRight.Paint
	sbarRight.btnDown.Paint = sbarRight.Paint
	sbarRight.btnGrip.Paint = sbarLeft.btnGrip.Paint

	for i=1, #configVariables do // populating right side of the menu with variables
		local panel = vgui.Create("DPanel", right)
		panel.Paint=panelListPaint
		local valuebox
		
		local f = function(p, val)
			val = tonumber(val) // dis some booshit derma does, numberwang returning a string sometimes
			TrueFish[configVariables[i][2]] = configVariables[i][4] and configVariables[i][4](val) or val
			NetworkChanges(configVariables[i][2], TrueFish[configVariables[i][2]])
		end
		local f2 = function(p, val)
			TrueFish[configVariables[i][2]] = tobool(val)
			NetworkChanges(configVariables[i][2], TrueFish[configVariables[i][2]])
		end

		if type(TrueFish[configVariables[i][2]]) == "boolean" then
			valuebox = vgui.Create("DCheckBox", panel)
			valuebox:SetValue(TrueFish[configVariables[i][2]])
			valuebox.OnChange = f2
		elseif configVariables[i][2] == "LOCALISATION_LANGUAGE" or configVariables[i][2] == "FISHING_JOB_RESTRICTION" then
			valuebox = vgui.Create("DComboBox", panel)
			valuebox:SetWide(48)
			if configVariables[i][2] == "LOCALISATION_LANGUAGE" then
				for k, v in pairs(TrueFishLanguages()) do
					valuebox:AddChoice(k)
				end
			else
				valuebox:SetSortItems(false)
				valuebox:AddChoice("None")
				for k, v in pairs(team.GetAllTeams()) do
					valuebox:AddChoice(v.Name)
				end
			end
			valuebox:SetValue(TrueFish[configVariables[i][2]])
			valuebox.OnSelect = function(p, index, val)
				TrueFish[configVariables[i][2]] = val
				NetworkChanges(configVariables[i][2], TrueFish[configVariables[i][2]])
			end
		else
			valuebox = vgui.Create("DNumberWang", panel)
			valuebox:SetMinMax(0, 9999)
			valuebox:SetWide(40)
			valuebox:SetValue(configVariables[i][3] and configVariables[i][3](TrueFish[configVariables[i][2]]) or TrueFish[configVariables[i][2]])
			valuebox.OnValueChanged = f
		end
		local textbox = vgui.Create("DLabel", panel)
		textbox:SetTextColor(color_white)
		textbox:SetWrap(true)
		textbox:SetText(configVariables[i][1])
		textbox:SetSize(right:GetWide()*0.82, 40)
		textbox:SetPos(right:GetWide()*0.15, 0)
		
		panel:SetTall(textbox:GetTall())	
		valuebox:SetPos(right:GetWide()*0.15*0.5-valuebox:GetWide()*0.5, panel:GetTall()*0.5-valuebox:GetTall()*0.5)

		right:AddItem(panel)
		
	end

	for i=1, FISH_HIGHNUMBER do // populating left side of the menu with stuff
		local panel = vgui.Create("DPanel", left)
		panel:SetTall(86)
		panel.Paint=panelListPaint
		
		local textbox = vgui.Create("DLabel", panel)
		textbox:SetFont("FishingS16")
		textbox:SetTextColor(color_white)
		textbox:SetText(TrueFishGetFishName(i))
		textbox:SizeToContents()
		textbox:SetPos(left:GetWide()*0.5-textbox:GetWide()*0.5, 1)
		
		local modelIcon = vgui.Create("SpawnIcon", panel)
		modelIcon:SetModel(TrueFishGetFishModel(i))
		modelIcon:SetMouseInputEnabled(false)
		modelIcon:SetSize(64, 64)
		modelIcon:SetPos(0, panel:GetTall()*0.5-modelIcon:GetTall()*0.5)
		
		
		if i != FISH_JUNK then
			local enabled = vgui.Create("DCheckBox", panel)
			enabled:SetValue(TrueFish.FISH_ENABLED[i])
			enabled:SetPos(left:GetWide()-75, panel:GetTall()*0.5-enabled:GetTall()*0.5)
			
			local textbox2 = vgui.Create("DLabel", panel)
			textbox2:SetFont("FishingS16")
			textbox2:SetTextColor(color_white)
			textbox2:SetText("Enabled")
			textbox2:SizeToContents()
			local x, y = enabled:GetPos()
			textbox2:SetPos(x+17, y)
			
			
			local textbox3 = vgui.Create("DLabel", panel)
			textbox3:SetFont("FishingS16")
			textbox3:SetTextColor(color_white)
			textbox3:SetText("Depth from")
			textbox3:SizeToContents()
			textbox3:SetPos(74, 20)

			local depthMin = vgui.Create("DNumberWang", panel)
			depthMin:SetMinMax(0, 3000)
			depthMin:SetWide(40)
			depthMin:SetValue(TrueFish.FISH_DEPTH[i][1])
			local x, y = textbox3:GetPos()
			depthMin:SetPos(x+textbox3:GetWide()+2, y-2)
			
			local textbox4 = vgui.Create("DLabel", panel)
			textbox4:SetFont("FishingS16")
			textbox4:SetTextColor(color_white)
			textbox4:SetText("to")
			textbox4:SizeToContents()
			local x, y = depthMin:GetPos()
			textbox4:SetPos(x+depthMin:GetWide()+2, y+2)
			
			local depthMax = vgui.Create("DNumberWang", panel)
			depthMax:SetMinMax(0, 3000)
			depthMax:SetWide(40)
			depthMax:SetValue(TrueFish.FISH_DEPTH[i][2])
			local x, y = textbox4:GetPos()
			depthMax:SetPos(x+textbox4:GetWide()+1, y-2)
			
			
			local textbox6 = vgui.Create("DLabel", panel)
			textbox6:SetFont("FishingS16")
			textbox6:SetTextColor(color_white)
			textbox6:SetText("Catch time in (s)")
			textbox6:SizeToContents()
			local x, y = textbox3:GetPos()
			textbox6:SetPos(x, y+22)

			local timeMin = vgui.Create("DNumberWang", panel)
			timeMin:SetMinMax(0, 3000)
			timeMin:SetWide(40)
			timeMin:SetValue(TrueFish.FISH_CATCH_TIME[i][1])
			local x, y = textbox6:GetPos()
			timeMin:SetPos(x+textbox6:GetWide()+2, y-2)
			
			local textbox7 = vgui.Create("DLabel", panel)
			textbox7:SetFont("FishingS16")
			textbox7:SetTextColor(color_white)
			textbox7:SetText("to")
			textbox7:SizeToContents()
			local x, y = timeMin:GetPos()
			textbox7:SetPos(x+timeMin:GetWide()+2, y+2)
			
			local timeMax = vgui.Create("DNumberWang", panel)
			timeMax:SetMinMax(0, 3000)
			timeMax:SetWide(40)
			timeMax:SetValue(TrueFish.FISH_CATCH_TIME[i][2])
			local x, y = textbox7:GetPos()
			timeMax:SetPos(x+textbox7:GetWide()+1, y-2)
			
			local textbox5 = vgui.Create("DLabel", panel)
			textbox5:SetFont("FishingS16")
			textbox5:SetTextColor(color_white)
			textbox5:SetText("Reward $")
			textbox5:SizeToContents()
			local x, y = textbox6:GetPos()
			textbox5:SetPos(x, y+22)

			local price = vgui.Create("DNumberWang", panel)
			price:SetMinMax(0, 3000)
			price:SetWide(40)
			price:SetValue(TrueFish.FISH_PRICE[i])
			local x, y = textbox5:GetPos()
			price:SetPos(x+textbox5:GetWide()+2, y-2)
			
			local loseFocus = function(p, gained)
				if !gained then
					p:OnValueChanged(p:GetValue())
				end
			end
			depthMin.OnFocusChanged = loseFocus
			depthMax.OnFocusChanged = loseFocus
			timeMin.OnFocusChanged = loseFocus
			timeMax.OnFocusChanged = loseFocus
			
			local ignoreLoopback = false
			depthMin.OnValueChanged = function(p, val)
				if ignoreLoopback then ignoreLoopback = false return true end
				val = tonumber(val)
				if val > TrueFish.FISH_DEPTH[i][2] and !p:HasFocus() then
					p:FocusNext()
				end				
				TrueFish.FISH_DEPTH[i][1] = math.Clamp(val, val, TrueFish.FISH_DEPTH[i][2])
				ignoreLoopback = true
				timer.Simple(0, function() p:SetValue(TrueFish.FISH_DEPTH[i][1]) end) // so much hoops to jump just to have limiting work properly.. i love derma /s
				NetworkFishChanges("FISH_DEPTH")
			end
			depthMax.OnValueChanged = function(p, val)
				if ignoreLoopback then ignoreLoopback = false return true end
				val = tonumber(val)
				if val < TrueFish.FISH_DEPTH[i][1] and !p:HasFocus() then
					p:FocusNext()
				end				
				TrueFish.FISH_DEPTH[i][2] = math.Clamp(val, TrueFish.FISH_DEPTH[i][1], val)
				ignoreLoopback = true
				timer.Simple(0, function() p:SetValue(TrueFish.FISH_DEPTH[i][2]) end)
				NetworkFishChanges("FISH_DEPTH")
			end
			
			timeMin.OnValueChanged = function(p, val)
				if ignoreLoopback then ignoreLoopback = false return true end
				val = tonumber(val)
				if val > TrueFish.FISH_CATCH_TIME[i][2] and !p:HasFocus() then
					p:FocusNext()
				end				
				TrueFish.FISH_CATCH_TIME[i][1] = math.Clamp(val, val, TrueFish.FISH_CATCH_TIME[i][2])
				ignoreLoopback = true
				timer.Simple(0, function() p:SetValue(TrueFish.FISH_CATCH_TIME[i][1]) end)
				NetworkFishChanges("FISH_CATCH_TIME")
			end
			timeMax.OnValueChanged = function(p, val)
				if ignoreLoopback then ignoreLoopback = false return true end
				val = tonumber(val)
				if val < TrueFish.FISH_CATCH_TIME[i][1] and !p:HasFocus() then
					p:FocusNext()
				end				
				TrueFish.FISH_CATCH_TIME[i][2] = math.Clamp(val, TrueFish.FISH_CATCH_TIME[i][1], val)
				ignoreLoopback = true
				timer.Simple(0, function() p:SetValue(TrueFish.FISH_CATCH_TIME[i][2]) end)
				NetworkFishChanges("FISH_CATCH_TIME")
			end
			
			price.OnValueChanged = function(p, val)
				TrueFish.FISH_PRICE[i] = tonumber(val)
				NetworkFishChanges("FISH_PRICE")
			end
			
			enabled.OnChange = function(p, val)
				TrueFish.FISH_ENABLED[i] = tobool(val)
				NetworkFishChanges("FISH_ENABLED")
			end
			
		else
		
			panel:SetTall(panel:GetTall()+22)
			local textbox = vgui.Create("DLabel", panel)
			textbox:SetFont("FishingS16")
			textbox:SetTextColor(color_white)
			textbox:SetText("Medium Cage fish junk drop chance")
			textbox:SizeToContents()
			textbox:SetPos(74, 20)

			local percentage = vgui.Create("DNumberWang", panel)
			percentage:SetMinMax(0, 100)
			percentage:SetWide(40)
			percentage:SetValue(TrueFish.MEDIUM_JUNK_CHANCE/10)
			local x, y = textbox:GetPos()
			percentage:SetPos(x+textbox:GetWide()+2, y-2)
			
			local percentlabel = vgui.Create("DLabel", panel)
			percentlabel:SetFont("FishingS16")
			percentlabel:SetTextColor(color_white)
			percentlabel:SetText("%")
			percentlabel:SizeToContents()
			local x, y = percentage:GetPos()
			percentlabel:SetPos(x+percentage:GetWide()+2, y+2)
			
			local textbox2 = vgui.Create("DLabel", panel)
			textbox2:SetFont("FishingS16")
			textbox2:SetTextColor(color_white)
			textbox2:SetText("Large Cage fish junk drop chance")
			textbox2:SizeToContents()
			local x, y = textbox:GetPos()
			textbox2:SetPos(74, y+22)

			local percentage2 = vgui.Create("DNumberWang", panel)
			percentage2:SetMinMax(0, 100)
			percentage2:SetWide(40)
			percentage2:SetValue(TrueFish.LARGE_JUNK_CHANCE/10)
			local x, y = textbox2:GetPos()
			percentage2:SetPos(x+textbox2:GetWide()+2, y-2)
			
			local percentlabel2 = vgui.Create("DLabel", panel)
			percentlabel2:SetFont("FishingS16")
			percentlabel2:SetTextColor(color_white)
			percentlabel2:SetText("%")
			percentlabel2:SizeToContents()
			local x, y = percentage2:GetPos()
			percentlabel2:SetPos(x+percentage2:GetWide()+2, y+2)
			
			local textbox3 = vgui.Create("DLabel", panel)
			textbox3:SetFont("FishingS16")
			textbox3:SetTextColor(color_white)
			textbox3:SetText("Fishing Rod fish junk drop chance")
			textbox3:SizeToContents()
			local x, y = textbox2:GetPos()
			textbox3:SetPos(74, y+22)

			local percentage3 = vgui.Create("DNumberWang", panel)
			percentage3:SetMinMax(0, 100)
			percentage3:SetWide(40)
			percentage3:SetValue(TrueFish.ROD_JUNK_CHANCE/10)
			local x, y = textbox3:GetPos()
			percentage3:SetPos(x+textbox3:GetWide()+2, y-2)
			
			local percentlabel3 = vgui.Create("DLabel", panel)
			percentlabel3:SetFont("FishingS16")
			percentlabel3:SetTextColor(color_white)
			percentlabel3:SetText("%")
			percentlabel3:SizeToContents()
			local x, y = percentage3:GetPos()
			percentlabel3:SetPos(x+percentage3:GetWide()+2, y+2)
			
			local textbox4 = vgui.Create("DLabel", panel)
			textbox4:SetFont("FishingS16")
			textbox4:SetTextColor(color_white)
			textbox4:SetText("Reward $")
			textbox4:SizeToContents()
			local x, y = textbox3:GetPos()
			textbox4:SetPos(x, y+22)

			local price = vgui.Create("DNumberWang", panel)
			price:SetMinMax(0, 3000)
			price:SetWide(40)
			price:SetValue(TrueFish.FISH_PRICE[i])
			local x, y = textbox4:GetPos()
			price:SetPos(x+textbox4:GetWide()+2, y-2)
			
			percentage.OnValueChanged = function(p, val)
				TrueFish.MEDIUM_JUNK_CHANCE = tonumber(val)*10
				NetworkChanges("MEDIUM_JUNK_CHANCE", TrueFish.MEDIUM_JUNK_CHANCE)
			end
			
			percentage2.OnValueChanged = function(p, val)
				TrueFish.LARGE_JUNK_CHANCE = tonumber(val)*10
				NetworkChanges("LARGE_JUNK_CHANCE", TrueFish.LARGE_JUNK_CHANCE)
			end
			
			percentage3.OnValueChanged = function(p, val)
				TrueFish.ROD_JUNK_CHANCE = tonumber(val)*10
				NetworkChanges("ROD_JUNK_CHANCE", TrueFish.ROD_JUNK_CHANCE)
			end
			
			price.OnValueChanged = function(p, val)
				TrueFish.FISH_PRICE[i] = tonumber(val)
				NetworkFishChanges("FISH_PRICE")
			end
		end
		

		left:AddItem(panel)
		
	end

	for i=1, FISH_GEAR_HIGHNUMBER do // populating left side of the menu with stuff
		local panel = vgui.Create("DPanel", left)
		panel:SetTall(64)
		panel.Paint=panelListPaint
		
		local textbox = vgui.Create("DLabel", panel)
		textbox:SetFont("FishingS16")
		textbox:SetTextColor(color_white)
		textbox:SetText(TrueFishGetGearName(i))
		textbox:SizeToContents()
		textbox:SetPos(left:GetWide()*0.5-textbox:GetWide()*0.5, 1)
		
		local modelIcon = vgui.Create("SpawnIcon", panel)
		modelIcon:SetModel(TrueFishGetGearModel(i))
		modelIcon:SetMouseInputEnabled(false)
		modelIcon:SetSize(64, 64)
		modelIcon:SetPos(0, 5)
		
		
		local enabled = vgui.Create("DCheckBox", panel)
		enabled:SetValue(TrueFish.GEAR_ENABLED[i])
		enabled:SetPos(left:GetWide()-75, panel:GetTall()*0.5-enabled:GetTall()*0.5)
		
		local textbox2 = vgui.Create("DLabel", panel)
		textbox2:SetFont("FishingS16")
		textbox2:SetTextColor(color_white)
		textbox2:SetText("Enabled")
		textbox2:SizeToContents()
		local x, y = enabled:GetPos()
		textbox2:SetPos(x+17, y)
		
		
		local textbox5 = vgui.Create("DLabel", panel)
		textbox5:SetFont("FishingS16")
		textbox5:SetTextColor(color_white)
		textbox5:SetText("Price $")
		textbox5:SizeToContents()
		textbox5:SetPos(74, panel:GetTall()*0.5-textbox5:GetTall()*0.5)

		local price = vgui.Create("DNumberWang", panel)
		price:SetMinMax(0, 3000)
		price:SetWide(40)
		price:SetValue(TrueFish.GEAR_PRICE[i])
		local x, y = textbox5:GetPos()
		price:SetPos(x+textbox5:GetWide()+2, y-2)
		
		
		price.OnValueChanged = function(p, val)
			TrueFish.GEAR_PRICE[i] = tonumber(val)
			NetworkFishChanges("GEAR_PRICE")
		end
		
		enabled.OnChange = function(p, val)
			TrueFish.GEAR_ENABLED[i] = tobool(val)
			NetworkFishChanges("GEAR_ENABLED")
		end
		
		left:AddItem(panel)	

	end

	local exit = vgui.Create("DButton", menu)
	exit:SetSize(100, 30)
	exit:SetFont("FishingS16")
	exit:SetText("Done")
	exit:SetColor(Color(250, 250, 250, 255))
	exit:SetPos(menu:GetWide()*0.5-exit:GetWide()*0.5, menu:GetTall()-35)
	exit.Paint = function(self)
		surface.SetDrawColor(self.Hovered and Color(99, 102, 111, 255) or Color(69, 72, 81, 255))
		surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
		surface.SetDrawColor(50, 50, 50, 255)
		surface.DrawOutlinedRect(0, 0, self:GetWide(), self:GetTall())
	end
	exit.DoClick = function(self)
		self:GetParent():Remove()
	end


end)
