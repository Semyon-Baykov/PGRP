-- По старой доброй традиции ебу рот церебро, да.


local eyepos = Vector()
local eyeangles = Angle()
local eyefov = 90
local eyevector = Vector()

hook.Add("RenderScene", "Eye", function(origin, angles, fov)
	eyepos = origin
	eyeangles = angles
	eyefov = fov
	eyevector = angles:Forward()
end)

local meta = FindMetaTable('Entity')
function meta:ShouldHide()
	local pos = self:GetPos()
	return self ~= LocalPlayer() && (eyevector:Dot(pos - eyepos) < 1.5 || pos:DistToSqr(eyepos) > 9000000)
end

function meta:NotInRange()
	local pos = self:GetPos()
	return pos:DistToSqr(eyepos) > 9000000
end

function EyePos() return eyepos end
function EyeAngles() return eyeangles end
function EyeFov() return eyefov end
function EyeVector() return eyevector end

hook.Remove("RenderScreenspaceEffects", "RenderColorModify")
hook.Remove("RenderScreenspaceEffects", "RenderBloom")
hook.Remove("RenderScreenspaceEffects", "RenderToyTown")
hook.Remove("RenderScreenspaceEffects", "RenderTexturize")
hook.Remove("RenderScreenspaceEffects", "RenderSunbeams")
hook.Remove("RenderScreenspaceEffects", "RenderSobel")
hook.Remove("RenderScreenspaceEffects", "RenderSharpen")
hook.Remove("RenderScreenspaceEffects", "RenderMaterialOverlay")
hook.Remove("RenderScreenspaceEffects", "RenderMotionBlur")
hook.Remove("RenderScene", "RenderStereoscopy")
hook.Remove("RenderScene", "RenderSuperDoF")
hook.Remove("GUIMousePressed", "SuperDOFMouseDown")
hook.Remove("GUIMouseReleased", "SuperDOFMouseUp")
hook.Remove("PreventScreenClicks", "SuperDOFPreventClicks")
hook.Remove("PostRender", "RenderFrameBlend")
hook.Remove("PreRender", "PreRenderFrameBlend")
hook.Remove("Think", "DOFThink")
hook.Remove("RenderScreenspaceEffects", "RenderBokeh")
hook.Remove("NeedsDepthPass", "NeedsDepthPass_Bokeh")
hook.Remove("PostDrawEffects", "RenderWidgets")

hook.Add("OnEntityCreated","WidgetInit",function(ent)
	if ent:IsWidget() then
		hook.Add( "PlayerTick", "TickWidgets", function( pl, mv ) widgets.PlayerTick( pl, mv ) end ) 
		hook.Remove("OnEntityCreated","WidgetInit")
	end
end)

hook.Add('InitPostEntity', 'azd',function()
	LocalPlayer():ConCommand('snd_restart; cl_drawmonitors 0; cl_tree_sway_dir .5 .5;')
    hook.Remove("StartChat", "StartChatIndicator")
    hook.Remove("FinishChat", "EndChatIndicator")
end)

hook.Add("OnAchievementAchieved", "gay2", function() return true end)

timer.Create( "lerp_timer", 1, 0, function() 
    local ratio = 2
    local lerp = 60
    local online = #player.GetAll()
    if online > 55 then 
        lerp = math.Clamp( online*ratio, 60, 250 )
    end 
    RunConsoleCommand( "cl_interp",lerp/1000 )
end )

hook.Add( "ChatText", "asdqwe", function( index, name, text, typ )
    if  typ == "joinleave" then return true end
    if  typ == "namechange" then return true end
end )

local GM = GAMEMODE
local CalcMainActivity = GM.CalcMainActivity
local UpdateAnimation = GM.UpdateAnimation
local PrePlayerDraw = GM.PrePlayerDraw
local DoAnimationEvent = GM.DoAnimationEvent
local PlayerFootstep = GM.PlayerFootstep
local PlayerStepSoundTime = GM.PlayerStepSoundTime
local TranslateActivity = GM.TranslateActivity

function GM:CalcMainActivity(pl, ...)
	if pl:ShouldHide() then return pl.CalcIdeal, pl.CalcSeqOverride end
	return CalcMainActivity(self, pl, ...)
end

function GM:UpdateAnimation(pl, ...)
	if pl:ShouldHide() then return end
	return UpdateAnimation(self, pl, ...)
end

function GM:PrePlayerDraw(pl, ...)
	if pl:ShouldHide() then return true end
	return PrePlayerDraw(self, pl, ...)
end

function GM:DoAnimationEvent(pl, ...)
	if pl:ShouldHide() then return pl.CalcIdeal end
	return DoAnimationEvent(self, pl, ...)
end

function GM:PlayerFootstep(pl, ...)
	if pl:NotInRange() then return true end
	PlayerFootstep(self, pl, ...)
end

function GM:PlayerStepSoundTime(pl, ...)
	if pl:NotInRange() then return 350 end
	return PlayerStepSoundTime(self, pl, ...)
end

function GM:TranslateActivity(pl, ...)
	if pl:ShouldHide() then return ACT_HL2MP_IDLE end
	return TranslateActivity(self, pl, ...)
end

function render.SupportsHDR() return false end
function render.SupportsPixelShaders_2_0() return false end
function render.SupportsPixelShaders_1_4() return false end
function render.SupportsVertexShaders_2_0() return false end
function render.GetDXLevel() return 80 end