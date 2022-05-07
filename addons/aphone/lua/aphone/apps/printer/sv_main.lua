util.AddNetworkString("APhone_Printer_Ping")

/*
PlayerID : 
    time : Last refresh
    pos : All the pos where there a printer
*/
local tbl = {}

net.Receive("APhone_Printer_Ping", function(_, ply)
    if !aphone.NetCD(ply, "PrinterPing", 3) then return end

    local posEnt = {}

    for k, v in ipairs(aphone.Printer.GetPrinters(ply)) do
        table.insert(posEnt, v:GetPos())
    end

    if table.IsEmpty(posEnt) then return end

    tbl[ply:UserID()] = {
        // wait a bit, don't put +5
        time = CurTime() + 8,
        pos = posEnt,
    }
end)

hook.Add("SetupPlayerVisibility", "AddRTCamera", function(ply, pViewEntity)
	-- Adds any view entity
    local t = tbl[ply:UserID()]
    if t then
        if t.time < CurTime() then
            tbl[ply:UserID()] = nil
        else
            for k, v in ipairs(t.pos) do
                AddOriginToPVS(v)
            end
        end
    end
end)