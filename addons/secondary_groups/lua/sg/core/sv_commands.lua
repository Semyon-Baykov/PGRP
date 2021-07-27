function SG.PlayerSay( ply, text )
    if text:lower():match( "[!/:.]" .. SG.cfg.Command ) then
        SG.OpenMenu( ply )

        return ""
    end
end
hook.Add( "PlayerSay", "SG.PlayerSay", SG.PlayerSay )

function SG.ConCommand( ply )
    SG.OpenMenu( ply )
end
concommand.Add( SG.cfg.ConCommand, SG.ConCommand )

function SG.AddUser( ply, _, args )
    local sid = tostring( args[ 1 ] )
    local rank = tostring( args[ 2 ] )

    if sid == "nil" or rank == "nil" then
        return SG.Print "Invalid arguments!"
    end

    local function doAdd()
        if sid:match "^STEAM_[0-5]:[01]:%d+$" then
            if table.HasValue( SG.Save.CurrentGroups, rank ) then
                SG.Update( 1, {
                    name = util.SteamIDTo64( sid ),
                    steamid = util.SteamIDTo64( sid ),
                    rank = rank
                } )

                SG.Print( "Successfully added # to #!", sid, rank )
            else
                return SG.Print "Invalid Group!"
            end
        else
            return SG.Print "Invalid SteamID!"
        end
    end

    if ply:IsValid() then
        if SG.CanOpen( ply ) then
            return doAdd()
        end
    else
        return doAdd()
    end
end
concommand.Add( "sg_adduser", SG.AddUser )

function SG.RemoveUser( ply, _, args )
    local sid = tostring( args[ 1 ] )

    if sid == "nil"  then
        return SG.Print "Invalid argument!"
    end

    local function doRemove()
        if sid:match "^STEAM_[0-5]:[01]:%d+$" then
            SG.Delete( 1, util.SteamIDTo64( sid ) )

            SG.Print( "Successfully removed #!", sid )
        else
            return SG.Print "Invalid SteamID!"
        end
    end

    if ply:IsValid() then
        if SG.CanOpen( ply ) then
            return doRemove()
        end
    else
        return doRemove()
    end
end
concommand.Add( "sg_removeuser", SG.RemoveUser )

function SG.CreateGroup( ply, _, args )
    local rank = tostring( args[ 1 ] )

    if rank == "nil" then
        return SG.Print "Invalid argument!"
    end

    local function doCreate()
        if table.HasValue( SG.Save.CurrentGroups, rank ) then
            return SG.Print "Already a group!"
        else
            SG.Update( 0, rank )

            SG.Print( "Successfully created #!", rank )
        end
    end

    if ply:IsValid() then
        if SG.CanOpen( ply ) then
            return doCreate()
        end
    else
        return doCreate()
    end
end
concommand.Add( "sg_creategroup", SG.CreateGroup )

function SG.DeleteGroup( ply, _, args )
    local rank = tostring( args[ 1 ] )

    if rank == "nil" then
        return SG.Print "Invalid argument!"
    end

    local function doDelete()
        if !table.HasValue( SG.Save.CurrentGroups, rank ) then
            return SG.Print "Invalid group!"
        else
            SG.Delete( 0, rank )

            SG.Print( "Successfully deleted #!", rank )
        end
    end

    if ply:IsValid() then
        if SG.CanOpen( ply ) then
            return doDelete()
        end
    else
        return doDelete()
    end
end
concommand.Add( "sg_deletegroup", SG.DeleteGroup )
