--[[
	Hello there !
	You like the addon ? Mind making a review ? That would be very helpful and it's always nice to see happy people :)
]]--

aphone.GPS = {
	-- Example
	{
		name = "Полицейский участок",
		vec = Vector(-1559.911133, 100.262398, -131.968750),	
		clr = Color(115, 147, 179),
		icon = "Q",
	},

	{
		name = "МЧС больница",
		vec = Vector(-1534.744873, 833.709595, -131.968750),
		clr = Color(0, 150, 255),
		icon = "N",
	},

	{
		name = "Росгвардия (армия)",
		vec = Vector(-10621.717773 -189.535416 -139.968750),
		clr = Color(0, 100, 0),
		icon = "O",
	},

	{
		name = "Автодром",
		vec = Vector(-7054.333496, -1823.313843, -139.968750),
		clr = Color(0, 0, 0),
		icon = "O",
	},
	
	{
		name = "Казино",
		vec = Vector(-490.809143, 258.112946, -311.968750),
		clr = Color(255, 0, 0),
		icon = "O",
	},
	
	{
		name = "Сбербанк",
		vec = Vector(583.910461, 265.504150, -131.968750),
		clr = Color(0, 128, 0),
		icon = "Q",
	},
	
	{
		name = "Пятёрочка",
		vec = Vector(-1505.373535, -2517.147949, -115.968750),
		clr = Color(255, 0, 0),
		icon = "O",
	},
	
	{
		name = "Лесной домик",
		vec = Vector(-3229.229248, 4779.442383, -111.968750),
		clr = Color(34,139,34),
		icon = "O",
	},
	
	{
		name = "Церковь",
		vec = Vector(678.593811, 1092.967773, -131.968750),
		clr = Color(165, 42, 42),
		icon = "O",
	},
}

// Edit there if you want to add painting, However you need to make the player download them yourself
aphone.Painting = {
	[1] = "akulla/aphone/sticker_1.png",
	[2] = "akulla/aphone/sticker_2.png",
	[3] = "akulla/aphone/sticker_3.png",
	[4] = "akulla/aphone/sticker_4.png",
	[5] = "akulla/aphone/sticker_5.png",
	[6] = "akulla/aphone/sticker_6.png",
	[7] = "akulla/aphone/sticker_7.png",
	[8] = "akulla/aphone/sticker_8.png",
	[9] = "akulla/aphone/sticker_9.png",
	[10] = "akulla/aphone/sticker_10.png",
	[11] = "akulla/aphone/sticker_11.png",
	[12] = "akulla/aphone/sticker_12.png",
	[13] = "akulla/aphone/sticker_13.png",
	[14] = "akulla/aphone/sticker_14.png",
	[15] = "akulla/aphone/sticker_15.png",
	[16] = "akulla/aphone/sticker_16.png",
	[17] = "akulla/aphone/sticker_17.png",
	[18] = "akulla/aphone/sticker_18.png",
	[19] = "akulla/aphone/sticker_19.png",
	[20] = "akulla/aphone/sticker_20.png",
	[21] = "akulla/aphone/sticker_21.png",
	[22] = "akulla/aphone/sticker_22.png",
	[23] = "akulla/aphone/sticker_23.png",
	[24] = "akulla/aphone/sticker_24.png",
	[25] = "akulla/aphone/sticker_25.png",
	[26] = "akulla/aphone/sticker_26.png",
	[27] = "akulla/aphone/sticker_27.png",
	[28] = "akulla/aphone/sticker_28.png",
	[29] = "akulla/aphone/sticker_29.png",
	[30] = "akulla/aphone/sticker_30.png",
}

// 8 Numbers/%s please
aphone.Format = "+7 %s%s%s%s"

aphone.OthersHearRadio = false
aphone.Language = "russian"
aphone.bank_onlytransfer = false
aphone.never_realname = false // Hide RP Name, except in Friends
aphone.disable_showingUnknownPlayers = false
aphone.disable_hitman = true

