
if SERVER then
	AddCSLuaFile("shared.lua")
	util.AddNetworkString("rod_phys_Fishing")
	util.AddNetworkString("rod_phys_Pull")
	util.AddNetworkString("rod_phys_End")
	util.AddNetworkString("FishPoleStrength")
end

if CLIENT then
	SWEP.PrintName = "Fishing Rod (Physics based)"
	SWEP.Slot = 3
	SWEP.SlotPos = 3
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
end

SWEP.Author = "Tomasas"
SWEP.Instructions = "Left click to cast a line.\nRight click to try and catch a fish."
SWEP.Contact = ""
SWEP.Purpose = ""


//SWEP.AnimPrefix	 = "rpg"
SWEP.WorldModel = ""//"models/fishing/pole.mdl"
SWEP.ViewModel = ""

SWEP.Spawnable = false
SWEP.AdminSpawnable = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

function SWEP:Initialize()
	self:SetWeaponHoldType("revolver")
	if CLIENT and self.Owner == LocalPlayer() then
		self.Owner.ReceivedFishingTip = true
		chat.AddText(Color(255,255,255), TrueFishLocal("fishing_rod_phys_tip"))
	end
end

function SWEP:DrawWorldModel()
	return true
end

function SWEP:Holster()
	if CLIENT then
		self.Owner.ThirdViewPhys = nil
		if LocalPlayer() == self.Owner then
			self.DrawFishing = nil
		end
	end
	if SERVER then
		self.Owner.IsFishing = nil
		
		if IsValid(self.WeaponModel) then
			self.WeaponModel:Remove()
		end
		if IsValid(self.Hook) then
			self.Hook:Remove()
		end
		
	end
	return true
end

