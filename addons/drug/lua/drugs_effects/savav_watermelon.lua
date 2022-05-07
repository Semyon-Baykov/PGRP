local mat_fb = Material( "pp/fb" )
local WMmat = Material( "Melon_screen" )
local DRUG = "savav_watermelon"

hook.Add( "PostDrawSkyBox", "PostDrawSkyBoxDGUG_savav_watermelon", function()
	if LocalPlayer().ALPHA1 != nil then 
if LocalPlayer().ALPHA1 <= 0 then
else
	if LocalPlayer().DrugType == DRUG then
	render.SetMaterial( WMmat )
	--render.DrawScreenQuad()
	render.DrawQuadEasy(LocalPlayer():EyePos()+Vector(0,0,100), Vector( -1, 0, -90 ), 2920, 2080, Color(255,255,255,LocalPlayer().ALPHA1), 0 )
end
end
	end
end)


hook.Add( "PostDrawOpaqueRenderables", "PostDrawOpaqueRenderablesDRUG_savav_watermelon", function()
	if LocalPlayer().ALPHA1 != nil then 
if LocalPlayer().ALPHA1 <= 0 then
else
	if LocalPlayer().DrugType == DRUG then

for i=1, 100 do
	if LocalPlayer().WaterMdodel[i] == nil then
		LocalPlayer().WaterMdodel[i] = ClientsideModel( "models/props_junk/watermelon01.mdl" )
		LocalPlayer().WaterMdodel[i]:SetRenderMode( RENDERMODE_TRANSALPHA ) 
		LocalPlayer().WaterMdodel[i]:SetPos(LocalPlayer():GetPos()+Vector(0,0,100))
		LocalPlayer().WaterMdodel[i]:DrawModel()
	end
	
	if LocalPlayer().WaterMdodel[i]:GetPos().z > LocalPlayer():GetPos().z-50 then
		LocalPlayer().WaterMdodel[i]:SetPos(LocalPlayer().WaterMdodel[i]:GetPos()+Vector(0,0,-1.5))
	else
		LocalPlayer().WaterMdodel[i]:SetPos(LocalPlayer():GetPos()+Vector(math.random(-1000,1000),math.random(-1000,1000),math.random(400,700)))
	end
	
	LocalPlayer().WaterMdodel[i]:SetColor( Color( 255, 255, 255, LocalPlayer().ALPHA1 ) )
	
end
	
	end

end
	end
end)


hook.Add( "RenderScreenspaceEffects", "DrugsREcts_savav_watermelon", function()
	if LocalPlayer().ALPHA1 != nil then 
if LocalPlayer().ALPHA1 <= 0 then
else
	if LocalPlayer().DrugType == DRUG then
	DrawColorModify( 
{
	[ "$pp_colour_addr" ] = 0,
	[ "$pp_colour_addg" ] = 0,
	[ "$pp_colour_addb" ] = 0,
	[ "$pp_colour_brightness" ] = 0-LocalPlayer().ALPHA1/590,
	[ "$pp_colour_contrast" ] = 1+LocalPlayer().ALPHA1/590,
	[ "$pp_colour_colour" ] = 1+LocalPlayer().ALPHA1/80,
	[ "$pp_colour_mulr" ] = 0,
	[ "$pp_colour_mulg" ] = 0,
	[ "$pp_colour_mulb" ] = 0
}

	)
end
end
	end

end )


local function MyCalcView( ply, pos, angles, fov )
	if LocalPlayer().ALPHA1 != nil then 
if LocalPlayer().ALPHA1 <= 0 then
else
	if LocalPlayer().DrugType == DRUG then
		local view = {}
		
		view.origin = pos+angles:Forward()*LocalPlayer().ALPHA1/7
		view.angles = angles+Angle(0,math.cos(CurTime())*LocalPlayer().ALPHA1/120,0)
		view.fov = fov + LocalPlayer().ALPHA1/3.6
		view.drawviewer = false

		return view
	end
end
	end
end

hook.Add( "CalcView", "CalcViewDrugsRect_savav_watermelon", MyCalcView )

hook.Add( "HUDPaint", "DrugsREct_savav_watermelon", function()

if LocalPlayer().ALPHA1 != nil then
if LocalPlayer().Active == 0 then
if LocalPlayer().ALPHA1 > 0 then LocalPlayer().ALPHA1 = LocalPlayer().ALPHA1 - 0.05 end
if LocalPlayer().ALPHA2 > 0 then LocalPlayer().ALPHA2 = LocalPlayer().ALPHA2 - 0.05 end
end

	if LocalPlayer().DrugType == DRUG then
	if LocalPlayer().Active == 1 then
		if LocalPlayer().ALPHA1 < 255 then LocalPlayer().ALPHA1 = LocalPlayer().ALPHA1 + 0.05 end
	if !LocalPlayer():Alive() then
	LocalPlayer().MUSIC:ChangePitch( 0, 60 )
	LocalPlayer().MUSIC:ChangeVolume( 0, 100 )
	LocalPlayer().Active = 0
	end
	end


		surface.SetDrawColor( math.sin(CurTime())*255, 255, math.sin(CurTime())*255, ( LocalPlayer().ALPHA1/35 ) )
		surface.DrawRect( 0, 0, ScrW(), ScrH() )
		
		if LocalPlayer().ALPHA1 <= 0 then

			LocalPlayer().DrugType = "0"
				LocalPlayer().MUSIC:Stop()
			
		end

	end
end
end )


local function DrugEffect_savav_watermelon(data)


if LocalPlayer().Active == 0 or LocalPlayer().Active == nil then
LocalPlayer().DrugType = data:ReadString()
LocalPlayer().Active = 1
LocalPlayer().ALPHA1 = 0
LocalPlayer().ALPHA2 = 0

LocalPlayer().MUSIC = CreateSound( LocalPlayer(), "awoo.wav" )

LocalPlayer().MUSIC:Play()
LocalPlayer().MUSIC:ChangePitch( 0, 0 )
LocalPlayer().MUSIC:ChangeVolume( 0, 0 )
LocalPlayer().MUSIC:ChangePitch( 100, 9 )
LocalPlayer().MUSIC:ChangeVolume( 1, 6 )
LocalPlayer().WaterMdodel = {}
timer.Simple(60,function()

LocalPlayer().MUSIC:ChangePitch( 0, 60 )
LocalPlayer().MUSIC:ChangeVolume( 0, 100 )
LocalPlayer().Active = 0


end)
end


end


local function DrugEffect_WATER(data)
LocalPlayer().Active = 0
end

usermessage.Hook("DrugEffect_WATER", DrugEffect_WATER ) 
usermessage.Hook("DrugEffect_savav_watermelon", DrugEffect_savav_watermelon ) 
 