aphone.Links = {
	{
		name = "Discord",
		icon = "akulla/aphone/app_socialserver.png",
		link = "https://discord.gg/Nt4jkRg",
	},
}

aphone.SpecialCallsCooldown = 30
aphone.SpecialCalls = {
	{
		name = "Полиция",
		icon = "akulla/aphone/specialcall_police.png",
		teams = {
			[2] = true,
			["Police"] = true,
		},
		desc = "Позвонить Полицие",
	}
}

aphone.Ringtones = {
	{
		name = "Old School",
		url = "https://akulla.dev/aphone/oldschool_ringtone.mp3"
	},
}

aphone.backgrounds_imgur = {
	"s6qzwYe",	--PGRP
	"KBFwXeb",	--Ducks
	"O5DzVnq",	--Pretty
	"l7MGtN1",	--Popit
	"jKy9Nbi", 	--Zoner
	"Cya6Cvh",	--PrplCar
	--[[
	"VQHAC3h",
	"vlwy740",
	"TxUSRK5",
	"DY0NdEr",
	"ACuEH9j",
	"6oeJSj9",
	"KPA1Q2d",
	"HijquPC",
	"7DX9Fuv",
	"ohrMfn1",
	"aI1Oxmn",
	"IMkav2r",
	"MqzB4Ib",
	"93TZu0t",
	"OmMWSSY",
	"fcIFXay",
	"lH2pun4",
	"OHzGh9m",
	"b8gEjIl",
	"qFSFj6l",
	"5nCGb2C",
	"wzXxgPQ",
	"JJH78M6",
	"1zhAVuS",
	"Fel9fOI",
	"pkVIpj5",
	"xQEWbYt",
	"Lv4zq7k",
	"Fh8Sx95",
	"nGWhWsx",
	"OvmjYIK",]]--
}

aphone.RadioList = {

	{
		name = "ГОП FM",
		url = "http://air.radiorecord.ru:8102/gop_320",
		logo = "https://i.imgur.com/KMTLMms.jpg?1",
		clr = Color(230, 126, 34),
	},
	
	{
		name = "Дорожное радио",
		url = "http://dorognoe.hostingradio.ru:8000/radio",
		logo = "https://dorognoe.ru/thumb/channel_logo_250x200/2017/0b/ce/591ec2b806d8c_tancpol.png",
		clr = Color(231, 76, 60),
	},
	
	{
		name = "Радио КАВКАЗ",
		url = "http://radio05.ru:8000/radio_kavkaz_128",
		logo = "https://vo-radio.ru/images/logoweb1/radio-kavkaz-180.jpg",
		clr = Color(155, 89, 182),
	},
	
	{
		name = "Радио Record",
		logo = "https://static-media.streema.com/media/cache/83/7a/837abbaa4025e0b53c5db2864289d5a7.jpg",
		url = "http://air.radiorecord.ru:8101/rr_320",
		clr = Color(23, 75, 158),
	},
	
	{
		name = "AniSonFM",
		logo = "https://static-media.streema.com/media/cache/9d/b6/9db6cbbcd7d0d86643f831682406ee02.jpg",
		url = "http://pool.anison.fm:9000/AniSonFM(320)?nocache=0.9834540412142996",
		clr = Color(255, 100, 100),
	},
	
	{
		name = "Energy",
		logo = "https://img2.goodfon.com/original/1024x1024/6/92/nrj-hit-music-only-energy.jpg",
		url = "http://ic7.101.ru:8000/v1_1?userid=0&setst=dchvi0vc1u5e4rl98o61vcv5h1&city=490",
		clr = Color(243, 104, 224),
	},
	
	{
		name = "Black Radio",
		logo = "https://images-na.ssl-images-amazon.com/images/I/61Zhg%2B2frRL._SX425_.jpg",
		url = "http://air.radiorecord.ru:805/yo_320",
		clr = Color(255, 50, 50),
	},
}