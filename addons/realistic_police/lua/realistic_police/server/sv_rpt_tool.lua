--[[
 _____            _ _     _   _        _____      _ _             _____           _                 
|  __ \          | (_)   | | (_)      |  __ \    | (_)           / ____|         | |                
| |__) |___  __ _| |_ ___| |_ _  ___  | |__) |__ | |_  ___ ___  | (___  _   _ ___| |_ ___ _ __ ___  
|  _  // _ \/ _` | | / __| __| |/ __| |  ___/ _ \| | |/ __/ _ \  \___ \| | | / __| __/ _ \ '_ ` _ \ 
| | \ \  __/ (_| | | \__ \ |_| | (__  | |  | (_) | | | (_|  __/  ____) | |_| \__ \ ||  __/ | | | | |
|_|  \_\___|\__,_|_|_|___/\__|_|\___| |_|   \___/|_|_|\___\___| |_____/ \__, |___/\__\___|_| |_| |_|
                                                                                                                                         
--]]
Realistic_Police = Realistic_Police or {}

-- Save Computer / Camera and police Screen on the map 
function Realistic_Police.SaveEntity()
    timer.Simple(1, function()
        file.Delete("realistic_police/" .. game.GetMap() .. "_rpt_entities" .. ".txt")
        local data = {} 
        for u, ent in pairs(ents.FindByClass("realistic_police_camera")) do
            table.insert(data, {
                Class = ent:GetClass(),          
                Pos = ent:GetPos(),    
                CName = ent:GetNWString("rpt_name_camera"),
                GetAngle = ent:GetAngles()  
            })
            file.Write("realistic_police/" .. game.GetMap() .. "_rpt_entities" .. ".txt", util.TableToJSON(data))    
        end
        for u, ent in pairs(ents.FindByClass("realistic_police_computer")) do
            table.insert(data, {
                Class = ent:GetClass(),          
                Pos = ent:GetPos(),      
                GetAngle = ent:GetAngles()  
            })
            file.Write("realistic_police/" .. game.GetMap() .. "_rpt_entities" .. ".txt", util.TableToJSON(data))    
        end
        for u, ent in pairs(ents.FindByClass("realistic_police_policescreen")) do
            table.insert(data, {
                Class = ent:GetClass(),          
                Pos = ent:GetPos(),      
                GetAngle = ent:GetAngles()  
            })
            file.Write("realistic_police/" .. game.GetMap() .. "_rpt_entities" .. ".txt", util.TableToJSON(data))    
        end
    end) 
end 

function Realistic_Police.Load(String)
    local directory = "realistic_police/" .. game.GetMap() .. String .. ".txt" 
    if file.Exists(directory, "DATA") then  
        local data = file.Read(directory, "DATA")
        data = util.JSONToTable(data)   
        for k, v in pairs(data) do
            local rpt_entity = ents.Create(v.Class)
            rpt_entity:SetPos(v.Pos)  
            rpt_entity:SetAngles(v.GetAngle) 
            rpt_entity:Spawn()  
            rpt_entity.RPTCam = true   
            rpt_entity.HealthEntity = Realistic_Police.CameraHealth
            if isstring(v.CName) then 
                rpt_entity:SetNWString("rpt_name_camera", v.CName)
            end 
            rpt_entity.DestroyCam = false  
            rpt_entity.RotateBack = false 
            if v.Class == "realistic_police_camera" then 
                rpt_entity:SetRptRotate("nil") 
            end 
            local rpt_entityload = rpt_entity:GetPhysicsObject()
            if (rpt_entityload:IsValid()) then  
                rpt_entityload:Wake()   
                rpt_entityload:EnableMotion(false)              
            end
        end
    end
end

concommand.Add("rpt_save", function(ply, cmd, args)
    if Realistic_Police.AdminRank[ply:GetUserGroup()] then
        Realistic_Police.SaveEntity()  
    end  
end)

concommand.Add("rpt_cleaupentities", function(ply, cmd, args) 
    if Realistic_Police.AdminRank[ply:GetUserGroup()] then
        for u, ent in pairs(ents.FindByClass("realistic_police_camera")) do
            ent:Remove() 
        end
    end 
end )

concommand.Add("rpt_removedata", function(ply, cmd, args)
    if Realistic_Police.AdminRank[ply:GetUserGroup()] then
        if file.Exists("realistic_police/" .. game.GetMap() .. "_rpt_entities" .. ".txt", "DATA") then 
            file.Delete( "realistic_police/" .. game.GetMap() .. "_rpt_entities" .. ".txt" )
            concommand.Run(ply,"rpt_cleaupentities")
        end  
    end  
end)

concommand.Add("rpt_reloadentities", function(ply, cmd, args) 
    if Realistic_Police.AdminRank[ply:GetUserGroup()] then
        concommand.Run(ply, "rpt_cleaupentities")
        Realistic_Police.Load("_rpt_entities")
    end 
end )
-------------------------------------------------------------------------------------------------------------------------

function Realistic_Police.SaveJailEntity()
    timer.Simple(1, function()
        if #ents.FindByClass("realistic_police_jailer") >= 1 && #ents.FindByClass("realistic_police_bailer") >= 1  then 
            file.Delete("realistic_police/" .. game.GetMap() .. "_rpt_entities" .. ".txt")
        end 
        local data = {}
        for u, ent in pairs(ents.FindByClass("realistic_police_bailer")) do
            table.insert(data, {
                Class = ent:GetClass(),          
                Pos = ent:GetPos(),      
                GetAngle = ent:GetAngles()  
            })
            file.Write("realistic_police/" .. game.GetMap() .. "_rpt_jailents" .. ".txt", util.TableToJSON(data))    
        end
        for u, ent in pairs(ents.FindByClass("realistic_police_jailer")) do
            table.insert(data, {
                Class = ent:GetClass(),          
                Pos = ent:GetPos(),      
                GetAngle = ent:GetAngles()  
            })
            file.Write("realistic_police/" .. game.GetMap() .. "_rpt_jailents" .. ".txt", util.TableToJSON(data))    
        end
        if #ents.FindByClass("realistic_police_jailpos") >= 1 then 
            file.Delete("realistic_police/" .. game.GetMap() .. "_rpt_jailpos" .. ".txt")
        end 
        local data = {} 
        for u, ent in pairs(ents.FindByClass("realistic_police_jailpos")) do
            table.insert(data, {         
                Pos = ent:GetPos(),      
            })
            file.Write("realistic_police/" .. game.GetMap() .. "_rpt_jailpos" .. ".txt", util.TableToJSON(data))  
            ent:Remove()  
        end
    end) 
end 

concommand.Add("rpt_savejailpos", function(ply, cmd, args)
    if Realistic_Police.AdminRank[ply:GetUserGroup()] then
        Realistic_Police.SaveJailEntity()
    end  
end)

concommand.Add("rpt_reloadjailent", function(ply, cmd, args)
    if Realistic_Police.AdminRank[ply:GetUserGroup()] then
        concommand.Run(ply, "rpt_removejail")
        Realistic_Police.Load("_rpt_jailents") 
    end 
end ) 

concommand.Add("rpt_removedatajail", function(ply, cmd, args)
    if Realistic_Police.AdminRank[ply:GetUserGroup()] then
        concommand.Run(ply, "rpt_removejail")
        if file.Exists("realistic_police/" .. game.GetMap() .. "_rpt_jailents" .. ".txt", "DATA") then 
            file.Delete( "realistic_police/" .. game.GetMap() .. "_rpt_jailents" .. ".txt" )
        end  
        if file.Exists("realistic_police/" .. game.GetMap() .. "_rpt_jailpos" .. ".txt", "DATA") then 
            file.Delete( "realistic_police/" .. game.GetMap() .. "_rpt_jailpos" .. ".txt" )
        end  
    end  
end ) 

concommand.Add("rpt_removejail", function(ply, cmd, args)
    if Realistic_Police.AdminRank[ply:GetUserGroup()] then
        for u, ent in pairs(ents.FindByClass("realistic_police_jailer")) do
            ent:Remove() 
        end
        for u, ent in pairs(ents.FindByClass("realistic_police_bailer")) do
            ent:Remove() 
        end
    end  
end ) 

-------------------------------------------------------------------------------------------------------------------------

hook.Add("InitPostEntity", "realistic_policeInit", function()
    Realistic_Police.Load("_rpt_entities")
    Realistic_Police.Load("_rpt_jailents") 
end)

hook.Add("PostCleanupMap", "realistic_policeLoad", function() 
    Realistic_Police.Load("_rpt_entities")
    Realistic_Police.Load("_rpt_jailents") 
end )