module( 'gpws', package.seeall )

local welcomeText = "Добро пожаловать на PGRP!"
local welcomeSong = "Приятной игры!"

color_orange = Color(255,120,0)

function WelcomeSeq()
	chat.AddText( color_orange, string.format( welcomeText ) )
	chat.AddText( color_white,  string.format( welcomeSong ) )
end

function close()
	WelcomeSeq()
end