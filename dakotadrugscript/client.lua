local QBCore = exports['qb-core']:GetCoreObject()

Citizen.CreateThread(function()
    while true do
        local sleep = 1500
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local dist = #(pos - Config.SellLocation)

        if dist < 10.0 then
            sleep = 0
            DrawMarker(2, Config.SellLocation.x, Config.SellLocation.y, Config.SellLocation.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 0, 255, 0, 100, false, true, 2, true, nil, nil, false)

            if dist < Config.SellDistance then
                QBCore.Functions.DrawText3D(Config.SellLocation.x, Config.SellLocation.y, Config.SellLocation.z + 0.2, "[E] Sell Drugs")
                if IsControlJustReleased(0, 38) then -- E key
                    for drugName, _ in pairs(Config.Drugs) do
                        TriggerServerEvent('md-drugs:sellDrug', drugName, 1)
                        Citizen.Wait(500)
                    end
                end
            end
        end

        Citizen.Wait(sleep)
    end
end)

RegisterNetEvent('md-drugs:policeAlert', function(coords, drugType)
    local alertMsg = "Suspicious drug activity detected: " .. (Config.Drugs[drugType].label or "Unknown Drug")
    QBCore.Functions.Notify(alertMsg, "error", 5000)

    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, 161)
    SetBlipScale(blip, 1.2)
    SetBlipColour(blip, 1)
    SetBlipAsShortRange(blip, false)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Drug Deal Alert")
    EndTextCommandSetBlipName(blip)

    Citizen.SetTimeout(60000, function()
        RemoveBlip(blip)
    end)
end)
