
TOOL.Category		= "Constraints"
TOOL.Name			= "#Precision"
TOOL.Command		= nil
TOOL.ConfigName		= ""

TOOL.ClientConVar[ "mode" ]	 			= "1"
TOOL.ClientConVar[ "user" ] 			= "1"

TOOL.ClientConVar[ "freeze" ]	 		= "1"
TOOL.ClientConVar[ "nocollide" ]		= "1"
TOOL.ClientConVar[ "nocollideall" ]		= "0"
TOOL.ClientConVar[ "rotation" ] 		= "15"
TOOL.ClientConVar[ "rotate" ] 			= "1"
TOOL.ClientConVar[ "offset" ]	 		= "0"
TOOL.ClientConVar[ "forcelimit" ]		= "0"
TOOL.ClientConVar[ "torquelimit" ] 		= "0"
TOOL.ClientConVar[ "friction" ]	 		= "0"
TOOL.ClientConVar[ "width" ]	 		= "1"
TOOL.ClientConVar[ "offsetpercent" ] 	= "1"
TOOL.ClientConVar[ "removal" ]	 		= "0"
TOOL.ClientConVar[ "move" ]	 			= "1"
TOOL.ClientConVar[ "physdisable" ]		= "0"
TOOL.ClientConVar[ "ShadowDisable" ]	= "0"
TOOL.ClientConVar[ "allowphysgun" ]		= "0"
TOOL.ClientConVar[ "autorotate" ]		= "0"
TOOL.ClientConVar[ "entirecontrap" ]	= "0"
TOOL.ClientConVar[ "nudge" ]			= "25"
TOOL.ClientConVar[ "nudgepercent" ]		= "1"
TOOL.ClientConVar[ "disablesliderfix" ]	= "0"

//adv ballsocket
TOOL.ClientConVar[ "XRotMin" ]		= "-180"
TOOL.ClientConVar[ "XRotMax" ]		= "180"
TOOL.ClientConVar[ "YRotMin" ]		= "-180"
TOOL.ClientConVar[ "YRotMax" ]		= "180"
TOOL.ClientConVar[ "ZRotMin" ]		= "-180"
TOOL.ClientConVar[ "ZRotMax" ]		= "180"
TOOL.ClientConVar[ "XRotFric" ]		= "0"
TOOL.ClientConVar[ "YRotFric" ]		= "0"
TOOL.ClientConVar[ "ZRotFric" ]		= "0"
TOOL.ClientConVar[ "FreeMov" ]		= "0"

//Removal
TOOL.ClientConVar[ "removal_nocollide" ]	= "1"
TOOL.ClientConVar[ "removal_weld" ]	 		= "1"
TOOL.ClientConVar[ "removal_axis" ]	 		= "1"
TOOL.ClientConVar[ "removal_ballsocket" ]	= "1"
TOOL.ClientConVar[ "removal_advballsocket" ]= "1"
TOOL.ClientConVar[ "removal_slider" ]	 	= "1"
TOOL.ClientConVar[ "removal_parent" ]	 	= "1"
TOOL.ClientConVar[ "removal_other" ]	 	= "1"


TOOL.ClientConVar[ "enablefeedback" ]	= "1"
TOOL.ClientConVar[ "chatfeedback" ]		= "1"
TOOL.ClientConVar[ "nudgeundo" ]		= "0"
TOOL.ClientConVar[ "moveundo" ]			= "1"
TOOL.ClientConVar[ "rotateundo" ]		= "1"

function TOOL:UndoParent( Ent1 )
	Ent1:SetParent( nil )
	Ent1:SetMoveType(MOVETYPE_VPHYSICS)
	Ent1.PhysgunDisabled = false
	Ent1:SetUnFreezable( false )
	local Phys1 = Ent1:GetPhysicsObject()
	if Phys1:IsValid() then
		Phys1:EnableCollisions( true )
		Phys1:Wake()
		//Phys1:UpdateShadow(Ent1:GetAngles(),Ent1:GetAngles())
	end
end

function TOOL:DoApply(CurrentEnt, FirstEnt, autorotate, nocollideall, ShadowDisable )
	local CurrentPhys = CurrentEnt:GetPhysicsObject()
	
	//local col = CurrentEnt:GetCollisionGroup()
	//col = 19
	//CurrentEnt:SetCollisionGroup(col)
	//self:SendMessage("New group: "..col)
	
	//if ( CurrentPhys:IsDragEnabled() ) then
	//end
	//CurrentPhys:SetAngleDragCoefficient(1.05)
	//CurrentPhys:SetDragCoefficient(1.05)
	
	if ( autorotate ) then
		if ( CurrentEnt == FirstEnt ) then//Snap-rotate original object first.  Rest needs to rotate around it.
			local angle = CurrentPhys:RotateAroundAxis( Vector( 0, 0, 1 ), 0 )
			self.anglechange = Vector( angle.p - (math.Round(angle.p/45))*45, angle.r - (math.Round(angle.r/45))*45, angle.y - (math.Round(angle.y/45))*45 )
			if ( table.Count(self.TaggedEnts) == 1 ) then
				angle.p = (math.Round(angle.p/45))*45
				angle.r = (math.Round(angle.r/45))*45//Only rotate on these axies if it's singular.
			end
			angle.y = (math.Round(angle.y/45))*45
			CurrentPhys:SetAngles( angle )
		else
			local distance = math.sqrt(math.pow((CurrentEnt:GetPos().X-FirstEnt:GetPos().X),2)+math.pow((CurrentEnt:GetPos().Y-FirstEnt:GetPos().Y),2))
			local theta = math.atan((CurrentEnt:GetPos().Y-FirstEnt:GetPos().Y) / (CurrentEnt:GetPos().X-FirstEnt:GetPos().X)) - math.rad(self.anglechange.Z)
			if (CurrentEnt:GetPos().X-FirstEnt:GetPos().X) < 0 then
				CurrentEnt:SetPos( Vector( FirstEnt:GetPos().X - (distance*(math.cos(theta))), FirstEnt:GetPos().Y - (distance*(math.sin(theta))), CurrentEnt:GetPos().Z ) )
			else
				CurrentEnt:SetPos( Vector( FirstEnt:GetPos().X + (distance*(math.cos(theta))), FirstEnt:GetPos().Y + (distance*(math.sin(theta))), CurrentEnt:GetPos().Z ) )
			end
			CurrentPhys:SetAngles( CurrentPhys:RotateAroundAxis( Vector( 0, 0, -1 ), self.anglechange.Z ) )
		end
	end

	CurrentPhys:EnableCollisions( !nocollideall )
	CurrentEnt:DrawShadow( !ShadowDisable )
	if physdis then
		CurrentEnt:SetMoveType(MOVETYPE_NONE)
		CurrentEnt.PhysgunDisabled = disablephysgun
		CurrentEnt:SetUnFreezable( disablephysgun )
	else
		CurrentEnt:SetMoveType(MOVETYPE_VPHYSICS)
		CurrentEnt.PhysgunDisabled = false
		CurrentEnt:SetUnFreezable( false )
	end
	CurrentPhys:Wake()
