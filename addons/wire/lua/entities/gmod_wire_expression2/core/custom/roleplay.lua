E2Lib.RegisterExtension("roleplay", false, "Custom gprp extensions")


e2function normal entity:gprpIsWanted()
	if not IsValid(this) then return 0 end
	if this:getDarkRPVar('wanted') == true then
		return 1
	else
		return 0
	end
end


e2function void entity:gprpUnWanted()
	if not IsValid(this) then return 0 end
	self.player:ConCommand('darkrp unwanted '..this:UserID())
end

e2function string entity:gprpGetWantedReason()
	if not IsValid(this) then return 0 end
	return this:getDarkRPVar( 'wantedReason' ) or 'nil'
end
e2function void entity:gprpWanted( string reason )
	if not IsValid(this) then return 0 end
	self.player:ConCommand('darkrp wanted '..this:UserID()..' "'..reason..'"')
end
e2function void gprpLottery( amount )
	self.player:ConCommand('darkrp lottery '..amount)
end