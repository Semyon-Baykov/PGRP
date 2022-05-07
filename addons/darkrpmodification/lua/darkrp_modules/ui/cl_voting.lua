surface.CreateFont("DarkRPVoteButtonText", {
	font = "Arial",
	size = 15,
	weight = 100,
	antialias = true,
})

surface.CreateFont("gpVote", {
	font = "Roboto",
	size = 18,
	weight = 300,
})

local QuestionVGUI = {}
local PanelNum = 0
local PanelOffSet = 0
local VoteVGUI = {}
local VoteVGUI_vote = {}
local Count = table.Count
local math = math
  
local function MsgDoVote( qs, str, id, time, ply )
	local question
	local voteid = 0
	local timeleft
	local pl
	local quesid
	if qs == false then
		question = str
		voteid = id
		timeleft = time
		pl = ply
	else
		question = str
		quesid = id
		timeleft = time
	end

	if timeleft == 0 then
		timeleft = 100
	end

	local OldTime = CurTime()

	if not IsValid(LocalPlayer()) then return end
	LocalPlayer():EmitSound("Town.d1_town_02_elevbell1", 100, 100)
	question = question:gsub("\n"," ")
	question = DarkRP.textWrap( question, "DarkRPVoteButtonText", 350 - 12)
	
	local hifagenda = 0
	local dist = 5

	local PanelOpacity = 250
	local panelh = 65
	if question:find("\n") then
		question = question:sub(1, question:len() - 1) .. "..."
		panelh = 75
	end
	
	local panel = vgui.Create("DFrame")
	panel:SetPos(ScrW()/2-200-10,-150)
	panel:SetSize(400, panelh)
	panel:MoveTo(ScrW()/2-200, 25+ PanelOffSet, 0.2)
	panel:SetTitle("")
	panel:SetSizable(false)
	panel.btnMaxim:SetVisible(false)                               
	panel.btnMinim:SetVisible(false)
	panel.btnClose:SetVisible(false)
	panel:SetDraggable(false)
	panel.Paint = function( _, w, h )
		local time = math.Clamp(timeleft - (CurTime() - OldTime), 0, 9999)
		gp_inv.blur( _, 5, 10, 255 )
		
		surface.SetDrawColor( 0, 0, 0, 170)
		surface.DrawRect(0, 0, panel:GetWide(), panel:GetTall())

		surface.SetDrawColor(255, 255, 255, 7)
		surface.DrawOutlinedRect(1, 1, panel:GetWide()-2, panel:GetTall()-2)
		if voteid == 1337 then
			surface.SetDrawColor(255, 0, 0)	
		else
			surface.SetDrawColor(0, 182, 249)	
		end
		surface.DrawRect(2, 2, time * (panel:GetWide() / timeleft) - 2, 3)
	end
	
	PanelOffSet = PanelOffSet + panel:GetTall() + dist
	
	if Count(VoteVGUI_vote)==0 then panel.now = true end
	VoteVGUI_vote[voteid..'_vote'] = panel	

	local label = vgui.Create("DLabel", panel)
	label:SetPos(6, 12)
	label:SetFont("gpVote")
	label:SetText(question)
	label:SetTextColor( Color(255, 255, 255) )
	label:SizeToContents()
	label:SetVisible(true)

	function panel:Close()
		VoteVGUI_vote[voteid..'_vote'] = nil
		PanelOffSet = PanelOffSet - panel:GetTall() - dist
		
		local num = hifagenda
		for k,v in SortedPairs(VoteVGUI_vote) do
			v:MoveTo(ScrW()/2-200, 25+num, 0.2)
			v.now = true
			num = num + v:GetTall() + dist
		end

		self:Remove()
	end	

	function panel:Think()
		if timeleft - (CurTime() - OldTime or 0) <= 0 then
			panel:Close()
			if voteid == 1337 then
				net.Start('GPortalRP_Reasonsys')
					net.WriteString('no')
					net.WriteString('')
					net.WriteEntity(pl)
				net.SendToServer()
			elseif voteid == 565 then
				LocalPlayer():ConCommand('gang_no')
				panel:Close()
			end
		end
			
		if panel.now then
			if input.IsKeyDown(KEY_F6) && not next_keydown then
				if voteid == 1337 then 
					arrestmenu(pl)
					panel:Close()
					next_keydown=true
				elseif voteid == 565 then
					LocalPlayer():ConCommand('gang_ok')
					panel:Close()
				elseif qs == true then
					LocalPlayer():ConCommand("ans " .. quesid .. " 1\n")
					panel:Close()
				else			
					print( voteid..' yea' )
	 				LocalPlayer():ConCommand("vote " .. voteid .. " yea\n")	
					panel:Close()
					next_keydown=true
				end

			elseif input.IsKeyDown(KEY_F7) && not next_keydown  then
				if voteid == 1337 then 
				
					net.Start('GPortalRP_Reasonsys')
						net.WriteString('no')
						net.WriteString('')
						net.WriteEntity(pl)
					net.SendToServer()
					panel:Close()
					next_keydown=true
				elseif voteid == 565 then
				LocalPlayer():ConCommand('gang_no')
				panel:Close()
				elseif qs == true then
					LocalPlayer():ConCommand("ans " .. quesid .. " 2\n")
					panel:Close()

				else			
	 				LocalPlayer():ConCommand("vote " .. voteid .. " yea\n")	
					panel:Close()
					next_keydown=true

				end
			end
			if not input.IsKeyDown(KEY_F6) && not input.IsKeyDown(KEY_F7) then
				next_keydown=false	
			end
		end
	end


	local ybutton = vgui.Create("Button")
	ybutton:SetParent(panel)
	ybutton:SetPos(280, panel:GetTall() - 25)
	ybutton:SetSize(50, 20)
	ybutton:SetText("")
	ybutton:SetVisible(true)
	ybutton.Paint = function()
		surface.SetDrawColor(200, 255, 200, 70)
		surface.DrawRect(0, 0, ybutton:GetWide(), ybutton:GetTall())
		draw.SimpleText(panel.now and "Да (F6)" or 'Да', "DarkRPVoteButtonText", ybutton:GetWide() / 2, ybutton:GetTall() / 2, Color(255,255,255), 1, 1)
	end
	ybutton.DoClick = function()
		if voteid == 1337 then
			arrestmenu(pl)
			panel:Close()
		elseif voteid == 565 then
					LocalPlayer():ConCommand('gang_ok')
					panel:Close()
		elseif qs == true then
			LocalPlayer():ConCommand("ans " .. quesid .. " 1\n")
			panel:Close()
		else
			LocalPlayer():ConCommand("vote " .. voteid .. " yea\n")
			panel:Close()
		end
	end

	local nbutton = vgui.Create("Button")
	nbutton:SetParent(panel)
	nbutton:SetPos(340, panel:GetTall() - 25)
	nbutton:SetSize(50, 20)
	nbutton:SetText("")
	nbutton:SetVisible(true)
	nbutton.Paint = function()
		surface.SetDrawColor(255, 200, 200, 70)
		surface.DrawRect(0, 0, nbutton:GetWide(), nbutton:GetTall())
		draw.SimpleText(panel.now and "Нет (F7)" or 'Нет', "DarkRPVoteButtonText", nbutton:GetWide() / 2, nbutton:GetTall() / 2, Color(255,255,255), 1, 1)
	end
	nbutton.DoClick = function()
		if voteid == 1337 then
    		net.Start('GPortalRP_Reasonsys')
				net.WriteString('no')
				net.WriteString('')
				net.WriteEntity(pl)
				net.SendToServer()
			panel:Close()
			elseif voteid == 565 then
					LocalPlayer():ConCommand('gang_no')
					panel:Close()
		elseif qs == true then
			LocalPlayer():ConCommand("ans " .. quesid .. " 2\n")
			panel:Close()
		else
			LocalPlayer():ConCommand("vote " .. voteid .. " nay\n")
			panel:Close()
		end
	end
