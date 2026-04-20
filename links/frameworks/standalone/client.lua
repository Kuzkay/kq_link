if Link.framework ~= 'none' and Link.framework ~= 'standalone' then
    return
end

function GetPlayerJob()
    return nil
end

function GetInventoryItems()
    return {}
end

function GetInventoryImagePath()
    return '', 'png'
end
