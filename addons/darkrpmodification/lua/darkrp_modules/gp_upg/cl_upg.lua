module( 'gp_upg', package.seeall )

function OpenMenu( player_upg )

	local frame = vgui.Create( 'gpFrame' )
	frame:SetSize( 500, 170 )
	frame:Center()
	frame:MakePopup()
	frame:SetTitle( 'Улучшение персонажа' )

	for k,v in pairs( tbl ) do

		local i = frame:Add( 'DButton' )
		i:SetHeight( 65 )
		i:Dock( TOP )
		i:DockMargin( 0, 0, 0, 5 )
		i:SetText( '' )
		i.Paint = function( self, w, h )

			draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 200 ) )

			draw.SimpleText( v.name, 'Trebuchet24', 10, 10, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			draw.SimpleText( v.desc, 'Trebuchet18', 10, 35, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )

			if !player_upg[ v.id ] then
			
				draw.SimpleText( DarkRP.formatMoney( v.price ), 'Trebuchet24', w-20, h/2, Color( 108, 198, 100 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
			
			else

				draw.SimpleText( 'Куплено', 'Trebuchet24', w-20, h/2, Color( 108, 215, 100 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )

			end


			if self:IsHovered() then

				draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 255, 255, 10 ) )

			end

		end

		i.DoClick = function()
			if LocalPlayer():canAfford( v.price ) and not player_upg[ v.id ] == true then
				Derma_Query( 'Вы действительно хотите купить улучшение за '..DarkRP.formatMoney( v.price )..'?', 'Подтверждение', 'Да', function()
					
						print('da')

						net.Start( 'gp_upg' )
							net.WriteInt( k, 5 )
						net.SendToServer()
						frame:Remove()

					
				end, 'Нет', function() 
				frame:Remove() end)

				end
			end

	end

end

net.Receive( 'gp_upg_op', function()

	local tbl = net.ReadTable()

	OpenMenu( tbl )

end )