end

function TOOL:CreateUndo(constraint,undoname)
	if (constraint) then
		undo.Create(undoname)
		undo.AddEntity( constraint )
		undo.SetPlayer( self:GetOwner() )
		undo.Finish()
		self:GetOwner():AddCleanup( "constraints", constraint )
	end
end

function TOOL:UndoRepairToggle()
	for key,CurrentEnt in pairs(self.TaggedEnts) do
		if ( CurrentEnt and CurrentEnt:IsValid() ) then
			if !(CurrentEnt == Ent2 ) then
				local CurrentPhys = CurrentEnt:GetPhysicsObject()
				if ( CurrentPhys:IsValid() && !CurrentEnt:GetParent():IsValid() ) then//parent?
					if ( CurrentEnt:GetPhysicsObjectCount() < 2 ) then //not a ragdoll
						if ( CurrentEnt:GetCollisionGroup() == COLLISION_GROUP_WORLD ) then
							CurrentEnt:SetCollisionGroup( COLLISION_GROUP_NONE )
						elseif ( CurrentEnt:GetCollisionGroup() == COLLISION_GROUP_NONE ) then
							CurrentEnt:SetCollisionGroup( COLLISION_GROUP_WORLD )
						end
						if ( speeddamp == 0 && angledamp == 0 ) then
							CurrentPhys:SetDamping( 5, 5 )
						elseif ( speeddamp == 5 && angledamp == 5 ) then
							CurrentPhys:SetDamping( 0, 0 )
						end
						CurrentPhys:Wake()
					end
				end
			end
		end
	end
	self.RepairTodo = false
end

function TOOL:DoConstraint(mode)
	self:SetStage(0)
	// Get information we're about to use
	local Ent1,  Ent2  = self:GetEnt(1),    self:GetEnt(2)

	if ( !Ent1:IsValid() || CLIENT ) then
		self:ClearObjects()
		return false//Something happened to original target, don't continue
	end

	// Get client's CVars
	local forcelimit 	= self:GetClientNumber( "forcelimit", 0 )
	local freeze		= util.tobool( self:GetClientNumber( "freeze", 1 ) )
	local nocollide		= self:GetClientNumber( "nocollide", 0 )
	local nocollideall	= util.tobool( self:GetClientNumber( "nocollideall", 0 ) )
	local torquelimit	= self:GetClientNumber( "torquelimit", 0 )
	local width			= self:GetClientNumber( "width", 1 )
	local friction		= self:GetClientNumber( "friction", 0 )
	local physdis		= util.tobool( self:GetClientNumber( "physdisable", 0 ) )
	local ShadowDisable = util.tobool( self:GetClientNumber( "ShadowDisable", 0 ) )
	local autorotate 	= util.tobool(self:GetClientNumber( "autorotate",1 ))
	local removal_nocollide 	= util.tobool(self:GetClientNumber( "removal_nocollide",1 ))
	local removal_weld 	= util.tobool(self:GetClientNumber( "removal_weld",1 ))
	local removal_axis 	= util.tobool(self:GetClientNumber( "removal_axis",1 ))
	local removal_ballsocket 	= util.tobool(self:GetClientNumber( "removal_ballsocket",1 ))
	local removal_advballsocket 	= util.tobool(self:GetClientNumber( "removal_advballsocket",1 ))
	local removal_slider 	= util.tobool(self:GetClientNumber( "removal_slider",1 ))
	local removal_parent 	= util.tobool(self:GetClientNumber( "removal_parent",1 ))
	local removal_other 	= util.tobool(self:GetClientNumber( "removal_other",1 ))
	local Bone1 = self:GetBone(1)
	local LPos1 = self:GetLocalPos(1)
	local Bone2 = nil
	local LPos2 = nil
	if ( Ent2 && (Ent2:IsValid() || Ent2:IsWorld()) ) then
		Bone2 = self:GetBone(2)
		LPos2 = self:GetLocalPos(2)
	end
	local Phys1 = self:GetPhys(1)
	
	local NumApp = 0
	

	for key,CurrentEnt in pairs(self.TaggedEnts) do
		if ( CurrentEnt and CurrentEnt:IsValid() ) then
			if !(CurrentEnt == Ent2 ) then
				local CurrentPhys = CurrentEnt:GetPhysicsObject()
				if ( CurrentPhys:IsValid() && !CurrentEnt:GetParent():IsValid() ) then//parent?
					if ( CurrentEnt:GetPhysicsObjectCount() < 2 ) then //not a ragdoll
						if (  util.tobool( nocollide ) && (mode == 1 || mode == 3)) then // not weld/axis/ballsocket or single application
							local constraint = constraint.NoCollide(CurrentEnt, Ent2, 0, Bone2)
						end
						if ( mode == 1 ) then //Apply
							self:DoApply( CurrentEnt, Ent1, autorotate, nocollideall, ShadowDisable )
						end
					end
				end
			end
		end
		NumApp = NumApp + 1
	end//Next
	if ( mode == 1 ) then
		self:SendMessage( NumApp .. " items targeted for apply." )
	elseif ( mode == 2 ) then
		self:SendMessage( NumApp .. " items targeted for rotate." )
	elseif ( mode == 3 ) then
		self:SendMessage( NumApp .. " items targeted for move." )
	end
	
	
	self:ClearSelection()
	// Clear the objects so we're ready to go again
	self:ClearObjects()
end

function TOOL:SendMessage( message )
	if ( self:GetClientNumber( "enablefeedback" ) == 0 ) then return end
	if ( self:GetClientNumber( "chatfeedback" ) == 1 ) then
		self:GetOwner():PrintMessage( HUD_PRINTTALK, "Tool: " .. message )
	else
		self:GetOwner():PrintMessage( HUD_PRINTCENTER, message )
	end
end

