-- weapon_vape_medicinal.lua
-- Defines a vape that heals the player

-- Vape SWEP by Swamp Onions - http://steamcommunity.com/id/swamponions/

if CLIENT then
	include('weapon_vape/cl_init.lua')
else
	include('weapon_vape/shared.lua')
end

SWEP.PrintName = "Медицинский"

SWEP.Instructions = "Вдыхая данный дым, ваши лёгкие очищаются и выдают вам новые силы."

SWEP.VapeID = 3

--JuicyVapeJuices = {
--	{name = "Лечебный", color = Color(0, 161, 13,255)}
--}

SWEP.VapeAccentColor = Vector(0,1,0.5)
SWEP.VapeTankColor = Vector(0,0.5,0.25)

-- note: healing functionality is in weapon_vape/init.lua