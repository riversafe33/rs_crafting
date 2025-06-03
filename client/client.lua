local Core = exports.vorp_core:GetCore()
local progressbar = exports.vorp_progressbar:initiate()

CreateThread(function()
    if Config.ShowBlip then 
        for i = 1, #Config.BlipZone do 
            local zone = Config.BlipZone[i]
            if zone.blips and type(zone.blips) == "number" then
                local blip = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, zone.coords.x, zone.coords.y, zone.coords.z) 
                SetBlipSprite(blip, zone.blips, 1)
                SetBlipScale(blip, 0.8)
                Citizen.InvokeNative(0x9CB1A1623062F402, blip, zone.blipsName)
                Citizen.InvokeNative(0x662D364ABF16DE2F, blip, GetHashKey("BLIP_MODIFIER_MP_COLOR_32"))
            end
        end
    end
end)

local Prompt

Citizen.CreateThread(function()

    Prompt = Uiprompt:new(Config.Prompt.key, Config.Prompt.text)
    Prompt:setEnabledAndVisible(false)

    while true do
        Citizen.Wait(500)

        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        local closestZone = nil
        for zoneId, zone in pairs(Config.CraftingZones) do
            for _, craftingZoneCoord in ipairs(zone.coords) do
                if Vdist(playerCoords.x, playerCoords.y, playerCoords.z, craftingZoneCoord.x, craftingZoneCoord.y, craftingZoneCoord.z) < Config.Prompt.distance then
                    closestZone = zoneId
                    break
                end
            end
            if closestZone then
                break
            end
        end

        if closestZone then

            if not Prompt:isEnabled() then
                Prompt:setEnabledAndVisible(true)
            end

            Prompt:setOnControlJustPressed(function()

                TriggerServerEvent('rs_crafting:getCraftableItems', closestZone) 
            end)
        else

            if Prompt:isEnabled() then
                Prompt:setEnabledAndVisible(false)
            end
        end
    end
end)

UipromptManager:startEventThread()

RegisterNetEvent('rs_crafting:openMenuClient', function(allItems, playerjob)
    if not MenuData then
        return
    end

    local filteredItems = {}

    for _, craft in ipairs(allItems) do
        local allowedJobs = craft.Job

        if allowedJobs == 0 or (type(allowedJobs) == "string" and allowedJobs == playerjob) then
            table.insert(filteredItems, craft)
        elseif type(allowedJobs) == "table" then
            for _, job in ipairs(allowedJobs) do
                if job == playerjob then
                    table.insert(filteredItems, craft)
                    break
                end
            end
        end
    end

    if #filteredItems == 0 then
        TriggerEvent("vorp:NotifyLeft", Config.Text.notifyTitle, Config.Text.notifyNoJob, "menu_textures", "cross", 3000, "COLOR_RED")
        return
    end

    local elements = {}

    for _, craft in ipairs(filteredItems) do

        local rewardImage = craft.Reward and craft.Reward[1] and craft.Reward[1].image

        table.insert(elements, {
            label = craft.Text,
            value = craft,
            image = "items/" .. rewardImage,
            descriptionimages = {}
        })

        for _, item in ipairs(craft.Items) do
            table.insert(elements[#elements].descriptionimages, {
                src = "nui://vorp_inventory/html/img/items/" .. item.image,
                text = item.label,
                count = " x " .. item.count,
            })
        end
    end

    MenuData.Open('default', GetCurrentResourceName(), 'crafting_menu', {
        title   = Config.Text.menuTitle,
        subtext = Config.Text.menuSubtext,
        align   = 'top-right',
        elements = elements,
    }, function(data, menu)

        local selectedItem = data.current.value

        local input = {
            type = "enableinput",
            inputType = "input",
            button = Config.Text.inputButton,
            placeholder = Config.Text.inputPlaceholder,
            style = "block",
            attributes = {
                inputHeader = Config.Text.inputHeader,
                type = "number",
                pattern = "[0-9]+",
                title = Config.Text.inputTitle,
                style = "border-radius: 10px; border:none;"
            }
        }

        local result = exports.vorp_inputs:advancedInput(input)
        local quantity = tonumber(result)
        if quantity and quantity > 0 then
            TriggerServerEvent('rs_crafting:startCrafting', selectedItem, quantity)
            
            MenuData.CloseAll()
        else
            TriggerEvent("vorp:TipRight", Config.Text.tipInvalid, 3000)
        end
    end, function(data, menu)
        menu.close()
    end)
end)

function table.contains(table, element)
    for _, value in ipairs(table) do
        if value == element then
            return true
        end
    end
    return false
end