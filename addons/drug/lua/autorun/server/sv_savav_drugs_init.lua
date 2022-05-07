AddCSLuaFile("drugs_effects/savav_acid.lua")

AddCSLuaFile("drugs_effects/savav_watermelon.lua")
   
AddCSLuaFile("drugs_effects/savav_beer.lua")
  
AddCSLuaFile("drugs_effects/savav_LCD.lua")

AddCSLuaFile("drugs_effects/savav_Psilocybin.lua")

AddCSLuaFile("drugs_effects/savav_meth.lua")

AddCSLuaFile("drugs_effects/savav_cocaine.lua")

local function DRUGSINPUT( ply )
	ply:SetNWFloat( "drug", "0" )
end

function DRUGSINPUTDRUG( ply )
	ply:SetNWFloat( "drug", "0" )
end

function DRUGSTHINK(ply)
if !ply:IsValid() then return end
if !ply:Alive() then return end

if ply:GetNWFloat( "drug" ) == "" then


end

end




hook.Add("Think", "DRUGSTHINK", function() for k, v in pairs( player.GetAll() ) do DRUGSTHINK(v) end end)

hook.Add( "PlayerInitialSpawn", "DRUGSINPUT", DRUGSINPUT )
hook.Add( "PlayerInitialSpawn", "DRUGSINPUTDRUG", DRUGSINPUTDRUG )