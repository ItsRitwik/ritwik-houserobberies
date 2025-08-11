local QBCore = exports['qb-core']:GetCoreObject()

-- Cooldown system
local playerCooldowns = {} -- Table to track player cooldowns

-- Function to format time for display
function FormatTime(seconds)
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local secs = seconds % 60
    
    if hours > 0 then
        return string.format("%dh %dm %ds", hours, minutes, secs)
    elseif minutes > 0 then
        return string.format("%dm %ds", minutes, secs)
    else
        return string.format("%ds", secs)
    end
end

-- Function to check if player is on cooldown
function IsPlayerOnCooldown(src)
    local steamId = GetPlayerIdentifierByType(src, 'steam')
    local license = GetPlayerIdentifierByType(src, 'license')
    local playerId = steamId or license
    
    -- print("DEBUG: IsPlayerOnCooldown - src: " .. src .. ", steamId: " .. tostring(steamId) .. ", license: " .. tostring(license) .. ", using: " .. tostring(playerId))
    
    if not playerId then 
        -- print("DEBUG: No identifier found for player " .. src)
        return false 
    end
    
    if playerCooldowns[playerId] then
        local timeLeft = playerCooldowns[playerId] - os.time()
        -- print("DEBUG: Found cooldown entry, timeLeft: " .. timeLeft .. ", os.time(): " .. os.time() .. ", cooldownTime: " .. playerCooldowns[playerId])
        if timeLeft > 0 then
            return true, timeLeft
        else
            playerCooldowns[playerId] = nil
            return false, 0
        end
    end
    -- print("DEBUG: No cooldown found for " .. playerId)
    return false, 0
end

-- Function to set player cooldown
function SetPlayerCooldown(src)
    local steamId = GetPlayerIdentifierByType(src, 'steam')
    local license = GetPlayerIdentifierByType(src, 'license')
    local playerId = steamId or license
    
    if playerId then
        local cooldownTime = os.time() + Config.RobberyCooldown
        playerCooldowns[playerId] = cooldownTime
        -- print("DEBUG: Set cooldown for " .. playerId .. " until " .. cooldownTime .. " (current: " .. os.time() .. ", duration: " .. Config.RobberyCooldown .. ")")
    else
        -- print("DEBUG: Could not set cooldown - no identifier for player " .. src)
    end
end

