module( 'gp_tune', package.seeall )

cats = { 'Стайлинг' }

tbl = {	
	['Front Bumper'] = {
		name = 'Передний бампер',
		cat = 'Стайлинг',
		subs = {
			{
				name = 'Снять',	
				price = 1500
			},
			[0]={
				name = 'Установить',
				price = 1500
			}
		}
	},
	['Rear Bumper'] = {
		name = 'Задний бампер',
		cat = 'Стайлинг',
		subs = {
			{
				name = 'Снять',	
				price = 1500
			},
			[0]={
				name = 'Установить',
				price = 1500
			}
		}
	},
	['Front bumper'] = {
		name = 'Передний бампер',
		cat = 'Стайлинг',
		subs = {
			{
				name = 'Снять',	
				price = 1500
			},
			[0]={
				name = 'Установить',
				price = 1500
			}
		}
	},
	['Rear bumper'] = {
		name = 'Задний бампер',
		cat = 'Стайлинг',
		subs = {
			{
				name = 'Снять',	
				price = 1500
			},
			[0]={
				name = 'Установить',
				price = 1500
			}
		}
	},
	['Mudguards'] = {
		name = 'Брызговики',
		cat = 'Стайлинг',
		subs = {
			{
				name = 'Снять',	
				price = 1500
			},
			[0]={
				name = 'Установить',
				price = 1500
			}
		}
	},
	['Mudguards'] = {
		name = 'Брызговики',
		cat = 'Стайлинг',
		subs = {
			{
				name = 'Снять',	
				price = 1500
			},
			[0]={
				name = 'Установить',
				price = 1500
			}
		}
	},
	['Side skirts'] = {
		name = 'Молдинги на порогах',
		cat = 'Стайлинг',
		subs = {
			{
				name = 'Снять',	
				price = 1500
			},
			[0]={
				name = 'Установить',
				price = 1500
			}
		}
	},
	['Window tinting'] = {
		name = 'Тонировка',
		cat = 'Стайлинг',
		subs = {
			[0]={
				name = 'Нет',
				price = 1500
			},

			{
				name = '50%',	
				price = 1500
			},
			{
				name = 'Наглухо',
				price = 25000
			}
		}
	},
	['Windows tinting'] = {
		name = 'Тонировка',
		cat = 'Стайлинг',
		subs = {
			[0]={
				name = 'Нет',
				price = 1500
			},
			{
				name = '50%',	
				price = 1500
			},
			{
				name = 'Наглухо',
				price = 25000
			}
		}
	},
	['Window tinting front'] = {
		name = 'Тонировка',
		cat = 'Стайлинг',
		subs = {
			[0]={
				name = 'Нет',
				price = 1500
			},

			{
				name = '50%',	
				price = 1500
			},
			{
				name = 'Наглухо',
				price = 25000
			}
		}
	},
	['Window tinting rear'] = {
		name = 'Тонировка',
		cat = 'Стайлинг',
		subs = {
			[0]={
				name = 'Нет',
				price = 1500
			},

			{
				name = '50%',	
				price = 1500
			},
			{
				name = 'Наглухо',
				price = 25000
			}
		}
	},
	['Window tinting (Front)'] = {
		name = 'Тонировка (перед)',
		cat = 'Стайлинг',
		subs = {
			[0]={
				name = 'Нет',
				price = 1500
			},

			{
				name = '50%',	
				price = 1500
			},
			{
				name = '25%',
				price = 5500
			},
			{
				name = 'Наглухо',
				price = 25000
			}
		}
	},
	['Window tinting (Rear)'] = {
		name = 'Тонировка (зад)',
		cat = 'Стайлинг',
		subs = {
			[0]={
				name = 'Нет',
				price = 1500
			},

			{
				name = '50%',	
				price = 1500
			},
			{
				name = '25%',
				price = 5500
			},
			{
				name = 'Наглухо',
				price = 25000
			}
		}
	},
}

tbl_en = {
	{
		name = 'Stage I',
		mt = 1.5,
		price = 45000
	},
	{
		name = 'Stage II',
		mt = 2,
		price = 85000
	},
	{
		name = 'Stage III',
		mt = 2.5,
		price = 150000
	}
}