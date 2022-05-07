local PANEL = {}

surface.CreateFont( 'button.text', {
	font = 'Roboto',
	size = 22
} )


function PANEL:Init()
	self:SetText('')
end

function PANEL:setText( text )
	self.text = text
end

function PANEL:Paint( w, h )

	draw.RoundedBox( 0, 0, 0, w, h, self:IsHovered() and Color( 100, 100, 100 ) or Color( 76, 76, 76 ) )
	draw.SimpleText( self.text, 'button.text', w/2, h/2, self:IsHovered() and Color( 240, 240, 240) or color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

end

function PANEL:SizeToContents()

	surface.SetFont( 'button.text' )
	local w, h = surface.GetTextSize( self.text )

	self:SetWide( w )

end

vgui.Register( 'gpButton', PANEL, 'DButton' )