if CLIENT then
	local tracedata = {mask = CONTENTS_SOLID + 268435488 + CONTENTS_OPAQUE}
	local function SWEPCalcView(ply, pos, ang, fov)
		if ply.ThirdViewPhys then
			ang.p = 35
			//ang.y = 45
			tracedata.start = pos
			tracedata.endpos = pos-ang:Forward()*150
			local trace = util.TraceLine(tracedata)
			return {origin = trace.HitWorld and trace.HitPos+ply:GetForward()*3 or tracedata.endpos, angles = ang, fov = fov, drawviewer = true}
		end
	end
	hook.Add("CalcView", "Fishing Rod Phys", SWEPCalcView)

	function SWEP:DrawHUD()
		if !self.Owner.ThirdViewPhys or !self.DrawFishing then return end

		local left = (self.StartedFishing+self.DrawFishing-CurTime())/self.DrawFishing
		if left < 0 then return end
		left = left - 0.5
		
		local x, y = math.floor(TFScreenScale(81)), math.floor(TFScreenScale(7))

		surface.SetDrawColor(0, 0, 0, 135)
		surface.DrawRect(ScrW()*0.5-x*0.5, ScrH()*0.8, x, y)
		for i=1, y do
			surface.SetDrawColor(0, 0.5*i*y, 0, 255)
			surface.DrawLine(ScrW()*0.5-x*0.5, ScrH()*0.8+i-1, ScrW()*0.5+x*left, ScrH()*0.8+i-1)
		end
		for i=1, 4 do
			surface.SetDrawColor(125+i*10, 125+i*10, 125+i*10, 255)
			surface.DrawOutlinedRect(ScrW()*0.5-x*0.5-i, ScrH()*0.8-i, x+i*2, y+i*2)
		end
		draw.SimpleText(TrueFishLocal("fishing_hud"), "SegoeUI_NormalBoldScaled", ScrW()*0.5, ScrH()*0.8-TFScreenScale(1), Color(220, 220, 220, 255), TEXT_ALIGN_CENTER)
	end

	local lineColor = Color(255, 255, 255, 100)
	net.Receive("rod_phys_Fishing", function()
		local owner = LocalPlayer()
		if !owner or !owner:IsValid() then return end
		local wep = owner:GetActiveWeapon()
		if !wep or !wep:IsValid() or wep:GetClass() != "fishing_rod_physics" then return end
		
		local wait = net.ReadUInt(12)
		
		if wait != 0 then
			owner.ThirdViewPhys = true
			wep.DrawFishing = wait
			wep.StartedFishing = CurTime()-owner:Ping()*0.001
		end
	end)

	net.Receive("rod_phys_Pull", function()
		local owner = LocalPlayer()
		if !owner or !owner:IsValid() then return end
		local wep = owner:GetActiveWeapon()
		if !wep or !wep:IsValid() then return end

		local ent = net.ReadEntity()
		local nextSplash = CurTime()
		wep.Think = function()
			local ctime = CurTime()
			if nextSplash < ctime and ent:IsValid() and ent:WaterLevel() > 0 then
				chat.PlaySound()
				local effectdata = EffectData()
				local pos = ent:GetPos()
				effectdata:SetOrigin(pos)
				effectdata:SetNormal(pos)
				effectdata:SetRadius(5)
				effectdata:SetScale(4)
				util.Effect("watersplash", effectdata)
				nextSplash = ctime+0.1
			end
		end
		
	end)

	net.Receive("rod_phys_End", function()
		local owner = LocalPlayer()
		if !owner or !owner:IsValid() then return end
		local wep = owner:GetActiveWeapon()
		if !wep or !wep:IsValid() then return end

		wep.Think = function() end
		owner.ThirdViewPhys = false
		
	end)

	local Strength = 175
	function SWEP:Reload()
		if self.LastR and self.LastR > SysTime() then return end
		self.LastR = SysTime()+1
		local Window = vgui.Create( "DFrame" )
			Window:SetTitle( "" )
			Window:SetDraggable( false )
			Window:ShowCloseButton( false )
			Window:SetBackgroundBlur( false )
			Window:SetDrawOnTop( true )
			Window.Paint = function(self)			
				draw.RoundedBoxEx(8, 0, 0, self:GetWide(), 20, Color(47, 54, 76, 255), true, true)
				draw.SimpleText(TrueFishLocal("throw_str"), "FishingS20", self:GetWide()*0.5, 0, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
				draw.RoundedBoxEx(8, 0, self:GetTall()-30, self:GetWide(), 30, Color(47, 54, 76, 255), false, false, true, true)
				surface.SetDrawColor(60, 64, 83, 255)
				surface.DrawRect(0, 20, self:GetWide(), self:GetTall()-50)
				
				surface.SetDrawColor(50, 50, 50, 255)
				surface.DrawOutlinedRect(0, 20, self:GetWide(), self:GetTall()-50)
			end
			
		local InnerPanel = vgui.Create( "DPanel", Window )
			InnerPanel:SetDrawBackground( false )
		
		local Text = vgui.Create( "DLabel", InnerPanel )
			Text:SetText( TrueFishLocal("throw_desc") )
			Text:SizeToContents()
			Text:SetContentAlignment( 5 )
			Text:SetTextColor( color_white )
			
		local TextEntry = vgui.Create( "DNumSlider", InnerPanel ) // y the fuck does this derma not have color editing for notches...
			TextEntry:SetMin(0)
			TextEntry:SetMax(800)
			TextEntry:SetValue(Strength)
			TextEntry:SetDark(false)
			TextEntry.TextArea:SetTextColor(Color(255, 255, 255, 255))
			
		local ButtonPanel = vgui.Create( "DPanel", Window )
			ButtonPanel:SetTall( 30 )
			ButtonPanel:SetDrawBackground( false )
			
		local Button = vgui.Create( "DButton", ButtonPanel )
			Button:SetText( "OK" )
			Button:SetColor(Color(250, 250, 250, 255))
			Button:SetFont("FishingS16")
			Button:SizeToContents()
			Button:SetTall( 20 )
			Button:SetWide( Button:GetWide() + 20 )
			Button:SetPos( 5, 5 )
			Button.DoClick = function()
				net.Start("FishPoleStrength")
				net.WriteFloat(TextEntry:GetValue())
				net.SendToServer()
				Strength = TextEntry:GetValue()
				Window:Close()
			end
			Button.Paint = function(self)
				surface.SetDrawColor(self.Hovered and Color(99, 102, 111, 255) or Color(69, 72, 81, 255))
				surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
				surface.SetDrawColor(50, 50, 50, 255)
				surface.DrawOutlinedRect(0, 0, self:GetWide(), self:GetTall())
			end
			
		local ButtonCancel = vgui.Create( "DButton", ButtonPanel )
			ButtonCancel:SetText( "Cancel" )
			ButtonCancel:SetColor(Color(250, 250, 250, 255))
			ButtonCancel:SetFont("FishingS16")
			ButtonCancel:SizeToContents()
			ButtonCancel:SetTall( 20 )
			ButtonCancel:SetWide( Button:GetWide() + 20 )
			ButtonCancel:SetPos( 5, 5 )
			ButtonCancel.DoClick = function() Window:Close() end
			ButtonCancel:MoveRightOf( Button, 5 )
			ButtonCancel.Paint = Button.Paint
			
		ButtonPanel:SetWide( Button:GetWide() + 5 + ButtonCancel:GetWide() + 10 )
		
		local w, h = Text:GetSize()
		w = math.max( w, 400 ) 
		
		Window:SetSize( w + 50, h + 25 + 75 + 10 )
		Window:Center()
		
		InnerPanel:StretchToParent( 5, 25, 5, 45 )
		
		Text:StretchToParent( 5, 5, 5, 35 )	
		
		TextEntry:StretchToParent( 5, nil, 5, nil )
		//TextEntry:SetSize(Window:GetWide()-10, 20)
		TextEntry:SetPos(-TextEntry:GetWide()*0.225, 25)
		//TextEntry:AlignBottom( 5 )
		
		TextEntry:RequestFocus()
		//TextEntry:SelectAllText( true )
		
		ButtonPanel:CenterHorizontal()
		ButtonPanel:AlignBottom( 2 )
		
		Window:MakePopup()
		Window:DoModal()
	end
end

local emptyf = function() end//destroy click sound
SWEP.PrimaryAttack = emptyf
SWEP.SecondaryAttack = emptyf
if CLIENT then return end

net.Receive("FishPoleStrength", function(len, ply)
	ply.HookThrowStr = math.Clamp(net.ReadFloat(), 0, 800)
end)


function SWEP:Think()
	if !IsValid(self.WeaponModel) or !IsValid(self.Hook) then self:Deploy(true) end
	local pos, ang = self.Owner:GetBonePosition(self.Owner:LookupBone("ValveBiped.Bip01_R_Hand", false))
	ang:RotateAroundAxis(ang:Right(), -55)
	//ang:RotateAroundAxis(ang:Forward(), 90)
	pos = pos - ang:Forward()*6.5 + ang:Up()*1.275 + ang:Right()*1.5
	self.WeaponModel:SetPos(pos)
	self.WeaponModel:SetAngles(ang)
	
	if self.Owner.IsFishing then
		local ctime = CurTime()
		if self.FishingEndTime <= ctime then
			self:NoCatch()
		elseif self.FishingTimeWindow <= ctime then
			net.Start("rod_phys_Pull")
			net.WriteEntity(self.Hook)
			net.Send(self.Owner)
			self.Owner.IsFishing = 1
			self.FishingTimeWindow = self.FishingEndTime
		end
	end
end

function SWEP:AdjustRope(len)
	constraint.RemoveConstraints(self.WeaponModel, "Rope")
	local pos, ang = self.WeaponModel:GetPos(), self.WeaponModel:GetAngles()
	//ang:RotateAroundAxis(ang:Right(), -55)
	//pos = ang:Forward()*98 + ang:Up()*0.25 
	constraint.Rope(self.WeaponModel, self.Hook, 0, 0, Vector(98, 0, 0.25), Vector(0, 0, 20), len, 0, 0, 0, "cable/cable2", false)
end

function SWEP:Deploy(fromNotEngine)
	if !IsValid(self.WeaponModel) then
		self.WeaponModel = ents.Create("fishing_rod_pole")
		self.WeaponModel:SetDTEntity(0, self.Owner)
		self.WeaponModel:Spawn()
		self.WeaponModel:GetPhysicsObject():SetMass(50000)
		self:Think()
	end
	if !IsValid(self.Hook) then
		self.Hook = ents.Create("fishing_rod_hook")
		self.Hook:SetModelScale(0.5, 0)
		self.Hook:SetPos(self.Owner:GetPos() + self.Owner:GetForward()*20 + Vector(0, 0, 20))
		self.Hook:Spawn()
		self:AdjustRope(50)
	end
	if IsValid(self.WeaponModel) and IsValid(self.Hook) then
		self.WeaponModel:SetDTEntity(1, self.Hook)
	end
	self.Owner:DrawViewModel(false)
end

function SWEP:OnRemove()
	if IsValid(self.WeaponModel) then
		self.WeaponModel:Remove()
	end
	if IsValid(self.Hook) then
		self.Hook:Remove()
	end
end

function SWEP:PrimaryAttack()
	
	if self.Owner.IsFishing or !self.Owner:OnGround() then return end

	if !self.Owner.FishBait or self.Owner.FishBait == 0 then
		TrueFishNotify(self.Owner, TrueFishLocal("no_fish_bait"))
		return false
	end
	
	self.Owner.HookThrowStr = self.Owner.HookThrowStr or 175
	
	local ang = self.Owner:GetAngles()
	ang.r = 0
	ang.p = 0
	local tracedata = {start = self.Owner:GetPos()+ang:Forward()*(self.Owner.HookThrowStr+70+math.random(-50, 50))+ang:Right()*math.random(-80, 80)}
	tracedata.start.z = tracedata.start.z + 50
	tracedata.endpos = Vector(tracedata.start.x, tracedata.start.y, tracedata.start.z-80)
	local trace = util.TraceLine(tracedata)
	tracedata.start.z = tracedata.start.z + 50
	tracedata.endpos.z = tracedata.endpos.z - 130
	tracedata.mask = CONTENTS_SOLID + 268435488 + CONTENTS_OPAQUE
	local trace2 = util.TraceLine(tracedata)
	if !trace.Hit and trace2.HitWorld then
		self.Owner.FishBait = self.Owner.FishBait - 1
		
		self:AdjustRope(trace2.HitPos:Distance(self.Owner:GetPos()) )
		local phys = self.Hook:GetPhysicsObject()
		ang = self.Owner:GetAngles()
		local force = ang:Forward()*(self.Owner.HookThrowStr+70)*2+Vector(0, 0, 500)
		phys:ApplyForceCenter(force)
		
		tracedata.start = trace2.HitPos
		tracedata.endpos.z = tracedata.endpos.z - FISH_MAX_DEPTH
		tracedata.mask = MASK_OPAQUE
		trace = util.TraceLine(tracedata)
		self.Depth = !trace.Hit and FISH_MAX_DEPTH or math.Clamp(math.abs(trace.HitPos.z - tracedata.start.z), 15, FISH_MAX_DEPTH)

		local owner = self.Owner
		owner.IsFishing = true
		
		local fish = TrueFishCalculateFish(self.Depth)
		local waitTime = TrueFish.ROD_SEPERATE_CATCH_TIME_ENABLED and TrueFish.ROD_SEPERATE_CATCH_TIME or !TrueFish.FISH_CATCH_TIME[fish] and TrueFish.ROD_SEPERATE_CATCH_TIME or math.random(TrueFish.FISH_CATCH_TIME[fish][1], TrueFish.FISH_CATCH_TIME[fish][2])
		net.Start("rod_phys_Fishing")
		net.WriteUInt(waitTime, 12)
		net.Send(owner)
		self.FishingEndTime = CurTime() + waitTime
		self.FishingTimeWindow = self.FishingEndTime - waitTime*TrueFish.ROD_CATCH_WINDOW
		
	end
	
	
end

function SWEP:NoCatch()
	net.Start("rod_phys_End")
	net.Send(self.Owner)
	self.Owner.IsFishing = false
	TrueFishNotify(self.Owner, TrueFishLocal("didnt_catch_anything"))
	self:AdjustRope(50)
end

function SWEP:SecondaryAttack()
	if self.Owner.IsFishing == true then
		self:NoCatch()
		return
	end
	if self.Owner.IsFishing == 1 and self.Hook:WaterLevel() > 0 then
		net.Start("rod_phys_End")
		net.Send(self.Owner)
		self.Owner.IsFishing = false
		self:AdjustRope(95)
		
		local fish = TrueFishCalculateFish(self.Depth)
		if math.random(1000) <= TrueFish.ROD_JUNK_CHANCE then
			fish = FISH_JUNK
		end
		
		if math.random(1000) <= TrueFish.ROD_MONEYBAG_CHANCE then // Yes, JUNK and MONEY BAG chances aren't 100% this way
			self.Hook:AddMoneyBag()
			return
		end
		
		if !fish then
			TrueFishNotify(self.Owner, TrueFishLocal("didnt_catch_anything"))
			return
		else
			TrueFishNotify(self.Owner, TrueFishLocal("hook_caught"))
		end
		
		self.Hook:AddFish(fish)
	end
end

