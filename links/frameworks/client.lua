PLAYER_DATA = {
    job = {},
    gang = {}
}

-- Fallback export function
function GetPlayerJob()
    return nil
end

-- Gangs only exist on qb-like frameworks, everywhere else there is none
function GetPlayerGang()
    return nil
end