end


net.Receive( 'DarkRP_DoVote', function()

	local str = net.ReadString()
	local id = net.ReadInt( 7 )
	local time = net.ReadFloat()

	MsgDoVote( false, str, id, time )

end)

local function KillVoteVGUI(id)

	if VoteVGUI_vote[id .. "vote"] and VoteVGUI_vote[id .. "vote"]:IsValid() then
		VoteVGUI_vote[id.."vote"]:Close()

	end
end

net.Receive( 'DarkRP_KillVoteVGUI', function()


	local id = net.ReadInt( 7 )

	KillVoteVGUI( id )

end )


local function MsgDoQuestion(msg)
	local question = msg:ReadString()
	local quesid = msg:ReadString()
	local timeleft = msg:ReadFloat()
	if timeleft == 0 then
		timeleft = 100
	end
	local OldTime = CurTime()
	LocalPlayer():EmitSound("Town.d1_town_02_elevbell1", 100, 100)
	
	--panel:SetPos(3 + PanelNum, ScrH() / 2 - 50)
	local panel = vgui.Create("DFrame")
	panel:SetPos(3 + PanelNum, ScrH() / 2 - 50)
	panel:SetSize(300, 140)
	panel:SetSizable(false)
	panel:SetTitle('')
	panel.btnClose:SetVisible(false)
	panel:SetKeyboardInputEnabled(false)
	panel:SetMouseInputEnabled(true)
	panel:SetVisible(true)
	panel.Paint = function ()
		local time = math.Clamp(timeleft - (CurTime() - OldTime), 0, 9999)
		
		
		gp_inv.blur( _, 5, 10, 255 )
		
		surface.SetDrawColor( 0, 0, 0, 170)
		surface.DrawRect(0, 0, panel:GetWide(), panel:GetTall())


		surface.SetDrawColor(255, 255, 255, 7)
		surface.DrawOutlinedRect(1, 1, panel:GetWide()-2, panel:GetTall()-2)
		
		surface.SetDrawColor(0, 182, 249)	
		surface.DrawRect(2, 2, time * (panel:GetWide() / timeleft) - 2, 3)
	end

	function panel:Close()
		PanelNum = PanelNum - 300
		QuestionVGUI[quesid .. "ques"] = nil
		local num = 0
		for k,v in SortedPairs(VoteVGUI) do
			v:SetPos(num, ScrH() / 2 - 50)
			num = num + 140
		end

		for k,v in SortedPairs(QuestionVGUI) do
			v:SetPos(num, ScrH() / 2 - 50)
			num = num + 300
		end

		self:Remove()
	end

	function panel:Think()
		if timeleft - (CurTime() - OldTime) <= 0 then
			panel:Close()
		end
	end

	local label = vgui.Create("DLabel")
	label:SetParent(panel)
	label:SetPos(5, 10)
	label:SetSize(380, 40)
	label:SetText(DarkRP.deLocalise(question))
	label:SetVisible(true)

	local divider = vgui.Create("Divider")
	divider:SetParent(panel)
	divider:SetPos(2, 80)
	divider:SetSize(380, 2)
	divider:SetVisible(true)

	local ybutton = vgui.Create("DButton")
	ybutton:SetParent(panel)
	ybutton:SetPos(105, 100)
	ybutton:SetSize(40, 20)
	ybutton:SetText(DarkRP.getPhrase("yes"))
	ybutton:SetVisible(true)
	ybutton.DoClick = function()
		LocalPlayer():ConCommand("ans " .. quesid .. " 1\n")
		panel:Close()
	end
	ybutton.Paint = function(_,w,h)

		draw.RoundedBox( 1, 0, 0, w, h, Color( 150, 150, 150 ) )

	end
	local nbutton = vgui.Create("DButton")
	nbutton:SetParent(panel)
	nbutton:SetPos(155, 100)
	nbutton:SetSize(40, 20)
	nbutton:SetText(DarkRP.getPhrase("no"))
	nbutton:SetVisible(true)
	nbutton.DoClick = function()
		LocalPlayer():ConCommand("ans " .. quesid .. " 2\n")
		panel:Close()
	end
	nbutton.Paint = function(_,w,h)

		draw.RoundedBox( 1, 0, 0, w, h, Color( 150, 150, 150 ) )

	end
	PanelNum = PanelNum + 300
	QuestionVGUI[quesid .. "ques"] = panel

	panel:SetSkin(GAMEMODE.Config.DarkRPSkin)
