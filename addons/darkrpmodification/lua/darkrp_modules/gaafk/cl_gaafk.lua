surface.CreateFont( 'gaafk', { font = 'DermaDefault', size = 15 } )

local gaafk = {}

gaafk.isAFK = false

gaafk.showUI = function()

	local frame = vgui.Create( 'DFrame' )

	frame:SetSize( ScrW() - ( ScrW() / 1.55 ), ScrH() - ( ScrH() / 1.08 ) )

	frame:ShowCloseButton( false )

	frame:Center()

	frame:SetTitle( 'ANTI-AFK' )

	frame.Think = function( self )

		if not gaafk.isAFK or ( LocalPlayer().isAFK and not LocalPlayer():isAFK() or false ) then

			self:Remove()

		end

		if crashmenu then

			if CurTime() - crashmenu.lastping >= 10 then

				self:SetVisible( false )

			else

				self:SetVisible( true )

			end

		end
	end

	local here = vgui.Create( 'DLabel', frame )

	here:SetFont( 'gaafk' )

	here:SetText( 'Вы здесь? Если да, то сделайте любое телодвижение, иначе вы будете кикнуты c профессии!' )

	here:SizeToContents()

	here:Dock( TOP )
end

net.Receive( 'gaafk', function( len, ply ) 

	gaafk.isAFK = net.ReadBool()

	if gaafk.isAFK then

--		gaafk.showUI()

		system.FlashWindow()

	end

end )