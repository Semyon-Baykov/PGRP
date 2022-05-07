function SG.Compress( table )
    return util.Compress( pon.encode( table ) )
end

function SG.Decompress( data )
    return pon.decode( util.Decompress( data ) )
end
