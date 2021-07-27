surface.CreateFont( "SG.User", { font = "Roboto", size = 18, weight = 500 } )

local PANEL = {}

function PANEL:Init()
    self.user = ""

    self.Avatar = vgui.Create( "SG_Avatar", self )

    self.Name = vgui.Create( "DLabel", self )
    self.Name:SetFont "SG.User"
    self.Name:SetText "Loading..."

    self.Rank = vgui.Create( "DLabel", self )
    self.Rank:SetFont "SG.User"
end

function PANEL:SetPlayer( steamid )
    self.Name:SetText( SG.Data.CurrentUsers[ steamid ].name )
    self.Name:SizeToContents()

    self.Rank:SetText( SG.Data.CurrentUsers[ steamid ].rank )

    self.Avatar:SetPlayer( steamid )

    self.user = steamid
end

function PANEL:PerformLayout( w, h )
    self.Avatar:Dock( LEFT )
    self.Avatar:DockMargin( 5, 0, 0, 0 )
    self.Avatar:SetSize( 32, 32 )

    self.Name:SizeToContents()
    self.Name:Dock( LEFT )
    self.Name:DockMargin( 5, 0, 0, 0 )

    self.Rank:SizeToContents()
    self.Rank:Dock( RIGHT )
    self.Rank:DockMargin( 0, 0, 6, 0 )
end

function PANEL:Paint( w, h )
    draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 178, 238 ) )
    draw.RoundedBox( 0, 0, 0, w, h - 1, Color( 20, 20, 20 ) )
end

function PANEL:OnMousePressed( click )
    if click == MOUSE_RIGHT then
        local menu = DermaMenu()

        if #SG.Data.CurrentGroups >= 2 then
            local subMenu, subMenuBase = menu:AddSubMenu( "Change Secondary User Group" )
            subMenuBase:SetIcon "icon16/group_add.png"

            for _, group in ipairs( SG.Data.CurrentGroups ) do
                if group == self.Rank:GetText() then continue end

                subMenu:AddOption( group, function()
                    net.Start "SG.DataUpdated"
                    net.WriteBit( 1 )
                    net.WriteTable {
                        steamid = self.user,
                        rank = group
                    }
                    net.SendToServer()
                end )
            end
        end

        menu:AddOption( "Remove Secondary User Group", function()
            net.Start "SG.DataRemoved"
            net.WriteBit( 1 )
            net.WriteString( self.user )
            net.SendToServer()

            chat.AddText( Color( 0, 178, 238 ), "[Secondary Groups] ", color_white, "Removed " .. util.SteamIDFrom64( self.user ) .. " from " .. self.Rank:GetText() .. "!" )
        end ):SetIcon "icon16/group_delete.png"

        menu:AddSpacer()

        menu:AddOption( "View Profile", function()
            gui.OpenURL( "http://steamcommunity.com/profiles/" .. self.user )
        end ):SetIcon "icon16/user.png"

        menu:Open()
    end
end

vgui.Register( "SG_User", PANEL )
