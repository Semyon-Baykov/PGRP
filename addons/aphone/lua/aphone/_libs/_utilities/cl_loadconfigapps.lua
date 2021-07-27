hook.Add("aphone_PostLoad", "APhone_LoadConfigLinks", function()
    for k, v in pairs(aphone.Links) do
        local APP = v
        APP.Complete_Detour = true

        function APP:Open()
            gui.OpenURL(self.link)
        end

        aphone.RegisterApp(APP)
    end
end)