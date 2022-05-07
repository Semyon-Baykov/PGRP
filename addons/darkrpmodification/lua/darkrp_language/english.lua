--[[---------------------------------------------------------------------------
English (example) language file
---------------------------------------------------------------------------

This is the english language file. The things on the left side of the equals sign are the things you should leave alone
The parts between the quotes are the parts you should translate. You can also copy this file and create a new language.

= Warning =
Sometimes when DarkRP is updated, new phrases are added.
If you don't translate these phrases to your language, it will use the English sentence.
To fix this, join your server, open your console and enter darkp_getphrases yourlanguage
For English the command would be:
	darkrp_getphrases "en"
because "en" is the language code for English.

You can copy the missing phrases to this file and translate them.

= Note =
Make sure the language code is right at the bottom of this file

= Using a language =
Make sure the convar gmod_language is set to your language code. You can do that in a server CFG file.
---------------------------------------------------------------------------]]

local my_language = {
	-- Admin things
	need_admin = "Вам нужны права админа для %s",
	need_sadmin = "Вам нужны права суперадмина для %s",
	no_privilege = "У вас нет нужных прав для этого действия",
	no_jail_pos = "Позиция тюрьмы не установлена",
	invalid_x = "Ошибка в %s! %s",

	-- F1 menu
	f1ChatCommandTitle = "Чат-команды",
	f1Search = "Поиск...",

	-- Money things:
	price = "Цена: %s%d",
	priceTag = "Цена: %s",
	reset_money = "%s сбросил деньги всем игрокам!",
	has_given = "%s дал вам %s",
	you_gave = "Вы дали %s %s",
	npc_killpay = "%s за убийство НИПа!",
	profit = " дохода",
	loss = "убыток",

	-- backwards compatibility
	deducted_x = "Вычтено %s%d",
	need_x = "Нужно %s%d",

	deducted_money = "Вычтено %s",
	need_money = "Нужно %s",

	payday_message = "Зарплата! Вы получили %s!",
	payday_unemployed = "Вы безработный и вы не получаете зарплату!",
	payday_missed = "Получка пропущена! (Вы под арестом)",

	property_tax = "Налог на собственность! %s",
	property_tax_cant_afford = "Вы не смогли уплатить налоги! Ваша собственность отобрана у вас!",
	taxday = "День налогов! Вычтено %s%% из вашей прибыли!",

	found_cheque = "Вы нашли %s%s в чеке, выписанном вам от %s.",
	cheque_details = "Этот чек выписан %s.",
	cheque_torn = "Вы разорвали чек.",
	cheque_pay = "Уплата: %s",
	signed = "Подпись: %s",

	found_cash = "Вы нашли %s%d!", -- backwards compatibility
	found_money = "Вы нашли %s!",

	owner_poor = "Владелец %s слишком беден чтобы субсидировать эту продажу!",

	-- Police
	Wanted_text = "Разыскивается!",
	wanted = "Разыскивается полицией!\nПричина: %s",
	youre_arrested = "Вы были арестованы на %d секунд!",
	youre_arrested_by = "%s арестовал вас.",
	youre_unarrested_by = "%s выпустил вас.",
	hes_arrested = "%s был арестован на %d секунд!",
	hes_unarrested = "%s был выпущен из тюрьмы!",
	warrant_ordered = "%s приказывает обыскать %s. Причина: %s",
	warrant_request = "%s запрашивает ордер на обыск %s\nПричина: %s",
	warrant_request2 = "Запрос на орден отправлен мэру %s!",
	warrant_approved = "Запрос на обыск %s был одобрен!\nПричина: %s\nПриказ выдал: %s",
	warrant_approved2 = "Теперь вы можете обыскать его дом.",
	warrant_denied = "Мэр %s отклонил ваш запрос на ордер.",
	warrant_expired = "Ордер на обыск %s истёк!",
	warrant_required = "Вам нужен ордер на обыск чтобы взломать эту дверь.",
	warrant_required_unfreeze = "Вам нужен ордер на обыск чтобы разморозить эту пропу.",
	warrant_required_unweld = "Вам нужен ордер на обыск чтобы отсоединить эту пропу.",
	wanted_by_police = "%s разыскивается полицией!\nПричина: %s\nПриказ выдал: %s",
	wanted_by_police_print = "%s объявил %s в розыск, причина: %s",
	wanted_expired = "%s больше не разыскивается полицией.",
	wanted_revoked = "%s больше не разыскивается полицией.\nОтменил: %s",
	cant_arrest_other_cp = "Вы не можете арестовывать других копов!",
	must_be_wanted_for_arrest = "Игрок должен быть в розыске чтобы вы могли арестовать его.",
	cant_arrest_fadmin_jailed = "You cannot arrest a player who has been jailed by an admin.",
	cant_arrest_no_jail_pos = "Вы не можете арестовывать людей так как нет позиций для тюрьмы!",
	cant_arrest_spawning_players = "Вы не можете арестовывать людей которые спавнятся.",

	suspect_doesnt_exist = "Подозреваемый отсутствует.",
	actor_doesnt_exist = "Действующее лицо отсутствует.",
	get_a_warrant = "Запросить ордер на обыск",
	make_someone_wanted = "Объявить в розыск",
	remove_wanted_status = "Снять розыск",
	already_a_warrant = "Ордер на обыск подозреваемого всё ещё в силе.",
	already_wanted = "Подозреваемый уже в розыске.",
	not_wanted = "Подозреваемый не в розыске.",
	need_to_be_cp = "Вы должны быть представителем полиции.",
	suspect_must_be_alive_to_do_x = "Подозреваемый должен быть живым чтобы %s.",
	suspect_already_arrested = "Подозреваемый уже в тюрьме.",

	-- Players
	health = "Здоровье: %s",
	job = "Работа: %s",
	salary = "Зарплата: %s%s",
	wallet = "Кошелёк: %s%s",
	weapon = "Оружие: %s",
	kills = "Убийств: %s",
	deaths = "Смертей: %s",
	rpname_changed = "%s сменил ролевое имя на %s",
	disconnected_player = "Отсоединившийся игрок",

	-- Teams
	need_to_be_before = "Вы должны быть %s чтобы стать %s",
	need_to_make_vote = "Вы должны провести голосование чтобы стать %s!",
	team_limit_reached = "Нельзя стать %s, лимит исчерпан",
	wants_to_be = "%s хочет стать %s",
	has_not_been_made_team = "%s не стал %s!",
	job_has_become = "%s стал %s!",

	-- Disasters
	meteor_approaching = "WARNING: Meteor storm approaching!",
	meteor_passing = "Meteor storm passing.",
	meteor_enabled = "Meteor Storms are now enabled.",
	meteor_disabled = "Meteor Storms are now disabled.",
	earthquake_report = "Сообщается о землетрясении магнитудой %sMw",
	earthtremor_report = "Сообщается о земных толчках магнитудой %sMw",

	-- Keys, vehicles and doors
	keys_allowed_to_coown = "Вам разрешено быть со-владельцем\n(Нажмите F2 чтобы стать со-владельцем)\n",
	keys_other_allowed = "Потенциальные со-владельцы:",
	keys_allow_ownership = "(Нажмите F2 чтобы разрешить владение)",
	keys_disallow_ownership = "(Нажмите F2 чтобы запретить владение)",
	keys_owned_by = "Владелец:",
	keys_unowned = "Свободно\n(Нажмите F2 чтобы стать владельцем)",
	keys_everyone = "(Нажмите F2 чтобы разрешить для всех)",
	door_unown_arrested = "You can not own or unown things while arrested!",
	door_unownable = "This door cannot be owned or unowned!",
	door_sold = "Вы продали это за %s",
	door_already_owned = "Этой дверью уже кто-то владеет!",
	door_cannot_afford = "Недостаточно средств для покупки этой двери!",
	door_hobo_unable = "Вы не можете купить дверь если вы бомж!",
	vehicle_cannot_afford = "Вы не можете позволить себе этот транспорт!",
	door_bought = "Вы купили эту дверь за %s%s",
	vehicle_bought = "Вы купили этот транспорт за %s%s",
	door_need_to_own = "Вам нужно владеть этой дверью чтобы %s",
	door_rem_owners_unownable = "Вы не можете удалять владельцев если дверь неовладима!",
	door_add_owners_unownable = "Вы не можете добавлять владельцев если дверь неовладима!",
	rp_addowner_already_owns_door = "%s уже (со-)владеет этой дверью!",
	add_owner = "Добавить владельца",
	remove_owner = "Удалить владельца",
	coown_x = "Со-владение %s",
	allow_ownership = "Разрешить владение",
	disallow_ownership = "Запретить владение",
	edit_door_group = "Редактировать группу двери",
	door_groups = "Группы дверей",
	door_group_doesnt_exist = "Группа дверей не существует!",
	door_group_set = "Группа двери успешно установлена.",
	sold_x_doors_for_y = "Вы продали %d дверей за %s%d!", -- backwards compatibility
	sold_x_doors = "Вы продали %d дверей за %s!",

	-- Entities
	drugs = "Наркотики",
	drug_lab = "Лаборатория наркотиков",
	gun_lab = "Лаборатория оружия",
	gun = "Пушка",
	microwave = "Микроволновка",
	food = "Еда",
	money_printer = "Денежный принтер",

	sign_this_letter = "Подписать это письмо",
	signed_yours = "С уважением,",

	money_printer_exploded = "Ваш денежный принтер взорвался!",
	money_printer_overheating = "Ваш денежный принтер перегревается!",

	contents = "Содержит: ",
	amount = "Количество: ",

	picking_lock = "Взламываем замок",

	cannot_pocket_x = "Вы не можете положить это в пакет!",
	object_too_heavy = "Этот предмет слишком тяжёлый.",
	pocket_full = "Ваш пакет полон!",
	pocket_no_items = "Ваш пакет пуст.",
	drop_item = "Выбросить предмет",

	bonus_destroying_entity = "уничтожение нелегального предмета.",

	switched_burst = "Переключение на пакетный режим огня.",
	switched_fully_auto = "Переключение на автоматический режим огня.",
	switched_semi_auto = "Переключение на полуавтоматический режим огня.",

	keypad_checker_shoot_keypad = "Shoot a keypad to see what it controls.",
	keypad_checker_shoot_entity = "Shoot an entity to see which keypads are connected to it",
	keypad_checker_click_to_clear = "Right click to clear.",
	keypad_checker_entering_right_pass = "Entering the right password",
	keypad_checker_entering_wrong_pass = "Entering the wrong password",
	keypad_checker_after_right_pass = "after having entered the right password",
	keypad_checker_after_wrong_pass = "after having entered the wrong password",
	keypad_checker_right_pass_entered = "Right password entered",
	keypad_checker_wrong_pass_entered = "Wrong password entered",
	keypad_checker_controls_x_entities = "This keypad controls %d entities",
	keypad_checker_controlled_by_x_keypads = "This entity is controlled by %d keypads",
	keypad_on = "ON",
	keypad_off = "OFF",
	seconds = "seconds",

	persons_weapons = "Нелегальное оружие у %s:",
	returned_persons_weapons = "Вернул вещи конфискованные у %s.",
	no_weapons_confiscated = "%s не имеет конфискованных предметов!",
	no_illegal_weapons = "%s не имеет нелегального оружия.",
	confiscated_these_weapons = "Конфисковал следующее оружие:",
	checking_weapons = "Проверяем оружие",

	shipment_antispam_wait = "Подождите прежде чем спавнить другой ящик.",
	shipment_cannot_split = "Нельзя разделить этот ящик.",

	-- Talking
	hear_noone = "Никто не слышит ваш%s!",
	hear_everyone = "Вас все слышат!",
	hear_certain_persons = "Ваш%s слышат: ",

	whisper = " шёпот",
	yell = " крик",
	advert = "[Объявление]",
	broadcast = "[Передача!]",
	radio = "радио",
	request = "(ЗАПРОС!)",
	group = "(группе)",
	demote = "(УВОЛЬНЕНИЕ)",
	ooc = "OOC",
	radio_x = "Радио %d",

	talk = " чат",
	speak = " голос",

	speak_in_ooc = " чат в OOC",
	perform_your_action = "е выполнение действия",
	talk_to_your_group = "е сообщение группе",

	channel_set_to_x = "Канал установлен на %s!",

	-- Notifies
	disabled = "%s выключено! %s",
	gm_spawnvehicle = "The spawning of vehicles",
	gm_spawnsent = "The spawning of scripted entities (SENTs)",
	gm_spawnnpc = "The spawning of Non-Player Characters (NPCs)",
	see_settings = "Please see the DarkRP settings.",
	limit = "Вы достигли лимита %s!",
	have_to_wait = "Вам нужно подождать ещё %d секунд прежде чем %s!",
	must_be_looking_at = "Вам нужно смотреть на %s!",
	incorrect_job = "Неправильная работа для %s",
	unavailable = "%s недоступен",
	unable = "Вы не можете %s. %s",
	cant_afford = "Вы не можете позволить себе %s",
	created_x = "%s создал %s",
	cleaned_up = "Ваши %s были очищены.",
	you_bought_x = "Вы купили %s за %s%d.", -- backwards compatibility
	you_bought = "Вы купили %s за %s.",
	you_received_x = "Вы получили %s за %s.",

	created_first_jailpos = "You have created the first jail position!",
	added_jailpos = "You have added one extra jail position!",
	reset_add_jailpos = "You have removed all jail positions and you have added a new one here.",
	created_spawnpos = "%s's spawn position created.",
	updated_spawnpos = "%s's spawn position updated.",
	do_not_own_ent = "Вы не владеете этим предметом!",
	cannot_drop_weapon = "Нельзя выбросить это оружие!",
	job_switch = "Профессии были успешно обменены!",
	job_switch_question = "Поменяться профессиями с %s?",
	job_switch_requested = "Запрос об обмене профессиями отправлен.",

	cooks_only = "Только поварам.",

	-- Misc
	unknown = "Неизвестное",
	arguments = "аргументы",
	no_one = "никто",
	door = "двери",
	vehicle = "транспорт",
	door_or_vehicle = "дверь/транспорт",
	driver = "Водитель: %s",
	name = "Название %s",
	locked = "Закрыто.",
	unlocked = "Открыто.",
	player_doesnt_exist = "Игрок отсутствует.",
	job_doesnt_exist = "Профессия не существует!",
	must_be_alive_to_do_x = "Вы должны быть живы чтобы %s.",
	banned_or_demoted = "Забанен/уволен",
	wait_with_that = "Эй, подожди с этим.",
	could_not_find = "Невозможно найти %s",
	f3tovote = "Нажмите F3 или зажмите TAB чтобы вывести курсор для голосования",
	listen_up = "Внимание:", -- In rp_tell or rp_tellall
	nlr = "Правило новой жизни (NLR): Не убивайте/арестовывайте в отместку.",
	reset_settings = "Все настройки сброшены!",
	must_be_x = "Вы должны быть %s чтобы сделать %s.",
	agenda_updated = "Повестка дня обновлена",
	job_set = "%s сменил свою работу на '%s'",
	demoted = "%s был уволен",
	demoted_not = "%s не был уволен",
	demote_vote_started = "%s запустил голосование об увольнении %s",
	demote_vote_text = "Причина увольнения:\n%s", -- '%s' is the reason here
	cant_demote_self = "Вы не можете уволить себя же.",
	i_want_to_demote_you = "Я желаю уволить тебя с работы. Причина: %s",
	tried_to_avoid_demotion = "Вы попытались избежать увольнения. Хорошая попытка, но вы всё равно были уволены.", -- naughty boy!
	lockdown_started = "Мэр объявил комендантский час, возвращайтесь по домам!",
	lockdown_ended = "Комендатский час отменён",
	gunlicense_requested = "%s запросил лицензию у %s",
	gunlicense_granted = "%s дал %s лицензию",
	gunlicense_denied = "%s отказал %s в лицензии",
	gunlicense_question_text = "Дать %s лицензию?",
	gunlicense_remove_vote_text = "%s начал голосование об отзыве лицензии у %s",
	gunlicense_remove_vote_text2 = "Отозвать лицензию:\n%s", -- Where %s is the reason
	gunlicense_removed = "Лицензия %s не была отозвана!",
	gunlicense_not_removed = "Лицензия %s была отозвана!",
	vote_specify_reason = "Вам нужно указать причину!",
	vote_started = "Голосование создано",
	vote_alone = "Вы выиграли голосование так как вы один на сервере.",
	you_cannot_vote = "Вы не можете голосовать!",
	x_cancelled_vote = "%s cancelled the last vote.",
	cant_cancel_vote = "Could not cancel the last vote as there was no last vote to cancel!",
	jail_punishment = "Наказание за отсоединение! Арестован на: %d секунд.",
	admin_only = "Админам только!", -- When doing /addjailpos
	chief_or = "Шефам или ",-- When doing /addjailpos
	frozen = "Заморожено.",

	dead_in_jail = "Вы мертвы до тех пор, пока с вас не снимут арест!",
	died_in_jail = "%s умер в тюрьме!",

	credits_for = "АВТОРЫ %s\n",
	credits_see_console = "Список авторов DarkRP отправлен в консоль.",

	rp_getvehicles = "Available vehicles for custom vehicles:",

	data_not_loaded_one = "Ваши данные ещё не загрузились. Пожалуйста, подождите.",
	data_not_loaded_two = "Если проблема все ещё остаётся, свяжитесь с админом.",

	cant_spawn_weapons = "Вы не можете спавнить оружие.",
	drive_disabled = "Управление отключено.",
	property_disabled = "Опция отключена.",

	not_allowed_to_purchase = "Вам нельзя купить этот предмет.",

	rp_teamban_hint = "rp_teamban [player name/ID] [team name/id]. Use this to ban a player from a certain team.",
	rp_teamunban_hint = "rp_teamunban [player name/ID] [team name/id]. Use this to unban a player from a certain team.",
	x_teambanned_y = "%s забанил %s с профессии %s.",
	x_teamunbanned_y = "%s разбанил %s с профессии %s.",

	-- Backwards compatibility:
	you_set_x_salary_to_y = "Вы установили зарплату %s в %s%d.",
	x_set_your_salary_to_y = "%s установил вам зарплату в %s%d.",
	you_set_x_money_to_y = "Вы установили количество денег %s в %s%d.",
	x_set_your_money_to_y = "%s установил вам количество денег в %s%d.",

	you_set_x_salary = "Вы установили зарплату %s в %s.",
	x_set_your_salary = "%s установил вам зарплату в %s.",
	you_set_x_money = "Вы установили количество денег %s в %s.",
	x_set_your_money = "%s установил вам количество денег в %s.",
	you_set_x_name = "Вы установили %s имя %s",
	x_set_your_name = "%s установил вам имя %s",

	someone_stole_steam_name = "Someone is already using your Steam name as their RP name so we gave you a '1' after your name.", -- Uh oh
	already_taken = "Уже занято.",

	job_doesnt_require_vote_currently = "Эта профессия не требует голосования на данный момент!",

	x_made_you_a_y = "%s сделал вас %s!",

	cmd_cant_be_run_server_console = "This command cannot be run from the server console.",

	-- The lottery
	lottery_started = "Проводится лотерея! Участвовать за %s%d?", -- backwards compatibility
	lottery_has_started = "Проводится лотерея! Участвовать за %s?",
	lottery_entered = "Вы участвуете в лотерее за %s",
	lottery_not_entered = "%s не участвует в лотерее",
	lottery_noone_entered = "Никто не участвовал в лотерее",
	lottery_won = "%s выиграл %s в лотерее!",

	-- Animations
	custom_animation = "",
	bow = "Поклон",
	dance = "Танец 1",
	follow_me = "За мной",
	laugh = "Хаха",
	lion_pose = "Лев",
	nonverbal_no = "Нет",
	thumbs_up = "Палец вверх",
	wave = "Помахать",

	-- Hungermod
	starving = "Starving!",

	-- AFK
	afk_mode = "AFK Mode",
	salary_frozen = "Your salary has been frozen.",
	salary_restored = "Welcome back, your salary has now been restored.",
	no_auto_demote = "You will not be auto-demoted.",
	youre_afk_demoted = "You were demoted for being AFK for too long. Next time use /afk.",
	hes_afk_demoted = "%s has been demoted for being AFK for too long.",
	afk_cmd_to_exit = "Type /afk again to exit AFK mode.",
	player_now_afk = "%s is now AFK.",
	player_no_longer_afk = "%s is no longer AFK.",

	-- Hitmenu
	hit = "заказ",
	hitman = "Заказной убийца",
	current_hit = "Заказ: %s",
	cannot_request_hit = "Невозможно сделать заказ! %s",
	hitmenu_request = "Заказать",
	player_not_hitman = "Этот игрок не убийца по заказу!",
	distance_too_big = "Слишком большое расстояние.",
	hitman_no_suicide = "Убийца не может убить себя.",
	hitman_no_self_order = "Убийца не может получить заказ от себя же.",
	hitman_already_has_hit = "Убийца уже имеет заказ.",
	price_too_low = "Цена слишком низкая!",
	hit_target_recently_killed_by_hit = "Цель была ранее убита по заказу,",
	customer_recently_bought_hit = "Заказчик сделал заказ ранее.",
	accept_hit_question = "Принять заказ от %s\nв отношении %s за %s%d?", -- backwards compatibility
	accept_hit_request = "Принять заказ от %s\nв отношении %s for %s?",
	hit_requested = "Заказ сделан!",
	hit_aborted = "Заказ прерван! %s",
	hit_accepted = "Заказ принят!",
	hit_declined = "Убийца отклонил заказ!",
	hitman_left_server = "Убийца покинул сервер!",
	customer_left_server = "Заказчик покинул сервер!",
	target_left_server = "Цель покинула сервер!",
	hit_price_set_to_x = "Цена на заказ установлена в %s%d.", -- backwards compatibility
	hit_price_set = "Цена на заказ установлена в %s.",
	hit_complete = "Заказ у %s выполнен!",
	hitman_died = "Заказной убийца умер!",
	target_died = "Цель умерла!",
	hitman_arrested = "Заказной убийца был арестован!",
	hitman_changed_team = "Заказной убийца сменил команду!",
	x_had_hit_ordered_by_y = "%s имел действующий заказ от %s",

	-- Vote Restrictions
	hobos_no_rights = "Бездомные не имеют права голоса!",
	gangsters_cant_vote_for_government = "Бандиты не могут голосовать по правительственным делам!",
	government_cant_vote_for_gangsters = "Представители правительства не могут голосовать по делам криминалов!",

	-- VGUI and some more doors/vehicles
	vote = "Голосование",
	time = "Время: %d",
	yes = "Да",
	no = "Нет",
	ok = "Окей",
	cancel = "Отмена",
	add = "Добавить",
	remove = "Удалить",
	none = "Ничего",

	x_options = "Опции %s",
	sell_x = "Продать %s",
	set_x_title = "Задать название %s",
	set_x_title_long = "Задать название %s на которую вы смотрите.",
	jobs = "Профессии",
	buy_x = "Купить %s",

	-- F4menu
	no_extra_weapons = "Эта должность не даёт дополнительного оружия.",
	become_job = "Занять должность",
	create_vote_for_job = "Создать голосование",
	shipments = "Ящики",
	F4guns = "Оружие",
	F4entities = "Предметы",
	F4ammo = "Патроны",
	F4vehicles = "Транспорт",

	-- Tab 1
	give_money = "Передать деньги",
	drop_money = "Выбросить пачку денег",
	change_name = "Сменить ролевое имя",
	go_to_sleep = "Уснуть или проснуться",
	drop_weapon = "Выбросить текущее оружие",
	buy_health = "Купить излечение за %s",
	request_gunlicense = "Запросить лицензию на оружие",
	demote_player_menu = "Уволить игрока с работы",


	searchwarrantbutton = "Объявить в розыск",
	unwarrantbutton = "Снять розыск",
	noone_available = "Никто не доступен",
	request_warrant = "Запросить ордер на обыск",
	make_wanted = "Объявить кого-либо в розыск",
	make_unwanted = "Снять розыск с кого-либо",
	set_jailpos = "Установить позицию тюрьмы (сброс)",
	add_jailpos = "Добавить позицию тюрьмы",

	set_custom_job = "Установить название профессии",

	set_agenda = "Установить агенду",

	initiate_lockdown = "Установить комендантский час",
	stop_lockdown = "Отменить комендантский час",
	start_lottery = "Запустить лотерею",
	give_license_lookingat = "Дать лицензию",

	laws_of_the_land = "ЗАКОНЫ ГОРОДА",
	law_added = "Закон добавлен.",
	law_removed = "Закон удалён.",
	law_reset = "Законы сброшены.",
	law_too_short = "Текст закона слишком короткий.",
	laws_full = "Доска законов переполнена.",
	default_law_change_denied = "Вам не разрешено менять основные законы.",

	-- Second tab
	job_name = "Название: ",
	job_description = "Описание: ",
	job_weapons = "Оружие: ",

	-- Entities tab
	buy_a = "Купить %s: %s",

	-- Licenseweaponstab
	license_tab = [[License weapons

	Tick the weapons people should be able to get WITHOUT a license!
	]],
	license_tab_other_weapons = "Other weapons:",

	zombie_spawn_removed = "You have removed this zombie spawn.",
	zombie_spawn = "Zombie Spawn",
	zombie_disabled = "Zombies are now disabled.",
	zombie_enabled = "Zombies are now enabled.",
	zombie_maxset = "Maximum amount of zombies is now set to %s",
	zombie_spawn_added = "You have added a zombie spawn.",
	zombie_spawn_not_exist = "Zombie Spawn %s does not exist.",
	zombie_leaving = "Zombies are leaving.",
	zombie_approaching = "WARNING: Zombies are approaching!",
	zombie_toggled = "Zombies toggled.",
}

-- The language code is usually (but not always) a two-letter code. The default language is "en".
-- Other examples are "nl" (Dutch), "de" (German)
-- If you want to know what your language code is, open GMod, select a language at the bottom right
-- then enter gmod_language in console. It will show you the code.
-- Make sure language code is a valid entry for the convar gmod_language.
DarkRP.addLanguage("en", my_language)
