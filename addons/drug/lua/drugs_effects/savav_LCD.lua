local mat_fb = Material( "pp/fb" )
local RICARDO = Material( "ricardo" )
local DRUG = "savav_LCD"
--inQuad( delta, ScrH(), -ScrH() )


hook.Add( "PostPlayerDraw" , "manual_model_draw_example" , function( ply )
	if LocalPlayer().ALPHA1 != nil then 
if LocalPlayer().ALPHA1 <= 0 then
else
	if LocalPlayer().DrugType == DRUG then
	if not IsValid( ply ) or not ply:Alive() then return end

	local POS = ply:GetBonePosition( ply:LookupBone( "ValveBiped.Bip01_Head1" ) )

	render.SetMaterial( RICARDO )
	render.DrawQuadEasy( POS-EyeAngles():Forward()*5, (EyeAngles()+Angle(-90,0,0)):Up(), 20, 20, Color( 255, 255, 255,LocalPlayer().ALPHA1 ), 180 )
end
end
	end
	
end )

hook.Add( "RenderScreenspaceEffects", "DrugsREcts", function()

	if LocalPlayer().ALPHA1 != nil then 
if LocalPlayer().ALPHA1 <= 0 then
else
	if LocalPlayer().DrugType == DRUG then
	DrawColorModify( 

{
	[ "$pp_colour_addr" ] = 0,
	[ "$pp_colour_addg" ] = 0,
	[ "$pp_colour_addb" ] = 0,
	[ "$pp_colour_brightness" ] = -LocalPlayer().ALPHA1/500,
	[ "$pp_colour_contrast" ] = 1+LocalPlayer().ALPHA1/500,
	[ "$pp_colour_colour" ] = 1+LocalPlayer().ALPHA1/250,
	[ "$pp_colour_mulr" ] = 0,
	[ "$pp_colour_mulg" ] = 0,
	[ "$pp_colour_mulb" ] = 0
}

	)
end
end
	end

end )

--[[
hook.Add( "Think", "ThinkDrugsREct_savav_beer", function()
	if LocalPlayer().ALPHA1 != nil then  
if LocalPlayer().ALPHA1 <= 0 then
else
	if LocalPlayer().DrugType == DRUG then
		
		if math.random(0,600) == 1 then

				LocalPlayer():ConCommand( "+jump" )
				
		elseif math.random(0,200) == 2 then	
		LocalPlayer():ConCommand( "+forward" )
			timer.Simple(0.1,function()
				LocalPlayer():ConCommand( "-forward" )
			end)
		elseif math.random(0,600) == 2 then
				LocalPlayer():SetEyeAngles(LocalPlayer():EyeAngles()+Angle(0,math.random(-90,90),0))
		else
				LocalPlayer():ConCommand( "-jump" )
				
		end
		
	end
end
	end
end)
-]]

local LERPANGL = Angle()

local function MyCalcView( ply, pos, angles, fov )
	if LocalPlayer().ALPHA1 != nil then 
if LocalPlayer().ALPHA1 <= 0 then
else
	if LocalPlayer().DrugType == DRUG then
		local view = {}
		
local blah = WorldToLocal( ply:GetVelocity(), Angle(0,0,0) , Vector(0,0,0), Angle(0,ply:EyeAngles().yaw,0) ) 
LERPANGL = LerpAngle(LocalPlayer().ALPHA1/258,angles,LERPANGL)
		view.origin = ( pos+ply:GetVelocity()/80 ) + angles:Forward()*LocalPlayer().ALPHA1/12
		view.angles = LERPANGL+Angle(((blah.x/4550)*LocalPlayer().ALPHA1),((blah.y/2550)*LocalPlayer().ALPHA1),((blah.y/2550)*LocalPlayer().ALPHA1)+math.cos(CurTime())*LocalPlayer().ALPHA1/10)
		view.fov = fov + LocalPlayer().ALPHA1/3.7
		view.drawviewer = false

		return view
	end
end
	end
end

hook.Add( "CalcView", "CalcViewDrugsRect_savav_LCD", MyCalcView )

hook.Add( "HUDPaint", "DrugsREct_savav_LCD", function()
if LocalPlayer().ALPHA1 != nil then
if LocalPlayer().Active == 0 then
if LocalPlayer().ALPHA1 > 0 then LocalPlayer().ALPHA1 = LocalPlayer().ALPHA1 - 0.05 end
if LocalPlayer().ALPHA2 > 0 then LocalPlayer().ALPHA2 = LocalPlayer().ALPHA2 - 0.05 end
end

if LocalPlayer().ALPHA1 != nil then
	if LocalPlayer().DrugType == DRUG then
	if LocalPlayer().Active == 1 then
		if LocalPlayer().ALPHA1 < 255 then LocalPlayer().ALPHA1 = LocalPlayer().ALPHA1 + 0.05 end
	if !LocalPlayer():Alive() then
	LocalPlayer().MUSIC:ChangePitch( 0, 60 )
	LocalPlayer().MUSIC:ChangeVolume( 0, 100 )
	LocalPlayer().Active = 0
	end
	end
 
LocalPlayer():SetEyeAngles(LocalPlayer():EyeAngles()+Angle((math.cos(CurTime())/2550)*LocalPlayer().ALPHA1,(math.sin(CurTime()*2)/2550)*LocalPlayer().ALPHA1,0))

	for i=1,30 do

	local Cos = math.cos(i/2) * LocalPlayer().ALPHA1
	local Sin = math.sin(i/2) * LocalPlayer().ALPHA1
	local Sinonius = math.cos(CurTime())* LocalPlayer().ALPHA1/10
	local Cosonius = math.sin(CurTime())* LocalPlayer().ALPHA1/10

		surface.SetDrawColor( 255, 255, 255, ( LocalPlayer().ALPHA1/22 ))
		surface.SetMaterial( mat_fb	) 
		surface.DrawTexturedRect( Cos-Cosonius, (Sin-Sinonius), ScrW(), ScrH() )
	end

		surface.SetDrawColor(255, 0, 255, LocalPlayer().ALPHA1/30 )
		surface.DrawRect( 0, 0, ScrW(), ScrH() )

		if LocalPlayer().ALPHA1 <= 0 then

			LocalPlayer().DrugType = "0"
				LocalPlayer().MUSIC:Stop()
			
		end
end

	end
end
end )


local function DrugEffect_savav_LCD(data)



if LocalPlayer().Active == 0 or LocalPlayer().Active == nil then
LocalPlayer().DrugType = data:ReadString()
LocalPlayer().Active = 1
LocalPlayer().ALPHA1 = 0
LocalPlayer().ALPHA2 = 0


LocalPlayer().MUSIC = CreateSound( LocalPlayer(), "U Got That.wav" )

LocalPlayer().MUSIC:Play()
LocalPlayer().MUSIC:ChangePitch( 0, 0 )
LocalPlayer().MUSIC:ChangeVolume( 0, 0 )
LocalPlayer().MUSIC:ChangePitch( 100, 25 )
LocalPlayer().MUSIC:ChangeVolume( 0.4, 6 )

timer.Simple(110,function()

LocalPlayer().MUSIC:ChangePitch( 0, 10 )
LocalPlayer().MUSIC:ChangeVolume( 0, 19 )
LocalPlayer().Active = 0


end)

end

end


local function DrugEffect_WATER(data)
LocalPlayer().Active = 0
end

usermessage.Hook("DrugEffect_WATER", DrugEffect_WATER ) 
usermessage.Hook("DrugEffect_savav_LCD", DrugEffect_savav_LCD ) 
 