function aphone.L(key, ...)
    if !aphone.LanguageTable[key] then
        print("[APhone] There a error with the language's text : " .. key)
    end

    return ... and string.format( aphone.LanguageTable[key], ... ) or aphone.LanguageTable[key]
end