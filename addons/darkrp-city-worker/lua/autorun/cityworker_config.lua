CITYWORKER = CITYWORKER or {}

CITYWORKER.Config = CITYWORKER.Config or {}

--[[
  /$$$$$$  /$$   /$$                     /$$      /$$                     /$$                          
 /$$__  $$|__/  | $$                    | $$  /$ | $$                    | $$                          
| $$  \__/ /$$ /$$$$$$   /$$   /$$      | $$ /$$$| $$  /$$$$$$   /$$$$$$ | $$   /$$  /$$$$$$   /$$$$$$ 
| $$      | $$|_  $$_/  | $$  | $$      | $$/$$ $$ $$ /$$__  $$ /$$__  $$| $$  /$$/ /$$__  $$ /$$__  $$
| $$      | $$  | $$    | $$  | $$      | $$$$_  $$$$| $$  \ $$| $$  \__/| $$$$$$/ | $$$$$$$$| $$  \__/
| $$    $$| $$  | $$ /$$| $$  | $$      | $$$/ \  $$$| $$  | $$| $$      | $$_  $$ | $$_____/| $$      
|  $$$$$$/| $$  |  $$$$/|  $$$$$$$      | $$/   \  $$|  $$$$$$/| $$      | $$ \  $$|  $$$$$$$| $$      
 \______/ |__/   \___/   \____  $$      |__/     \__/ \______/ |__/      |__/  \__/ \_______/|__/      
                         /$$  | $$                                                                     
                        |  $$$$$$/                                                                     
                         \______/                                                                      
                                
                                                v1.0.4
                                    By: Silhouhat (76561198072551027)
                                      Licensed to: 76561198051291901

--]]

-- How often should we check (in seconds) for City Workers with no assigned jobs, so we can give them?
CITYWORKER.Config.Time = 30

------------
-- RUBBLE --
------------

CITYWORKER.Config.Rubble = {}

-- Whether or not rubble is enabled or disabled.
CITYWORKER.Config.Rubble.Enabled = true

-- Rubble models and the range of time (in seconds) it takes to clear them.
CITYWORKER.Config.Rubble.Models = {
    ["models/props_debris/concrete_debris128pile001a.mdl"] = { min = 30, max = 30 },
    ["models/props_debris/concrete_debris128pile001b.mdl"] = { min = 30, max =30 },
    ["models/props_debris/concrete_floorpile01a.mdl"] = { min = 30, max = 30 },
    ["models/props_debris/concrete_cornerpile01a.mdl"] = { min = 30, max = 20 },
    ["models/props_debris/concrete_spawnplug001a.mdl"] = { min = 30, max = 30 },
    ["models/props_debris/plaster_ceilingpile001a.mdl"] = { min = 30, max = 30 },
}

-- Payout per second it takes to clear a given pile of rubble.
-- (i.e. 10 seconds = 10 * 30 = 300)
CITYWORKER.Config.Rubble.Payout = 25

-------------------
-- FIRE HYDRANTS --
-------------------

CITYWORKER.Config.FireHydrant = {}

-- Whether or not fire hydrants are enabled or disabled.
CITYWORKER.Config.FireHydrant.Enabled = false

-- The range for how long it takes to fix a fire hydrant.
-- Maximum value: 255 seconds.
CITYWORKER.Config.FireHydrant.Time = { min = 20, max = 30 }

-- Payout per second it takes to fix a fire hydrant.
CITYWORKER.Config.FireHydrant.Payout = 40

-----------
-- LEAKS --
-----------

CITYWORKER.Config.Leak = CITYWORKER.Config.Leak or {}

-- Whether or not leaks are enabled or disabled.
CITYWORKER.Config.Leak.Enabled = true

-- The range for how long it takes to fix a leak.
-- Maximum value: 255 seconds.
CITYWORKER.Config.Leak.Time = { min = 30, max = 30 }

-- Payout per second it takes to fix a leak.
CITYWORKER.Config.Leak.Payout = 23

--------------
-- ELECTRIC --
--------------

CITYWORKER.Config.Electric = CITYWORKER.Config.Electric or {}

-- Whether or not electrical problems are enabled or disabled.
CITYWORKER.Config.Electric.Enabled = true

-- The range for how long it takes to fix an electrical problem.
-- Maximum value: 255 seconds.
CITYWORKER.Config.Electric.Time = { min = 30, max = 30 }

-- Payout per second it takes to fix an electrical problem.
CITYWORKER.Config.Electric.Payout = 30

----------------------------
-- LANGUAGE CONFIGURATION --
----------------------------

CITYWORKER.Config.Language = {
    ["FireHydrant"]         = "_",
    ["Leak"]                = "Чиним трубу...",
    ["Electric"]            = "Чиним проводку...",
    ["Rubble"]              = "Расчищаем обвал...",

    ["CANCEL"]              = "Нажмите на F2 чтобы остановить работу",
    ["PAYOUT"]              = "Вы заработали %s рублей!",
    ["CANCELLED"]           = "Вы отменили починку...",
    ["NEW_JOB"]             = "У вас появилась новая работа!",
    ["NOT_CITY_WORKER"]     = "Вы не работник ЖКХ!",
    ["JOB_WORKED"]          = "Над этой работой уже кто-то работает!",
    ["ASSIGNED_ELSE"]       = "Эту работу дали другому работнику ЖКХ!",
}