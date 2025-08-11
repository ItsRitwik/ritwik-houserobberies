local QBCore = exports['qb-core']:GetCoreObject()
local lib = exports.ox_lib
local houseObj = {}
local CurrentCops = 0

-- Functions
local function loadParticle(dict)
    RequestNamedPtfxAsset(dict)
    while not HasNamedPtfxAssetLoaded(dict) do
        Wait(10)
    end
    SetPtfxAssetNextCall(dict)
end

local function loadAnimDict(dict)
    RequestAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do Wait(5) end
end


local function openHouseAnim()
    loadAnimDict('anim@heists@keycard@')
    TaskPlayAnim(PlayerPedId(), 'anim@heists@keycard@', 'exit', 5.0, 1.0, -1, 16, 0, 0, 0, 0)
    Wait(400)
    ClearPedTasks(PlayerPedId())
end

local function enterRobberyHouse(house)
    local home = Config.Houses[house] 
    TriggerServerEvent('InteractSound_SV:PlayOnSource', 'houses_door_open', 0.25)
    openHouseAnim()
    Wait(250)
    local coords = { x = Config.Houses[house].coords.x, y = Config.Houses[house].coords.y, z = Config.Houses[house].coords.z - 145.0} -- dont change this z value i swear to fucking god
    if home.tier == 1 then
        data = exports['qb-interior']:CreateCaravanShell(coords)
    elseif  home.tier == 2 then
          data = exports['qb-interior']:CreateLesterShell(coords)
    elseif  home.tier == 3 then
        data = exports['qb-interior']:CreateTrevorsShell(coords)
    elseif  home.tier == 4 then
        data = exports['qb-interior']:CreateHouseRobbery(coords)
    elseif   home.tier == 5 then
        data = exports['qb-interior']:CreateFurniMotelModern(coords)
    elseif home.tier == 6 then
        data = exports['qb-interior']:CreateMichael(coords)
    end
    for k, v in pairs(home['loot']) do
        RequestModel(v.prop)
        local timeout = 0
        while not HasModelLoaded(v.prop) do
            Wait(10)
            timeout = timeout + 10
            if timeout > 3000 then
                break
            end
        end
        if HasModelLoaded(v.prop) and v.taken == false then
            local objectCoords = vector3(coords.x + v.coords.x, coords.y + v.coords.y, coords.z + v.coords.z)
            local obj = CreateObject(v.prop, objectCoords.x, objectCoords.y, objectCoords.z, false, false, false)
            if DoesEntityExist(obj) then
                SetEntityHeading(obj, v.rotation or 180.0)
                FreezeEntityPosition(obj,true)
                TriggerEvent('ritwik-houserobbery:client:deleteobject', obj)
                AddSingleModel(obj, {name = 'StealLoot',
                     icon = "fas fa-sign-in-alt",
                     label = "Steal Loot",
                     action = function()
                         TriggerServerEvent('ritwik-houserobbery:server:setlootstatebusy', house, v.num, true)
                         if not progressbar("Stealing", math.random(Config.MinRobTime, Config.MaxRobTime), 'search') then return end
                         if not minigame(home.tier) then 
                             Notify("This Nerd Failed", "error")
                             TriggerServerEvent('ritwik-houserobbery:server:setlootstatebusy', house, v.num, false)
                             return end
                         DeleteObject(obj)
                         TriggerServerEvent('ritwik-houserobbery:server:setlootused', house, v.num)
                         TriggerServerEvent('ritwik-houserobbery:server:GetLoot', Config.Houses[house].tier, v.type, objectCoords)
                         TriggerServerEvent('ritwik-houserobbery:server:setlootstatebusy', house, v.num, false)    
                     end,
                     canInteract = function()
                         if v.taken == false and v.busy == false then return true end end}, obj)
            end
        end
    end
    local loc = vector3(coords.x + Config.OffSet[home.tier].x, coords.y + Config.OffSet[home.tier].y, coords.z + Config.OffSet[home.tier].z )
    
    houseObj = data[1]
    Wait(500)
    TriggerEvent('qb-weathersync:client:DisableSync')
    Wait(1000 * 60 * Config.HouseTimer)
    exports['qb-interior']:DespawnInterior(houseObj, function()
        if #(GetEntityCoords(PlayerPedId()) - vector3(coords.x, coords.y, coords.z)) <= 15.0 then
            SetEntityCoords(PlayerPedId(),Config.Houses[house]['coords'])
        end
    end)
