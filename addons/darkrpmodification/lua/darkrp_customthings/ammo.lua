﻿--[[---------------------------------------------------------------------------
Ammo types
---------------------------------------------------------------------------
Ammo boxes that can be purchased in the F4 menu.

Add your custom ammo types in this file. Here's the syntax:
DarkRP.createAmmoType("ammoType", {
    name = "Ammo name",
    model = "Model",
    price = 1234,
    amountGiven = 5678,
    customCheck = function(ply) return ply:IsAdmin()
})

ammoType: The name of the ammo that Garry's mod recognizes
	If you open your SWEP's shared.lua, you can find the ammo name next to
	SWEP.Primary.Ammo = "AMMO NAME HERE"
	or
	SWEP.Secondary.Ammo = "AMMO NAME HERE"

name: The name you want to give to the ammo. This can be anything.

model: The model you want the ammo to have in the F4 menu

price: the price of your ammo in dollars

amountGiven: How much bullets of this ammo is given every time the player buys it

customCheck: (Optional! Advanced!) a Lua function that describes who can buy the ammo.
	Similar to the custom check function for jobs and shipments
	Parameters:
		ply: the player who is trying to buy the ammo

Examples are below!

Pistol ammo type. Used by p228, desert eagle and all other pistols
Example 1:

DarkRP.createAmmoType("357", {
	name = "357",
	model = "models/Items/BoxSRounds.mdl",
	price = 30,
	amountGiven = 24
})

Buckshot ammo, used by the shotguns
Example 2:

DarkRP.createAmmoType("SniperPenetratedRound", {
	name = "SniperPenetratedRound",
	model = "models/Items/BoxBuckshot.mdl",
	price = 50,
	amountGiven = 8
})

Rifle ammo, usually used by assault rifles
Example 3:

DarkRP.createAmmoType("AirboatGun", {
	name = "Winchesterammo",
	model = "models/Items/BoxMRounds.mdl",
	price = 80,
	amountGiven = 30
})

Add new ammo types under the next line!
---------------------------------------------------------------------------]]
DarkRP.createAmmoType("357", {
	name = "Патроны для револьера",
	model = "models/Items/357ammobox.mdl",
	price = 60,
	amountGiven = 20
})
DarkRP.createAmmoType("AR2", {
	name = "Патроны для винтовки",
	model = "models/Items/BoxMRounds.mdl",
	price = 60,
	amountGiven = 30
})
DarkRP.createAmmoType("Buckshot", {
	name = "Патроны для дробовика",
	model = "models/Items/BoxBuckshot.mdl",
	price = 40,
	amountGiven = 8
})
DarkRP.createAmmoType("Pistol", {
	name = "Патроны для пистолета",
	model = "models/Items/BoxSRounds.mdl",
	price = 20,
	amountGiven = 20
})
DarkRP.createAmmoType("SMG1", {
	name = "Патроны для ПП",
	model = "models/Items/BoxSRounds.mdl",
	price = 40,
	amountGiven = 30
})
DarkRP.createAmmoType("SniperPenetratedRound", {
	name = "Патроны для снайперской винтовки",
	model = "models/items/sniper_round_box.mdl",
	price = 60,
	amountGiven = 10
})