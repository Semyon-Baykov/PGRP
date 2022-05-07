module( 'gp_trinfo', package.seeall )

surface.CreateFont( 'gp_trinfo_arial' , {
	font = 'Roboto',
	size = 24,
	weight = 300
})

tbl = {
	['prop_door_rotating'] = {
		{
			key = 'E',
			func = function( ent ) 
				return 'Открыть/закрыть'
			end,
		},
	},
	['prop_vehicle_jeep'] = {
		{
			key = 'E',
			info = 'Сесть в машину'
		},
	},
	['spawned_weapon'] = {
		{
			key = 'E',
			info = 'Использовать'
		},
		{
			key = 'T',
			info = 'Положить в инвентарь'
		},
	},
	['spawned_food'] = {
		{
			key = 'E',
			info = 'Использовать'
		},
		{
			key = 'T',
			info = 'Положить в инвентарь'
		},
	},
	['spawned_shipment'] = {
		{
			key = 'E',
			info = 'Взять'
		},
		{
			key = 'T',
			info = 'Положить в инвентарь'
		},
	},
	['spawned_ammo'] = {
		{
			key = 'E',
			info = 'Взять'
		}
	},
	['money_printer'] = {
		{
			key = 'E',
			info = 'Использовать'
		}
	},
	['freshcardealer'] = {
		{
			key = 'E',
			info = ''
		}
	},
	['npc_rg'] = {
		{
			key = 'E',
			info = ''
		}
	},
	['buyer'] = {
		{
			key = 'E',
			info = ''
		}
	},
	['cm_stove'] = {
		{
			key = 'E',
			info = ''
		}
	},
	['ent_ars'] = {
		{
			key = 'E',
			info = ''
		}
	},
	['prop_ragdoll'] = {
		{
			key = 'E',
			info = ''
		}
	},
	['eml_buyer'] = {
		{
			key = 'E',
			info = ''
		}
	},
	['boyar_vendingmachine'] = {
		{
			key = 'E',
			info = 'Купить боярышник'
		}
	},
	['spawned_money'] = {
		{
			key = 'E',
			info = 'Взять'
		}
	}
}
tbl.halos = {
	['spawned_weapon'] = {
		gp_halo = true
	},
	['spawned_shipment'] = {
		gp_halo = true
	},
	['spawned_ammo'] = {
		gp_halo = true
	},
	['spawned_food'] = {
		gp_halo = true
	},
	['prop_ragdoll'] = {
		gp_halo = true
	},
	['spawned_money'] = {
		gp_halo = true
	}
}

local function build( key, info, amount )

	surface.SetFont( 'gp_trinfo_arial' )

	local boxsizew, boxsizeh = 36,36
	local infosizew, infosizeh = surface.GetTextSize( info )
	local padding = -25
	local down = 100
	local w, h = ScrW(), ScrH()

	draw.SimpleTextOutlined( info, 'gp_trinfo_arial', w/2+boxsizew/2, h/2+down + ( amount / 0.025 ) , Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ))
	surface.SetMaterial( Material( 'ui/key.png' ) )
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.DrawTexturedRect( w/2-boxsizew/2 - ( infosizew + boxsizew + padding )/2, h/2-boxsizeh/2+down + ( amount / 0.025 ), boxsizew, boxsizeh )
	draw.SimpleText( key, 'Trebuchet24', w/2 - ( infosizew + boxsizew + padding )/2, h/2+down + ( amount / 0.025 ), Color( 0, 0, 0 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

end

local dis = 100

hook.Add( 'HUDPaint', 'gp_trinfo_hp',function()

	local te = LocalPlayer():GetEyeTrace().Entity
	if !IsValid( te ) then return end
	if LocalPlayer():InVehicle() then return end
	if LocalPlayer():GetPos():DistToSqr(te:GetPos()) > (dis * dis) then return end

	if tbl[ te:GetClass() ] then
		for k,v in pairs( tbl[ te:GetClass() ] ) do
			if v.func then
				build( v.key, v.func(te), k )
			else
				build( v.key, v.info, k )
				if input.WasKeyPressed( KEY_T ) then
					print( 'a' )
				end
			end
		end
	end	

end )



hook.Add( 'PreDrawHalos', 'gp_trinfo_halo', function()

	local tr = LocalPlayer():GetEyeTrace()

	if (tr.Entity and tr.HitNonWorld and IsValid(tr.Entity) and tbl.halos[tr.Entity:GetClass()] and tbl.halos[tr.Entity:GetClass()].gp_halo and LocalPlayer():GetPos():DistToSqr(tr.Entity:GetPos()) <= (dis * dis)) then
		halo.Add({tr.Entity}, Color( 255, 255, 255 ))
	end

end )
