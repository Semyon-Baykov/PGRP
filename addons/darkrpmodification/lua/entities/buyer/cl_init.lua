include("shared.lua");


function ENT:DrawTranslucent()
	self:Draw();


end;

function ENT:Initialize()
	AddNPCText( self, 'Степан Голубев', 'Скупщик полезных ископаемых', Color( 0, 200, 0 ) )
end




function ENT:BuildBonePositions(NumBones, NumPhysBones)
end;
 
function ENT:SetRagdollBones(bIn)
	self.m_bRagdollSetup = bIn;
end;

function ENT:DoRagdollBone(PhysBoneNum, BoneNum)
	--self:SetBonePosition( BoneNum, Pos, Angle )
end;

local function prices()

	local frame = vgui.Create('gpFrame')
	frame:SetSize(340,105)
	frame:Center()
	frame:MakePopup()
	frame:SetTitle('Курс скупки полезных ископаемых')


	local text = vgui.Create('DLabel',frame)
	text:Dock(TOP)
	text:SetFont('Trebuchet24')
	text:SetTextColor(Color(255,255,255))
	text:SetText(DarkRP.formatMoney(400)..' за 1х камня\n'..DarkRP.formatMoney(1000)..' за 1х золотой руды\n'..DarkRP.formatMoney(2000)..' за 1х урана')
	text:SizeToContents()

end
local function menu()



	local frame = vgui.Create('gpFrame')
	frame:SetSize(350,180)
	frame:Center()
	frame:MakePopup()
	frame:SetTitle('Скупка полезных ископаемых')

		
	local priceb = vgui.Create('gpButton',frame)
	priceb:SetSize(0,70)
	priceb:Dock( TOP )
	priceb:setText('Узнать курс')
	priceb.DoClick = function()

		prices()
		frame:Remove()
	end

	local sellb = vgui.Create('gpButton',frame)
	sellb:SetSize(0,70)
	sellb:Dock(TOP)
	sellb:DockMargin(0,5,0,0)
	sellb:setText('Продать добытые ископаемые')


	sellb.DoClick = function()

		net.Start('GPoratlRP_SellAll')
		net.SendToServer()
	end
end





net.Receive('GPoratlRP_OpenMenuMining',function()

	menu()

end)
