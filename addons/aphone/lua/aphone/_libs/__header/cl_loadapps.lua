function aphone.RegisterApp(app)
    if !app or !app.name or !app.icon then
        print("[APhone] Tried to register a app with missing params")
        return
    end

    if type(app.icon) != "Material" then
        app.icon = Material(app.icon, "smooth 1")
    end

    aphone.RegisteredApps[app.name] = app
end