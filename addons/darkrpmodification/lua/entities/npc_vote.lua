AddCSLuaFile()

ENT.Base = 'base_ai'

ENT.PrintName = 'Представитель ЦИК РФ'
ENT.Author = 'SnOOp'
ENT.Information = ''
ENT.Category = 'GPRP'
ENT.Editable = false
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.Spawnable = true
ENT.AdminSpawnable = true

if CLIENT then
	function ENT:Draw()
		self:DrawModel()
	end
	function ENT:Initialize()
		AddNPCText( self, 'Борис Калинин', 'Представитель ЦИК РФ', Color( 170, 30, 30 ) )
	end
else
	function ENT:Initialize()
		self:SetModel( 'models/Humans/Group02/male_02.mdl' )
		self:SetHullType( HULL_HUMAN )
		self:SetHullSizeNormal( )
		self:SetNPCState( NPC_STATE_SCRIPT )
		self:SetSolid( SOLID_BBOX )
		self:SetUseType( SIMPLE_USE )
	end

	function ENT:AcceptInput( input, _, ply )
		if string.lower( input ) != 'use' then return end

		if IsValid( ply ) and ply:IsPlayer() then
			ply:ElectionsJoinMenu()
		end 
	end
end


/*
scripted_ents.Register( ENT, 'sni_test' )

if SERVER then
	local npc = ents.Create( 'sni_test' )
	npc:SetPos( there )
	npc:Spawn()
end
