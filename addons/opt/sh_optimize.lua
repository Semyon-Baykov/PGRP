hook.Remove("PlayerTick", "TickWidgets")
hook.Remove("PlayerTick","TickWidgets")
hook.Remove("Think", "CheckSchedules")
hook.Remove("LoadGModSave", "LoadGModSave")
timer.Destroy("HostnameThink")

local GM = GAMEMODE

function GM:FindUseEntity(pl, ent)
	return ent
end 