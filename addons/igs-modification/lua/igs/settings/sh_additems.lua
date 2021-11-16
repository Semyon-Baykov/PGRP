--[[-------------------------------------------------------------------------
	Обязательные методы:
		:SetPrice()
		:SetDescription()

	Популярные:
		:SetTerm()            --> Срок действия в днях (по умолчанию 0, т.е. одноразовая активация)
		:SetStackable()       --> Разрешает покупать несколько одинаковых предметов
		:SetCategory()        --> Группирует предметы
		:SetIcon()            --> Картинка или модель в качестве иконки
		:SetHighlightColor()  --> Цвет заголовка
		:SetDiscountedFrom()  --> Скидка
		:SetOnActivate()      --> Свое действие при активации
		:SetHidden()          --> Скрытый предмет

	Полезное:
		gm-donate.ru/docs     -->  Подробнее о методах и все остальные
		gm-donate.ru/support  -->  Быстрая помощь и настройка от нас
		gm-donate.ru/mods     -->  Бесплатные модули
-------------------------------------------------------------------------]]--
IGS("500 тысяч валюты", "500k", 200):SetDarkRPMoney(500000) :SetIcon("https://i.imgur.com/E2a0qxB.jpg") 
IGS("1 миллион валюты", "1m", 300):SetDarkRPMoney(1000000) :SetIcon("https://i.imgur.com/F2TpSY6.jpg")
IGS("2 миллиона валюты", "2m", 450):SetDarkRPMoney(2000000) :SetIcon("https://i.imgur.com/sLWmZs7.jpg")
IGS("5 миллионов валюты", "5m", 600):SetDarkRPMoney(5000000) :SetIcon("https://i.imgur.com/uayp2UH.jpg")
IGS("10 миллионов валюты", "10m", 900):SetDarkRPMoney(10000000) :SetIcon("https://i.imgur.com/QMKiZSi.jpg")
IGS("15 миллионов валюты", "15m", 1100):SetDarkRPMoney(15000000) :SetIcon("https://i.imgur.com/DRnPtqD.jpg")


-- Premium
local prem_desc = [[
-=-=-=- Премиум активируется автоматически после активации в донат инвентаре! -=-=-=-

Привилегия премиум даёт бонус к вашей игре и разрешает вам тратить меньше денег, времени, и усилий.

• Доступ ко всем премиум работам
• Доступ к работам даже если заполнен лимит!
• Доступ к покупке супер быстрого эмеральдового принтера
• 3x XP в Росгвардие, доступ к премиум арсенальным наборам
• В 3 раза меньше тратиться бензин и голод
• Респавн таймер длится только 10 секунд
• Наркобарон получает на 10% больше денег от продажи мета
• Мер получает процентики от лотереи

-=-=-=- Премиум активируется автоматически после активации в донат инвентаре! -=-=-=-
]]
local prem_icon = "https://i.imgur.com/6I0Hdaq.jpg"	--:SetULXCommandAccess("ulx premium", "^")
local function premium_activate (ply)
	-- Give prem
	RunConsoleCommand( "sg_adduser", ply:SteamID(), "premium" )
	
	-- Notify the player
	ply:ChatAddText( Color( 139, 0, 0 ), '[PGRP-донат] ', Color( 255, 255, 255 ), 'Вы активировали премиум подписку!' )	
	ply:ChatAddText( Color( 139, 0, 0 ), '[PGRP-донат] ', Color( 255, 255, 255 ), 'Возможно вам нужно перезайти на сервер что-бы премиум полностью заработал!' )
	
	-- Notify everyone
	for k, v in ipairs( ents.FindByClass("player") ) do 
		v:ChatAddText( Color( 139, 50, 0 ), '[PGRP-донат] ', Color( 255, 255, 255 ), ply:Nick(), ' приобрёл премиум подписку!' )
		v:ChatAddText( Color( 139, 50, 0 ), '[PGRP-донат] ', Color( 255, 255, 255 ), 'Вам было начислено 5,000₽ в подарок!' )
		v:addMoney(5000)
	end
end

IGS("Премиум на 15 дней", "premium15")
	:SetOnActivate(premium_activate)
 	:SetPrice(150)
 	:SetTerm(15)
	:SetIcon(prem_icon)
 	:SetCategory("Премиум")
	:SetDescription(prem_desc)

IGS("Премиум на 30 дней", "premium30")
	:SetOnActivate(premium_activate)
 	:SetPrice(250) 
 	:SetTerm(30)
	:SetIcon(prem_icon)
 	:SetCategory("Премиум")
	:SetDescription(prem_desc)


IGS("Премиум на год", "premium365")
	:SetOnActivate(premium_activate)
 	:SetPrice(1800) 
 	:SetTerm(365)
	:SetIcon(prem_icon)
 	:SetCategory("Премиум")
	:SetDescription(prem_desc)
	:SetHidden()



