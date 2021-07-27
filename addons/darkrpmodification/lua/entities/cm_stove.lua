AddCSLuaFile()

//local ENT = {}

ENT.Base = "base_gmodentity"

ENT.PrintName = 'Печь'
ENT.Author = 'SnOOp'
ENT.Information = 'Печь для хлiб.'
ENT.Category = 'Cook'
ENT.Editable = false
ENT.Spawnable = true
ENT.AdminOnly = false

ENT.CookingTime = 300

function ENT:SetupDataTables()
    self:NetworkVar( 'Entity', 0, 'owning_ent' )
end

if CLIENT then
	surface.CreateFont( 'CookMod', {
	    font = 'Console',
	    size = 18,
	    weight = 900,
	    shadow = true,
	    antialias = false
	} )

	function ENT:Draw()
		self:DrawModel()

		cam.Start3D2D( self:GetPos() + self:GetUp() * 75.5 + self:GetForward() * 16 + self:GetRight() * 15, self:LocalToWorldAngles( Angle( 0, 90, 90 ) ), 0.2 )
				
			draw.RoundedBox( 0, 0, 0, 145, 135, Color( 0, 0, 0, 200 ) )
			
			draw.SimpleText( 'Выпечка:', 'CookMod', 145 / 2, 30, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

			for i = 1, 3 do
				local state = self:GetNWInt( 'CookState' .. i, 1 )
				local time = self:GetNWInt( 'CookTime' .. i, 0 )

				local bcolor = Color( 0, 0, 0 )
				local text = ''

				if state == 1 and CurTime() > time then
					text = 'Нету муки!'
					bcolor = Color( 240, 10, 15 )
				elseif state == 2 and CurTime() < time then
					text = 'Готовка(' ..math.Round( ( time - CurTime() ) ).. ')'
					bcolor = Color( 20, 240, 15 )
				elseif state == 3 and CurTime() >= time then
					text = 'Готово!'
					bcolor = Color( 20, 10, 240 )
				end

				draw.RoundedBox( 0, ( 145 - 125 ) / 2, 50 + ( ( i - 1 ) * 25 ), 125, 20, bcolor )
				draw.SimpleText( text, 'CookMod', 145 / 2, 60 + ( ( i - 1 ) * 25 ), Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end
		
		cam.End3D2D()
	end
else
	local bread_models = {
		'models/props_misc/bread-1.mdl',
		'models/props_misc/bread-1b.mdl',
		'models/props_misc/bread-2.mdl',
		'models/props_misc/bread-3.mdl',
		'models/props_misc/bread-4.mdl'

	}

	function ENT:Initialize()
		self:SetModel( 'models/props_wasteland/kitchen_stove002a.mdl')
		self:PhysicsInit( SOLID_VPHYSICS ) 
		self:SetUseType( SIMPLE_USE )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		
		self:SetCollisionGroup( COLLISION_GROUP_NONE )

		for i = 1, 3 do
			self:SetNWInt( 'CookTime' .. i, 0 )
			self:SetNWInt( 'CookState' .. i, 1 ) // 1 - Нет теста | 2 - Готовка | 3 - Можно забирать
		end
		
		self.Health = 500
		self.last_spawn = CurTime() - 1 

		local phys = self:GetPhysicsObject()

		if phys:IsValid() then
			phys:Wake()
		end
	end

	function ENT:Use( act, caller )
		if self.last_spawn > CurTime() then return end

		for i = 1, 3 do 
			local state = self:GetNWInt( 'CookState' .. i, 1 )

			if state == 3 then
				self.last_spawn = CurTime() + 1

				self:EmitSound( 'items/ammocrate_open.wav' )

				local bread = ents.Create( 'spawned_food' )
				bread:SetPos( self:GetPos() + ( self:GetUp() * 65 ) + self:GetForward() * 25 )
				bread:SetModel( table.Random( bread_models ) )
				bread:Setowning_ent( self:Getowning_ent() )	

				if math.random( 1, 3 ) == 3 then bread:SetColor( Color( 103, 84, 31 ) ) end

				bread.FoodName = 'Украiнский Хлiб'
		        bread.FoodEnergy = 70
		        bread.FoodPrice = 100 

		        bread.foodItem = { model = 'models/props_misc/bread-1.mdl', energy = 70, price = 100, name = 'Украiнский Хлiб' }

				bread:Spawn()

				self:SetNWInt( 'CookTime' .. i, 0 )
				self:SetNWInt( 'CookState' .. i, 1 )

				return
			end
		end
	end

	function ENT:Think()
		
		if IsValid( self:Getowning_ent() ) then

			if self:Getowning_ent():Team() != TEAM_COOK then

				return self:Remove()

			end

		end

		for i = 1, 3 do
			local state = self:GetNWInt( 'CookState' .. i, 1 )
			local time = self:GetNWInt( 'CookTime' .. i, 0 )

			if CurTime() >= time and state != 1 and state != 3 then
				self:SetNWInt( 'CookState' .. i, 3 )
				self:GetNWInt( 'CookTime' .. i, 0 )

				self:EmitSound( 'gportal/bell.mp3' )
			end
		end
	end
end

/*
scripted_ents.Register( ENT, 'cm_stove' )

if SERVER then
	local stove = ents.Create'cm_stove'
	stove:SetPos( there )
	stove:Spawn()
end