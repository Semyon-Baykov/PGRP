-- weapon_vape_golden.lua
-- Defines a vape with gold accent and shaded tank

-- Vape SWEP by Swamp Onions - http://steamcommunity.com/id/swamponions/

if CLIENT then
	include('weapon_vape/cl_init.lua')
else
	include('weapon_vape/shared.lua')
end

SWEP.PrintName = "Золотой"

-- SWEP.VapeID = 20

--JuicyVapeJuices = {
	--{name = "Золото", color = Color(255, 255, 0, 255)}--,
	--{name = "Окисленное Золото", color = Color(255, 93, 0, 255)}
--}

SWEP.Instructions = "Элегантно выглядищий вейп, но ничего особенного!"

SWEP.VapeAccentColor = Vector(1,0.8,0)
SWEP.VapeTankColor = Vector(0.1,0.1,0.1)