function TOOL:TargetValidity ( trace, Phys ) //TODO: Parented stuff should return 1
	if ( SERVER && (!util.IsValidPhysicsObject( trace.Entity, trace.PhysicsBone ) || !Phys:IsValid()) ) then
		local mode = self:GetClientNumber( "mode" )
		if ( trace.Entity:GetParent():IsValid() ) then
			return 2//Valid parent, but itself isn't
		else
			return 0//No valid phys
		end
	elseif ( trace.Entity:IsPlayer() ) then
		return 0// Don't attach players, or to players
	elseif ( trace.HitWorld ) then
		return 1// Only allow second click to be here...
	else
		return 3//Everything seems good
	end
end

function TOOL:StartRotate()
	local Ent = self:GetEnt(1)
	local Phys = self:GetPhys(1)
	local oldposu = Ent:GetPos()
	local oldangles = Ent:GetAngles()

	local function MoveUndo( Undo, Entity, oldposu, oldangles )
		if Entity:IsValid() then
			Entity:SetAngles( oldangles )
			Entity:SetPos( oldposu )
		end
	end
	
	if ( self:GetClientNumber( "rotateundo" )) then
		if SERVER then
			undo.Create("Precision_Rotate")
				undo.SetPlayer(self:GetOwner())
				undo.AddFunction( MoveUndo, Ent, oldposu, oldangles )
			undo.Finish()
		end
	end
	
	if IsValid( Phys ) then
		Phys:EnableMotion( false ) //else it drifts
	end
	
	local rotation = self:GetClientNumber( "rotation" )
	if ( rotation < 0.02 ) then rotation = 0.02 end
	self.axis = self:GetNormal(1)
	self.axisY = self.axis:Cross(Ent:GetUp())
	if self:WithinABit( self.axisY, Vector(0,0,0) ) then
		self.axisY = self.axis:Cross(Ent:GetForward())
	end
	self.axisZ = self.axisY:Cross(self.axis)
	self.realdegrees = 0
	self.lastdegrees = -((rotation/2) % rotation)
	self.realdegreesY = 0
	self.lastdegreesY = -((rotation/2) % rotation)
	self.realdegreesZ = 0
	self.lastdegreesZ = -((rotation/2) % rotation)
	self.OldPos = self:GetPos(1)//trace.HitPos
end

function TOOL:DoMove()
	// Get information we're about to use
	local Norm1, Norm2 = self:GetNormal(1),   self:GetNormal(2)
	local Phys1, Phys2 = self:GetPhys(1),     self:GetPhys(2)
	
	local Ang1, Ang2 = Norm1:Angle(), (Norm2 * -1):Angle()
	if self:GetClientNumber( "autorotate" ) == 1 then
		Ang2.p = (math.Round(Ang2.p/45))*45
		Ang2.r = (math.Round(Ang2.r/45))*45
		Ang2.y = (math.Round(Ang2.y/45))*45
		Norm2 = Ang2:Forward() * -1
	end


	local oldposu = self:GetEnt(1):GetPos()
	local oldangles = self:GetEnt(1):GetAngles()

	local function MoveUndo( Undo, Entity, oldposu, oldangles )
		if Entity:IsValid() then
			Entity:SetAngles( oldangles )
			Entity:SetPos( oldposu )
		end
	end
	if self:GetClientNumber( "moveundo" ) == 1 then
	undo.Create("Precision Move")
		undo.SetPlayer(self:GetOwner())
		undo.AddFunction( MoveUndo, self:GetEnt(1), oldposu, oldangles )
	undo.Finish()
	end

	local rotation = self:GetClientNumber( "rotation" )
	if ( rotation < 0.02 ) then rotation = 0.02 end
	if ( (self:GetClientNumber( "rotate" ) == 1 && mode != 1) || mode == 2) then//Set axies for rotation mode directions
		self.axis = Norm2
		self.axisY = self.axis:Cross(Vector(0,1,0))
		if self:WithinABit( self.axisY, Vector(0,0,0) ) then
			self.axisY = self.axis:Cross(Vector(0,0,1))
		end
		self.axisY:Normalize()
		self.axisZ = self.axisY:Cross(self.axis)
		self.axisZ:Normalize()
		self.realdegrees = 0
		self.lastdegrees = -((rotation/2) % rotation)
		self.realdegreesY = 0
		self.lastdegreesY = -((rotation/2) % rotation)
		self.realdegreesZ = 0
		self.lastdegreesZ = -((rotation/2) % rotation)
	else
		self.axis = Norm2
		self.axisY = self.axis:Cross(Vector(0,1,0))
		if self:WithinABit( self.axisY, Vector(0,0,0) ) then
			self.axisY = self.axis:Cross(Vector(0,0,1))
		end
		self.axisY:Normalize()
		self.axisZ = self.axisY:Cross(self.axis)
		self.axisZ:Normalize()
	end



	local TargetAngle = Phys1:AlignAngles( Ang1, Ang2 )//Get angle Phys1 would be at if difference between Ang1 and Ang2 was added


	if self:GetClientNumber( "autorotate" ) == 1 then
		TargetAngle.p = (math.Round(TargetAngle.p/45))*45
		TargetAngle.r = (math.Round(TargetAngle.r/45))*45
		TargetAngle.y = (math.Round(TargetAngle.y/45))*45
	end

	Phys1:SetAngles( TargetAngle )


	local NewOffset = math.Clamp( self:GetClientNumber( "offset" ), -5000, 5000 )
	local offsetpercent		= self:GetClientNumber( "offsetpercent" ) == 1
	if ( offsetpercent ) then
		local  Ent2  = self:GetEnt(2)
		local glower = Ent2:OBBMins()
		local gupper = Ent2:OBBMaxs()
		local height = math.abs(gupper.z - glower.z) -0.5
		if self:WithinABit(Norm2,Ent2:GetForward()) then
			height = math.abs(gupper.x - glower.x)-0.5
		elseif self:WithinABit(Norm2,Ent2:GetRight()) then
			height = math.abs(gupper.y - glower.y)-0.5
		end
		NewOffset = NewOffset / 100
		NewOffset = NewOffset * height
	end
	Norm2 = Norm2 * (-0.0625 + NewOffset)
	local TargetPos = self:GetPos(2) + (Phys1:GetPos() - self:GetPos(1)) + (Norm2)
	//self:SetPos(2)

	// Set the position

	Phys1:SetPos( TargetPos )
	Phys1:EnableMotion( false )

	// Wake up the physics object so that the entity updates
	Phys1:Wake()
