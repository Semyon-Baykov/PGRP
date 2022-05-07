include("shared.lua")

surface.CreateFont( 'letter_font', {
    font = 'Roboto',
    size = 15,
    weight = 100,
    antialias = false,
} )

surface.CreateFont( 'letter_font2', {
    font = 'Roboto',
    size = 13,
    antialias = false,
} )

local frame
local SignButton

function ENT:Draw()
    self:DrawModel()
    local Pos = self:GetPos()
    local Ang = self:GetAngles()
    Ang:RotateAroundAxis(Ang:Up(), 90)
    
    cam.Start3D2D(Pos + Ang:Up() * 1.6, Ang, 0.11)
       draw.DrawText( DarkRP.textWrap(self:GetNWString( 'letter_text', 'nay' ), 'DebugFixed', 200), 'DebugFixed', 5, 5, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
       draw.DrawText( 'Подпись: '..(IsValid(self:Getsigned()) and self:Getsigned():Nick() or 'Никто'), 'DebugFixed', 5, 200, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
     -- draw.WordBox(2, -TextWidth2 * 0.5, 18, owner, "HUDNumber5", Color(140, 0, 0, 100), Color(255, 255, 255, 255))
    cam.End3D2D()

end

local function KillLetter(msg)

end
usermessage.Hook("KillLetter", KillLetter)

local function ShowLetter(msg)
    if frame then
        frame:Remove()
    end

    local LetterMsg = ""
    local Letter = msg:ReadEntity()
    local LetterType = msg:ReadShort()
    local LetterPos = msg:ReadVector()
    local sectionCount = msg:ReadShort()
    local LetterY = ScrH() / 2 - 300
    local LetterAlpha = 255

    Letter:CallOnRemove("Kill letter HUD on remove", KillLetter)

    for k = 1, sectionCount, 1 do
        LetterMsg = LetterMsg .. msg:ReadString()
    end

    local frame = vgui.Create( 'gpFrame' )
    frame:SetSize( 500, 500 )
    frame:Center()
    frame:SetTitle( 'Письмо' )
    frame:MakePopup()

    frame.PaintOver = function( _, w, h )

        draw.DrawText( DarkRP.textWrap( Letter:GetNWString( 'letter_text' ), 'Trebuchet24', 500 ), 'Trebuchet24', 5, 30, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP  )

        draw.DrawText( 'Подпись: '..(IsValid(Letter:Getsigned()) and Letter:Getsigned():Nick() or 'Никто'), 'Trebuchet18', 5, 450, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)


    end

    local sign = vgui.Create( 'gpButton', frame )
    sign:Dock( BOTTOM )
    sign:setText( 'Подписать' )
    sign.DoClick = function()

        RunConsoleCommand( '_DarkRP_SignLetter', Letter:EntIndex() )

    end

 

end
usermessage.Hook("ShowLetter", ShowLetter)
