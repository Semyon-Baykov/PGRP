--[[
 _____            _ _     _   _        _____      _ _             _____           _                 
|  __ \          | (_)   | | (_)      |  __ \    | (_)           / ____|         | |                
| |__) |___  __ _| |_ ___| |_ _  ___  | |__) |__ | |_  ___ ___  | (___  _   _ ___| |_ ___ _ __ ___  
|  _  // _ \/ _` | | / __| __| |/ __| |  ___/ _ \| | |/ __/ _ \  \___ \| | | / __| __/ _ \ '_ ` _ \ 
| | \ \  __/ (_| | | \__ \ |_| | (__  | |  | (_) | | | (_|  __/  ____) | |_| \__ \ ||  __/ | | | | |
|_|  \_\___|\__,_|_|_|___/\__|_|\___| |_|   \___/|_|_|\___\___| |_____/ \__, |___/\__\___|_| |_| |_|
                                                                                                                                         
--]]

local MODULE = GAS.Logging:MODULE()
MODULE.Category = "Realistic Police"
MODULE.Name = "Stungun"
MODULE.Colour = Color(44, 91, 240)

MODULE:Hook("RealisticPolice:Tazz", "RealisticPolice:Tazz", function(ply, owner)
    MODULE:Log(GAS.Logging:FormatPlayer(ply) .. " was tased by "..GAS.Logging:FormatPlayer(owner))
end)

GAS.Logging:AddModule(MODULE)

-----------------------------------------------------------------

local MODULE = GAS.Logging:MODULE()
MODULE.Category = "Realistic Police"
MODULE.Name = "Cuff / UnCuff"
MODULE.Colour = Color(44, 91, 240)

MODULE:Hook("RealisticPolice:Cuffed", "RealisticPolice:Cuffed", function(ply, officer)
    MODULE:Log(GAS.Logging:FormatPlayer(ply).. " was cuffed by "..GAS.Logging:FormatPlayer(officer))
end)

MODULE:Hook("RealisticPolice:UnCuffed", "RealisticPolice:UnCuffed", function(ply, officer)
    MODULE:Log(GAS.Logging:FormatPlayer(ply).. " was uncuffed by "..GAS.Logging:FormatPlayer(officer))
end)

GAS.Logging:AddModule(MODULE)

-----------------------------------------------------------------

local MODULE = GAS.Logging:MODULE()
MODULE.Category = "Realistic Police"
MODULE.Name = "Jail / UnJail"
MODULE.Colour = Color(44, 91, 240)

MODULE:Hook("RealisticPolice:Jailed", "RealisticPolice:Jailed", function(ply, Time)
    MODULE:Log(GAS.Logging:FormatPlayer(ply).. " was jailed for "..Time.." s")
end)

MODULE:Hook("RealisticPolice:UnJailed", "RealisticPolice:UnJailed", function(ply, officer)
    MODULE:Log(GAS.Logging:FormatPlayer(ply).. " was unjailed")
end)

GAS.Logging:AddModule(MODULE)

-----------------------------------------------------------------

local MODULE = GAS.Logging:MODULE()
MODULE.Category = "Realistic Police"
MODULE.Name = "Fining"
MODULE.Colour = Color(44, 91, 240)

MODULE:Hook("RealisticPolice:FinePlayer", "RealisticPolice:FinePlayer", function(ply, rptEnt)
    MODULE:Log(GAS.Logging:FormatPlayer(ply).. " send a fine to "..GAS.Logging:FormatPlayer(rptEnt))
end)

MODULE:Hook("RealisticPolice:FineVehicle", "RealisticPolice:FineVehicle", function(ply, officer)
    MODULE:Log(GAS.Logging:FormatPlayer(ply).. " send a fine to a vehicle")
end)

GAS.Logging:AddModule(MODULE)
