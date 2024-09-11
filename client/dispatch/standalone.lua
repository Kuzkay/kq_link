if Link.dispatch.system ~= 'standalone' then return end

function SendDispatchMessage(data)
    local dispatchData = {
        coords = data.coords or GetEntityCoords(PlayerPedId()),
        jobs = data.jobs or {'police', 'lspd'},
    
        title = data.message or '',
        subtitle = data.description or '',
  
        blip = {
            sprite = (data.blip.sprite or 58),
            colour = (data.blip.colour or 3),
            scale = (data.blip.scale or 1.0),
            text = (data.blip.text or 'Dispatch Alert'),
            flashes = (data.flash or false),
        }
    }
    TriggerServerEvent('kq_link:server:dispatch:sendAlert', dispatchData)
end


RegisterNetEvent('kq_link:client:dispatch:sendAlert')
AddEventHandler('kq_link:client:dispatch:sendAlert', function(data.jobs)
    if not Contains(data.jobs, GetPlayerJob()) then
        return
    end

    CreateDispatchBlip(data)

    SendDispatchMessage(data.title, data.subtitle)
end)


function CreateDispatchBlip(data)
    Citizen.CreateThread(function()
        local blipData = data.blip
        local blip = AddBlipForCoord(data.coords)

        SetBlipSprite(blip, blipData.sprite)
        SetBlipHighDetail(blip, true)
        SetBlipColour(blip, blipData.color)
        SetBlipAlpha(blip, 255)
        SetBlipFlashes(blip( blipData.flashes)
        SetBlipScale(blip, blipData.scale)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString(data.subtitle)
        EndTextCommandSetBlipName(blip)
        SetBlipAsShortRange(blip, false)

        RealWait(blipData.duration or 120000)

        RemoveBlip(blip)
    end)
end

function SendDispatchMessage(message, subtitle)
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName(message)

    -- Set the notification icon, title and subtitle.
    local iconType = 0
    EndTextCommandThefeedPostMessagetext('CHAR_CALL911', 'CHAR_CALL911', false, iconType, subtitle, '')

    -- Draw the notification
    local showInBrief = true
    local blink = false -- blink doesn't work when using icon notifications.
    EndTextCommandThefeedPostTicker(false, showInBrief)
end
