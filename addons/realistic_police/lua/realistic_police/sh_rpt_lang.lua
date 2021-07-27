
--[[
 _____            _ _     _   _        _____      _ _             _____           _                 
|  __ \          | (_)   | | (_)      |  __ \    | (_)           / ____|         | |                
| |__) |___  __ _| |_ ___| |_ _  ___  | |__) |__ | |_  ___ ___  | (___  _   _ ___| |_ ___ _ __ ___  
|  _  // _ \/ _` | | / __| __| |/ __| |  ___/ _ \| | |/ __/ _ \  \___ \| | | / __| __/ _ \ '_ ` _ \ 
| | \ \  __/ (_| | | \__ \ |_| | (__  | |  | (_) | | | (_|  __/  ____) | |_| \__ \ ||  __/ | | | | |
|_|  \_\___|\__,_|_|_|___/\__|_|\___| |_|   \___/|_|_|\___\___| |_____/ \__, |___/\__\___|_| |_| |_|
                                                                                                                                         
--]]

include("sh_rpt_config.lua")

Realistic_Police.Lang = {} 

Realistic_Police.Lang[1] = {

	["en"] = "Criminal Record",
    ["tr"] = "Sabika Kaydi",
    ["cn"] = "犯罪记录",
    ["fr"] = "Casier Judiciaire",
	["ru"] = "Уголовное прошлое",

}

Realistic_Police.Lang[2] = {

	["en"] = "Locker of",
    ["tr"] = "Dolap sahibi",
    ["cn"] = "储物柜",
    ["fr"] = "Casier de",
	["ru"] = "Шкафчик",

}

Realistic_Police.Lang[3] = {

	["en"] = "Name of the Person",
    ["tr"] = "Kisinin Ismi",
    ["cn"] = "姓名",
    ["fr"] = "Nom de la Personne",
	["ru"] = "Имя человека",

}

Realistic_Police.Lang[4] = {

	["en"] = "ADD",
    ["tr"] = "EKLE",
    ["cn"] = "添加",
    ["fr"] = "AJOUTER",
	["ru"] = "ДОБАВИТЬ",

}

Realistic_Police.Lang[5] = {

	["en"] = "Reason for the offence",
    ["tr"] = "Sucun nedeni",
    ["cn"] = "罪行",
    ["fr"] = "Motif de l'infraction",
	["ru"] = "Причина преступления",

}

Realistic_Police.Lang[6] = {

	["en"] = "Create",
    ["tr"] = "Olustur",
    ["cn"] = "创建",
    ["fr"] = "Creer",
	["ru"] = "Создать",

}

Realistic_Police.Lang[7] = {

	["en"] = "Cancel",
    ["tr"] = "Iptal Et",
    ["cn"] = "取消",
    ["fr"] = "Annuler",
	["ru"] = "Отменить",

}

Realistic_Police.Lang[8] = {

	["en"] = "License Plate",
    ["tr"] = "Plaka",
    ["cn"] = "车牌",
    ["fr"] = "Plaque D'imatriculation",
	["ru"] = "Номерной знак",

}

Realistic_Police.Lang[9] = {

	["en"] = "Search",
    ["tr"] = "Ara",
    ["cn"] = "搜索",
    ["fr"] = "Rechercher",
	["ru"] = "Поиск",

}

Realistic_Police.Lang[10] = {

	["en"] = "No vehicles found",
    ["tr"] = "Hicbir arac bulunamadi",
    ["cn"] = "没有找到车辆",
    ["fr"] = "Aucun Vehicules Trouvés",
	["ru"] = "Не найдено",

}

Realistic_Police.Lang[11] = {

    ["en"] = [[Madam, Mr. Prosecutor,

    I, the undersigned (surname and first name), born on (date of birth at place of birth) and exercising the profession of (profession), hereby inform you to lodge a complaint against (surname and first name / name of company / name of organisation / or X if unknown), residing in (name the address of the person or company concerned) for (qualification of the offence).

    As of (date of the event), I have indeed been a victim of the following facts: (indicate as precisely as possible the details of the facts as well as the place where they occurred, the time of the event and the persons involved in the offence). I am enclosing with this letter any documents/photographs/evidence that may be useful in the further course of this case (please attach copies and not originals).

    Several people witnessed the above-mentioned offence. They are Mrs/Mr (full names), residing at (address of witnesses) and can be reached at the following number (telephone number of witnesses).

    Several people witnessed the above-mentioned offence. They are Mrs / Mr (surnames and first names).

    Signature of the Police Officer]],

    ["fr"] = [[Madame, Monsieur le Procureur,

    Je soussigné(e) (nom et prénom), né(e) le date de naissance à lieu de naissance et exerçant la profession de (profession), vous informe porter plainte contre (nom et prénom / nom de l'entreprise / nom de l'organisation / ou X si personne non connue), résidant à (nommer l'adresse de la personne ou de l'entreprise concernée) pour (qualification de l'infraction).

    En date du (date de l'événement), j'ai en effet été victime des faits suivants : (indiquer le plus précisément possible le détail des faits ainsi que le lieu où ils se sont produits, l'heure de l'événement et les personnes impliquées dans l'infraction). Je joins à cette lettre les documents / photos / preuves qui pourraient se révéler utiles dans la suite de cette affaire (attention à joindre des copies et non des originaux).

    Plusieurs personnes ont été témoins de l'infraction mentionnée ci-dessus. Il s'agit de Madame / Monsieur (noms et prénoms).

    Je vous prie d'agréer, Madame, Monsieur le Procureur, l'expression de mes sentiments les meilleurs.

    Signature du Policier]],

    ["tr"] = [[Bayan, Bay. Savci,

    Ben asagida imzasi bulunan (Isim ve soy isim), (Dogum yeri ve dogum gunu) dogan ve meslegi (mesleginiz) olan bir sikayetciyim. Bu vesile ile (Isim ve Soyisim / sirket ismi / organizasyon ismi / veya bilinmiyorsa X), (sirketin veya sahisin adresi)'nde ikamet eden ve (sucun niteligi).

    (olayin tarihi) tarihinde gerceklesen bu olaydan sikayetciyim, Bu olayin kurbani oldugumu su sebeplerle gostereyim: (yasanan olayi tum detaylarla, mekan isimleri,saatiyle beraber her detayına kadar yazin). Bu davanin kisa surmesinde yardimci olan dokuman/fotograf/kanit ve benzeri dokumanlari suraya birakiyorum  (lutfen fotograflari buraya yerlestiriniz).

    Asagida adi gecen birkac sahis olaya taniklik etmislerdir. Bunlar Bay/Bayan (tam adlari), (tanikin istikamet ettigi yer)'da istikamet ediyorlar ve su numaradan ulasilabilir (tanikin telefon numarasi).

    Asagida adi gecen birkac sahis olaya taniklik etmislerdir. Bunlar Bay / Bayan (isim ve soy isimleri).

    Lutfen bu davayi cozmenizi rica ediyorum, Bayan, Bay Savci, size sans dileyip tesekkur ediyorum, iyi gunler.

    Polis Memurunun Imzasi]],

    ["cn"] = [[检察官先生/女士，

    本人（姓和名），生于（出生地出生日期），从事（职业），特此通知你对居住在（有关人员或公司的地址名称）的（姓和名/公司名称/组织名称/或X（如不详））进行（犯罪行为）投诉。

    截至(事件发生日期)，本人确实是以下事件的受害者：(请尽可能准确地注明事件的详细情况以及发生地点、事件发生时间和参与犯罪的人员)。我随信附上可能对本案进一步审理有用的任何文件/照片/证据（请附上复印件，不要原件）。

    有几个人目睹了上述犯罪行为。他们是太太/先生（姓和名），住在（证人的地址），可以通过以下号码（证人的电话号码）联系。

    有几个人目睹了上述犯罪行为。他们是夫人/先生（姓和名）。

    检察官先生/女士，请接受我最美好的祝愿，谢谢你，祝你有愉快的一天。

    警务人员签名]],
	
	["ru"] = [[Мадам, Господин Прокурор,

    Я, нижеподписавшийся (фамилия и имя), родившийся (дата рождения по месту рождения) и осуществляющий профессию (профессия), Настоящим сообщаю вам подать жалобу на (фамилию и имя / название компании / название организации / или X, если неизвестно), проживающий (имя адрес соответствующего лица или компании) для (квалификации преступления).

    По состоянию на (дату события) я действительно стал жертвой следующих фактов: (укажите как можно точнее детали фактов, а также место, где они произошли, время события и лиц, причастных к преступлению). Прилагаю к настоящему письму любые документы / фотографии / доказательства, которые могут быть полезны в дальнейшем ходе этого дела (пожалуйста, приложите копии, а не оригиналы).

    Несколько человек стали свидетелями вышеупомянутого преступления. Они являются г-жой/г-ном (полные имена), проживающими по адресу (адрес свидетелей), и с ними можно связаться по следующему номеру (номер телефона свидетелей).

    Несколько человек стали свидетелями вышеупомянутого преступления. Это Миссис / Мистер (фамилии и имена).

    Подпись сотрудника полиции]]

}

Realistic_Police.Lang[12] = {

    ["en"] = "Unknown",
    ["tr"] = "Bilinmeyen",
    ["cn"] = "未知",
    ["fr"] = "Inconnue",
	["ru"] = "Неизвестный",

}

Realistic_Police.Lang[13] = {

    ["en"] = "Delete",
    ["tr"] = "Sil",
    ["cn"] = "删除",
    ["fr"] = "Delete",
	["ru"] = "Удалить",
    
}

Realistic_Police.Lang[14] = {

    ["en"] = "The",
    ["tr"] = "The",
    ["cn"] = "该",
    ["fr"] = "Le",
	["ru"] = "",
    
}

Realistic_Police.Lang[15] = {

    ["en"] = "Accused Name",
    ["tr"] = "Sanik Adi",
    ["cn"] = "被告姓名",
    ["fr"] = "Nom de L'Accusé",
	["ru"] = "Имя обвиняемого",
    
}

Realistic_Police.Lang[16] = {

    ["en"] = "Save",
    ["tr"] = "Kaydet",
    ["cn"] = "保存",
    ["fr"] = "Save",
	["ru"] = "Сохр.",

}

Realistic_Police.Lang[17] = {

    ["en"] = "Prosecutor",
    ["tr"] = "Savci",
    ["cn"] = "检察官",
    ["fr"] = "Procureur",
	["ru"] = "Прокурор",

}

Realistic_Police.Lang[18] = {

    ["en"] = "Acknowledged",
    ["tr"] = "Taninan",
    ["cn"] = "已确认",
    ["fr"] = "Acusé",
	["ru"] = "Признанный",

}

Realistic_Police.Lang[19] = {

    ["en"] = "Date",
    ["tr"] = "Tarih",
    ["cn"] = "日期",
    ["fr"] = "Date",
	["ru"] = "Дата",

}

Realistic_Police.Lang[20] = {

    ["en"] = "See",
    ["tr"] = "Goz At",
    ["cn"] = "看",
    ["fr"] = "Voir",
	["ru"] = "Посм.",

}

Realistic_Police.Lang[21] = {

    ["en"] = "Name of the Person",
    ["tr"] = "Kisinin ismi",
    ["cn"] = "姓名",
    ["fr"] = "Nom de la Personne",
	["ru"] = "Имя человека",

}

Realistic_Police.Lang[22] = {

    ["en"] = "All complaints",
    ["tr"] = "Tum sikayetler",
    ["cn"] = "所有的投诉",
    ["fr"] = "Toutes les Plaintes",
	["ru"] = "Все жалобы",

}

Realistic_Police.Lang[23] = {

    ["en"] = "Displacement X-axis",
    ["tr"] = "Yerlestirmenin X-ekseni",
    ["cn"] = "X轴位移",
    ["fr"] = "Deplacement Axe-X",
	["ru"] = "Смещение по оси X",

}

Realistic_Police.Lang[24] = {

    ["en"] = "Displacement Y-axis",
    ["tr"] = "Yerlestirmenin Y-ekseni",
    ["cn"] = "Y轴位移",
    ["fr"] = "Deplacement Axe-Y",
	["ru"] = "Смещение по оси Y",

}

Realistic_Police.Lang[25] = {

    ["en"] = "Displacement Z-axis",
    ["tr"] = "Yerlestirmenin Z-ekseni",
    ["cn"] = "Z轴位移",
    ["fr"] = "Deplacement Axe-Z",
	["ru"] = "Смещение по оси Z",

}

Realistic_Police.Lang[26] = {

    ["en"] = "Rotation X-axis",
    ["tr"] = "Donmenin X-ekseni",
    ["cn"] = "X轴旋转",
    ["fr"] = "Rotation Axe-X",
	["ru"] = "Вращение по оси X",

}

Realistic_Police.Lang[27] = {

    ["en"] = "Rotation Y-axis",
    ["tr"] = "Donmenin Y-ekseni",
    ["cn"] = "Y轴旋转",
    ["fr"] = "Rotation Axe-Y",
	["ru"] = "Вращение по оси Y",

}

Realistic_Police.Lang[28] = {

    ["en"] = "Rotation Z-axis",
    ["tr"] = "Donmenin Z-ekseni",
    ["cn"] = "Z轴旋转",
    ["fr"] = "Rotation Axe-Z",
	["ru"] = "Вращение по оси Z",

}

Realistic_Police.Lang[29] = {

    ["en"] = "Rotation Y-axis",
    ["tr"] = "Donmenin Y-ekseni",
    ["cn"] = "Y轴旋转",
    ["fr"] = "Rotation Axe-Y",
	["ru"] = "Вращение по оси Y",

}

Realistic_Police.Lang[30] = {

    ["en"] = "Width",
    ["tr"] = "Genislik",
    ["cn"] = "宽度",
    ["fr"] = "Largeur",
	["ru"] = "Ширина",

}

Realistic_Police.Lang[31] = {

    ["en"] = "Height",
    ["tr"] = "Yukseklik",
    ["cn"] = "高度",
    ["fr"] = "Hauteur",
	["ru"] = "Высота",

}

Realistic_Police.Lang[32] = {

    ["en"] = "Select the vehicle \n for configure the \n license plate",
    ["tr"] = "Plakayi yapilandirmak \n icin bir arac seciniz",
    ["cn"] = "选择车辆进行车牌配置。",
    ["fr"] = "Selectioner le vehicule \n pour configurer la \n plaque d'imatriculation",
	["ru"] = "Выберите транспорт \n для настройки \n номерного знака",

}

Realistic_Police.Lang[33] = {

    ["en"] = "Place the (1) License \n Plate in the good place \n of your vehicle",
    ["tr"] = "Plakayi (1) aracin guzel \n ve gorunulebilir yerine \n yerlestirin",
    ["cn"] = "把(1)块车牌挂在你车辆的上",
    ["fr"] = "Placer la (1) Plaque \n D'imatriculation au bon endroit \n sur votre  vehicule",
	["ru"] = "Поместите (1) номерной \n знак в хорошее место \n вашего транспорта",

}

Realistic_Police.Lang[34] = {

    ["en"] = "Place the (2) License \n Plate in the good place \n of your vehicle",
    ["tr"] = "Plakayi (2) aracin guzel \n ve gorunulebilir yerine \n yerlestirin",
    ["cn"] = "把(2)块车牌挂在你车辆的上",
    ["fr"] = "Placer la (2) Plaque \n D'imatriculation au bon endroit \n sur votre  vehicule",
	["ru"] = "Поместите (2) номерной \n знак в хорошее место \n вашего транспорта",

}

Realistic_Police.Lang[35] = {

    ["en"] = "You don't have the right job to access on the computer",
    ["tr"] = "Bilgisayara erişmek için doğru işiniz yok",
    ["cn"] = "你没有正确的工作来访问computer。",
    ["fr"] = "Vous n'avez pas le bon metier pour ouvrir l'ordinateur",
	["ru"] = "У вас нет нужной работы для доступа к компьютеру",

}

Realistic_Police.Lang[36] = {

    ["en"] = "You just won",
    ["tr"] = "Kazandin",
    ["cn"] = "你刚刚赢了",
    ["fr"] = "Vous avez gagné",
	["ru"] = "Вы получили",

}

Realistic_Police.Lang[37] = {

    ["en"] = "You have added a penalty",
    ["tr"] = "Bir ceza ekledin",
    ["cn"] = "你增加了一个处罚",
    ["fr"] = "Vous avez ajouter une penalité",
	["ru"] = "Вы добавили наказание",

}

Realistic_Police.Lang[38] = {

    ["en"] = "Camera Center",
    ["tr"] = "Kamera Merkezi",
    ["cn"] = "摄像中心",
    ["fr"] = "Centre Camera",
	["ru"] = "Камерный центр",

}

Realistic_Police.Lang[39] = {

    ["en"] = "Security Camera of the City",
    ["tr"] = "Sehirin guvenlik kamerasi",
    ["cn"] = "市区监控摄像头",
    ["fr"] = "Camera de Sécurité de la ville",
	["ru"] = "Камера безопасности города",

}

Realistic_Police.Lang[40] = {

    ["en"] = "Press Use for Change Camera",
    ["tr"] = "Kamerayi degistirmek icin kullan tusuna basin",
    ["cn"] = "按 使用 键更换摄像头",
    ["fr"] = "Appuyé sur [UTILISER] pour changer de camera",
	["ru"] = "Нажмите [ИСПОЛЬЗОВАТЬ] для смены камеры",

}

Realistic_Police.Lang[41] = {

    ["en"] = "You can't delete this",
    ["tr"] = "Bunu silemezsin",
    ["cn"] = "你不能删除它",
    ["fr"] = "Vous ne pouvez pas supprimer ceci",
	["ru"] = "Вы не можете удалить это",

}

Realistic_Police.Lang[42] = {

    ["en"] = "You can't do this",
    ["tr"] = "Bunu yapamazsin",
    ["cn"] = "你不能这样做",
    ["fr"] = "Vous ne pouvez pas faire cela",
	["ru"] = "Вы не можете сделать это",

}

Realistic_Police.Lang[43] = {

    ["en"] = "NO SIGNAL",
    ["tr"] = "SINYAL YOK",
    ["cn"] = "无信号",
    ["fr"] = "AUCUN SIGNAL",
	["ru"] = "НЕТ СИГНАЛА",

}

Realistic_Police.Lang[44] = {

    ["en"] = "Problem with the Connexion",
    ["tr"] = "Baglantida bir problem var",
    ["cn"] = "连接错误",
    ["fr"] = "Probleme de Connection",
	["ru"] = "Проблема с подключением",

}

Realistic_Police.Lang[45] = {

    ["en"] = "The computer have to be hacked for open an application",
    ["tr"] = "Bir uygulamayi acmak icin bilgisayari hacklemen gerekir",
    ["cn"] = "你必须入侵它才可以打开应用程序。",
    ["fr"] = "l'ordinateur doit être hacké pour ouvrir une application",
	["ru"] = "Компьютер должен быть взломан, чтобы открыть приложение",

}

Realistic_Police.Lang[46] = {

    ["en"] = "You don't have enough money for pay the fine",
    ["tr"] = "Cezayi odemek icin yeterli paran yok",
    ["cn"] = "你没有足够的钱来支付罚款。",
    ["fr"] = "Vous n'avez pas assez d'argent pour payer l'amende",
	["ru"] = "У вас недостаточно денег, чтобы оплатить штраф",

}

Realistic_Police.Lang[47] = {

    ["en"] = "Pay the Fine",
    ["tr"] = "Cezayi Ode",
    ["cn"] = "缴纳罚款",
    ["fr"] = "Payer l'Ammende",
	["ru"] = "Оплатить штраф",

}

Realistic_Police.Lang[48] = {

    ["en"] = "CONFIRM",
    ["tr"] = "ONAYLA",
    ["cn"] = "确认",
    ["fr"] = "CONFIRMER",
	["ru"] = "ПОДТВЕРДИТЬ",

}

Realistic_Police.Lang[49] = {

    ["en"] = "CATEGORY",
    ["tr"] = "KATEGORI",
    ["cn"] = "类型",
    ["fr"] = "CATEGORIE",
	["ru"] = "КАТЕГОРИЯ",

}

Realistic_Police.Lang[50] = {

    ["en"] = "Fine Book",
    ["tr"] = "Ceza Defteri",
    ["cn"] = "罚款书",
    ["fr"] = "Carnet D'Ammende",
	["ru"] = "Книга штрафов",

}

Realistic_Police.Lang[51] = {

    ["en"] = "Did not pay the fine",
    ["tr"] = "Para Cezasini Odemedi",
    ["cn"] = "没有支付罚款",
    ["fr"] = "N'a pas payé l'amende",
	["ru"] = "Не оплатил штраф",

}

Realistic_Police.Lang[52] = {

    ["en"] = "This person have already a fine",
    ["tr"] = "Bu sahis adina zaten bir para cezasi kesilmis durumda",
    ["cn"] = "这个人已经有罚款了",
    ["fr"] = "Cette personne a déjà une amende",
	["ru"] = "Этого человека уже оштрафовали",

}

Realistic_Police.Lang[53] = {

    ["en"] = "This vehicle have already a fine",
    ["tr"] = "Bu arac adina zaten bir para cezasi kesilmis durumda",
    ["cn"] = "这辆车已经有罚款了",
    ["fr"] = "Ce vehicule a déjà une amende",
	["ru"] = "Этот транспорт уже оштрафовали",

}

Realistic_Police.Lang[54] = {

    ["en"] = "This vehicle can't have a fine",
    ["tr"] = "Bu araca ceza kesemezsiniz",
    ["cn"] = "不能给这辆车罚款",
    ["fr"] = "Ce vehicule ne peut pas avoir d'amende",
	["ru"] = "Этот транспорт не может быть оштрафован",

}

Realistic_Police.Lang[55] = {

    ["en"] = "You don't have the right job for add a fine",
    ["tr"] = "Ceza eklemek icin dogru meslekte degilsiniz",
    ["cn"] = "职业错误，不能增加罚单",
    ["fr"] = "Vous n'avez pas le bon metier pour ajouter une amende",
	["ru"] = "У вас нет подходящей работы для добавления штрафа",

}

Realistic_Police.Lang[56] = {

    ["en"] = "You can't add a fine to this player",
    ["tr"] = "Bu oyuncuya para cezasi kesemezsin",
    ["cn"] = "你不能给这名玩家下罚单",
    ["fr"] = "Cette personne ne peux pas recevoir d'amende",
	["ru"] = "Вы не можете оштрафовать этого игрока",

}

Realistic_Police.Lang[57] = {

    ["en"] = "You can't add fine on this vehicle",
    ["tr"] = "Bu araca para cezasi kesemezsin",
    ["cn"] = "你不能给这辆车下罚单",
    ["fr"] = "Ce vehicule ne peut pas avoir d'amende",
	["ru"] = "Вы не можете добавить штраф к этому транспорту",

}

Realistic_Police.Lang[58] = {

    ["en"] = "You can add more penalty",
    ["tr"] = "Daha fazla ceza kesebilirsin",
    ["cn"] = "你可以增加更多的罚金",
    ["fr"] = "Vous avez atteint la limite de sanction",
	["ru"] = "Вы можете добавить ещё одно наказание",

}

Realistic_Police.Lang[59] = {

    ["en"] = "You have to select a penalty",
    ["tr"] = "Bir ceza secmen lazim",
    ["cn"] = "你必须设定罚款金额",
    ["fr"] = "Vous devez selectionner une penalité",
	["ru"] = "Вы должны выбрать наказание",

}

Realistic_Police.Lang[60] = {

    ["en"] = "You can't add a fine to your vehicle",
    ["tr"] = "Kendi aracina ceza kesemezsin",
    ["cn"] = "你不能给自己的车罚款",
    ["fr"] = "Vous ne pouvez pas ajouter une amende a votre vehicule",
	["ru"] = "Вы не можете добавить штраф к вашему транспорту",

}

Realistic_Police.Lang[61] = {

    ["en"] = "You don't have the right job for arrest this person",
    ["tr"] = "Bu oyuncuyu tutuklamak icin dogru meslege sahip degilsin",
    ["cn"] = "职业错误，你不能逮捕这个人",
    ["fr"] = "Vous n'avez pas le bon metier pour arreter cette personne",
	["ru"] = "У вас нет подходящей работы для ареста этого человека",

}

Realistic_Police.Lang[62] = {

    ["en"] = "You can't arrest this person",
    ["tr"] = "Bu oyuncuyu tutuklayamazsin",
    ["cn"] = "你不能逮捕这个人",
    ["fr"] = "Vous ne pouvez pas arreter cette personne",
	["ru"] = "Вы не можете арестовать этого человека",

}

Realistic_Police.Lang[63] = {

    ["en"] = "You must drag a player for jail someone",
    ["tr"] = "Birini hapise atmak icin suruklemen lazim",
    ["cn"] = "你必须抓着玩家才能让他坐牢",
    ["fr"] = "Vous devez tenir une personne pour le mettre en prison",
	["ru"] = "Вы должны вести человека, чтобы посадить его в тюрьму",

}

Realistic_Police.Lang[64] = {

    ["en"] = "You just paid",
    ["tr"] = "Su kadar odedin",
    ["cn"] = "你刚付了钱",
    ["fr"] = "Vous venez de payer",
	["ru"] = "Вы заплатили",

}

Realistic_Police.Lang[65] = {

    ["en"] = "You don't have enought money for do this",
    ["tr"] = "Bunu yapmaya yeterli paran yok",
    ["cn"] = "你没有足够的钱来做这件事",
    ["fr"] = "Vous n'avez pas assez d'argent pour faire ceci",
	["ru"] = "У вас недостаточно денег для этого",

}

Realistic_Police.Lang[66] = {

    ["en"] = "Arrest Menu",
    ["tr"] = "Tutuklama Menusu",
    ["cn"] = "逮捕菜单",
    ["fr"] = "Menu d'Arrestation",
	["ru"] = "Меню ареста",

}

Realistic_Police.Lang[67] = {

    ["en"] = "Name",
    ["tr"] = "Isim",
    ["cn"] = "名称",
    ["fr"] = "Nom",
	["ru"] = "Имя",

}

Realistic_Police.Lang[68] = {

    ["en"] = "Price",
    ["tr"] = "Ucret",
    ["cn"] = "价格",
    ["fr"] = "Prix",
	["ru"] = "Цена",

}

Realistic_Police.Lang[69] = {

    ["en"] = "Motif",
    ["tr"] = "Motif",
    ["cn"] = "原因",
    ["fr"] = "Motif",
	["ru"] = "Причина",

}

Realistic_Police.Lang[70] = {

    ["en"] = "Pay",
    ["tr"] = "Ode",
    ["cn"] = "支付",
    ["fr"] = "Payer",
	["ru"] = "Оплатить",

}

Realistic_Police.Lang[71] = {

    ["en"] = "List of Arrested",
    ["tr"] = "Tutuklananlarin Listesi",
    ["cn"] = "被捕人员名单",
    ["fr"] = "Liste des Prisonniers",
	["ru"] = "Список арестованных",

}

Realistic_Police.Lang[72] = {

    ["en"] = "There is no player arrested",
    ["tr"] = "Hicbir oyuncu tutuklanmamis",
    ["cn"] = "没有玩家被捕",
    ["fr"] = "Aucune personne n'est arretée",
	["ru"] = "Нет ни одного арестованного игрока",

}

Realistic_Police.Lang[73] = {

    ["en"] = "There is no jail position contact an administrator",
    ["tr"] = "Ayarlanmis herhangi bir hapis pozisyonu yok, bir admine ulasin",
    ["cn"] = "没有设置监狱位置，请联系管理员",
    ["fr"] = "Il n'y a aucune position de prison contacté un administrateur",
	["ru"] = "Нет позиции тюрьмы, обратитесь к администратору",

}

Realistic_Police.Lang[74] = {

    ["en"] = "List of Weapons",
    ["tr"] = "Silah Listesi",
    ["cn"] = "武器列表",
    ["fr"] = "Liste des Armes",
	["ru"] = "Список оружия",

}

Realistic_Police.Lang[75] = {

    ["en"] = "CONFISCATE",
    ["tr"] = "EL KOY",
    ["cn"] = "充公",
    ["fr"] = "CONFISQUER",
	["ru"] = "КОНФИСКОВАТЬ",

}

Realistic_Police.Lang[76] = {

    ["en"] = "You are Surrender",
    ["tr"] = "Teslim Oldunuz",
    ["cn"] = "你已投降",
    ["fr"] = "Vous vous rendez",
	["ru"] = "Вы сдаётесь",

}

Realistic_Police.Lang[77] = {

    ["en"] = "You are Arrested",
    ["tr"] = "Tutuklusunuz",
    ["cn"] = "你被逮捕了",
    ["fr"] = "Vous êtes arreté",
	["ru"] = "Вас заковали в наручники",

}

Realistic_Police.Lang[78] = {

    ["en"] = "Years",
    ["tr"] = "Yil",
    ["cn"] = "年",
    ["fr"] = "Années",
	["ru"] = "секунд",

}

Realistic_Police.Lang[79] = {

    ["en"] = "You have too many entities",
    ["tr"] = "Birçok varlığa sahipsin",
    ["cn"] = "你有很多实体",
    ["fr"] = "Vous avez trop d'entités",
	["ru"] = "У вас слишком много энтити",

}

Realistic_Police.Lang[80] = {

    ["en"] = "Press [USE] to spawn the prop",
    ["tr"] = "Pervaneyi oluşturmak için [USE] tuşuna basın",
    ["cn"] = "按[USE]键生成道具",
    ["fr"] = "Appuyez sur [UTILISER] pour faire spawn le prop",
	["ru"] = "Нажмите [ИСПОЛЬЗОВАТЬ], чтобы заспавнить проп",

}

Realistic_Police.Lang[81] = {

    ["en"] = "You were released by",
    ["tr"] = "Tarafından serbest bırakıldınız",
    ["cn"] = "你被释放了",
    ["fr"] = "Vous avez été liberé par",
	["ru"] = "Вас освободил",

}

Realistic_Police.Lang[82] = {

    ["en"] = "You were arrested by",
    ["tr"] = "Tarafından tutuklandın",
    ["cn"] = "你被逮捕了",
    ["fr"] = "Vous avez été arreté par",
	["ru"] = "Вас арестовал",

}

Realistic_Police.Lang[83] = {

    ["en"] = "You arrested",
    ["tr"] = "Tutukladın",
    ["cn"] = "逮捕你",
    ["fr"] = "Vous avez arreté",
	["ru"] = "Вы арестованы",

}

Realistic_Police.Lang[84] = {

    ["en"] = "Police Trunk",
    ["tr"] = "Polis Sandıgı",
    ["cn"] = "警察箱",
    ["fr"] = "Coffre de Police",
	["ru"] = "Полицейский багажник",

}

Realistic_Police.Lang[85] = {

    ["en"] = "You can't delete your penalty",
    ["tr"] = "Penalitesini silemezsin",
    ["cn"] = "你不能删除你的惩罚",
    ["fr"] = "Vous ne pouvez pas supprimer une de vos sanctions",
	["ru"] = "Вы не можете удалить своё наказание",

}

Realistic_Police.Lang[86] = {

    ["en"] = "You can't edit your penalty",
    ["tr"] = "Penalitesini düzenleyemezsin",
    ["cn"] = "你不能编辑你的刑罚",
    ["fr"] = "Vous ne pouvez pas editer une de vos sanctions",
	["ru"] = "Вы не можете изменить своё наказание",

}

Realistic_Police.Lang[87] = {

    ["en"] = "Seconds",
    ["tr"] = "saniye",
    ["cn"] = "秒",
    ["fr"] = "Secondes",
	["ru"] = "секунды",

}

Realistic_Police.Lang[88] = {

    ["en"] = "Name of the Camera",
    ["tr"] = "Kamera Adı",
    ["cn"] = "相机名称",
    ["fr"] = "Nom de la Camera",
	["ru"] = "Имя камеры",

}

Realistic_Police.Lang[89] = {

    ["en"] = "Camera Configuration",
    ["tr"] = "Kamera Yapılandırması",
    ["cn"] = "相机配置",
    ["fr"] = "Configuration Camera",
	["ru"] = "Конфигурация камеры",

}













