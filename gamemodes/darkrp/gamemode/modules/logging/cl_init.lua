--[[---------------------------------------------------------------------------
Log a message to console
---------------------------------------------------------------------------]]
local function AdminLog( color, str )
    local colour = color
    local text = DarkRP.deLocalise(str .. "\n")

    MsgC(Color(255, 0, 0), "[" .. GAMEMODE.Name .. "] ", colour, text)

    hook.Call("DarkRPLogPrinted", nil, text, colour)
end


net.Receive( 'DarkRP_DRPLogMsg', function()

    local color = net.ReadColor()

    local str = net.ReadString()

    AdminLog( color, str )

end )

--[[---------------------------------------------------------------------------
Interface
---------------------------------------------------------------------------]]
DarkRP.hookStub{
    name = "DarkRPLogPrinted",
    description = "Called when a log has printed in console.",
    realm = "Client",
    parameters = {
        {
            name = "text",
            description = "The actual log.",
            type = "string"
        },
        {
            name = "colour",
            description = "The colour of the printed log.",
            type = "Color"
        }
    },
    returns = {}
}
