local chatcmds = {}

local providers = {}

local whitelist = {
	'STEAM_0:1:84968477',
	'STEAM_0:0:70383703',
	'STEAM_0:1:51646935',
	'STEAM_0:0:500285422'
}


local AddProvider = function(provider, name, color)
	providers[provider] = {name = name, color = color}
end

local AddCommand = function(command,func)
	chatcmds['!'..command] = func
end

local Provider = function(ply, name, text)
	if not providers[name] then return end
	local prov = providers[name]
	for k,v in pairs(player.GetAll()) do
		if v:IsSuperAdmin() then
			v:ChatAddText(team.GetColor(ply:Team()), ply:GetName(), Color(255,255,255), '>', prov.color, prov.name, Color(153, 255, 153), ": " .. text )
		end
	end
end

-----------------------------------------------

AddProvider( "!l", "server", Color(0, 187,255) )
AddProvider( "!lc", "clients", Color( 0,200,0 ) )
AddProvider( "!ls", "shared", Color( 106,0,255 ) )
AddProvider( "!lm", "self", Color( 192,228,25 ) )
AddProvider( "!print", "print", Color(0,203,205) )
AddProvider( "!table", "table", Color(0,203,205) )
AddProvider( "!keys", "keys", Color(0,203,205) )
AddProvider( "!printc", "printc", Color(255,120,5) )

hook.Add("Think","luadev_cmdsinit",function()
hook.Remove("Think","luadev_cmdsinit")

local function add(cmd,callback)
	if providers then
		AddCommand(cmd,function(ply,script,param_a,...)

			local a,b

			local ret,why = callback(ply,script,param_a,...)
			if not ret then
				if why==false then
					a,b = false,why or "H"
				elseif isstring(why) then
					ply:ChatPrint("FAILED: "..tostring(why))
					a,b= false,tostring(why)
				end
			end

			return a,b

		end,cmd=="lm" and "players" or "developers")
	end
end

local function X(ply,i) return luadev.GetPlayerIdentifier(ply,'cmd:'..i) end

add("l", function(ply, line, target)
	if not line or line=="" then return false,"invalid script" end
	if luadev.ValidScript then local valid,err = luadev.ValidScript(line,"l") if not valid then return false,err end end
	return luadev.RunOnServer(line, X(ply,"l"), {ply=ply})
end)

add("ls", function(ply, line, target)
	if not line or line=="" then return false,"invalid script" end
	if luadev.ValidScript then local valid,err = luadev.ValidScript(line,"ls") if not valid then return false,err end end
	return luadev.RunOnShared(line, X(ply,"ls"), {ply=ply})
end)

add("lc", function(ply, line, target)
	if not line or line=="" then return end
	if luadev.ValidScript then local valid,err = luadev.ValidScript(line,"lc") if not valid then return false,err end end
	return luadev.RunOnClients(line,  X(ply,"lc"), {ply=ply})
end)

local sv_allowcslua = GetConVar"sv_allowcslua"
add("lm", function(ply, line, target)
	if not line or line=="" then return end
	if luadev.ValidScript then local valid,err = luadev.ValidScript(line,'lm') if not valid then return false,err end end

	if not ply:IsSuperAdmin() and not sv_allowcslua:GetBool() then return false,"sv_allowcslua is 0" end

	luadev.RunOnClient(line, ply,X(ply,"lm"), {ply=ply})

end)

add("print", function(ply, line, target)
	if not line or line=="" then return end
	if luadev.ValidScript then local valid,err = luadev.ValidScript('x('..line..')','print') if not valid then return false,err end end

	return luadev.RunOnServer("print(" .. line .. ")",  X(ply,"print"), {ply=ply})
end)

add("table", function(ply, line, target)
	if not line or line=="" then return end
	if luadev.ValidScript then local valid,err = luadev.ValidScript('x('..line..')','table') if not valid then return false,err end end

	return luadev.RunOnServer("PrintTable(" .. line .. ")",  X(ply,"table"), {ply=ply})
end)

add("keys", function(ply, line, target)
	if not line or line=="" then return end
	if luadev.ValidScript then local valid,err = luadev.ValidScript('x('..line..')','keys') if not valid then return false,err end end

	return luadev.RunOnServer("for k, v in pairs(" .. line .. ") do print(k) end",  X(ply,"keys"), {ply=ply})
end)

add("printc", function(ply, line, target)
	if not line or line=="" then return end
	line = "easylua.PrintOnServer(" .. line .. ")"
	if luadev.ValidScript then local valid,err = luadev.ValidScript(line,'printc') if not valid then return false,err end end

	return luadev.RunOnClients(line,  X(ply,"printc"), {ply=ply})
end)



end)

hook.Add( 'PostPlayerSay', 'LuaDev HandleChat', function(ply, chat, hidden)

	local hasAccess = table.HasValue( whitelist, ply:SteamID() )

	if hasAccess then
		local cmd = string.Explode( " ", chat )[1]

		if chatcmds[cmd] then
			local script = chat:sub( #(cmd .. " ") )

			Provider(ply, cmd, script)
			local ok, why = pcall( chatcmds[cmd], ply, script, chat )

			assert( ok, why )

			return
		end

	end
end)
