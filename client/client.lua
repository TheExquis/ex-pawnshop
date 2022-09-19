local PlayerData = {}
local Open = false
RegisterNetEvent('esx:playerLoaded', function(playerData)
    PlayerData = playerData
end)
RegisterNetEvent('esx:setJob',function(job)
    PlayerData.job = job
end)

CreateThread(function()
    for k,v in ipairs(Config.Pawnshop) do
        local shopCoords = lib.points.new(v.coords,Config.DrawDistance)
        function shopCoords:nearby()
            local Allowed = false
            for i,j in ipairs(v.jobs) do
                if PlayerData.job and (j == PlayerData.job.name) then
                    Allowed = true
                end
            end
            if #v.jobs == 0 then
                Allowed = true
            end
            if Allowed and not Open then
                DrawText3Ds(v.coords.x,v.coords.y,v.coords.z,"Press ~r~[E]~s~ To Open ~y~Pawn Shop~s~")
                DisableControlAction(0, 38, true)
                if self.currentDistance < 3 and IsDisabledControlJustPressed(0, 38) then
                    Open = true
                    TriggerEvent('ts-pawnshop:open:Pawnshop',k)
                end
            end
        end
    end
end)

lib.registerMenu({
    id = 'ts_pawnshop',
    title = 'Pawnshop',
    position = 'top-right',
    onClose = function()
        Open = false
    end,
    options = {
    }
}, function(selected, scrollIndex, args)
    if args then
        local input = lib.inputDialog('Pawnshop', {
            { type = "number", label = "Count", default = 1 }
        })
        if input and input[1] then
            local amount = tonumber(input[1])
            TriggerServerEvent('ts-pawnshop:server:SellItem',args,amount)
            Open = false
        end
    end
end)


RegisterNetEvent('ts-pawnshop:open:Pawnshop',function(shopid)
    local pawnShopid = shopid
    local options = {}
    for k,v in pairs(Config.Pawnshop[pawnShopid].items) do
        local label = exports.ox_inventory:Items(k).label
        options[#options+1] = {label = label, description = 'Sell Price: '..v,args={item = k,shop=pawnShopid}}
    end
    lib.setMenuOptions('ts_pawnshop',options)
    lib.showMenu('ts_pawnshop')
end)

function DrawText3Ds(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    SetTextScale(0.32, 0.32)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 255)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
    local factor = (string.len(text)) / 500
    DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 0, 0, 0, 80)
end