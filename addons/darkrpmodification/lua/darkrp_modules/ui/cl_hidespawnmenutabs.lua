hook.Add("SpawnMenuOpen", "CDRP", function()
	local all = {"#spawnmenu.category.dupes", "#spawnmenu.category.saves"}
	local nonadmins = {"#spawnmenu.category.entities", "#spawnmenu.category.npcs", '#spawnmenu.category.weapons', '#spawnmenu.category.vehicles' }

	for k = #g_SpawnMenu.CreateMenu.Items, 1, -1 do
		local v = g_SpawnMenu.CreateMenu.Items[k]
		if table.HasValue(all, v.Name) or not LocalPlayer():gp_WepAccess() and table.HasValue(nonadmins, v.Name) then
			g_SpawnMenu.CreateMenu:CloseTab(v.Tab, true)
		end
	end
	hook.Remove("SpawnMenuOpen", "CDRP")
end)

--[[
"#spawnmenu.category.dupes" -- Никто
"#spawnmenu.category.saves" -- Никто
"#spawnmenu.category.npcs" -- Superadmin
"#spawnmenu.category.vehicles" -- Superadmin
"#spawnmenu.category.postprocess" -- user
"#spawnmenu.category.entities" -- Superadmin
"#spawnmenu.category.weapons" -- user
"SCars" -- Superadmin
]]