-- Don admins
-- Checking for price reduction:
local m_desc = [[
Теперь вы не относитесь к числу обычных игроков. У вас появляются обязанности, а с ними и новые возможности!

Привилегия "Модератор" даёт возможнсти к начальному комплекту административных команд:
Чат:
• Mute & Unmute
Отчистка:
• Cleanprops (отчиска всех пропов выбранного игрока)
• Cleardecals (помогает серверу не лагать)
• Nolag (замараживает все вещи на карте)
Администрирование:
• Resetname (если у кого-то нонрп имя)
• Setjob
• Jail, JailTP, & Unjail
• Strip (убирает все вещи у игрока)
• Spectate
• Возможность поднимать игроков физганом
Teleport:
• Adminr (тп игрока или себя в админ комнату)
• Bring (тп игрока к себе)
• Goto
• Return
]]
local a_desc = [[
Помогайте игрокам, теперь у вас есть доступ к очень полезным административным командам. Чувствуйте себя как настоящий админ: теперь вы сможете летать, банить, и многое другое!

Привилегия "Админ" даёт доступ ко всем следующим командам:
Чат:
• Mute & Unmute
• Gag & Ungag
Отчистка:
• Cleanprops (отчиска всех пропов выбранного игрока)
• Cleardecals (помогает серверу не лагать)
• Nolag (замараживает все вещи на карте)
Администрирование:
• Noclip, Cloak, & Uncloak (позволяет вам летать по карте, наблюдая за игроками)
• Kick
• Resetname (если у кого-то нонрп имя)
• Setjob
• Jail, JailTP, & Unjail
• Strip (убирает все вещи у игрока)
• Spectate
• Возможность поднимать игроков физганом
Teleport:
• Adminr (тп игрока или себя в админ комнату)
• Bring (тп игрока к себе)
• Goto
• Return
]]
local ap_desc = [[
Полный комплект административных возможностей: доступ к job(ban), ban, и множеству других команд. Вы чувствуете власть?

Привилегия "Админ+" даёт доступ ко всем командам "Админа", "Модератора", и добавляет:
Администрирование:
• Arrest & Unarrest
• Freeze & Unfreeze
• Teleport (игрока)
• Ban & BanID (банит игрока - будьте осторожны, вам нельзя разбанивать!)
• Slap (фановая возможнсть)
]]
local s_desc = [[
Дон-суперадмин позволяет вам иметь огромную власть над игровым процессом всего сервера! Вы имеете право брать 2 оружия за игру + огромное количество разнотипных команд как выдача хп.

Привилегия "Суперадмин" даёт доступ ко всем командам "Админа+", "Админа", "Модератора", и добавляет:
DarkRP:
• Lockdown & Unlockdown (выставление ком-часа)
• Jobban & Jobunban (убирает возможность игроку стать работой)
• HP & Armor (выставление уровня хп или армора)
Администрирование:
• God & Ungod 
• Slay (убить)
• Send (тп игрока к икроку)
• Доступ к просмотру бан-листа
Q-menu:
• Выдача оружия себе в руки (вы обязаны соблюдать правила)
]]
local sp_desc = [[
Спонсор - это массивная привилегия которая даёт просто огромное количество возможностей. Вы можете спавнить машины, получаете 500к каждые два дня, и имеете права на почти все команды.

Привилегия "Спонсор" имеет права почти на все ulx команды:
Администрирование:
• Stopsound (останавливает звук у всех игроков)
• Setname (выставлять имя игроку)
• Unban, и edit ban
Фановые:
• Blind & Unblind
• Ignite & Unignite
• Maul, sslay, scream
• Model
Q-menu:
• Доступ ко спавну машин (соблюдая правила)
Чат:
• Возможность получить 500к каждые 48 часов прописав "спасибо цой"
]]

local function admin_activate (ply)
	-- Notify the player
	ply:ChatAddText( Color( 139, 0, 0 ), '[PGRP-донат] ', Color( 255, 255, 255 ), 'Вы приобрели донатную админку! Для начала, советуем вам прочитать правила администрации сервера!' )
	ply:ChatAddText( Color( 139, 0, 0 ), '[PGRP-донат] ', Color( 255, 255, 255 ), 'Теперь, вы имеете право выявлять нарушения и давать наказания игрокам!' )
	ply:ChatAddText( Color( 139, 0, 0 ), '[PGRP-донат] ', Color( 255, 255, 255 ), 'Вот полезные команды что-бы вам было легче администрировать:\n', Color( 200, 200, 200 ), 'bind l "ulx menu" -> менюшка администрации\nbind v "ulx noclip" -> полёт\nbind o "ulx cloak" -> невидимка\nbind p "ulx uncloak" -> видимка' )
	ply:ChatAddText( Color( 139, 0, 0 ), '[PGRP-донат] ', Color( 255, 255, 255 ), 'Удачи вам и спасибо за покупку!')
	
	-- Notify everyone
	for k, v in ipairs( ents.FindByClass("player") ) do 
		v:ChatAddText( Color( 139, 50, 0 ), '[PGRP-донат] ', Color( 255, 255, 255 ), ply:Nick(), ' приобрёл админку!' )
		v:ChatAddText( Color( 139, 50, 0 ), '[PGRP-донат] ', Color( 255, 255, 255 ), 'Вам было начислено 5,000₽ в подарок!' )
		v:addMoney(5000)
	end
end

IGS("Модератор", "moderator")
	:SetULXGroup("moder")
	:SetOnActivate( admin_activate )
	:SetPrice(250)
	:SetCategory("Группы")
	:SetPerma()
	:SetDescription(m_desc)
	:SetHidden()
	
IGS("Админ", "admin")
	:SetULXGroup("admin")
	:SetOnActivate( admin_activate )
	:SetPrice(450)
	:SetCategory("Группы")
	:SetPerma()
	:SetDescription(a_desc)

IGS("Админ+", "admin_plus")
	:SetULXGroup("admin+")
	:SetOnActivate( admin_activate )
	:SetPrice(670)
	:SetCategory("Группы")
	:SetPerma()
	:SetDescription(ap_desc)
	
IGS("Супер Админ", "donsuperadmin")
	:SetULXGroup("donsuperadmin")
	:SetOnActivate( admin_activate )
	:SetPrice(1200)
	:SetCategory("Группы")
	:SetPerma()
	:SetDescription(s_desc)
	
IGS("Спонсор", "sponsor")
	:SetULXGroup("owner")
	:SetOnActivate( admin_activate )
	:SetPrice(2000)
	:SetCategory("Группы")
	:SetPerma()
	:SetDescription(sp_desc)