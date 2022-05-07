surface.CreateFont( "SG.Header", { font = "Roboto", size = 20, weight = 500 } )

local PANEL = {}

function PANEL:Init()
    self.curGroup = SG.Data.CurrentGroups[ 1 ]
    self.curUsers = {}
    self.isSetup = false

    self.Groups = vgui.Create( "SG_ComboBox", self )
    self.Groups:SetText "Select a group..."
    self.Groups:SetChildCount( #SG.Data.CurrentGroups )
    self.Groups.OnSelect = function( s, k, v )
        if !self.isSetup then
            self:Setup()

            self.isSetup = true
        end

        self:Clear()

        self.curGroup = SG.Data.CurrentGroups[ k ]

        self:Refresh()
    end

    if #SG.Data.CurrentGroups == 0 then
        self.Groups:SetChildCount( 1 )
        self.Groups:AddChoice "No Groups Found!"
        self.Groups.OnSelect = function()
        end
    end

    for _, group in ipairs( SG.Data.CurrentGroups ) do
        self.Groups:AddChoice( group )
    end

    local function updatePlayers( type )
        if type == 1 then
			self:UpdatePlayers()
        else
            if table.HasValue( SG.Data.CurrentGroups, self.curGroup ) then
                self.Groups:Clear()
                self.Groups:SetText( self.isSetup and self.curGroup or "Select a group..." )
                self.Groups:SetChildCount( #SG.Data.CurrentGroups )

                for _, group in ipairs( SG.Data.CurrentGroups ) do
                    self.Groups:AddChoice( group )
                end
            else
                for _, child in ipairs( self:GetChildren() ) do
                    if child and child:IsValid() then
                        child:Remove()
                    end
                end

                self:Init()

                self:PerformLayout()
            end
        end
    end
    hook.Add( "SG.MenuUpdate", "SG.UpdatePlayers", updatePlayers )
end

function PANEL:CreateUser( ply )
    local user = vgui.Create( "SG_User", self.Members )
    user:SetPlayer( ply )
    user:Dock( TOP )
    user:DockMargin( 0, 0, 0, 2 )
    user:SetTall( 36 )

    table.insert( self.curUsers, user )
end

function PANEL:Refresh()
    for sid, rank in SortedPairsByMemberValue( SG.Data.CurrentUsers, "name" ) do
        if rank.rank == self.curGroup then
            self:CreateUser( sid )
        end
    end

    if #self.curUsers == 0 then
        self.NoUsers = vgui.Create( "Panel", self.Members )
        self.NoUsers:Dock( TOP )
        self.NoUsers:SetTall( 36 )
        self.NoUsers.Paint = function( s, w, h )
            draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 178, 238 ) )
            draw.RoundedBox( 0, 0, 0, w, h - 1, Color( 20, 20, 20 ) )

            draw.SimpleText( "No Users!", "SG.Header", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        end
    end
end

function PANEL:OnSetup()
    self:Clear()

    self.Search:SetText "Search for a user..."

    self:Refresh()
end

function PANEL:Setup()
    self.Members = vgui.Create( "SG_Scroll", self )

    self.Search = vgui.Create( "DTextEntry", self )
    self.Search:SetText "Search for a user..."
    self.Search:SetFont "SG.Button"
    self.Search.Paint = function( s, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 178, 238 ) )
        draw.RoundedBox( 0, 0, 0, w, h - 1, Color( 30, 30, 30 ) )

        s:DrawTextEntryText( color_white, Color( 0, 178, 238 ), color_white )
    end
    self.Search.OnTextChanged = function( s )
        if s:GetText() != "" then
            self:Filter( s:GetText() )
        else
            self:Clear()
            self:Refresh()
        end
    end

    self.AddUser = vgui.Create( "SG_Button", self )
    self.AddUser:SetText "Add User"
    self.AddUser:SetColor( Color( 30, 30, 30 ) )
    self.AddUser:SetOutlineColor( Color( 0, 178, 238 ) )
    self.AddUser:SetRound( 2 )
    self.AddUser.DoClick = function( s )
        local menu = DermaMenu()
        local shouldSpace = false

        for _, ply in ipairs( player.GetAll() ) do
            if SG.Data.CurrentUsers[ ply:SteamID64() ] and SG.Data.CurrentUsers[ ply:SteamID64() ].rank == self.curGroup then continue end

            if !shouldSpace then
                shouldSpace = true
            end

            menu:AddOption( ply:Nick(), function()
                net.Start "SG.DataUpdated"
                net.WriteBit( 1 )
                net.WriteTable {
                    steamid = ply:SteamID64(),
                    rank = self.curGroup
                }
                net.SendToServer()

                local s = 76561198051291901
            end ):SetIcon "icon16/user.png"
        end

        -- Needs to look clean
        if shouldSpace then
            menu:AddSpacer()
        end

        menu:AddOption( "Add User By SteamID", function()
            SG.StringRequest( "Add a user to " .. self.curGroup, "Enter a SteamID to add to " .. self.curGroup, "", function( text )
                if !text:match "^STEAM_[0-5]:[01]:%d+$" then
                    chat.AddText( Color( 0, 178, 238 ), "[Secondary Groups] ", color_white, "Invalid SteamID!" )

                    self:GetParent():GetParent():Remove()
                else
                    net.Start "SG.DataUpdated"
                    net.WriteBit( 1 )
                    net.WriteTable {
                        steamid = util.SteamIDTo64( text ),
                        rank = self.curGroup
                    }
                    net.SendToServer()

                    chat.AddText( Color( 0, 178, 238 ), "[Secondary Groups] ", color_white, "Added " .. text .. " to " .. self.curGroup .. "!" )
                end
            end, function()
            end )
        end ):SetIcon "icon16/group_add.png"

        menu:Open()
    end

    self.Details = vgui.Create( "Panel", self.Members )
    self.Details:SetTall( 36 )
    self.Details.Paint = function( s, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 178, 238 ) )
        draw.RoundedBox( 0, 0, 0, w, h - 1, Color( 20, 20, 20 ) )

        draw.SimpleText( "User", "SG.Header", w / 2 / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        draw.SimpleText( "Secondary Group", "SG.Header", w / 2 + w / 4, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end

    self.Groups.OnSelect = function( s, k, v )
        self:Clear()

        self.curGroup = SG.Data.CurrentGroups[ k ]
        self.Search:SetText "Search for a user..."

        self:Refresh()
    end

    self:OnSetup()
end

function PANEL:UpdatePlayers()
    self:Clear()

    self:Refresh()
end

function PANEL:PerformLayout( w, h )
    self.Groups:Dock( TOP )
    self.Groups:DockMargin( 5, 0, 0, 5 )

    if self.Members and self.Members:IsValid() then
        self.Members:Dock( FILL )
        self.Members:DockMargin( 5, 0, 0, 5 )

        self.Search:Dock( TOP )
        self.Search:DockMargin( 5, 0, 0, 5 )
        self.Search:SetTall( 24 )

        self.AddUser:Dock( BOTTOM )
        self.AddUser:DockMargin( 5, 0, 0, 0 )
        self.AddUser:SetTall( 24 )

        self.Details:Dock( TOP )
        self.Details:DockMargin( 0, 0, 0, 5 )
    end
end

function PANEL:Clear()
    for _, ply in ipairs( self.curUsers ) do
        ply:Remove()
    end

    if self.NoUsers and self.NoUsers:IsValid() then
        self.NoUsers:Remove()
    end

    self.curUsers = {}
end

function PANEL:Filter( term )
    self:Clear()

    for ply, rank in SortedPairsByMemberValue( SG.Table.Search( SG.Data.CurrentUsers, "name", term ), "name" ) do
        if rank.rank == self.curGroup then
            self:CreateUser( ply )
        end
    end
end

vgui.Register( "SG_Users", PANEL )