end

function TOOL:ToggleColor( CurrentEnt )
	color = CurrentEnt:GetColor()
	color["a"] = color["a"] - 128
	if ( color["a"] < 0 ) then
		color["a"] = color["a"] + 256
	end
	color["r"] = color["r"] - 128
	if ( color["r"] < 0 ) then
		color["r"] = color["r"] + 256
	end
	color["g"] = color["g"] - 128
	if ( color["g"] < 0 ) then
		color["g"] = color["g"] + 256
	end
	color["b"] = color["b"] - 128
	if ( color["b"] < 0 ) then
		color["b"] = color["b"] + 256
	end
	CurrentEnt:SetColor( color )
	if ( color["a"] == 255 ) then
		CurrentEnt:SetRenderMode( 0 )
	else
		CurrentEnt:SetRenderMode( 1 )
	end
end

function TOOL:ClearSelection()
	if ( self.RepairTodo ) then
		self:UndoRepairToggle()
	end
	if ( self.TaggedEnts ) then
		local color
		for key,CurrentEnt in pairs(self.TaggedEnts) do
			if ( CurrentEnt and CurrentEnt:IsValid() ) then
				local CurrentPhys = CurrentEnt:GetPhysicsObject()
				if ( CurrentPhys:IsValid() ) then
					self:ToggleColor(CurrentEnt)
				end
			end
		end
	end
	self.TaggedEnts = {}
end

function TOOL:SelectEnts(StartEnt, AllConnected)
	self:ClearSelection()
	if ( CLIENT ) then return end
	local color
	if ( AllConnected == 1 ) then
		local NumApp = 0
		EntsTab = {}
		ConstsTab = {}
		GetAllEnts(StartEnt, self.TaggedEnts, EntsTab, ConstsTab)
		for key,CurrentEnt in pairs(self.TaggedEnts) do
			if ( CurrentEnt and CurrentEnt:IsValid() ) then
				local CurrentPhys = CurrentEnt:GetPhysicsObject()
				if ( CurrentPhys:IsValid() ) then
					self:ToggleColor(CurrentEnt)
				end
			end
			NumApp = NumApp + 1
		end
		self:SendMessage( NumApp .. " objects selected." )
	else
		if ( StartEnt and StartEnt:IsValid() ) then
			local CurrentPhys = StartEnt:GetPhysicsObject()
			if ( CurrentPhys:IsValid() ) then
				table.insert(self.TaggedEnts, StartEnt)
				self:ToggleColor(StartEnt)
			end
		end
	end
	
end

function TOOL:LeftClick( trace )
	local stage = self:GetStage()//0 = started, 1 = moving/second target, 2 = rotation?
	local mode = self:GetClientNumber( "mode" )
	local moving = ( mode == 3 || (self:GetClientNumber( "move" ) == 1 && mode >= 3 && mode <= 8 ) )
	local rotating = ( self:GetClientNumber( "rotate" ) == 1 )
	local Phys = trace.Entity:GetPhysicsObjectNum( trace.PhysicsBone )

	if ( mode > 3 ) then
		return false
	end

	if ( stage == 0 ) then//first click - choose a target.
		if ( self:TargetValidity(trace, Phys) <= 1 ) then
			return false//No phys or hit world
		end
		self:SetObject( 1, trace.Entity, trace.HitPos, Phys, trace.PhysicsBone, trace.HitNormal )
		
		if (self:GetClientNumber( "entirecontrap" ) == 1 || mode == 10 ) then
			self:SelectEnts(trace.Entity,1)
		else
			self:SelectEnts(trace.Entity,0)
		end
		if ( mode == 1 || mode == 10 || mode == 11 ) then //Don't care about stage, always apply.
			self:DoConstraint(mode)
		else
			if ( mode == 9 ) then
				self:SetStage(1)
			else
				if ( moving ) then//Moving
					self:StartGhostEntity( trace.Entity )
					self:SetStage(1)
				elseif ( mode == 2 ) then//Straight to rotate
					self:StartRotate()
					self:SetStage(2)
				else
					self:SetStage(1)
				end
			end
		end
	elseif ( stage == 1 ) then//Second click
		self:SetObject( 2, trace.Entity, trace.HitPos, Phys, trace.PhysicsBone, trace.HitNormal )
		
		if ( self:GetEnt(1) == self:GetEnt(2) ) then
			SavedPos = self:GetPos(2)
		end
	
		if ( moving ) then
			if ( CLIENT ) then
				self:ReleaseGhostEntity()
				return true
			end
			if ( SERVER && !game.SinglePlayer() ) then
				self:ReleaseGhostEntity()
				//return true
			end
			self:DoMove()
		end
		if ( rotating ) then
			self:StartRotate()
			self:SetStage(2)
		else
			self:DoConstraint(mode)
		end

	elseif ( stage == 2 ) then//Done rotate
		self:DoConstraint(mode)
	end
	return true
end

function TOOL:WithinABit( v1, v2 )
	local tol = 0.1
	local da = v1.x-v2.x
	local db = v1.y-v2.y
	local dc = v1.z-v2.z
	if da < tol && da > -tol && db < tol && db > -tol && dc < tol && dc > -tol then
		return true
	else
		da = v1.x+v2.x
		db = v1.y+v2.y
		dc = v1.z+v2.z
		if da < tol && da > -tol && db < tol && db > -tol && dc < tol && dc > -tol then
			return true
		else
			return false
		end
	end
end

if ( SERVER ) then
	
	function GetAllEnts( Ent, OrderedEntList, EntsTab, ConstsTab )
		if ( Ent and Ent:IsValid() ) and ( !EntsTab[ Ent:EntIndex() ] ) then
			EntsTab[ Ent:EntIndex() ] = Ent
			table.insert(OrderedEntList, Ent)
			if ( !constraint.HasConstraints( Ent ) ) then return OrderedEntList end
			for key, ConstraintEntity in pairs( Ent.Constraints ) do
				if ( !ConstsTab[ ConstraintEntity ] ) then
					ConstsTab[ ConstraintEntity ] = true
					local ConstTable = ConstraintEntity:GetTable()
					for i=1, 6 do
						local e = ConstTable[ "Ent"..i ]
						if ( e and e:IsValid() ) and ( !EntsTab[ e:EntIndex() ] ) then
							GetAllEnts( e, OrderedEntList, EntsTab, ConstsTab )
						end
					end
				end
			end
		end
		return OrderedEntList
	end
	
	function GetAllConstraints( EntsTab )
		local ConstsTab = {}
		for key, Ent in pairs( EntsTab ) do
			if ( Ent and Ent:IsValid() ) then
				local MyTable = constraint.GetTable( Ent )
				for key, Constraint in pairs( MyTable ) do
					if ( !ConstsTab[ Constraint.Constraint ] ) then
						ConstsTab[ Constraint.Constraint ] = Constraint
					end
				end
			end
		end
		return ConstsTab
	end
