module( 'gp_ninv', package.seeall )

local lp = LocalPlayer()
local slots = 12

net.Receive( 'gp_ninv_update', function()

	gpinvitems = nil
	gpinvitems = net.ReadTable()

end )

function fixMdlPos( mdl )
	if !mdl then return end

	local mn, mx = mdl.Entity:GetRenderBounds()
	local size = 0
	size = math.max( size, math.abs(mn.x) + math.abs(mx.x) )
	size = math.max( size, math.abs(mn.y) + math.abs(mx.y) )
	size = math.max( size, math.abs(mn.z) + math.abs(mx.z) )
	mdl:SetFOV( 45 )
	mdl:SetCamPos( Vector( size, size, size ) )
	mdl:SetLookAt( (mn + mx) * 0.5 )


end

function OpenNewInventory()

	local sw, sh = ScrW(), ScrH()

	frame = vgui.Create( 'DFrame', g_ContextMenu )
	frame:SetSize( 400, 350 )
	frame:SetPos( sw-400, sh/2-200 )
	frame:SetTitle( '' )
	frame:ShowCloseButton( false )
	frame:SetMouseInputEnabled(true)
	frame.Paint = function( _, w, h )

		gp_inv.blur( _, 5, 10, 255 )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 150 ) )
		draw.RoundedBox( 0, 0, 0, w, 50, Color( 0, 0, 0, 170 ) )
		draw.SimpleText( 'Инвентарь', 'Trebuchet24', 15, 25, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		draw.SimpleText(  (CalcInvWeight() or 0)..'/'..LocalPlayer():GetMaxWeight() , 'Trebuchet24', w-25, 25, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )

	end

	local function cont()

		local container = frame:Add( 'DPanel' )
		container:Dock( FILL )
		container:DockMargin( 2, 28, 2, 2 )
		container.Paint = function() end
		local st = {}
		local ssw = 0
		local ssh = 0
		for i = 1, slots do

			local slot = container:Add( 'DPanel' )
			slot:SetSize( 93, 92 )
			slot.Paint = function( _, w, h )
				draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 165 ) )
			end
			slot:Receiver( 'invitem', function( self, tbl, drop ) 
				if drop then
					net.Start( 'gp_ninv_setslot' )
						net.WriteString( tbl[1].class )
						net.WriteInt( i, 5 )
					net.SendToServer()
					timer.Simple( 0.3, function() container:Remove() if frame:IsValid() then cont() end end )
				end

			end)
			st[i] = slot
			if ssw >= (93*4) then
				ssw = 0
				ssh = ssh + 97
			end
			slot:SetPos( ssw, ssh )
			ssw = ssw + 98

		end

		for k,v in pairs( gpinvitems ) do

			if not v.class then continue end
			local it = items[v.class]
			local item = st[k]:Add( 'DModelPanel' )
			
			function item:LayoutEntity( Entity ) return end

			item:Dock( FILL )

			item.OverlayFade = 0
			item:Droppable( 'invitem' )
			item.class = v.class
			item:SetModel( it.model )
			
			item.PaintOver = function( _, w, h )

				draw.SimpleText( it.name, 'Trebuchet18', w/2, h-15, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				draw.SimpleText( 'x'..v.amount, 'Trebuchet18', 15, 15, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				

			end
			item.DoRightClick = function()

				local mm = DermaMenu( item )

				if it.use then
					mm:AddOption( 'Использовать', function()
						net.Start( 'gp_ninv_act' )
							net.WriteString( 'use' )
							net.WriteString( v.class )
							net.WriteInt( 1, 7 )
						net.SendToServer()
						timer.Simple( 0.3, function() container:Remove() if frame:IsValid() then cont() end end )
					end ):SetImage('icon16/tick.png')
				end
				if it.spawn then
					mm:AddOption( 'Выбросить', function() 
						if v.amount > 1 and not (v.class == 'spawned_food') then
							local f = vgui.Create( 'DFrame' )
							f:SetTitle( 'Сколько вы хотите выбросить?' )
							f:SetSize(300,100)
							f:Center()
							f:MakePopup()
							f.OnClose = function()
							end

							local s = vgui.Create( 'DNumSlider', f )
							s:Dock( TOP )
							s:DockMargin( -150, 0, 0, 0 )
							s:SetMin( 1 )
							s:SetMax( v.amount )
							s:SetDecimals( 0 )
							s:SetValue( 1 )
							local db = vgui.Create( 'DButton', f )
							db:Dock( LEFT )
							db:DockMargin(50, 0, 0, 0)
							db:SetText( 'Принять' )
							db.DoClick = function()
								net.Start( 'gp_ninv_act' )
									net.WriteString( 'drop' )
									net.WriteString( v.class )
									net.WriteInt( math.Round(s:GetValue()), 7  )
								net.SendToServer()
								timer.Simple( 0.3, function() container:Remove() if frame:IsValid() then cont() end end )
								f:Close()
							end

							local db = vgui.Create( 'DButton', f )
							db:Dock( RIGHT )
							db:SetText( 'Отмена' )
							db:DockMargin(0, 0, 50, 0)
							db.DoClick = function()
								f:Close()
							end
						else
							net.Start( 'gp_ninv_act' )
								net.WriteString( 'drop' )
								net.WriteString( v.class )
								net.WriteInt( 1, 7 )
							net.SendToServer()
							timer.Simple( 0.3, function() container:Remove() if frame:IsValid() then cont() end end )
						end
					end ):SetImage('icon16/cart_delete.png')
				end
				mm:AddOption( 'Уничтожить', function() 
					if v.amount > 1 then
						local f = vgui.Create( 'DFrame' )
						f:SetTitle( 'Сколько вы хотите уничтожить?' )
						f:SetSize(300,100)
						f:Center()
						f:MakePopup()
						f.OnClose = function()
						end

						local s = vgui.Create( 'DNumSlider', f )
						s:Dock( TOP )
						s:DockMargin( -150, 0, 0, 0 )
						s:SetMin( 1 )
						s:SetMax( v.amount )
						s:SetDecimals( 0 )
						s:SetValue( 1 )
						local db = vgui.Create( 'DButton', f )
						db:Dock( LEFT )
						db:DockMargin(50, 0, 0, 0)
						db:SetText( 'Принять' )
						db.DoClick = function()
							net.Start( 'gp_ninv_act' )
								net.WriteString( 'remove' )
								net.WriteString( v.class )
								net.WriteInt( math.Round(s:GetValue()), 7  )
							net.SendToServer()
							timer.Simple( 0.3, function() container:Remove() if frame:IsValid() then cont() end end )
							f:Close()
						end

						local db = vgui.Create( 'DButton', f )
						db:Dock( RIGHT )
						db:SetText( 'Отмена' )
						db:DockMargin(0, 0, 50, 0)
						db.DoClick = function()
							f:Close()
						end
					else
						Derma_Query( 'Данное действие невозможно отменить!', 'Вы уверены?', 'Да', function() 
							net.Start( 'gp_ninv_act' )
								net.WriteString( 'remove' )
								net.WriteString( v.class )
								net.WriteInt( 1, 7 )
							net.SendToServer()
							timer.Simple( 0.3, function() container:Remove() if frame:IsValid() then cont() end end ) 
						end, 'Отмена', function() end )
					end
				end):SetImage('icon16/cross.png')
				mm:Open()

			end
			fixMdlPos(item)



		end
		return container
	end
	cont()



end

hook.Add( 'ContextMenuOpen', 'gp_openinv', function()
	 if LocalPlayer():InVehicle() != false then return end
	 if LocalPlayer():GetEyeTrace().Entity:GetClass() == 'mediaplayer_tv' then return end
	 OpenNewInventory()
end )
hook.Add( 'OnContextMenuClose', 'gp_closeinv', function()
	if IsValid(frame) then 
		frame:Remove()
	end
end )