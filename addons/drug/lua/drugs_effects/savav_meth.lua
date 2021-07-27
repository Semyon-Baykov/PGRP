local mat_fb = Material( "pp/fb" )
local WMmat = Material( "Melon_screen" )
local DRUG = "savav_meth"




hook.Add( "RenderScreenspaceEffects", "DrugsREcts_savav_meth", function()
	if LocalPlayer().ALPHA1 != nil then 
if LocalPlayer().ALPHA1 <= 0 then
else
	if LocalPlayer().DrugType == DRUG then
 DrawTexturize( 0, Material( "meth_screen" ) )
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
		
		view.origin = pos-angles:Forward()*LocalPlayer().ALPHA1/6
		view.angles = angles+Angle(0,math.cos(CurTime())*LocalPlayer().ALPHA1/120,0)
		view.fov = fov - LocalPlayer().ALPHA1/7
		view.drawviewer = false

		return view
	end
end
	end
end

hook.Add( "CalcView", "CalcViewDrugsRect_savav_meth", MyCalcView )

hook.Add( "HUDPaint", "DrugsREct_savav_meth", function()

if LocalPlayer().ALPHA1 != nil then
if LocalPlayer().Active == 0 then
if LocalPlayer().ALPHA1 > 0 then LocalPlayer().ALPHA1 = LocalPlayer().ALPHA1 - 0.05 end
if LocalPlayer().ALPHA2 > 0 then LocalPlayer().ALPHA2 = LocalPlayer().ALPHA2 - 0.05 end
end

	if LocalPlayer().DrugType == DRUG then
	if LocalPlayer().Active == 1 then
		if LocalPlayer().ALPHA1 < 255 then LocalPlayer().ALPHA1 = LocalPlayer().ALPHA1 + 0.05 end
		
	for i=1,30 do

	local Cos = math.cos(i) * LocalPlayer().ALPHA1*2
	local Sin = math.sin(i) * LocalPlayer().ALPHA1*2
	local Sinonius = math.cos(CurTime())* LocalPlayer().ALPHA1/10
	local Cosonius = math.sin(CurTime())* LocalPlayer().ALPHA1/10

		surface.SetDrawColor( 255, 255, 255, ( LocalPlayer().ALPHA1/20 ))
		surface.SetMaterial( mat_fb	) 
		surface.DrawTexturedRect( Cos-Cosonius, (Sin-Sinonius), ScrW(), ScrH() )
	end

	
		surface.SetDrawColor( 255, 255, 255, ( 255-LocalPlayer().ALPHA1 ))
		surface.SetMaterial( mat_fb	) 
		surface.DrawTexturedRect( 0, 0, ScrW(), ScrH() )
		
	if !LocalPlayer():Alive() then
	LocalPlayer().MUSIC:ChangePitch( 0, 60 )
	LocalPlayer().MUSIC:ChangeVolume( 0, 100 )
	LocalPlayer().Active = 0
	
	
	end
	end


		
		if LocalPlayer().ALPHA1 <= 0 then

			LocalPlayer().DrugType = "0"
				LocalPlayer().MUSIC:Stop()
			
		end

	end
end
end )


local function DrugEffect_savav_meth(data)


if LocalPlayer().Active == 0 or LocalPlayer().Active == nil then
LocalPlayer().DrugType = data:ReadString()
LocalPlayer().Active = 1
LocalPlayer().ALPHA1 = 0
LocalPlayer().ALPHA2 = 0

LocalPlayer().MUSIC = CreateSound( LocalPlayer(), "SBGRNG.wav" )

LocalPlayer().MUSIC:Play()
LocalPlayer().MUSIC:ChangePitch( 0, 0 )
LocalPlayer().MUSIC:ChangeVolume( 0, 0 )
LocalPlayer().MUSIC:ChangePitch( 100, 30 )
LocalPlayer().MUSIC:ChangeVolume( 0.4, 6 )
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
usermessage.Hook("DrugEffect_savav_meth", DrugEffect_savav_meth ) 
 