end

RegisterNetEvent('ritwik-houserobbery:client:deleteobject', function(k, house)
    Wait(1000 * 60 * Config.HouseTimer)
    DeleteObject(k)
end)

RegisterNetEvent('ritwik-houserobbery:client:enterHouse', function(house)
    enterRobberyHouse(house)
end)

RegisterNetEvent('ritwik-houserobbery:client:notify', function(message, type)
    Notify(message, type)
end)

RegisterNetEvent('ritwik-houserobbery:client:setHouseState', function(house, state)
    Config.Houses[house]['spawned'] = state
end)

RegisterNetEvent('ritwik-houserobbery:client:SetLootState', function(house, k, state)
    Config.Houses[house]['loot'][k].taken = state
end)
RegisterNetEvent('ritwik-houserobbery:client:SetLootStateBusy', function(house, k, state)
    Config.Houses[house]['loot'][k].busy = state
end)

RegisterNetEvent('ritwik-housrobberies:client:ptfx', function(loc)
    dict = "scr_ba_bb"
    loadParticle(dict)
    smoke = StartParticleFxLoopedAtCoord('scr_ba_bb_plane_smoke_trail',loc.x, loc.y, loc.z - 145.0, 0, 0, 0, 3.0, 0, 0,0)
    SetParticleFxLoopedAlpha(smoke, 1.0)
    Wait(20000)
    StopParticleFxLooped(smoke,true)
end)

CreateThread(function()
    for k, v in pairs (Config.Houses) do
            local labeltext = " "
            if Config.DebugHouseNumber then
                labeltext = "break in " .. k .."!"
            else
                labeltext = "Break In"    
            end
            AddBoxZoneMultiOptions('breakin' .. k, v.coords,{
                {   name = 'renterhouse', icon = "fas fa-sign-in-alt", label = "Re-Enter House", 
                    action = function()     enterRobberyHouse(k) end, 
                    onSelect = function()     enterRobberyHouse(k) end, 
                    canInteract = function()
                        if Config.Houses[k]['spawned']  then return true end end
                },
                {
                    name = 'makesmoke',
                    icon = "fas fa-sign-in-alt",
                    label = "Throw Smoke Grenade",
                    action = function()
                        if not progressbar("Throwing A Smoke Grenade", 4000, 'uncuff') then return end
                        TriggerServerEvent('ritwik-houserobberies:server:ptfx', Config.Houses[k]['coords'])
                    end,    
                    onSelect = function()
                        if not progressbar("Throwing A Smoke Grenade", 4000, 'uncuff') then return end
                        TriggerServerEvent('ritwik-houserobberies:server:ptfx', Config.Houses[k]['coords'])
                    end,
                    canInteract = function()
                        if Config.Houses[k]['spawned'] and QBCore.Functions.GetPlayerData().job.type == 'leo'  then return true end end
                },
                {
                    name = 'lockup',
                    icon = "fas fa-sign-in-alt",
                    label = "Lock The House Down",
                    action = function()
                        if not progressbar("Locking Up The House", math.random(3000,6000), 'uncuff') then return end
                         TriggerServerEvent('ritwik-houserobbery:server:closeHouse', k)
                     end,
                    onSelect = function()
                       if not progressbar("Locking Up The House", math.random(3000,6000), 'uncuff') then return end
                        TriggerServerEvent('ritwik-houserobbery:server:closeHouse', k)
                    end,
                    canInteract = function()
                        if Config.Houses[k]['spawned']  and QBCore.Functions.GetPlayerData().job.type == 'leo' then return true end end
                },
                {
                    name = 'LockPickHouse',
                    icon = "fas fa-sign-in-alt",
                    label = labeltext,
                    onSelect = function()
                        BreakIn(k)								
                    end,
                    action = function()
                        BreakIn(k)								
                    end,
                    canInteract = function()
                        if Config.Houses[k]['spawned'] == false  and QBCore.Functions.GetPlayerData().job.type ~= 'leo' then return true end end
                    
                }, })
                local loc = vector3(Config.Houses[k]['coords'].x  + Config.OffSet[Config.Houses[k]['tier']].x, Config.Houses[k]['coords'].y + Config.OffSet[Config.Houses[k]['tier']].y, Config.Houses[k]['coords'].z + Config.OffSet[Config.Houses[k]['tier']].z - 145 )
                AddBoxZoneSingle('leavehouse'..k, loc, 
                {name = 'leaverobbery', icon = "fas fa-sign-in-alt",label = "Leave Robbery House",action = function()   SetEntityCoords(PlayerPedId(), Config.Houses[k].coords)   end,})
end
end)

