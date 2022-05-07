local mat_fb = Material( "pp/fb" )
local WMmat = Material( "Melon_screen" )
local DRUG = "savav_Psilocybin"
local POSITION = Vector()


hook.Add( "RenderScreenspaceEffects", "DrugsREcts_savav_Psilocybin", function()
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
	[ "$pp_colour_colour" ] = 1+LocalPlayer().ALPHA1/30,
	[ "$pp_colour_mulr" ] = 0,
	[ "$pp_colour_mulg" ] = 0,
	[ "$pp_colour_mulb" ] = 0
}

	)
end
end
	end

end )

hook.Add( "Think", "ThinkDrugsREct_savav_Psilocybin", function()

local TRACE = util.QuickTrace( POSITION+Vector(0,0,60), Vector(0,0,-80) )

if !LocalPlayer():KeyDown(IN_JUMP) then
POSITION = Vector(POSITION.x,POSITION.y,TRACE.HitPos.z)
else
POSITION = Vector(POSITION.x,POSITION.y,POSITION.z+3)
end

if LocalPlayer():KeyDown(IN_FORWARD) then
POSITION = POSITION + Angle(0,LocalPlayer():EyeAngles().yaw,0):Forward()*3
end

if LocalPlayer():KeyDown(IN_BACK) then
POSITION = POSITION + Angle(0,LocalPlayer():EyeAngles().yaw,0):Forward()*-3
end

if LocalPlayer():KeyDown(IN_MOVELEFT) then
POSITION = POSITION + Angle(0,LocalPlayer():EyeAngles().yaw,0):Right()*-3
end

if LocalPlayer():KeyDown(IN_MOVERIGHT) then
POSITION = POSITION + Angle(0,LocalPlayer():EyeAngles().yaw,0):Right()*3
end

end)

local function MyCalcView( ply, pos, angles, fov )
	if LocalPlayer().ALPHA1 != nil then 
if LocalPlayer().ALPHA1 <= 0 then
else
	if LocalPlayer().DrugType == DRUG then
		local view = {}



		view.origin = (POSITION+angles:Forward()*LocalPlayer().ALPHA1/20 )+Vector(0,0,60)
		view.angles = angles+Angle(0,math.cos(CurTime())*LocalPlayer().ALPHA1/120,0)
		view.fov = fov + LocalPlayer().ALPHA1/6
		view.drawviewer = true

		return view
	end
end
	end
end

hook.Add( "CalcView", "CalcViewDrugsRect_savav_Psilocybin", MyCalcView )

hook.Add( "HUDPaint", "DrugsREct_savav_Psilocybin", function()

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


		surface.SetDrawColor( 255, 255, 255, ( 255-LocalPlayer().ALPHA1 ) )
		surface.DrawRect( 0, 0, ScrW(), ScrH() )
		
		if LocalPlayer().ALPHA1 <= 0 then

			LocalPlayer().DrugType = "0"
				LocalPlayer().MUSIC:Stop()
			
		end

	end
end
end )


local function DrugEffect_savav_Psilocybin(data)


if LocalPlayer().Active == 0 or LocalPlayer().Active == nil then
LocalPlayer().DrugType = data:ReadString()
LocalPlayer().Active = 1
LocalPlayer().ALPHA1 = 0
LocalPlayer().ALPHA2 = 0
POSITION = LocalPlayer():GetPos()+Vector(0,0,10)
LocalPlayer().MUSIC = CreateSound( LocalPlayer(), "FOTY.wav" )

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
usermessage.Hook("DrugEffect_savav_Psilocybin", DrugEffect_savav_Psilocybin ) 
 