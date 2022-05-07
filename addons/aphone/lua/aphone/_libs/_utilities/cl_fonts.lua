local fonts = {
    ["Roboto18_500"] = {
        font = "Roboto",
        size = 18,
        weight = 500,
        antialias = true
    },
    ["Little"] = {
        font = "Roboto",
        size = 20,
        weight = 1000,
        antialias = true
    },
    ["Little2"] = {
        font = "Roboto",
        size = 20,
        weight = 800,
        antialias = true
    },
    ["Small"] = {
        font = "Roboto",
        size = 25,
        weight = 500,
        antialias = true
    },

    ["Little_NoWeight"] = {
        font = "Roboto",
        size = 20,
        antialias = true
    },

    ["Medium"] = {
        font = "ebrima",
        size = 30,
        antialias = true,
        weight = 550
    },
    ["MediumHeader"] = {
        font = "Roboto",
        size = 30,
        antialias = true
    },

    ["MediumHeader_500"] = {
        font = "Roboto",
        size = 30,
        weight = 550,
        antialias = true
    },

    ["Header_Friends"] = {
        font = "Volaroid Script",
        size = 100,
        weight = 800,
        antialias = true
    },

    ["StartScreen"] = {
        font = "Strasua",
        size = 80,
        antialias = true
    },

    ["Roboto40"] = {
        font = "Roboto",
        size = 40,
        antialias = true
    },

    ["Roboto40_700"] = {
        font = "Roboto",
        size = 40,
        antialias = true,
        weight = 700
    },

    ["Roboto45_700"] = {
        font = "Roboto",
        size = 45,
        antialias = true,
        weight = 700
    },

    ["Roboto60"] = {
        font = "Roboto",
        size = 60,
        antialias = true,
        weight = 550
    },

    ["Roboto80"] = {
        font = "Roboto",
        size = 80,
        antialias = true,
        weight = 550
    },

    ["DateShow_200"] = {
        font = "Arial",
        size = 200,
        antialias = true
    },
    -- SVG
    ["SVG_16"] = {
        font = "Akulla_SVG",
        size = 16,
        antialias = true
    },

    ["SVG_20"] = {
        font = "Akulla_SVG",
        size = 20,
        antialias = true
    },

    ["SVG_25"] = {
        font = "Akulla_SVG",
        size = 25,
        antialias = true
    },

    ["SVG_30"] = {
        font = "Akulla_SVG",
        size = 30,
        antialias = true
    },

    ["SVG_40"] = {
        font = "Akulla_SVG",
        size = 40,
        antialias = true
    },

    ["SVG_45"] = {
        font = "Akulla_SVG",
        size = 45,
        antialias = true
    },

    ["SVG_60"] = {
        font = "Akulla_SVG",
        size = 60,
        antialias = true
    },

    ["SVG_76"] = {
        font = "Akulla_SVG",
        size = 76,
        antialias = true
    },

    ["SVG_90"] = {
        font = "Akulla_SVG",
        size = 90,
        antialias = true
    },

    ["SVG_180"] = {
        font = "Akulla_SVG",
        size = 180,
        antialias = true
    },
    -- Darkweb
    ["BigDarkweb"] = {
        font = "Rockwell",
        size = 60,
        antialias = true
    },

    ["HeaderDarkWeb"] = {
        font = "Rockwell",
        size = 30,
        antialias = true
    },

    ["LittleDarkWeb"] = {
        font = "Rockwell",
        size = 20,
        antialias = true
    }
}

local backup_setting = aphone:GetParameters("Core", "2D", false)

local function create_fonts()
    for _, tags in ipairs({"3D", "2D"}) do
        -- Doing this check so the scaledsize got the good 3D/2D state and not return 2D size for 3D or 3D size for 2D
        aphone:ChangeParameters("Core", "2D", tags ~= "3D")

        for k, v in pairs(fonts) do
            local cp = table.Copy(v)
            cp.size = math.floor(aphone.GUI.ScaledSize(cp.size))

            if cp.weight then
                cp.weight = math.floor(aphone.GUI.ScaledSize(cp.weight))
            end

            surface.CreateFont(k .. "_" .. tags, cp)
        end
    end

    aphone:ChangeParameters("Core", "2D", backup_setting)
end

create_fonts()

function aphone:GetFont(name)
    return name .. "_" .. (aphone:Is2D() and "2D" or "3D")
end

hook.Add("OnScreenSizeChanged", "APhone_RefreshFonts", function()
    create_fonts()
end)