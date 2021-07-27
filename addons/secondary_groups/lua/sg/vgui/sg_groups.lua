local PANEL = {}

function PANEL:Init()
    self.curGroup = SG.Data.CurrentGroups[ 1 ] or ""

    self.Groups = vgui.Create( "SG_ComboBox", self )
    self.Groups:SetText "Select a group..."
    self.Groups:SetChildCount( #SG.Data.CurrentGroups )
    self.Groups.OnSelect = function( s, k, v )
        self.curGroup = SG.Data.CurrentGroups[ k ]

        if !self.Delete then
            self:Setup()
        end
    end

    for _, group in ipairs( SG.Data.CurrentGroups ) do
        self.Groups:AddChoice( group )
    end

    if #SG.Data.CurrentGroups == 0 then
        self.Groups:SetChildCount( 1 )
        self.Groups:AddChoice "No Groups Found!"
        self.Groups.OnSelect = function()
        end
    end

    self.CreateGroup = vgui.Create( "SG_Button", self )
    self.CreateGroup:SetText "Create Group"
    self.CreateGroup:SetColor( Color( 30, 30, 30 ) )
    self.CreateGroup:SetOutlineColor( Color( 0, 178, 238 ) )
    self.CreateGroup:SetRound( 2 )
    self.CreateGroup.DoClick = function( s, w, h )
        SG.StringRequest( "Create a new group", "Please enter the group name.", "", function( text )
            if !self.curGroup:lower():match( text:lower() ) then
                net.Start "SG.DataUpdated"
                net.WriteBit( 0 )
                net.WriteString( tostring( text ) )
                net.SendToServer()

                table.insert( SG.Data.CurrentGroups, tostring( text ) )

                self:Update()
            end
        end, function()
        end )
    end

    local function updateRanks( type )
        if type == 0 then
            self.Groups.OnSelect = function( s, k, v )
                self.curGroup = SG.Data.CurrentGroups[ k ]

                if !self.Delete then
                    self:Setup()
                end
            end
        end
    end
    hook.Add( "SG.MenuUpdate", "SG.UpdateRanks", updateRanks )
end

function PANEL:Update()
    if self.Delete and self.Delete:IsValid() then
        self.Delete:Remove()
        self.Delete = nil
    end

    self.Groups:Clear()
    self.Groups:SetText "Select a group..."
    self.Groups:SetChildCount( #SG.Data.CurrentGroups )

    for _, group in ipairs( SG.Data.CurrentGroups ) do
        self.Groups:AddChoice( group )
    end
end

function PANEL:Setup()
    self.Delete = vgui.Create( "SG_Button", self )
    self.Delete:SetText "Delete Group"
    self.Delete:SetColor( Color( 30, 30, 30 ) )
    self.Delete:SetOutlineColor( Color( 255, 120, 120, 150 ) )
    self.Delete.DoClick = function( s )
        SG.StringRequest( "Deleting " .. self.curGroup, "Please enter '" .. self.curGroup ..  "' to delete the group.", "", function( text )
            if !text:lower():match( self.curGroup:lower() ) then
                chat.AddText( Color( 0, 178, 238 ), "[Secondary Groups] ", color_white, "Wrong group name!" )

                self:GetParent():GetParent():Remove()
            else
                net.Start "SG.DataRemoved"
                net.WriteBit( 0 )
                net.WriteString( self.curGroup )
                net.SendToServer()

                table.RemoveByValue( SG.Data.CurrentGroups, self.curGroup )

                self:Update()
            end
        end, function()
        end )
    end
end

function PANEL:PerformLayout( w, h )
    self.Groups:Dock( TOP )
    self.Groups:DockMargin( 5, 0, 0, 5 )

    self.CreateGroup:Dock( BOTTOM )
    self.CreateGroup:DockMargin( 5, 0, 0, 0 )
    self.CreateGroup:SetTall( 24 )

    if self.Delete and self.Delete:IsValid() then
        self.Delete:Dock( TOP )
        self.Delete:DockMargin( 5, 0, 0, 0 )
        self.Delete:SetTall( 24 * 1.5 )
    end
end

vgui.Register( "SG_Groups", PANEL )