RegisterNetEvent('ritwik-houserobbery:server:accessbreak', function(tier, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local info = Player.PlayerData.charinfo
    local luck = math.random(1,100)
    local playerCoords = GetEntityCoords(GetPlayerPed(src))
    if luck <= 20 then 
        RemoveItem(src, item, 1)
    end
    
end)

RegisterNetEvent('ritwik-houserobberies:server:sellloot', function(itemName)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local info = Player.PlayerData.charinfo
    local itemConfig
    for i = 1, #Config.BlackMarket do
        if Config.BlackMarket[i].item == itemName then
            itemConfig = Config.BlackMarket[i]
            break
        end
    end
    if not itemConfig then return end 
    local price = math.random(itemConfig.minvalue, itemConfig.maxvalue) 
    local itemsell = Player.Functions.GetItemByName(itemName)
    local playerCoords = GetEntityCoords(GetPlayerPed(src))
    if itemsell and itemsell.amount > 0 then
        if RemoveItem(src, itemName, itemsell.amount) then
            Player.Functions.AddMoney('cash', price * itemsell.amount)
            Notifys("You received " .. itemsell.amount * price .. " of Cash.", "success")
            Log('ID: 1 Name: ' .. info.firstname .. ' ' .. info.lastname .. ' Sold  ' .. itemsell.amount .. ' ' .. itemName .. ' For A Price Of ' .. price * itemsell.amount .. ' At ' .. playerCoords .. '!', 'sell')
        end
    end
end)

RegisterNetEvent('ritwik-houserobberies:server:loseloot', function(item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local itemsell = Player.Functions.GetItemByName(item)
    local info = Player.PlayerData.charinfo
    if itemsell and itemsell.amount > 0 then
        if RemoveItem(src, item, itemsell.amount) then
            Notifys("You Just Got Robbed of " ..itemsell.amount .." ".. QBCore.Shared.Items[item].label .. "s!", "error")
            Log('ID: 1 Name: ' .. info.firstname .. ' ' .. info.lastname .. ' Got Robbed Of   ' .. itemsell.amount .. ' ' .. item .. ' Like A Nerd!', 'robbed')
        end
    end
end)

RegisterNetEvent('ritwik-houserobbery:server:enterHouse', function(house)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local info = Player.PlayerData.charinfo
    
    -- print("DEBUG: Player " .. src .. " trying to enter house " .. house)
    
    -- Check cooldown
    local onCooldown, timeLeft = IsPlayerOnCooldown(src)
    -- print("DEBUG: Cooldown check result - onCooldown: " .. tostring(onCooldown) .. ", timeLeft: " .. tostring(timeLeft or 0))
    
    if onCooldown then
        local timeString = FormatTime(timeLeft)
        local message = string.format(Config.CooldownMessage, timeString)
        -- print("DEBUG: Player on cooldown, sending message: " .. message)
        TriggerClientEvent('ritwik-houserobbery:client:notify', src, message, 'error')
        return
    end
    
    -- Set cooldown for this player
    -- print("DEBUG: Setting cooldown for player " .. src)
    SetPlayerCooldown(src)
    
    TriggerClientEvent('ritwik-houserobbery:client:enterHouse', src, house)
    Config.Houses[house]['spawned'] = true
    TriggerClientEvent('ritwik-houserobbery:client:setHouseState', -1, house, true)
    Log('House ID ' .. house .. ' Has Been Unlocked By ' .. info.firstname .. ' ' .. info.lastname .. '!', 'brokenin')
    Wait(1000 * 60 * Config.HouseTimer)
    Config.Houses[house]['spawned'] = false
    TriggerClientEvent('ritwik-houserobbery:client:setHouseState', -1, house, false)
    Log('House ID ' .. house .. ' Has Been Locked', 'locked')
end)

RegisterNetEvent('ritwik-houserobbery:server:setlootused', function(house, k)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local info = Player.PlayerData.charinfo
    Log('ID: ' .. src .. 'Name:' .. info.firstname .. ' ' .. info.lastname .. ' Took From ' .. house .. ' Loot Spot ' .. k .. '!', 'set' )
    Config.Houses[house]['loot'][k].taken = true
    TriggerClientEvent('ritwik-houserobbery:client:SetLootState', -1, house, k, true)
    Wait(1000 * 60 * Config.HouseTimer)
    Config.Houses[house]['loot'][k].taken = false
    Log('' .. house .. ' Loot Spot ' .. k .. ' Is Availavble!', 'set' )
    TriggerClientEvent('ritwik-houserobbery:client:SetLootState', -1, house, k, false)
end)

RegisterNetEvent('ritwik-houserobbery:server:setlootstatebusy', function(house, k,state)
    Config.Houses[house]['loot'][k].busy = state
    TriggerClientEvent('ritwik-houserobbery:client:SetLootStateBusy', -1, house, k, state)
end)

RegisterNetEvent('ritwik-houserobbery:server:closeHouse', function(house)
    Config.Houses[house]['spawned'] = false
    Log('House ID ' .. house .. ' Has Been Locked By Police', 'locked')
    TriggerClientEvent('ritwik-houserobbery:client:setHouseState', -1, house, false)
end)

RegisterNetEvent('ritwik-houserobberies:server:ptfx', function(loc)
TriggerClientEvent('ritwik-housrobberies:client:ptfx', -1, loc)
end)
RegisterNetEvent('ritwik-houserobbery:server:GetLoot', function(tier, rewardtype, objectCoords)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local info = Player.PlayerData.charinfo
    if not CheckDist(source, objectCoords) then return end
    local chance = math.random(1,100)
    local cashamount = math.random(Config.CashMin, Config.CashMax)
    local randomItem = math.random(1,#Config.Rewards[tier][rewardtype])
    local data = Config.Rewards[tier][rewardtype][randomItem]
    if Config.EmptyChance <= chance then 
        AddItem(src, data.item, data.amount)
        if Config.CashChance <= chance then
            Player.Functions.AddMoney('cash', cashamount)
        end
        Log('ID: 1 Name: '.. GetName(src).. ' Stole ' .. data.amount .. ' Of ' .. data.item .. ' From A Tier ' .. tier .. ' House', 'stole')
    else
        Notifys("This Isn't Worth Taking", "error") 
    end
end)

-- TechGuy server event for removing money
RegisterNetEvent('ritwik-houserobberies:server:removemoney', function(amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local info = Player.PlayerData.charinfo
    
    if Player.Functions.GetMoney('cash') >= amount then
        Player.Functions.RemoveMoney('cash', amount)
        Log('ID: ' .. src .. ' Name: ' .. info.firstname .. ' ' .. info.lastname .. ' Purchased house intel for $' .. amount, 'techguy')
    end
end)

-- Debug command to check cooldowns (commented out for production)
--[[
RegisterCommand('checkcooldown', function(source)
    local src = source
    if src == 0 then return end -- Console command
    
    local steamId = GetPlayerIdentifierByType(src, 'steam')
    local license = GetPlayerIdentifierByType(src, 'license')
    local playerId = steamId or license
    
    print("DEBUG COMMAND: Player " .. src .. " identifiers:")
    print("  Steam: " .. tostring(steamId))
    print("  License: " .. tostring(license))
    print("  Using: " .. tostring(playerId))
    
    if playerCooldowns[playerId] then
        local timeLeft = playerCooldowns[playerId] - os.time()
        print("  Cooldown found - Time left: " .. timeLeft .. " seconds")
        TriggerClientEvent('ritwik-houserobbery:client:notify', src, "Cooldown: " .. FormatTime(timeLeft) .. " remaining", 'inform')
    else
        print("  No cooldown found")
        TriggerClientEvent('ritwik-houserobbery:client:notify', src, "No cooldown active", 'success')
    end
    
    print("All active cooldowns:")
    for id, time in pairs(playerCooldowns) do
        print("  " .. id .. " -> " .. time .. " (expires in " .. (time - os.time()) .. "s)")
    end
end, false)
--]]

-- Emergency exit command removed as per user request
