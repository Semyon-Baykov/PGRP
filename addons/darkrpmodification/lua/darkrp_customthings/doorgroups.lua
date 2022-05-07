--[[---------------------------------------------------------------------------
Door groups
---------------------------------------------------------------------------
The server owner can set certain doors as owned by a group of people, identified by their jobs.


HOW TO MAKE A DOOR GROUP:
AddDoorGroup("NAME OF THE GROUP HERE, you will see this when looking at a door", Team1, Team2, team3, team4, etc.)
---------------------------------------------------------------------------]]


-- Example: AddDoorGroup("Cops and Mayor only", TEAM_CHIEF, TEAM_POLICE, TEAM_MAYOR)
-- Example: AddDoorGroup("Gundealer only", TEAM_GUN)

			AddDoorGroup("Стационарный пост полиции", TEAM_CHIEF, TEAM_POLICE, TEAM_MAYOR, TEAM_FBI, TEAM_PPS, TEAM_DPS, TEAM_OMON)
			AddDoorGroup("Городская администрация", TEAM_MAYOR, TEAM_CHIEF, TEAM_POLICE, TEAM_FBI, TEAM_PPS, TEAM_DPS, TEAM_OMON)
			AddDoorGroup("Сбербанк", TEAM_MAYOR, TEAM_CHIEF, TEAM_POLICE, TEAM_FBI, TEAM_PPS, TEAM_OMON, TEAM_DPS)
			AddDoorGroup("Росгвардия", TEAM_NRG1, TEAM_NRG2, TEAM_NRG3, TEAM_NRG4)
			AddDoorGroup("Командование Росгвардии", TEAM_NRG2, TEAM_NRG3, TEAM_NRG4)
			AddDoorGroup("Старшее командование Росгвардии", TEAM_NRG3, TEAM_NRG4)
			AddDoorGroup("Министерство Чрезвычайных Ситуаций",  TEAM_MEDIC)
			AddDoorGroup("КПП Росгвардии",  TEAM_NRG4)
			AddDoorGroup("Полиция", TEAM_CHIEF, TEAM_POLICE, TEAM_FBI, TEAM_PPS, TEAM_DPS, TEAM_OMON)
			AddDoorGroup("Администрация", TEAM_CHIEF, TEAM_POLICE, TEAM_MAYOR, TEAM_FBI, TEAM_PPS, TEAM_DPS, TEAM_OMON)
			AddDoorGroup("Казино", TEAM_CHIEF, TEAM_POLICE, TEAM_MAYOR, TEAM_FBI, TEAM_PPS, TEAM_DPS, TEAM_OMON)
			AddDoorGroup("Вход в Казино", TEAM_COOK, TEAM_TRADE, TEAM_CHIEF, TEAM_POLICE, TEAM_MAYOR, TEAM_FBI, TEAM_PPS, TEAM_DPS, TEAM_OMON)


			