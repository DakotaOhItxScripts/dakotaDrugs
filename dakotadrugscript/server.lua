local QBCore = exports['qb-core']:GetCoreObject()

local alertRadius = 100.0

RegisterNetEvent('md-drugs:sellDrug', function(drugType, amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local drugData = Config.Drugs[drugType]
    if not drugData then
        print(("Invalid drug type: %s"):format(tostring(drugType)))
        return
    end

    amount = tonumber(amount) or 0
    if amount <= 0 then return end

    local item = Player.Functions.GetItemByName(drugType)
    if not item or item.amount < amount then
        TriggerClientEvent('QBCore:Notify', src, "Not enough " .. drugData.label, "error")
        return
    end

    local totalPrice = drugData.price * amount
    Player.Functions.RemoveItem(drugType, amount)
    Player.Functions.AddMoney('cash', totalPrice, 'sold-drugs')

    TriggerClientEvent('QBCore:Notify', src, ("Sold %d %s for $%d"):format(amount, drugData.label, totalPrice), "success")

    -- Police alert logic
    local srcCoords = GetEntityCoords(GetPlayerPed(src))
    for k, v in pairs(QBCore.Functions.GetPlayers()) do
        local police = QBCore.Functions.GetPlayer(v)
        if police and police.PlayerData.job.name == "police" then
            local policePed = GetPlayerPed(v)
            local policeCoords = GetEntityCoords(policePed)
            local dist = #(srcCoords - policeCoords)
            if dist <= alertRadius then
                TriggerClientEvent('md-drugs:policeAlert', v, srcCoords, drugType)
            end
        end
    end
end)
