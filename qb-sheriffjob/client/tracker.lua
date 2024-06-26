RegisterNetEvent('sheriff:client:CheckDistance', function()
    local player, distance = QBCore.Functions.GetClosestPlayer()
    if player ~= -1 and distance < 2.5 then
        local playerId = GetPlayerServerId(player)
        TriggerServerEvent('sheriff:server:SetTracker', playerId)
    else
        QBCore.Functions.Notify(Lang:t('error.none_nearby'), 'error')
    end
end)

RegisterNetEvent('sheriff:client:SetTracker', function(bool)
    local trackerClothingData = {
        outfitData = {
            ['accessory'] = { item = -1, texture = 0 },
        }
    }

    if bool then
        trackerClothingData.outfitData = {
            ['accessory'] = { item = 13, texture = 0 }
        }

        TriggerEvent('qb-clothing:client:loadOutfit', trackerClothingData)
    else
        TriggerEvent('qb-clothing:client:loadOutfit', trackerClothingData)
    end
end)

RegisterNetEvent('sheriff:client:SendTrackerLocation', function(requestId)
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)

    TriggerServerEvent('sheriff:server:SendTrackerLocation', coords, requestId)
end)

RegisterNetEvent('sheriff:client:TrackerMessage', function(msg, coords)
    PlaySound(-1, 'Lose_1st', 'GTAO_FM_Events_Soundset', 0, 0, 1)
    QBCore.Functions.Notify(msg, 'sheriff')
    local transG = 250
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, 458)
    SetBlipColour(blip, 1)
    SetBlipDisplay(blip, 4)
    SetBlipAlpha(blip, transG)
    SetBlipScale(blip, 1.0)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(Lang:t('info.ankle_location'))
    EndTextCommandSetBlipName(blip)
    while transG ~= 0 do
        Wait(180 * 4)
        transG = transG - 1
        SetBlipAlpha(blip, transG)
        if transG == 0 then
            SetBlipSprite(blip, 2)
            RemoveBlip(blip)
            return
        end
    end
end)
