surface.CreateFont( "SG.Sidebar", { font = "Roboto", size = ScreenScale( 5 ), weight = 500 } )

local PANEL = {}

function PANEL:Init()
    self.Container = vgui.Create( "Panel", self )

    self.curTab = "Users"
    self.ease = FrameTime() * 10

    self.tabs = {}
end

function PANEL:AddTab( title, panel )
    local newTab = vgui.Create( "SG_Sidebar_Button", self.Container )
    newTab:Dock( TOP )
    newTab:DockMargin( 0, 0, 0, 5 )
    newTab:SetTall( 64 )
    newTab:SetWidth( self.Container:GetWide() )
    newTab:SetText( title )
    newTab:SetPanel( panel )
    newTab.DoClick = function( s, w, h )
        for _, tab in ipairs( self.tabs ) do
            tab:SetActive( false )
            tab.panel:Hide()
        end

        s:SetSelected( true )
        s:SetActive( true )
        s.panel:Show()
    end

    if self.curTab == title then
        newTab:SetSelected( true )
        newTab:SetActive( true )
    end

    table.insert( self.tabs, newTab )
end

function PANEL:PerformLayout( w, h )
    self.Container:Dock( FILL )
end

function PANEL:Paint()
end

vgui.Register( "SG_Sidebar", PANEL )