CreateThread(function()
    local chance = math.random(1,100)
    local current = GetHashKey("g_m_y_famdnf_01")
    RequestModel(current)
    while not HasModelLoaded(current) do
        Wait(100)
    end
	local CurrentLocation = Config.FenceSpawn
	local blackmarket = CreatePed(0, current,CurrentLocation.x,CurrentLocation.y,CurrentLocation.z-1, CurrentLocation.w, false, false)
    SetEntityInvincible(blackmarket, true)
    SetBlockingOfNonTemporaryEvents(blackmarket, true)
    Freeze(blackmarket, true, CurrentLocation.w)
    if chance <= 50 then
        GiveWeaponToPed(blackmarket, Config.FenceWeaponone, 1, false, true)
    else
         GiveWeaponToPed(blackmarket, Config.FenceWeapontwo, 1, false, true)
    end     
    AddSingleModel(blackmarket,{label = "Robbery Fence",icon = "fas fa-eye",event = "ritwik-houserobberies:client:openblackmarket"}, blackmarket )
end)

-- TechGuy Dynamic Ped Creation System
local techGuyPed = nil
local currentTechGuyLocation = 1

local function createTechGuy()
    -- Delete existing ped if it exists
    if techGuyPed and DoesEntityExist(techGuyPed) then
        DeleteEntity(techGuyPed)
        techGuyPed = nil
    end
    
    -- Get random location
    local randomLocation = math.random(1, #Config.TechGuySpawns)
    currentTechGuyLocation = randomLocation
    local techGuyLocation = Config.TechGuySpawns[randomLocation]
    
    -- Load model
    local techGuyModel = GetHashKey(Config.TechGuyModel)
    RequestModel(techGuyModel)
    while not HasModelLoaded(techGuyModel) do
        Wait(100)
    end
    
    -- Create ped
    techGuyPed = CreatePed(0, techGuyModel, techGuyLocation.x, techGuyLocation.y, techGuyLocation.z-1, techGuyLocation.w, false, false)
    SetEntityInvincible(techGuyPed, true)
    SetBlockingOfNonTemporaryEvents(techGuyPed, true)
    Freeze(techGuyPed, true, techGuyLocation.w)
    
    AddSingleModel(techGuyPed,{label = "Tech Guy - House Intel",icon = "fas fa-laptop",event = "ritwik-houserobberies:client:opentechguy"}, techGuyPed )
    
    -- print("^2[TechGuy] Spawned at location " .. randomLocation .. " (" .. techGuyLocation.x .. ", " .. techGuyLocation.y .. ")")
end

CreateThread(function()
    -- Initial spawn
    createTechGuy()
    
    -- Location change timer
    while true do
        Wait(1000 * 60 * Config.TechGuyChangeTime) -- Wait for configured minutes
        createTechGuy()
        
        -- Notify all players about location change
        TriggerServerEvent('ritwik-houserobberies:server:techguymoved')
    end
end)

-- Export function to get current tech guy location (for debugging)
exports('getCurrentTechGuyLocation', function()
    if techGuyPed and DoesEntityExist(techGuyPed) then
        return currentTechGuyLocation, Config.TechGuySpawns[currentTechGuyLocation]
    end
    return nil, nil
end)

RegisterNetEvent("ritwik-houserobberies:client:openblackmarket", function(data)
    local blackmarketmenu = {}
    local notify = 0
    for k, v in pairs (Config.BlackMarket) do
        if QBCore.Functions.HasItem(v.item) then
            notify = 1
            if Config.Oxmenu then
                blackmarketmenu[#blackmarketmenu + 1] = {
                    title = GetLabel(v.item) or v.item,
                    description = "$".. v.minvalue .. "  -  $" .. v.maxvalue,
                    event = "ritwik-houserobberies:client:sellloot", 
                    args = {
                        item = v.item,
                        min = v.minvalue,
                        max = v.maxvalue,
                        success = v.successchance,
                    }
                }
            else
                blackmarketmenu[#blackmarketmenu + 1] = {
                    icon = GetImage(v.item),
                    header = GetLabel(v.item),
                    txt =  "$".. v.minvalue .. "  -  $" .. v.maxvalue,
                    params = {
                        event = "ritwik-houserobberies:client:sellloot",
                        args = {
                            item = v.item,
                            min = v.minvalue,
                            max = v.maxvalue,
                            success = v.successchance,
                            }
                        }
                    }	
            end
        end
    end
    if Config.Oxmenu then 
        if #blackmarketmenu > 0 then
            -- Try calling ox_lib directly instead of through the lib variable
            exports.ox_lib:registerContext({
                id = 'blackmarketritwik',
                title = "Black Market", 
                options = blackmarketmenu
            })
            exports.ox_lib:showContext('blackmarketritwik')
        else
            Notify("Nothing To Sell", 'error')
        end
    else
        if #blackmarketmenu > 0 then
            exports['qb-menu']:openMenu(blackmarketmenu)
        else
            Notify("Nothing To Sell", 'error')
        end
    end    
    if notify == 0 then
       Notify("Nothing To Sell", 'error')
    end
end)

RegisterNetEvent("ritwik-houserobberies:client:sellloot", function(data)
    local chance = math.random(1,100)
   
    if data.success >= chance then 
        TriggerServerEvent('ritwik-houserobberies:server:sellloot', data.item)
    else
        TriggerServerEvent('ritwik-houserobberies:server:loseloot', data.item)
    end
end)

-- TechGuy Menu System
RegisterNetEvent("ritwik-houserobberies:client:opentechguy", function(data)
    local techguymenu = {}
    
    for tier = 1, 6 do
        local tierPrice = Config.TechGuyTierPrices[tier] or 0
        if Config.Oxmenu then
            techguymenu[#techguymenu + 1] = {
                title = "Tier " .. tier .. " Houses",
                description = "Get intel on Tier " .. tier .. " houses - $" .. tierPrice,
                event = "ritwik-houserobberies:client:buyhouseintel",
                args = {
                    tier = tier,
                    price = tierPrice
                }
            }
        else
            techguymenu[#techguymenu + 1] = {
                header = "Tier " .. tier .. " Houses",
                txt = "Get intel on Tier " .. tier .. " houses - $" .. tierPrice,
                params = {
                    event = "ritwik-houserobberies:client:buyhouseintel",
                    args = {
                        tier = tier,
                        price = tierPrice
                    }
                }
            }
        end
    end
    
    if Config.Oxmenu then 
        if #techguymenu > 0 then
            exports.ox_lib:registerContext({
                id = 'techguyritwik',
                title = "Tech Guy - House Intel", 
                options = techguymenu
            })
            exports.ox_lib:showContext('techguyritwik')
        end
    else
        if #techguymenu > 0 then
            exports['qb-menu']:openMenu(techguymenu)
        end
    end
end)

RegisterNetEvent("ritwik-houserobberies:client:techguymoved", function()
    Notify("The Tech Guy has moved to a new location!", 'info')
end)

RegisterNetEvent("ritwik-houserobberies:client:buyhouseintel", function(data)
    local tier = data.tier
    local price = data.price
    
    -- Check if player has enough money
    if QBCore.Functions.GetPlayerData().money.cash < price then
        Notify("You don't have enough cash! Need $" .. price, 'error')
        return
    end
    
    -- Get random house of the selected tier
    local availableHouses = {}
    for k, v in pairs(Config.Houses) do
        if v.tier == tier and not v.spawned then
            table.insert(availableHouses, {key = k, house = v})
        end
    end
    
    if #availableHouses == 0 then
        Notify("No available Tier " .. tier .. " houses found!", 'error')
        return
    end
    
    local randomHouse = availableHouses[math.random(#availableHouses)]
    
    -- Remove money from player
    TriggerServerEvent('ritwik-houserobberies:server:removemoney', price)
    
    -- Create waypoint on map
    SetNewWaypoint(randomHouse.house.coords.x, randomHouse.house.coords.y)
    
    -- Notify player
    Notify("Intel purchased! Tier " .. tier .. " house location marked on your map.", 'success')
end)

