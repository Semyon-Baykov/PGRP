--[[---------------------------------------------------------
	Name: Setup
-----------------------------------------------------------]]
ENT.Type = 'anim'
ENT.Base = 'base_gmodentity'
ENT.PrintName = 'FG Printer - Base'
ENT.Author = 'TheCodingBeast'

ENT.Spawnable = true
ENT.AdminSpawnable = true

--[[---------------------------------------------------------
	Name: Settings
-----------------------------------------------------------]]

--[[---------------------------------------------------------

	pGroupDonator: The group(s) that should be able to purchase donator only upgrades.
	pGroupStaff: The group(s) that should be able to purchase staff only upgrades.

	pTitle: The title of the upgrade window.
	pName: The name of the printer shown on the top.
	pColor: The color of the printer.

	pSpeed: The default speed.
	pQuality: The default quality.
	pCooler: The default cooler.

	pTemp: The starting temperature.
	pTempChange:
	{
		both-above: Temperature change when both the speed and quality level is higher than the cooler level,
		both-below: Temperature change when both the speed and quality level is lower than the cooler level,
		other: Temperature change when when speed and or quality is the same as the cooler level or one is below or above,

		power-off: Temperature change when the printer is powered off,

		blow-chance: The chance of the printer blowing up when temperature is above 75C
	}

	pStorage: The max amount of money the printer should be able to hold (0: Unlimited).

	pMessages: The messages that should be display for each action.

	pLevelSpeed, pLevelQuality, pLevelCooler:
	{
		1: The percentage of the orginal value,
		2: The percentage price of the default upgrade price,
		3: The team required to buy the upgrade (1: Donator, 2: Staff)
	}

-----------------------------------------------------------]]

--> Groups
ENT.pGroupDonator = {'premium'}
ENT.pGroupStaff = {''}

--> Printer
ENT.pTitle = 'PGRP Printers'
ENT.pName = 'Dev Printer'
ENT.pColor = Color(0, 0, 0, 255)

--> Defaults
ENT.pSpeed = 30
ENT.pQuality = 250
ENT.pCooler = 14

--> Temperature
ENT.pTemp = 20
ENT.pTempChange = {
	['both-above'] = function() return math.random(1.5, 5.5) end,
	['both-below'] = function() return math.random(0.1, 0.3) end,
	['other'] = function() return math.random(0.3, 0.6) end,

	['power-off'] = function() return math.random(0.2, 3.5) end,

	['blow-chance'] = function() return math.random(1, 8) end
}

--> Storage
ENT.pStorage = 50000

--> Messages
ENT.pMessages = {
	['money'] = 'У вас не достаточно денег!',
	['rank'] = 'У вас нету премиума!',
	['collect'] = 'Собрано %руб.',
	['explode'] = 'Ваш принтер был уничтожен!'
}

--> Levels
ENT.pLevelSpeed = {
	{100, 0, 0},
	
	{97, 300, 0},
	{95, 300, 0},
	{90, 300, 0},
	{85, 300, 0},
	{80, 300, 0},
	{75, 300, 0},
	{70, 300, 0},
	{65, 600, 1},
	{60, 600, 1},
}

ENT.pLevelQuality = {
	{100, 0, 0},

	{105, 300, 0},
	{110, 300, 0},
	{120, 300, 0},
	{135, 300, 0},
	{145, 300, 0},
	{185, 300, 0},
	{200, 600, 0},
	{250, 600, 1},
	{255, 600, 1},
}

ENT.pLevelCooler = {
	{100, 0, 0},

	{105, 50, 0},
	{110, 50, 0},
	{115, 50, 0},
	{120, 50, 0},
	{125, 50, 0},
	{130, 50, 0},
	{150, 100, 0},
	{200, 200, 0},
	{250, 200, 0},
}

--[[---------------------------------------------------------
	Name: SetupDataTables
-----------------------------------------------------------]]
function ENT:SetupDataTables()

	--> Owner
	self:NetworkVar('Entity', 1, 'owning_ent')

	--> Levels
	self:NetworkVar('Int', 1, 'lvl_speed')
	self:NetworkVar('Int', 2, 'lvl_quality')
	self:NetworkVar('Int', 3, 'lvl_cooler')

	--> Data
	self:NetworkVar('Int', 4, 'data_power')
	self:NetworkVar('Int', 5, 'data_money')
	self:NetworkVar('Float', 6, 'data_temp')

end