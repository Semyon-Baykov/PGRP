--[[-----------------------------------------------------------------------
Categories
---------------------------------------------------------------------------
The categories of the default F4 menu.

Please read this page for more information:
http://wiki.darkrp.com/index.php/DarkRP:Categories

In case that page can't be reached, here's an example with explanation:

DarkRP.createCategory{
    name = "Citizens", -- The name of the category.
    categorises = "jobs", -- What it categorises. MUST be one of "jobs", "entities", "shipments", "weapons", "vehicles", "ammo".
    startExpanded = true, -- Whether the category is expanded when you open the F4 menu.
    color = Color(0, 107, 0, 255), -- The color of the category header.
    canSee = function(ply) return true end, -- OPTIONAL: whether the player can see this category AND EVERYTHING IN IT.
    sortOrder = 100, -- OPTIONAL: With this you can decide where your category is. Low numbers to put it on top, high numbers to put it on the bottom. It's 100 by default.
}


Add new categories under the next line!
---------------------------------------------------------------------------]]

DarkRP.createCategory{
    name = "Пистолеты",
    categorises = "shipments",
    startExpanded = false,
    color = Color(60, 60, 60, 255),
    sortOrder = 1,
}

DarkRP.createCategory{
    name = "Пистолеты-пулеметы",
    categorises = "shipments",
    startExpanded = false,
    color = Color(60, 60, 60, 255),
    sortOrder = 2,
}

DarkRP.createCategory{
    name = "Дробовики",
    categorises = "shipments",
    startExpanded = false,
    color = Color(60, 60, 60, 255),
    sortOrder = 3,
}

DarkRP.createCategory{
    name = "Штурмовые винтовки",
    categorises = "shipments",
    startExpanded = false,
    color = Color(60, 60, 60, 255),
    sortOrder = 4,
}

DarkRP.createCategory{
    name = "Снайперские винтовки",
    categorises = "shipments",
    startExpanded = false,
    color = Color(60, 60, 60, 255),
    sortOrder = 5,
}

DarkRP.createCategory{
    name = "Пулеметы",
    categorises = "shipments",
    startExpanded = false,
    color = Color(60, 60, 60, 255),
    sortOrder = 6,
}


DarkRP.createCategory{
    name = "Граждане",
    categorises = "jobs",
    startExpanded = true,
    color = Color(0, 107, 0, 255),
    canSee = function(ply) return true end, 
    sortOrder = 1,
}
DarkRP.createCategory{
    name = "Правопорядок",
    categorises = "jobs",
    startExpanded = true,
    color = Color(0, 0, 107, 255),
    canSee = function(ply) return true end, 
    sortOrder = 2,
}
DarkRP.createCategory{
    name = "Бизнес",
    categorises = "jobs",
    startExpanded = true,
    color = Color(0, 107, 0, 255),
    canSee = function(ply) return true end, 
    sortOrder = 3,
}
DarkRP.createCategory{
    name = "Криминал",
    categorises = "jobs",
    startExpanded = true,
    color = Color(0, 107, 0, 255),
    canSee = function(ply) return true end, 
    sortOrder = 4,
}
DarkRP.createCategory{
    name = "Городские службы",
    categorises = "jobs",
    startExpanded = true,
    color = Color(0, 107, 0, 255),
    canSee = function(ply) return true end, 
    sortOrder = 5,
}
DarkRP.createCategory{
    name = "Другие",
    categorises = "jobs",
    startExpanded = true,
    color = Color(0, 107, 0, 255),
    canSee = function(ply) return true end, 
    sortOrder = 6,
}
DarkRP.createCategory{
    name = "Premium работы",
    categorises = "jobs",
    startExpanded = true,
    color = Color(107, 0, 0, 255),
    canSee = function(ply) return true end, 
    sortOrder = 25,
}

DarkRP.createCategory{
    name = "Вещи Биткойн Манера",
    categorises = "entities",
    startExpanded = true,
    color = Color(182, 182, 182, 255),
    canSee = function(ply) return table.HasValue({TEAM_BITMINER}, ply:Team()) end,
    sortOrder = 25,
}