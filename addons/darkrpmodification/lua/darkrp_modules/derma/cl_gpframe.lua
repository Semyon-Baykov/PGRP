surface.CreateFont( 'derma.title', {
	font = 'Roboto',
	size = 23
} )



local PANEL = {}

function PANEL:Init()

	self.title = 'Window'
	self:ShowCloseButton( false )
	self.lblTitle:Remove()

	self.close = self:Add( 'DButton' )
	self.close.Paint = function( _, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, color_cred )
		if self.close:IsHovered() then
			draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 255, 255, 10 ) )
		end
	end	
	self.close:SetText( '' )
	self.close.DoClick = function()
		self:Remove()
	end

end

function PANEL:PerformLayout()

	self.close:SetPos( self:GetWide() - 26 - 4, 5 )
	self.close:SetSize( 25, 13 )

end

function PANEL:SetTitle( title )

	self.title = title

end

function PANEL:Paint( w, h )

	gp_dermaUtil.blur( self, 5, 10, 255 )
	draw.RoundedBox( 0, 0, 0, w, h, Color( 54, 54, 54, 255 ) )
	draw.RoundedBox( 0, 0, 0, w, 25, Color(  77, 77, 77, 255 ) )
	draw.SimpleText( self.title, 'derma.title', 5, 0, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )

end

vgui.Register( 'gpFrame', PANEL, 'DFrame' )