end

function TOOL:UpdateCustomGhost( ghost, player, offset )
	
	// Ghost is identically buggy to that of easyweld...  welding two frozen props and two unfrozen props yields different ghosts even if identical allignment

	if (ghost == nil) then return end
	if (!ghost:IsValid()) then ghost = nil return end

	local tr = util.GetPlayerTrace( player, player:GetAimVector() )
	local trace = util.TraceLine( tr )
	if (!trace.Hit) then return end

	local Ang1, Ang2 = self:GetNormal(1):Angle(), (trace.HitNormal * -1):Angle()
	local TargetAngle = self:GetEnt(1):AlignAngles( Ang1, Ang2 )

	self.GhostEntity:SetPos( self:GetEnt(1):GetPos() )
	
	if self:GetClientNumber( "autorotate" ) == 1 then
		TargetAngle.p = (math.Round(TargetAngle.p/45))*45
		TargetAngle.r = (math.Round(TargetAngle.r/45))*45
		TargetAngle.y = (math.Round(TargetAngle.y/45))*45
	end
	self.GhostEntity:SetAngles( TargetAngle )

	local TraceNormal = trace.HitNormal

	local offsetpercent		= self:GetClientNumber( "offsetpercent" ) == 1
	local NewOffset = offset
	if ( offsetpercent ) then
		local glower = trace.Entity:OBBMins()
		local gupper = trace.Entity:OBBMaxs()
		local height = math.abs(gupper.z - glower.z) -0.5
		if self:WithinABit(TraceNormal,trace.Entity:GetForward()) then
			height = math.abs(gupper.x - glower.x) -0.5
		elseif self:WithinABit(TraceNormal,trace.Entity:GetRight()) then
			height = math.abs(gupper.y - glower.y) -0.5
		end
		NewOffset = NewOffset / 100
		NewOffset = NewOffset * height
	end

	local TranslatedPos = ghost:LocalToWorld( self:GetLocalPos(1) )
	local TargetPos = trace.HitPos + (self:GetEnt(1):GetPos() - TranslatedPos) + (TraceNormal*NewOffset)

	self.GhostEntity:SetPos( TargetPos )
end


function TOOL:Think()
	//if CLIENT then return end
	local pl = self:GetOwner()
	local wep = pl:GetActiveWeapon()
	if not wep:IsValid() or wep:GetClass() != "gmod_tool" or pl:GetInfo("gmod_toolmode") != "precision" then return end
		
	if (self:NumObjects() < 1) then return end
	local Ent1 = self:GetEnt(1)
	if ( SERVER ) then
		if ( !Ent1:IsValid() ) then
			self:ClearObjects()
			return
		end
	end
	local mode = self:GetClientNumber( "mode" )

	if self:NumObjects() == 1 && mode != 2 then
		if ( (self:GetClientNumber( "move" ) == 1 && mode >= 3) || mode == 3 ) then
			if ( mode <= 8 ) then//no move = no ghost in parent mode
				local offset = math.Clamp( self:GetClientNumber( "offset" ), -5000, 5000 )
				self:UpdateCustomGhost( self.GhostEntity, self:GetOwner(), offset )
			end
		end
	else
		local rotate = (self:GetClientNumber( "rotate" ) == 1 && mode != 1) || mode == 2
		if ( SERVER && rotate && mode <= 8 ) then
			local offset = math.Clamp( self:GetClientNumber( "offset" ), -5000, 5000 )

			local Phys1 = self:GetPhys(1)

			local cmd = self:GetOwner():GetCurrentCommand()

			local rotation		= self:GetClientNumber( "rotation" )
			if ( rotation < 0.02 ) then rotation = 0.02 end
			local degrees = cmd:GetMouseX() * 0.02

			local newdegrees = 0
			local changedegrees = 0

			local angle = 0
			if( self:GetOwner():KeyDown( IN_RELOAD ) ) then
				self.realdegreesY = self.realdegreesY + degrees
				newdegrees =  self.realdegreesY - ((self.realdegreesY + (rotation/2)) % rotation)
				changedegrees = self.lastdegreesY - newdegrees
				self.lastdegreesY = newdegrees
				angle = Phys1:RotateAroundAxis( self.axisY , changedegrees )
			elseif( self:GetOwner():KeyDown( IN_ATTACK2 ) ) then
				self.realdegreesZ = self.realdegreesZ + degrees
				newdegrees =  self.realdegreesZ - ((self.realdegreesZ + (rotation/2)) % rotation)
				changedegrees = self.lastdegreesZ - newdegrees
				self.lastdegreesZ = newdegrees
				angle = Phys1:RotateAroundAxis( self.axisZ , changedegrees )
			else
				self.realdegrees = self.realdegrees + degrees
				newdegrees =  self.realdegrees - ((self.realdegrees + (rotation/2)) % rotation)
				changedegrees = self.lastdegrees - newdegrees
				self.lastdegrees = newdegrees
				angle = Phys1:RotateAroundAxis( self.axis , changedegrees )
			end
			Phys1:SetAngles( angle )

			if ( ( self:GetClientNumber( "move" ) == 1 && mode >= 3) || mode == 3 ) then
				local WPos2 = self:GetPos(2)
				local Ent2 = self:GetEnt(2)
				// Move so spots join up
				local Norm2 = self:GetNormal(2)

				local NewOffset = offset
				local offsetpercent	= self:GetClientNumber( "offsetpercent" ) == 1
				if ( offsetpercent ) then
					local glower = Ent2:OBBMins()
					local gupper = Ent2:OBBMaxs()
					local height = math.abs(gupper.z - glower.z) -0.5
					if self:WithinABit(Norm2,Ent2:GetForward()) then
						height = math.abs(gupper.x - glower.x) -0.5
					elseif self:WithinABit(Norm2,Ent2:GetRight()) then
						height = math.abs(gupper.y - glower.y) -0.5
					end
					NewOffset = NewOffset / 100
					NewOffset = NewOffset * height
				end

				Norm2 = Norm2 * (-0.0625 + NewOffset)
				local TargetPos = Vector(0,0,0)
				if ( self:GetEnt(1) == self:GetEnt(2) ) then
	//////////////////////////////////////////
					TargetPos = SavedPos + (Phys1:GetPos() - self:GetPos(1)) + (Norm2)
				else
					TargetPos = WPos2 + (Phys1:GetPos() - self:GetPos(1)) + (Norm2)
				end
				Phys1:SetPos( TargetPos )
			else
				// Move so rotating on axis

				local TargetPos = (Phys1:GetPos() - self:GetPos(1)) + self.OldPos
				Phys1:SetPos( TargetPos )
			end
			Phys1:Wake()
		end
	end
