if Link.dispatch.system ~= 'standalone' then return end

function SendDispatchMessage(data)
    local dispatchData = {
        coords = data.coords or GetEntityCoords(PlayerPedId()),
        jobs = data.jobs or {'police', 'lspd', 'bcso'},
    
        title = data.message or '',
        subtitle = data.description or '',
        
        duration = 120000,
        
        blip = {
            sprite = (data.blip.sprite or 58),
            color = (data.blip.color or 1),
            scale = (data.blip.scale or 1.0),
            text = (data.blip.text or 'Dispatch Alert'),
            flash = (data.blip.flash or false),
        }
    }
    
    TriggerServerEvent('kq_link:server:dispatch:sendAlert', dispatchData)
end


RegisterNetEvent('kq_link:client:dispatch:sendAlert')
AddEventHandler('kq_link:client:dispatch:sendAlert', function(data)
    if not Contains(data.jobs, GetPlayerJob()) then
        return
    end
    
    CreateDispatchBlip(data)
    
    NotifyDispatch(data.title, data.subtitle)
end)


function CreateDispatchBlip(data)
    Citizen.CreateThread(function()
        local blipData = data.blip
        local blip = AddBlipForCoord(data.coords)

        SetBlipSprite(blip, blipData.sprite)
        SetBlipHighDetail(blip, true)
        SetBlipColour(blip, blipData.color)
        SetBlipAlpha(blip, 255)
        SetBlipFlashes(blip, blipData.flash)
        SetBlipScale(blip, blipData.scale)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString(blipData.text)
        EndTextCommandSetBlipName(blip)
        SetBlipAsShortRange(blip, false)

        Citizen.SetTimeout(blipData.duration or 120000, function()
            RemoveBlip(blip)
        end)
    end)
end

function NotifyDispatch(message, subtitle)
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName(subtitle)

    -- Set the notification icon, title and subtitle.
    local iconType = 0
    EndTextCommandThefeedPostMessagetext('CHAR_CALL911', 'CHAR_CALL911', false, iconType, message, '')

    -- Draw the notification
    local showInBrief = true
    local blink = false -- blink doesn't work when using icon notifications.
    EndTextCommandThefeedPostTicker(false, showInBrief)
end
