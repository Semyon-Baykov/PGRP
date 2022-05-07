-- Functions
aphone.GUI = aphone.GUI or {}

function aphone:Is2D()
    return aphone:GetParameters("Core", "2D", false)
end

local ratio_h = ScrH() / 1080
local ratio_w = ScrW() / 1920
local ratio = ratio_h < ratio_w and ratio_h or ratio_w

hook.Add("OnScreenSizeChanged", "APhone_RefreshRatio", function()
    ratio_h = ScrH() / 1080
    ratio_w = ScrW() / 1920
    local new_ratio = ratio_h < ratio_w and ratio_h or ratio_w
    if new_ratio == ratio then return end

    ratio = new_ratio
end)

function aphone.GUI.ScaledSize(...)
    local args = {...}

    for k, v in ipairs(args) do
        args[k] = v * ratio * (aphone:Is2D() and 0.65 or 1)
    end

    return unpack(args)
end

function aphone.GUI.ScaledSizeX(num)
    return aphone.GUI.ScaledSize(num)
end

function aphone.GUI.ScaledSizeY(num)
    return aphone.GUI.ScaledSize(num)
end

local p = FindMetaTable("Panel")

function p:aphone_RemoveCursor()
    if aphone:Is2D() then return end

    for k, v in ipairs(self:GetChildren()) do
        v:aphone_RemoveCursor()
    end

    self:SetCursor("blank")
end

function aphone.GUI.GenerateCircle(x, y, r)
    local circle = {}

    for i = 1, 360 do
        circle[i] = {}
        circle[i].x = x + math.cos(math.rad(i * 360) / 360) * r
        circle[i].y = y + math.sin(math.rad(i * 360) / 360) * r
    end

    return circle
end

function aphone.GUI.RoundedBox(x, y, w, h, r)
    local pts = {}
    -- Top right
    local x_corner = (x + w) - r
    local y_corner = y + r

    for i = 270, 360 do
        table.insert(pts, {
            x = x_corner + math.cos(math.rad(i * 360) / 360) * r,
            y = y_corner + math.sin(math.rad(i * 360) / 360) * r
        })
    end

    -- Bottom Right
    x_corner = (x + w) - r
    y_corner = (y + h) - r

    for i = 0, 90 do
        table.insert(pts, {
            x = x_corner + math.cos(math.rad(i * 360) / 360) * r,
            y = y_corner + math.sin(math.rad(i * 360) / 360) * r
        })
    end

    -- Bottom Left
    x_corner = x + r
    y_corner = (y + h) - r

    for i = 90, 180 do
        table.insert(pts, {
            x = x_corner + math.cos(math.rad(i * 360) / 360) * r,
            y = y_corner + math.sin(math.rad(i * 360) / 360) * r
        })
    end

    -- Top Left
    x_corner = x + r
    y_corner = y + r

    for i = 180, 270 do
        table.insert(pts, {
            x = x_corner + math.cos(math.rad(i * 360) / 360) * r,
            y = y_corner + math.sin(math.rad(i * 360) / 360) * r
        })
    end

    return pts
end

-- Wrap text, big thanks to https://github.com/FPtje/DarkRP/blob/master/gamemode/modules/base/cl_util.lua
local function charWrap(text, remainingWidth, maxWidth)
    local totalWidth = 0

    text = text:gsub(".", function(char)
        totalWidth = totalWidth + surface.GetTextSize(char)

        -- Wrap around when the max width is reached
        if totalWidth >= remainingWidth then
            -- totalWidth needs to include the character width because it's inserted in a new line
            totalWidth = surface.GetTextSize(char)
            remainingWidth = maxWidth

            return "\n" .. char
        end

        return char
    end)

    return text, totalWidth
end

function aphone.GUI.WrapText(text, font, maxWidth)
    local totalWidth = 0
    surface.SetFont(font)
    local spaceWidth = surface.GetTextSize(' ')

    text = text:gsub("(%s?[%S]+)", function(word)
        local char = string.sub(word, 1, 1)

        if char == "\n" or char == "\t" then
            totalWidth = 0
        end

        local wordlen = surface.GetTextSize(word)
        totalWidth = totalWidth + wordlen

        -- Wrap around when the max width is reached
        -- Split the word if the word is too big
        if wordlen >= maxWidth then
            local splitWord, splitPoint = charWrap(word, maxWidth - (totalWidth - wordlen), maxWidth)
            totalWidth = splitPoint

            return splitWord
        elseif totalWidth < maxWidth then
            return word
        end

        -- Split before the word
        if char == ' ' then
            totalWidth = wordlen - spaceWidth

            return '\n' .. string.sub(word, 2)
        end

        totalWidth = wordlen

        return '\n' .. word
    end)

    return text
end