end

function TOOL:Nudge( trace, direction )
	if (!trace.Entity:IsValid() || trace.Entity:IsPlayer() ) then return false end
	local Phys1 = trace.Entity:GetPhysicsObjectNum( trace.PhysicsBone )
	local offsetpercent		= self:GetClientNumber( "nudgepercent" ) == 1
	local offset		= self:GetClientNumber( "nudge", 100 )
	local max = 8192
	if ( offsetpercent != 1 ) then
		if ( offset > max ) then
			offset = max
		elseif ( offset < -max ) then
			offset = -max
		end
	end
	//if ( offset == 0 ) then offset = 1 end
	local NewOffset = offset
	if ( offsetpercent ) then
		local glower = trace.Entity:OBBMins()
		local gupper = trace.Entity:OBBMaxs()
		local height = math.abs(gupper.z - glower.z) -0.5
		if self:WithinABit(trace.HitNormal,trace.Entity:GetForward()) then
			height = math.abs(gupper.x - glower.x)-0.5
		elseif self:WithinABit(trace.HitNormal,trace.Entity:GetRight()) then
			height = math.abs(gupper.y - glower.y)-0.5
		end
		NewOffset = NewOffset / 100
		local cap = math.floor(max / height)//No more than max units.
		if ( NewOffset > cap ) then
			NewOffset = cap
		elseif ( NewOffset < -cap ) then
			NewOffset = -cap
		end
		NewOffset = NewOffset * height
	end

	if ( self:GetClientNumber( "entirecontrap" ) == 1 ) then
		local NumApp = 0
		local TargetEnts = {}
		local EntsTab = {}
		local ConstsTab = {}
		GetAllEnts(trace.Entity, TargetEnts, EntsTab, ConstsTab)
		for key,CurrentEnt in pairs(TargetEnts) do
			if ( CurrentEnt and CurrentEnt:IsValid() ) then
				local CurrentPhys = CurrentEnt:GetPhysicsObject()
				if ( CurrentPhys:IsValid() ) then

					/*if ( self:GetClientNumber( "nudgeundo" ) == 1 ) then
						local oldpos = CurrentPhys:GetPos()
						local function NudgeUndo( Undo, Entity, oldpos )
							if CurrentEnt:IsValid() then
								CurrentEnt:SetPos( oldpos )
							end
						end
						undo.Create("Nrecision Nudge")
							undo.SetPlayer(self:GetOwner())
							undo.AddFunction( NudgeUndo, CurrentEnt, oldpos )
						undo.Finish()
					end*/// todo: all in 1 undo for mass nudging

					local TargetPos = CurrentPhys:GetPos() + trace.HitNormal * NewOffset * direction
					CurrentPhys:SetPos( TargetPos )
					CurrentPhys:Wake()
					if (CurrentEnt:GetMoveType() == 0 ) then //phys disabled, so move manually
						CurrentEnt:SetPos( TargetPos )
					end

				end
			end
			NumApp = NumApp + 1
		end
		if ( direction == -1 ) then
			self:SendMessage( NumApp .. " items pushed." )
		elseif ( direction == 1 ) then
			self:SendMessage( NumApp .. " items pulled." )
		else
			self:SendMessage( NumApp .. " items nudged." )
		end
	else
		if ( self:GetClientNumber( "nudgeundo" ) == 1 ) then
			local oldpos = Phys1:GetPos()
			local function NudgeUndo( Undo, Entity, oldpos )
				if trace.Entity:IsValid() then
					trace.Entity:SetPos( oldpos )
				end
			end
			undo.Create("Precision PushPull")
				undo.SetPlayer(self:GetOwner())
				undo.AddFunction( NudgeUndo, trace.Entity, oldpos )
			undo.Finish()
		end
		local TargetPos = Phys1:GetPos() + trace.HitNormal * NewOffset * direction
		Phys1:SetPos( TargetPos )
		Phys1:Wake()
		if ( trace.Entity:GetMoveType() == 0 ) then
			trace.Entity:SetPos( TargetPos )
		end
		if ( direction == -1 ) then
			self:SendMessage( "target pushed." )
		elseif ( direction == 1 ) then
			self:SendMessage( "target pulled." )
		else
			self:SendMessage( "target nudged." )
		end
	end
	return true
end

function TOOL:RightClick( trace )
	local rotate = self:GetClientNumber( "rotate" ) == 1
	local mode = self:GetClientNumber( "mode" )
	if ( (mode == 2 && self:NumObjects() == 1) || (rotate && self:NumObjects() == 2 ) ) then
		if ( CLIENT ) then return false end
	else
		if ( CLIENT ) then return true end
		return self:Nudge( trace, -1 )
	end
end

function TOOL:Reload( trace )
	local rotate = self:GetClientNumber( "rotate" ) == 1
	local mode = self:GetClientNumber( "mode" )
	if ( (mode == 2 && self:NumObjects() == 1) || (rotate && self:NumObjects() == 2 ) ) then
		if ( CLIENT ) then return false end
	else
		if ( CLIENT ) then return true end
		return self:Nudge( trace, 1 )
	end
end