end


net.Receive( 'DarkRP_DoQuestion', function()

	local str = net.ReadString()
	local id = net.ReadString() //я не ебу почему стринг, FPtje терпел и нам велел.
	local time = net.ReadFloat()

	MsgDoVote( true, str, id, time )

end )

local function KillQuestionVGUI(id)

	if QuestionVGUI[id .. "ques"] and QuestionVGUI[id .. "ques"]:IsValid() then
		QuestionVGUI[id .. "ques"]:Close()
	end
end

net.Receive( 'DarkRP_KillVoteVGUI', function()

	local id = net.ReadString() // ????????

	KillQuestionVGUI(id)

end )


local function DoVoteAnswerQuestion(ply, cmd, args)
	if not args[1] then return end

	local vote = 0
	if tonumber(args[1]) == 1 or string.lower(args[1]) == "yes" or string.lower(args[1]) == "true" then vote = 1 end

	for k,v in pairs(VoteVGUI) do
		if ValidPanel(v) then
			local ID = string.sub(k, 1, -5)
			VoteVGUI[k]:Close()
			RunConsoleCommand("vote", ID, vote)
			return
		end
	end

	for k,v in pairs(QuestionVGUI) do
		if ValidPanel(v) then
			local ID = string.sub(k, 1, -5)
			QuestionVGUI[k]:Close()
			RunConsoleCommand("ans", ID, vote)
			return
		end
	end
end
concommand.Add("rp_vote", DoVoteAnswerQuestion)