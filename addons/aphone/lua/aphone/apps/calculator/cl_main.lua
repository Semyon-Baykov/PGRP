local APP = {}

APP.name = aphone.L("Calculator")
APP.icon = "akulla/aphone/app_calculator.png"

local operator, last_result
local first_num = ""
local second_num = ""

local function Retrieve_NumberOn()
	if !tonumber(first_num) then
		first_num = ""
	end
	return operator and second_num or first_num
end

local function Set_NumberOn(n)
	if operator then
		second_num = n
	else
		first_num = n
	end
end

local function addnumber(num)
	local new_num = tonumber(Retrieve_NumberOn() .. num)

	if new_num > 999999999 or -999999999 > new_num then return end
	Set_NumberOn(tostring(new_num))
end

local function removenumber()
	if !tonumber(Retrieve_NumberOn()) then return end
	Set_NumberOn(string.sub(Retrieve_NumberOn(), 0, -1))
end

local function switch_sign()
	if !tonumber(Retrieve_NumberOn()) then return end
	Set_NumberOn(-tonumber(Retrieve_NumberOn()))
end

local function add_comma()
	Set_NumberOn(Retrieve_NumberOn() .. ".")
end

local function reset()
	first_num = ""
	second_num = ""
	operator = nil
end

local function operation(o)
	if !operator then
		// Check if he really put a number
		if !tonumber(first_num) or o == "=" then return end

		operator = o
	elseif tonumber(second_num) then
		first_num = tonumber(first_num)
		second_num = tonumber(second_num)

		// Switch and +=, -=, /=, *= would fit so well for this
		if operator == "+" then
			first_num = first_num + second_num
		elseif operator == "-" then
			first_num = first_num - second_num
		elseif operator == "*" then
			first_num = first_num * second_num
		elseif operator == "/" then
			// Little easter egg
			first_num = second_num == 0 and "/0 ?" or first_num / second_num
		elseif operator == "%" then
			first_num = first_num % second_num
		end

		// don't break the easter egg 
		last_result = isnumber(first_num) and string.Comma(math.Round(first_num, 4)) or first_num

		reset()
	end
end

local button_table = {
	[1] = {name = "C", func = reset},
	[2] = {name = "+/-", func = switch_sign},
	[3] = {name = "%"},
	[4] = {name = "/"},
	[5] = {name = 7},
	[6] = {name = 8},
	[7] = {name = 9},
	[8] = {name = "*"},
	[9] = {name = 4},
	[10] = {name = 5},
	[11] = {name = 6},
	[12] = {name = "-"},
	[13] = {name = 1},
	[14] = {name = 2},
	[15] = {name = 3},
	[16] = {name = "+"},
	[17] = {name = 0},
	[18] = {name = ".", func = add_comma},
	[19] = { name = "<", func = removenumber },
	[20] = { name = "=" },
}

local mat_bg = Material("akulla/aphone/background_calculator.jpg")
function APP:Open(main, main_x, main_y, screenmode)
	// consts
	local font_big2 = aphone:GetFont("Roboto80")
	local font_header = aphone:GetFont("Roboto40")
	local font_mediumheader = aphone:GetFont("MediumHeader")
	local clr_white180 = aphone:Color("Text_White180")
	local clr_white = aphone:Color("Text_White")
	local black_120 = Color(40, 40, 40, 120)

	local scaledsize_24 = aphone.GUI.ScaledSizeY(24)
	local scaledsize_61 = aphone.GUI.ScaledSizeY(61)

	// adapt to screenmode
	local sub_panely, p_sizey, p_sizex

	local but_lay = vgui.Create("DIconLayout", main)
	but_lay:SetSpaceX(aphone.GUI.ScaledSizeX(5))
	but_lay:SetSpaceY(aphone.GUI.ScaledSizeY(5))

	if !screenmode then
		sub_panely = math.abs(main_x / 4 * 5 - main_y)
		p_sizey = (main_y - sub_panely) / 5 - aphone.GUI.ScaledSizeY(5)
		p_sizex = main_x / 4 - aphone.GUI.ScaledSizeX(5)
		but_lay:Dock(BOTTOM)
		but_lay:DockMargin(0, sub_panely, 0, aphone.GUI.ScaledSizeY(12))
		but_lay:SetTall(sub_panely)
	else
		sub_panely = math.abs(main_y / 5 * 5 - main_x)
		p_sizey = (main_x - sub_panely) / 5 - aphone.GUI.ScaledSizeY(10)
		p_sizex = main_y / 4 - aphone.GUI.ScaledSizeX(5)
		but_lay:Dock(RIGHT)
		but_lay:DockMargin(sub_panely, aphone.GUI.ScaledSize(12, 12, 12))
		but_lay:SetWide(sub_panely)
	end

	for k, v in SortedPairs(button_table) do
		local d = but_lay:Add("DButton")
		d:SetText(v.name)
		d:SetFont(font_header)
		d:SetSize(p_sizex, p_sizey)
		d:SetTextColor(clr_white)
		d:SetPaintBackground(false)
		d:TDLib()

		d:On("DoClick", function(self)
			if v.func then
				v.func()
			elseif isnumber(v.name) then
				addnumber(v.name)
			else
				operation(v.name)
			end
		end)

		d:FadeHover(black_120)
	end

	function main:Paint(w, h)
		surface.SetMaterial(mat_bg)
		surface.SetDrawColor(color_white)
		surface.DrawTexturedRect(0, 0, w, h)

		surface.SetFont(font_big2)

		if !screenmode then
			if last_result then
				draw.DrawText(last_result, select(1, surface.GetTextSize(last_result)) >= main_x * 0.9 and font_mediumheader or font_big2, w / 2, sub_panely / 2 - scaledsize_24, clr_white, 1, 1)
			end
			draw.SimpleText(first_num .. (operator or "") .. second_num, font_header, w / 2, sub_panely / 2 + scaledsize_61, clr_white180, 1, 0)
		else
			local w_final = (w - but_lay:GetWide()) / 2
			if last_result then
				draw.DrawText(last_result, (select(1, surface.GetTextSize(last_result)) >= main_x * 0.9 and font_mediumheader or font_big2), w_final, h / 3, clr_white, 1, 1)
			end
			draw.SimpleText(first_num .. (operator or "") .. second_num, font_header, w_final, h/2 + scaledsize_61, clr_white180, 1, 0)
		end
	end

	if !screenmode then
		main:Phone_DrawTop(main_x, main_y)
	end
	main:aphone_RemoveCursor()
end

function APP:Open2D(main, main_x, main_y)
	self:Open(main, main_x, main_y, true)
end

aphone.RegisterApp(APP)