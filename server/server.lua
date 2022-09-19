local ESX = exports['es_extended']:getSharedObject()
RegisterNetEvent('ts-pawnshop:server:SellItem',function (data,amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    local job = xPlayer.getJob().name
    local item = data.item
    local shopid = data.shop
    local allowedJobs = Config.Pawnshop[shopid].jobs
    local price = Config.Pawnshop[shopid].items[item]
    local allowed = false
    local sellPrice = amount
    for k,v in ipairs(allowedJobs) do
        if v == job then
            allowed = true
        end
    end
    if not allowed then return end
    if xPlayer.getInventoryItem(item) and xPlayer.getInventoryItem(item).count >= amount then
        xPlayer.removeInventoryItem(item, amount)
        xPlayer.addAccountMoney('money',(price*sellPrice))
    else
        xPlayer.showNotification("You don't have enough of the item")
    end
end)