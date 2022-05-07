SG.Table = {}

function SG.Table.Search( tbl, key, term )
    local ret = {}

    for index, value in pairs( tbl ) do
        if value[ key ]:lower():find( term:lower() ) then
            ret[ index ] = table.Copy( tbl[ index ] )
        end
    end

    return ret
end