if CLIENT then

	language.Add( "Tool.precision.name", "Precision Tool 0.98e" )
	language.Add( "Tool.precision.desc", "Accurately moves/constrains objects" )
	language.Add( "Tool.precision.0", "Primary: Move/Apply | Secondary: Push | Reload: Pull" )
	language.Add( "Tool.precision.1", "Target the second item. If enabled, this will move the first item.  (Swap weps to cancel)" )
	language.Add( "Tool.precision.2", "Rotate enabled: Turn left and right to rotate the object (Hold Reload or Secondary for other rotation directions!)" )


	language.Add("Undone.precision", "Undone Precision Constraint")
	language.Add("Undone.precision.nudge", "Undone Precision PushPull")
	language.Add("Undone.precision.rotate", "Undone Precision Rotate")
	language.Add("Undone.precision.move", "Undone Precision Move")
	language.Add("Undone.precision.weld", "Undone Precision Weld")
	language.Add("Undone.precision.axis", "Undone Precision Axis")
	language.Add("Undone.precision.ballsocket", "Undone Precision Ballsocket")
	language.Add("Undone.precision.advanced.ballsocket", "Undone Precision Advanced Ballsocket")
	language.Add("Undone.precision.slider", "Undone Precision Slider")

	local showgenmenu = 0//Seems to hide often, probably for the best

	local function AddDefControls( Panel )
		Panel:ClearControls()

		Panel:AddControl("ComboBox",
		{
			Label = "#Presets",
			MenuButton = 1,
			Folder = "precision",
			Options = {},
			CVars =
			{
				[0] = "precision_offset",
				[1] = "precision_forcelimit",
				[2] = "precision_freeze",
				[3] = "precision_nocollide",
				[4] = "precision_nocollideall",
				[5] = "precision_rotation",
				[6] = "precision_rotate",
				[7] = "precision_torquelimit",
				[8] = "precision_friction",
				[9] = "precision_mode",
				[10] = "precision_width",
				[11] = "precision_offsetpercent",
				[12] = "precision_removal",
				[13] = "precision_move",
				[14] = "precision_physdisable",
				[15] = "precision_advballsocket",
				[16] = "precision_XRotMin",
				[17] = "precision_XRotMax",
				[18] = "precision_YRotMin",
				[19] = "precision_YRotMax",
				[20] = "precision_ZRotMin",
				[21] = "precision_ZRotMax",
				[22] = "precision_XRotFric",
				[23] = "precision_YRotFric",
				[24] = "precision_ZRotFric",
				[25] = "precision_FreeMov",
				[26] = "precision_ShadowDisable",
				[27] = "precision_allowphysgun",
				[28] = "precision_autorotate",
				[29] = "precision_massmode",
				[30] = "precision_nudge",
				[31] = "precision_nudgepercent",
				[32] = "precision_disablesliderfix"
			}
		})

		//Panel:AddControl( "Label", { Text = "Secondary attack pushes, Reload pulls by this amount:", Description	= "Phx 1x is 47.45, Small tiled cube is 11.8625 and thin is 3 exact units" }  )
		Panel:AddControl( "Slider",  { Label	= "Push/Pull Amount",
					Type	= "Float",
					Min		= 1,
					Max		= 100,
					Command = "precision_nudge",
					Description = "Distance to push/pull props with altfire/reload"}	 ):SetDecimals( 4 )


		Panel:AddControl( "Checkbox", { Label = "Push/Pull as Percent (%) of target's depth", Command = "precision_nudgepercent", Description = "Unchecked = Exact units, Checked = takes % of width from target prop when pushing/pulling" } )


		local user = 1 //LocalPlayer():GetInfoNum( "precision_user", 0 )
		local mode = LocalPlayer():GetInfoNum( "precision_mode", 0 )
		//Panel:AddControl( "Label", { Text = "Primary attack uses the tool's main mode.", Description	= "Select a mode and configure the options, be sure to try new things out!" }  )

		local list = vgui.Create("DListView")

		//17 per item + 16 for title
		local height = 67 //7 shown
		

		list:SetSize(30,height)
		//list:SizeToContents()
		list:AddColumn("Tool Mode")
		list:SetMultiSelect(false)
		function list:OnRowSelected(LineID, line)
			if not (mode == LineID) then
				RunConsoleCommand("precision_setmode", LineID)
			end
		end

		if ( mode == 1 ) then
			list:AddLine(" 1 ->Apply<- (Directly apply settings to target)")
		else
			list:AddLine(" 1   Apply   (Directly apply settings to target)")
		end
		if ( mode == 2 ) then
			list:AddLine(" 2 ->Rotate<- (Turn an object without moving it)")
		else
			list:AddLine(" 2   Rotate   (Turn an object without moving it)")
		end
		if ( mode == 3 ) then
			list:AddLine(" 3 ->Move<- (Snap objects together - Great for building!)")
		else
			list:AddLine(" 3   Move   (Snap objects together - Great for building!)")
		end
		
		list:SortByColumn(1)
		Panel:AddItem(list)

		if ( mode >= 4 && mode <= 8 ) then
			Panel:AddControl( "Checkbox", { Label = "Move Target? ('Easy' constraint mode)", Command = "precision_move", Description = "Uncheck this to apply the constraint without altering positions." } )
		end
		if (  mode >= 3 && mode <= 8 ) then
			Panel:AddControl( "Checkbox", { Label = "Rotate Target? (Rotation after moving)", Command = "precision_rotate", Description = "Uncheck this to remove the extra click for rotation. Handy for speed building." } )
			//Panel:AddControl( "Label", { Text = "This is the distance from touching of the targeted props after moving:", Description	= "Use 0 mostly, % takes the second prop's width." }  )
			Panel:AddControl( "Slider",  { Label	= "Snap Distance",
					Type	= "Float",
					Min		= 0,
					Max		= 10,
					Command = "precision_offset",
					Description = "Distance offset between joined props.  Type in negative to inset when moving."}	 )
			Panel:AddControl( "Checkbox", { Label = "Snap distance as Percent (%) of target's depth", Command = "precision_offsetpercent", Description = "Unchecked = Exact units, Checked = takes % of width from second prop" } )
		end
		if ( mode >= 2 && mode <= 8 ) then
			Panel:AddControl( "Slider",  { Label	= "Rotation Snap (Degrees)",
					Type	= "Float",
					Min		= 0.02,
					Max		= 90,
					Command = "precision_rotation",
					Description = "Rotation rotates by this amount at a time. No more guesswork. Min: 0.02 degrees "}	 ):SetDecimals( 4 )
		end
		if ( mode <= 8 ) then
			if ( mode >= 3 && mode <= 8 ) then
				Panel:AddControl( "Checkbox", { Label = "No Collide Targets", Command = "precision_nocollide", Description = "Nocollide pairs of props when this tool is used. Note: No current way to remove this constraint when used alone."  } )
			end
		end

		
		if ( (mode >= 3 && mode <= 8) || mode == 1 ) then
			Panel:AddControl( "Checkbox", { Label = "Auto-align to world (nearest 45 degrees)", Command = "precision_autorotate", Description = "Rotates to the nearest world axis (similar to holding sprint and use with physgun)"  } )
		end

		if ( mode == 1 ) then
			Panel:AddControl( "Checkbox", { Label = "Disable target shadow", Command = "precision_ShadowDisable", Description = "Disables shadows cast from the prop"  } )
		end
		if ( showgenmenu == 1 ) then
			Panel:AddControl( "Button", { Label = "\\/ General Tool Options \\/", Command = "precision_generalmenu", Description = "Collapse menu"  } )


			//Panel:AddControl( "Label", { Text = "General Tool Options:", Description	= "Note: These don't save with presets." }  )
			Panel:AddControl( "Checkbox", { Label = "Enable tool feedback messages?", Command = "precision_enablefeedback", Description = "Toggle for feedback messages incase they get annoying"  } )
			Panel:AddControl( "Checkbox", { Label = "On = Feedback in Chat, Off = Centr Scrn", Command = "precision_chatfeedback", Description = "Chat too cluttered? Can have messages centre screen instead"  } )
			//Panel:AddControl( "Checkbox", { Label = "Hide Menu Tips?", Command = "precision_hidehints", Description = "Streamline the menu once you're happy with using the tool."  } )
			Panel:AddControl( "Checkbox", { Label = "Add Push/Pull to Undo List", Command = "precision_nudgeundo", Description = "For if you're in danger of nudging somthing to where you can't reach it"  } )
			Panel:AddControl( "Checkbox", { Label = "Add Movement to Undo List", Command = "precision_moveundo", Description = "So you don't have to secondary fire with nocollide to undo mistakes"  } )
			Panel:AddControl( "Checkbox", { Label = "Add Rotation to Undo List", Command = "precision_rotateundo", Description = "So you can find the exact rotation value easier"  } )
			Panel:AddControl( "Button", { Label = "Restore Current Mode Default", Command = "precision_defaultrestore", Description = "Collapse menu"  } )
		else
			Panel:AddControl( "Button", { Label = "-- General Tool Options --", Command = "precision_generalmenu", Description = "Expand menu"  } )
		end
	end



	local function precision_defaults()
		local mode = LocalPlayer():GetInfoNum( "precision_mode", 3 )
		if mode  == 1 then
			RunConsoleCommand("precision_freeze", "1")
			RunConsoleCommand("precision_autorotate", "1")
			RunConsoleCommand("precision_ShadowDisable", "0")
			RunConsoleCommand("precision_nocollideall", "0")
			RunConsoleCommand("precision_physdisable", "0")
			RunConsoleCommand("precision_allowphysgun", "0")
			RunConsoleCommand("precision_entirecontrap", "0")
		elseif mode == 2 then
			RunConsoleCommand("precision_rotation", "15")
			RunConsoleCommand("precision_freeze", "1")
			RunConsoleCommand("precision_entirecontrap", "0")
		elseif mode == 3 then
			RunConsoleCommand("precision_rotate", "1")
			RunConsoleCommand("precision_offset", "0")
			RunConsoleCommand("precision_offsetpercent", "1")
			RunConsoleCommand("precision_rotation", "15")
			RunConsoleCommand("precision_freeze", "1")
			RunConsoleCommand("precision_nocollide", "1")
			RunConsoleCommand("precision_autorotate", "1")
			RunConsoleCommand("precision_entirecontrap", "0")
		end
		precision_updatecpanel()
	end
	concommand.Add( "precision_defaultrestore", precision_defaults )

	local function precision_genmenu()
		if ( showgenmenu == 1 ) then
			showgenmenu = 0
		else
			showgenmenu = 1
		end
		precision_updatecpanel()
	end
	concommand.Add( "precision_generalmenu", precision_genmenu )
	

	function precision_setmode( player, tool, args )
		if LocalPlayer():GetInfoNum( "precision_mode", 3 ) != args[1] then
			RunConsoleCommand("precision_mode", args[1])
			timer.Simple(0.05, function() precision_updatecpanel() end ) 
		end
	end
	concommand.Add( "precision_setmode", precision_setmode )


	function precision_setuser( player, tool, args )
		if LocalPlayer():GetInfoNum( "precision_user", 3 ) != args[1] then
			RunConsoleCommand("precision_user", args[1])
			timer.Simple(0.05, function() precision_updatecpanel() end ) 
		end
	end
	concommand.Add( "precision_setuser", precision_setuser )


	function precision_updatecpanel()
		local Panel = controlpanel.Get( "precision" )
		if (!Panel) then return end
		//custom panel building ( wtf does Panel:AddDefaultControls() get it's defaults from? )
		AddDefControls( Panel )
	end
	concommand.Add( "precision_updatecpanel", precision_updatecpanel )

	function TOOL.BuildCPanel( Panel )
		AddDefControls( Panel )
	end

	local function precision_removalall()
		RunConsoleCommand("precision_removal_nocollide", "1")
		RunConsoleCommand("precision_removal_weld", "1")
		RunConsoleCommand("precision_removal_axis", "1")
		RunConsoleCommand("precision_removal_ballsocket", "1")
		RunConsoleCommand("precision_removal_advballsocket", "1")
		RunConsoleCommand("precision_removal_slider", "1")
		RunConsoleCommand("precision_removal_parent", "1")
		RunConsoleCommand("precision_removal_other", "1")
		precision_updatecpanel()
	end
	concommand.Add( "precision_removal_all", precision_removalall )
	local function precision_removalnone()
		RunConsoleCommand("precision_removal_nocollide", "0")
		RunConsoleCommand("precision_removal_weld", "0")
		RunConsoleCommand("precision_removal_axis", "0")
		RunConsoleCommand("precision_removal_ballsocket", "0")
		RunConsoleCommand("precision_removal_advballsocket", "0")
		RunConsoleCommand("precision_removal_slider", "0")
		RunConsoleCommand("precision_removal_parent", "0")
		RunConsoleCommand("precision_removal_other", "0")
		precision_updatecpanel()
	end
	concommand.Add( "precision_removal_none", precision_removalnone )

	function TOOL:FreezeMovement()
		local stage = self:GetStage()
		if ( stage == 2 ) then
			return true
		//elseif ( iNum > 0 && self:GetClientNumber("mode") == 2 ) then
		//	return true
		end
		return false
	end
end

function TOOL:Holster()
	self:ClearObjects()
	self:SetStage(0)
	self:ClearSelection()
end