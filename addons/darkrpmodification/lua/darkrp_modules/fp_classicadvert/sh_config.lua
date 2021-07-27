--[[-------------------------------------------------------------------------
You are free to use, distribute and change this module, as long as you keep
this text here - and/or credit me:

Made by Fillipuster :D
---------------------------------------------------------------------------]]

CLASSICADVERT = CLASSICADVERT or {}

--[[-------------------------------------------------------------------------
					CLASSIC ADVERT CONFIG
---------------------------------------------------------------------------]]

-- The prefix before the adverted text (but after the sending player's name).
CLASSICADVERT.chatPrefix = "[Объявление]"

-- The color of the text in the advert (Originally yellow).
CLASSICADVERT.advertTextColor = Color( 255, 255, 0, 255 )

-- The failure message id the players fails to provide text for the advert.
CLASSICADVERT.failMessage = "Объявление должно состоять более чем из 2-х символов."

-- The chat command for adverts. (A "/" is added at the front automatically.)
CLASSICADVERT.chatCommand = "advert" -- Please, do not use "/advert" as it is used for the new advert system in DarkRP.

-- The F1 (help menu) description of the advert command.
CLASSICADVERT.commandDescription = "Сообщение для всех игроков сервера."

-- The delay (in seconds) between players being able to advert.
CLASSICADVERT.commandDelay = 3

--[[-------------------------------------------------------------------------
					END OF CONFIG
---------------------------------------------------------------------------]]

DarkRP.declareChatCommand{
    command = CLASSICADVERT.chatCommand,
    description = CLASSICADVERT.commandDescription,
    delay = CLASSICADVERT.commandDelay
}