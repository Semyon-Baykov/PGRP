local PANEL = {}

function PANEL:Paint( w, h )
	surface.SetDrawColor( 76,76,76, 255 )
	surface.DrawRect( 0, 0, w, h )
	self:DrawTextEntryText( Color( 255, 255, 255 ), Color( 30, 130, 255 ), Color( 255, 255, 255 ) )
	if self:HasFocus() then
		draw.RoundedBox( 0, 0, h-1, w, 1, color_white )
	else
		draw.RoundedBox( 0, 0, h-1, w, 1, Color( 170, 170, 170 ) )
	end
end

function PANEL:SetAlign( num )

	self.align = num

end

vgui.Register( 'gpTextEntry', PANEL, 'DTextEntry' )

local PANEL = {}

function PANEL:Paint( w, h )
	surface.SetDrawColor( color_cgray.r, color_cgray.g, color_cgray.b, 90 )
	surface.DrawRect( 0, 0, w, h )
	draw.SimpleText( self:GetValue(), self:GetFont(), (self.align == 1 and w/2) or 10, h/2, color_white, (self.align == 1 and TEXT_ALIGN_CENTER) or TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER  )
	if self:HasFocus() then
		draw.RoundedBox( 0, 0, h-1, w, 1, color_white )
	else
		draw.RoundedBox( 0, 0, h-1, w, 1, Color( 170, 170, 170 ) )
	end
end

function PANEL:SetAlign( num )

	self.align = num

end

vgui.Register( 'gpTextEntryA', PANEL, 'DTextEntry' )