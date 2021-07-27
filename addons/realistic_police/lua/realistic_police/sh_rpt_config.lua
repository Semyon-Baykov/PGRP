    
--[[
 _____            _ _     _   _        _____      _ _             _____           _                 
|  __ \          | (_)   | | (_)      |  __ \    | (_)           / ____|         | |                
| |__) |___  __ _| |_ ___| |_ _  ___  | |__) |__ | |_  ___ ___  | (___  _   _ ___| |_ ___ _ __ ___  
|  _  // _ \/ _` | | / __| __| |/ __| |  ___/ _ \| | |/ __/ _ \  \___ \| | | / __| __/ _ \ '_ ` _ \ 
| | \ \  __/ (_| | | \__ \ |_| | (__  | |  | (_) | | | (_|  __/  ____) | |_| \__ \ ||  __/ | | | | |
|_|  \_\___|\__,_|_|_|___/\__|_|\___| |_|   \___/|_|_|\___\___| |_____/ \__, |___/\__\___|_| |_| |_|
                                                                                                                                                  
--]]


Realistic_Police = Realistic_Police or {}
Realistic_Police.PlateConfig = Realistic_Police.PlateConfig or {}
Realistic_Police.Application = Realistic_Police.Application or {}
Realistic_Police.PlateVehicle = Realistic_Police.PlateVehicle or {}
Realistic_Police.FiningPolice = Realistic_Police.FiningPolice or {}
Realistic_Police.Trunk = Realistic_Police.Trunk or {}
Realistic_Police.TrunkPosition = Realistic_Police.TrunkPosition or {}
 
-----------------------------------------------------------------------------
---------------------------- Main Configuration------------------------------
-----------------------------------------------------------------------------

Realistic_Police.Langage = "ru" -- You can choose fr , en , tr , cn 

Realistic_Police.DefaultJob = false -- Default Job Activate/Desactivate (Camera Repairer )

Realistic_Police.TrunkSystem = false -- Do you want to use the trunk system ? 

Realistic_Police.KeyOpenTablet = KEY_I -- Key for open the tablet into a vehicle  

Realistic_Police.WantedMessage = "Разыскивается Сетью Полицейской Структуры" -- Message when you wanted someone with the computer 

Realistic_Police.StungunAmmo = 14 

Realistic_Police.AdminRank = { -- Rank Admin 
    ["superadmin"] = true
}

Realistic_Police.OpenComputer = { -- Which job can open the computer 
    ["Начальник Полиции"] = true,
    ["Сотрудник ДПС"] = true, 
	["Сотрудник ППС"] = true,
	["Сотрудник Полиции"] = true,
	["Сотрудник ОМОН"] = true,
	["Сотрудник ФСБ"] = true,
	["Мэр"] = true
}

Realistic_Police.PoliceVehicle = { -- Police Vehicle
    ["sim_fphys_uaz_patriot_pol"] = true,
    ["sim_fphys_vaz-2114_pol"] = true, 
	["sim_fphys_vaz-2115_pol"] = true, 
	-- ["sim_fphys_uaz_patriot"] = true
}

-----------------------------------------------------------------------------
------------------------- Computer Configuration-----------------------------
-----------------------------------------------------------------------------

Realistic_Police.MaxReport = 4 -- Max report per persson

Realistic_Police.MaxCriminalRecord = 30 -- Max Criminal Record per persson 

Realistic_Police.Application[1] = { -- Unique Id 
    ["Name"] = "Интернет", -- Name of the Application 
    ["Materials"] = Material("rpt_internet.png"), -- Material of the Application 
    ["Function"] = Realistic_Police.FireFox, -- Function Application 
    ["Type"] = "police",  
}

Realistic_Police.Application[2] = { -- Unique Id 
    ["Name"] = "Камеры", -- Name of the Application 
    ["Materials"] = Material("rpt_cctv.png"), -- Material of the Application    
    ["Function"] = Realistic_Police.Camera, -- Function Application 
    ["Type"] = "police",  
}

Realistic_Police.Application[3] = { -- Unique Id 
    ["Name"] = "Криминальные Записи", -- Name of the Application 
    ["Materials"] = Material("rpt_law.png"), -- Material of the Application 
    ["Function"] = Realistic_Police.CriminalRecord, -- Function Application 
    ["Type"] = "police",  
}

Realistic_Police.Application[4] = { -- Unique Id 
    ["Name"] = "Меню репорта", -- Name of the Application 
    ["Materials"] = Material("rpt_cloud.png"), -- Material of the Application   
    ["Function"] = Realistic_Police.ReportMenu, -- Function application 
    ["Type"] = "police",  
}

Realistic_Police.Application[5] = { -- Unique Id 
    ["Name"] = "Лист Репорта", -- Name of the Application 
    ["Materials"] = Material("rpt_documents.png"), -- Material of the Application  
    ["Function"] = Realistic_Police.ListReport, -- Function Application 
    ["Type"] = "police",   
}

Realistic_Police.Application[6] = { -- Unique Id 
    ["Name"] = "(скоро_будет_апдейт)", -- Name of the Application  
    ["Materials"] = Material("rpt_listreport.png"), -- Material of the Application  
    ["Function"] = Realistic_Police.License, -- Function Application 
    ["Type"] = "police",  
}

Realistic_Police.Application[7] = { -- Unique Id 
    ["Name"] = "Полицейской CMD", -- Name of the Application  
    ["Materials"] = Material("rpt_cmd.png"), -- Material of the Application  
    ["Function"] = Realistic_Police.Cmd, -- Function Application  
    ["Type"] = "hacker", 
}

-----------------------------------------------------------------------------
--------------------------- Plate Configuration------------------------------
-----------------------------------------------------------------------------

Realistic_Police.PlateActivate = false -- If Module plate is activate

Realistic_Police.LangagePlate = "ru" -- You can choose eu or us

Realistic_Police.PlateConfig["us"] = { 
    ["Image"] = Material("rpt_plate_us.png"), -- Background of the plate 
    ["ImageServer"] = nil, -- Image server or Image of the department 
    ["TextColor"] = Color(24, 55, 66), -- Color Text of the plate 
    ["Country"] = "ARIZONA", -- Country Name 
    ["CountryPos"] = {2, 5}, -- The pos of the text 
    ["CountryColor"] = Color(26, 134, 185), -- Color of the country text 
    ["Department"] = "",  
    ["PlatePos"] = {2, 1.5}, -- Plate Pos 
    ["PlateText"] = false, -- AABCDAA
}

Realistic_Police.PlateConfig["eu"] = { 
    ["Image"] = Material("rpt_plate_eu.png"), -- Background of the plate  
    ["ImageServer"] = Material("rpt_department_eu.png"), -- Image server or Image of the department 
    ["TextColor"] = Color(0, 0, 0, 255), -- Color Text of the plate 
    ["Country"] = "F", -- Country Name 
    ["CountryPos"] = {1.065, 1.4}, -- The pos of the text 
    ["CountryColor"] = Color(255, 255, 255), -- Color of the country text 
    ["Department"] = "77", -- Department 
    ["PlatePos"] = {2, 2}, -- Plate Pos 
    ["PlateText"] = true, -- AA-BCD-AA
}

Realistic_Police.PlateConfig["ru"] = { 
    ["Image"] = Material("rpt_plate_ru.png"), -- Background of the plate  
    ["ImageServer"] = Material(""), -- Image server or Image of the department 
    ["TextColor"] = Color(0, 0, 0, 255), -- Color Text of the plate 
    ["Country"] = "", -- Country Name 
    ["CountryPos"] = {1.065, 1.4}, -- The pos of the text 
    ["CountryColor"] = Color(0, 0, 0), -- Color of the country text 
    ["Department"] = "228", -- Department 
    ["PlatePos"] = {2, 2}, -- Plate Pos 
    ["PlateText"] = true, -- AA-BCD-AA
}

--Realistic_Police.PlateVehicle["sim_fphys_uaz_patriot_pol"] = "ru" 
--Realistic_Police.PlateVehicle["sim_fphys_vaz-2114_pol"] = "ru" 
--Realistic_Police.PlateVehicle["sim_fphys_vaz-2115_pol"] = "ru" 
-- Realistic_Police.PlateVehicle["sim_fphys_uaz_patriot"] = "ru" 

-----------------------------------------------------------------------------
---------------------------- Trunk Configuration-----------------------------
-----------------------------------------------------------------------------

Realistic_Police.KeyForOpenTrunk = KEY_G -- https://wiki.facepunch.com/gmod/Enums/KEY

Realistic_Police.KeyTrunkHUD = true -- Activate/desactivate the hud of the vehicle 

Realistic_Police.CanOpenTrunk = {
    ["Начальник Полиции"] = true,
    ["Сотрудник ДПС"] = true, 
	["Сотрудник ППС"] = true,
	["Сотрудник Полиции"] = true,
	["Сотрудник ОМОН"] = true,
	["Сотрудник ФСБ"] = true,
	["Мэр"] = true 
}

Realistic_Police.VehiclePoliceTrunk = {
    ["sim_fphys_uaz_patriot_pol"] = true, 
    ["sim_fphys_vaz-2114_pol"] = true, 
	["sim_fphys_vaz-2115_pol"] = true, 
	["Airboat"] = true
}

Realistic_Police.MaxPropsTrunk = 10 -- Max props trunk 

Realistic_Police.Trunk["models/props_wasteland/barricade002a.mdl"] = {
    ["GhostPos"] = Vector(0,0,35),
    ["GhostAngle"] = Vector(0,0,0),
}

Realistic_Police.Trunk["models/props_wasteland/barricade001a.mdl"] = {
    ["GhostPos"] = Vector(0,0,30),
    ["GhostAngle"] = Vector(0,0,0),
}

Realistic_Police.Trunk["models/props_junk/TrafficCone001a.mdl"] = {
    ["GhostPos"] = Vector(0,0,16),
    ["GhostAngle"] = Vector(0,0,0),
}

Realistic_Police.Trunk["models/props_c17/streetsign004f.mdl"] = {
    ["GhostPos"] = Vector(0,0,12),
    ["GhostAngle"] = Vector(0,0,0),
}

Realistic_Police.Trunk["models/props_c17/streetsign001c.mdl"] = {
    ["GhostPos"] = Vector(0,0,12),
    ["GhostAngle"] = Vector(0,0,0),
}

Realistic_Police.TrunkPosition["Airboat"] = {
    ["Pos"] = Vector(0, 0, 0),
    ["Ang"] = Angle(0,0,0),
}
Realistic_Police.TrunkPosition["sim_fphys_uaz_patriot_pol"] = {
    ["Pos"] = Vector(-23.529, -129.412, 51.049),
    ["Ang"] = Angle(0,90,0),
}
Realistic_Police.TrunkPosition["sim_fphys_vaz-2114_pol"] = {
    ["Pos"] = Vector(-0.347, -94.568, 32.229),
    ["Ang"] = Angle(0,90,0),
}
Realistic_Police.TrunkPosition["sim_fphys_vaz-2115_pol"] = {
    ["Pos"] = Vector(-0.088, -85.498, 30.545),
    ["Ang"] = Angle(0,90,0),
}

-----------------------------------------------------------------------------
-------------------------- HandCuff Configuration----------------------------
-----------------------------------------------------------------------------

Realistic_Police.MaxDay = 450 -- Max Jail Day 

Realistic_Police.DayEqual = 450 -- 1 day = 60 Seconds 

Realistic_Police.PriceDay = 20 -- Price to pay with the bailer per day 

Realistic_Police.JailerName = "Тюремщик NPC" -- Jailer Name 

Realistic_Police.BailerName = "Выпустить Друга" -- Bailer Name 

Realistic_Police.SurrenderKey = KEY_T -- The key for surrender 

Realistic_Police.SurrenderInfoKey = "T" -- The Key 

Realistic_Police.SurrenderActivate = true 

Realistic_Police.CanCuff = { -- Job which can arrest someone
    ["Начальник Полиции"] = true,
    ["Сотрудник ДПС"] = true, 
	["Сотрудник ППС"] = true,
	["Сотрудник Полиции"] = true,
	["Сотрудник ОМОН"] = true,
	["Сотрудник ФСБ"] = true,
	["Мэр"] = true,
	-- rg all lvls (can't be cuffed) [""] = true,
	["Стрелок"] = true,
	["Фельдшер"] = true,
	["Механик-водитель"] = true,
	["Старший стрелок"] = true,
	["Инструктор сержантского состава"] = true,
	["Инспектор ОЛРР"] = true,
	["Начальник склада"] = true,
	["Начальник медслужбы"] = true,
	["Начальник химслужбы"] = true,
	["Начальник ОЛРР"] = true,
	-- 12+
	["Заместитель командира части"] = true,
	["Инструктор младшего офицерского состава"] = true,
	["Командир части"] = true,
	["Инструктор старшего офицерского состава"] = true,
	["Командир дивизии"] = true,
	["Командир корпуса"] = true,
	["Командующий армией"] = true,
	["Инструктор высшего офицерского состава"] = true,
	["Командующий округом"] = true,
	["Командующий"] = true,
	-- TEMP
	["Сотрудник росгвардии"] = true,
	["Офицер росгвардии"] = true,
	["Старший офицер росгвардии"] = true,
	["Маршал росгвардии"] = true 
}
 
Realistic_Police.CantBeCuff = { -- Job which can't be cuff
    ["Начальник Полиции"] = true,
    ["Сотрудник ДПС"] = true, 
	["Сотрудник ППС"] = true,
	["Сотрудник Полиции"] = true,
	["Сотрудник ОМОН"] = true,
	["Сотрудник ФСБ"] = true,
	["Мэр"] = true,
	-- rg all lvls (can't be cuffed) [""] = true,
	["Стрелок"] = true,
	["Фельдшер"] = true,
	["Механик-водитель"] = true,
	["Старший стрелок"] = true,
	["Инструктор сержантского состава"] = true,
	["Инспектор ОЛРР"] = true,
	["Начальник склада"] = true,
	["Начальник медслужбы"] = true,
	["Начальник химслужбы"] = true,
	["Начальник ОЛРР"] = true,
	-- 12+
	["Заместитель командира части"] = true,
	["Инструктор младшего офицерского состава"] = true,
	["Командир части"] = true,
	["Инструктор старшего офицерского состава"] = true,
	["Командир дивизии"] = true,
	["Командир корпуса"] = true,
	["Командующий армией"] = true,
	["Инструктор высшего офицерского состава"] = true,
	["Командующий округом"] = true,
	["Командующий"] = true,
	-- TEMP
	["Сотрудник росгвардии"] = true,
	["Офицер росгвардии"] = true,
	["Старший офицер росгвардии"] = true,
	["Маршал росгвардии"] = true,
	-- Admins
	["Администратор"] = true
}

Realistic_Police.CantConfiscate = { -- Guns that can't get confiscated
    ["gmod_tool"] = true,
    ["weapon_physgun"] = true, 
    ["weapon_fists"] = true, 
    ["weapon_physcannon"] = true, 
	["weapon_keypadchecker"] = true, 
	["stunstick"] = true,
	["keys"] = true, 
	["pass_ua"] = true,
	["aphone"] = true,
	["weapon_medkit"] = true,
	["climb_swep2"] = true,
	["weapon_bugbait"] = true,
	["weapon_sexinguisher"] = true,
	["weapon_gpwrench"] = true
}

-----------------------------------------------------------------------------
-------------------------- Stungun Configuration-----------------------------
-----------------------------------------------------------------------------

Realistic_Police.CantBeStun = { -- Job which can't be cuff
    ["Начальник Полиции"] = true,
    ["Сотрудник ДПС"] = true, 
	["Сотрудник ППС"] = true,
	["Сотрудник Полиции"] = true,
	["Сотрудник ОМОН"] = true,
	["Сотрудник ФСБ"] = true,
	["Мэр"] = true,
	-- rg all lvls (can't be cuffed) [""] = true,
	["Стрелок"] = true,
	["Фельдшер"] = true,
	["Механик-водитель"] = true,
	["Старший стрелок"] = true,
	["Инструктор сержантского состава"] = true,
	["Инспектор ОЛРР"] = true,
	["Начальник склада"] = true,
	["Начальник медслужбы"] = true,
	["Начальник химслужбы"] = true,
	["Начальник ОЛРР"] = true,
	-- 12+
	["Заместитель командира части"] = true,
	["Инструктор младшего офицерского состава"] = true,
	["Командир части"] = true,
	["Инструктор старшего офицерского состава"] = true,
	["Командир дивизии"] = true,
	["Командир корпуса"] = true,
	["Командующий армией"] = true,
	["Инструктор высшего офицерского состава"] = true,
	["Командующий округом"] = true,
	["Командующий"] = true,
	-- TEMP
	["Сотрудник росгвардии"] = true,
	["Офицер росгвардии"] = true,
	["Старший офицер росгвардии"] = true,
	["Маршал росгвардии"] = true,
	-- Admins
	["Администратор"] = true
}

-----------------------------------------------------------------------------
--------------------------- Camera Configuration-----------------------------
-----------------------------------------------------------------------------

Realistic_Police.CameraHealth = 100 -- Health of the Camera 

Realistic_Police.CameraRestart = 120 -- Camera restart when they don't have humans for repair 

Realistic_Police.CameraRepairTimer = 0 -- Time to repair the camera 10s 

Realistic_Police.CameraBrokeHud = true -- If when a camera was broken the Camera Worker have a Popup on his screen 

Realistic_Police.CameraBroke = false -- if camera broke sometime when a camera repairer is present on the server 

Realistic_Police.CameraWorker = { -- Job which can repair the camera 
    ["Никто"] = false
}

Realistic_Police.CameraGiveMoney = 0 -- Money give when a player repair a camera 

-----------------------------------------------------------------------------
--------------------------- Report Configuration-----------------------------
-----------------------------------------------------------------------------

Realistic_Police.JobDeleteReport = { -- Which job can delete Report 
    ["Начальник Полиции"] = true,
    ["Сотрудник ДПС"] = true, 
	["Сотрудник ППС"] = true,
	["Сотрудник Полиции"] = true,
	["Сотрудник ОМОН"] = true,
	["Сотрудник ФСБ"] = true,
	["Мэр"] = true 
}

Realistic_Police.JobEditReport = { -- Which job can create / edit report 
    ["Начальник Полиции"] = true,
    ["Сотрудник ДПС"] = true, 
	["Сотрудник ППС"] = true,
	["Сотрудник Полиции"] = true,
	["Сотрудник ОМОН"] = true,
	["Сотрудник ФСБ"] = true,
	["Мэр"] = true  
}

-----------------------------------------------------------------------------
------------------------ Criminal Record Configuration ----------------------
-----------------------------------------------------------------------------

Realistic_Police.JobDeleteRecord = { -- Which job can delete Criminal Record
    ["Начальник Полиции"] = true,
    ["Сотрудник ДПС"] = true, 
	["Сотрудник ППС"] = true,
	["Сотрудник Полиции"] = true,
	["Сотрудник ОМОН"] = true,
	["Сотрудник ФСБ"] = true,
	["Мэр"] = true  
}

Realistic_Police.JobEditRecord = { -- Which job can create / edit Criminal Record  
    ["Начальник Полиции"] = true,
    ["Сотрудник ДПС"] = true, 
	["Сотрудник ППС"] = true,
	["Сотрудник Полиции"] = true,
	["Сотрудник ОМОН"] = true,
	["Сотрудник ФСБ"] = true,
	["Мэр"] = true  
}

-----------------------------------------------------------------------------
---------------------------- Fining System ----------------------------------
-----------------------------------------------------------------------------

Realistic_Police.PlayerWanted = true -- if the player is wanted when he doesn't pay the fine 

Realistic_Police.PourcentPay = 65 -- The amount pourcent which are give when the player pay the fine 

Realistic_Police.MaxPenalty = 5 -- Maxe Penalty on the same player 

Realistic_Police.JobCanAddFine = { -- Which job can add fine
    ["Начальник Полиции"] = true,
    ["Сотрудник ДПС"] = true, 
	["Сотрудник ППС"] = true,
	["Сотрудник Полиции"] = true,
	["Сотрудник ОМОН"] = true,
	["Сотрудник ФСБ"] = true,
	["Мэр"] = true  
}

Realistic_Police.JobCantHaveFine = { -- Which job can't receive fine 
    ["Начальник Полиции"] = true,
    ["Сотрудник ДПС"] = true, 
	["Сотрудник ППС"] = true,
	["Сотрудник Полиции"] = true,
	["Сотрудник ОМОН"] = true,
	["Сотрудник ФСБ"] = true,
	["Мэр"] = true,
	-- rg all lvls (can't be cuffed) [""] = true,
	["Стрелок"] = true,
	["Фельдшер"] = true,
	["Механик-водитель"] = true,
	["Старший стрелок"] = true,
	["Инструктор сержантского состава"] = true,
	["Инспектор ОЛРР"] = true,
	["Начальник склада"] = true,
	["Начальник медслужбы"] = true,
	["Начальник химслужбы"] = true,
	["Начальник ОЛРР"] = true,
	-- 12+
	["Заместитель командира части"] = true,
	["Инструктор младшего офицерского состава"] = true,
	["Командир части"] = true,
	["Инструктор старшего офицерского состава"] = true,
	["Командир дивизии"] = true,
	["Командир корпуса"] = true,
	["Командующий армией"] = true,
	["Инструктор высшего офицерского состава"] = true,
	["Командующий округом"] = true,
	["Командующий"] = true,
	-- TEMP
	["Сотрудник росгвардии"] = true,
	["Офицер росгвардии"] = true,
	["Старший офицер росгвардии"] = true,
	["Маршал росгвардии"] = true,
	-- Admins
	["Администратор"] = true
}

Realistic_Police.VehicleCantHaveFine = { -- Which vehicle can't receive fine 
    ["sim_fphys_uaz_patriot_pol"] = true, 
    ["sim_fphys_vaz-2114_pol"] = true, 
	["sim_fphys_vaz-2115_pol"] = true, 
	-- ["sim_fphys_uaz_patriot"] = true 
}


-- Fines

Realistic_Police.FiningPolice[1] = { 
    ["Name"] = "Неподчинение", 
    ["Price"] = 2500,
    ["Vehicle"] = false, 
    ["Category"] = "Нарушения",
}
Realistic_Police.FiningPolice[2] = { 
    ["Name"] = "Оскарбление Гос-служаищих",
    ["Price"] = 1000,
    ["Vehicle"] = false, 
    ["Category"] = "Нарушения",
}
Realistic_Police.FiningPolice[3] = { 
    ["Name"] = "Проникновение на охраняемый объект",
    ["Price"] = 7500,
    ["Vehicle"] = false, 
    ["Category"] = "Нарушения",
}
Realistic_Police.FiningPolice[4] = { 
    ["Name"] = "Вандализм",
    ["Price"] = 5000,
    ["Vehicle"] = false, 
    ["Category"] = "Нарушения",
}
Realistic_Police.FiningPolice[5] = { 
    ["Name"] = "Извращение", 
    ["Price"] = 1000,
    ["Vehicle"] = false, 
    ["Category"] = "Нарушения",
}
Realistic_Police.FiningPolice[6] = { 
    ["Name"] = "Драки",  
    ["Price"] = 2500,
    ["Vehicle"] = false, 
    ["Category"] = "Нарушения",
}
Realistic_Police.FiningPolice[7] = { 
    ["Name"] = "Пранковые Звонки",
    ["Price"] = 500,
    ["Vehicle"] = false, 
    ["Category"] = "Нарушения",
}


Realistic_Police.FiningPolice[8] = { 
    ["Name"] = "Помощь Приступникам", 
    ["Price"] = 5000,
    ["Vehicle"] = false, 
    ["Category"] = "Серьёзные Нарушения",
}
Realistic_Police.FiningPolice[9] = { 
    ["Name"] = "Угон Авто", 
    ["Price"] = 5000,
    ["Vehicle"] = false, 
    ["Category"] = "Серьёзные Нарушения",
}
Realistic_Police.FiningPolice[10] = { 
    ["Name"] = "Воровство", 
    ["Price"] = 5000,
    ["Vehicle"] = false, 
    ["Category"] = "Серьёзные Нарушения",
}
Realistic_Police.FiningPolice[11] = { 
    ["Name"] = "Использование Ядерных Технологий", 
    ["Price"] = 7500,
    ["Vehicle"] = false, 
    ["Category"] = "Серьёзные Нарушения",
}
Realistic_Police.FiningPolice[12] = { 
    ["Name"] = "Убийство", 
    ["Price"] = 10000,
    ["Vehicle"] = false, 
    ["Category"] = "Серьёзные Нарушения",
}

Realistic_Police.FiningPolice[13] = { 
    ["Name"] = "Наркотики",
    ["Price"] = 5000,
    ["Vehicle"] = false, 
    ["Category"] = "Нелегал",
}
Realistic_Police.FiningPolice[14] = { 
    ["Name"] = "Нелицензионное Оружие",
    ["Price"] = 5000,
    ["Vehicle"] = false, 
    ["Category"] = "Нелегал",
}
Realistic_Police.FiningPolice[15] = { 
    ["Name"] = "Нелицензионный Бизнес",
    ["Price"] = 5000,
    ["Vehicle"] = false, 
    ["Category"] = "Нелегал",
}

Realistic_Police.FiningPolice[16] = { 
    ["Name"] = "Нарушение ПДД - пешеход", -- Unique Name is require 
    ["Price"] = 1000,
    ["Vehicle"] = false, 
	["Category"] = "ПДД",
}
Realistic_Police.FiningPolice[17] = { 
    ["Name"] = "Нарушение ПДД - строительство", -- Unique Name is require 
    ["Price"] = 2000,
    ["Vehicle"] = false, 
	["Category"] = "ПДД",
}
	Realistic_Police.FiningPolice[18] = { 
    ["Name"] = "Нарушение ПДД - водитель", -- Unique Name is require 
    ["Price"] = 3000,
    ["Vehicle"] = true, 
	["Category"] = "ПДД",
}
Realistic_Police.FiningPolice[19] = {  
    ["Name"] = "Привышение скорости", -- Unique Name is require 
    ["Price"] = 4000,
    ["Vehicle"] = true, 
    ["Category"] = "ПДД",
}
Realistic_Police.FiningPolice[20] = {  
    ["Name"] = "Погоня", -- Unique Name is require 
    ["Price"] = 5000,
    ["Vehicle"] = true, 
    ["Category"] = "ПДД",
}

Realistic_Police.FiningPolice[18] = { 
    ["Name"] = "Undefined speed limit offence", -- Unique Name is require 
    ["Price"] = 160,
    ["Vehicle"] = true, 
    ["Category"] = "Нарушения",
}
--]]
-----------------------------------------------------------------------------
--------------------------- Hacking System ----------------------------------
-----------------------------------------------------------------------------

Realistic_Police.NameOs = "СистемкаХуенкаCMD" -- The name of the os 

Realistic_Police.ResolveHack = 120 -- Time which the computer will be repair 

Realistic_Police.WordCount = 10 -- How many word the people have to write for hack the computer

Realistic_Police.HackerJob = { -- Which are not able to use the computer without hack the computer 
    ["Начальник Полиции"] = false,
    ["Сотрудник ДПС"] = false, 
	["Сотрудник ППС"] = false,
	["Сотрудник Полиции"] = false,
	["Сотрудник ОМОН"] = false,
	["Сотрудник ФСБ"] = false,
	["Мэр"] = false
}

Realistic_Police.WordHack = { -- Random Word for hack the computer 
    "run.hack.exe",
    "police.access.hack",
    "rootip64",
    "delete.password", 
    "password.breaker", 
    "run.database.sql", 
    "delete.access", 
    "recompil", 
    "connect.police.system", 
    "datacompil", 
    "username", 
    "mysqlbreaker", 
    "camera.exe",
    "criminal.record.exe",
    "deleteusergroup",
    "license.plate.exe",
    "cameracitizen.exe", 
    "loaddatapublic",
    "internet.exe",
    "reportmenu.exe",
    "listreport.exe",
}

-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
 