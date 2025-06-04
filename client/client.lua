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

------------ Crafteos desde un Prop ----------
local Prompt2

Citizen.CreateThread(function()
    Prompt2 = Uiprompt:new(Config.Prompt2.key, Config.Prompt2.text)
    Prompt2:setEnabledAndVisible(false)

    while true do
        Citizen.Wait(500)

        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local entityExists = false
        local closestEntity = nil
        local propToCheck = nil  -- Esto nos ayudará a verificar qué prop es el más cercano.

        for _, category in pairs(Config.CraftingProps) do
            for _, item in pairs(category.Items) do
                -- Comprobamos si el prop está en la lista de props permitidos
                for _, prop in ipairs(item.props) do
                    local entity = GetClosestObjectOfType(playerCoords, Config.Prompt.distance, GetHashKey(prop), 0, 0, 0)
                    if DoesEntityExist(entity) then
                        entityExists = true
                        closestEntity = entity
                        propToCheck = prop  -- Guardamos el prop correspondiente a este item
                        break
                    end
                end
                if entityExists then break end
            end
            if entityExists then break end
        end

        if entityExists and closestEntity then
            -- Verificamos si el prop coincide
            if not Prompt2:isEnabled() then
                Prompt2:setEnabledAndVisible(true)
            end

            Prompt2:setOnControlJustPressed(function()
                -- Ahora pasamos el propToCheck para que solo abra el menú correspondiente
                TriggerEvent('rs_crafting:openPropMenu', closestEntity, propToCheck)
            end)
        else
            if Prompt2:isEnabled() then
                Prompt2:setEnabledAndVisible(false)
            end
        end
    end
end)

RegisterNetEvent('rs_crafting:openPropMenu', function(entity, propToCheck)
    if not MenuData then return end

    local elements = {}
    local addedCategories = {} -- Tabla para evitar duplicados
    local directItems = {} -- Lista de ítems si la categoría es false

    for _, category in ipairs(Config.CraftingProps) do
        local hasMatchingItem = false

        for _, item in ipairs(category.Items) do
            if table.contains(item.props, propToCheck) then
                hasMatchingItem = true
                if category.Category == false then
                    table.insert(directItems, {
                        label = item.Text,
                        value = item,
                        image = "items/" .. (item.Reward[1] and item.Reward[1].image),
                        descriptionimages = {}
                    })
                    for _, reqItem in ipairs(item.Items) do
                        table.insert(directItems[#directItems].descriptionimages, {
                            src = "nui://vorp_inventory/html/img/items/" .. reqItem.image,
                            text = reqItem.label,
                            count = " x " .. reqItem.count,
                        })
                    end
                end
            end
        end

        -- Si la categoría no es false y tiene ítems, la agregamos al menú de categorías
        if hasMatchingItem and category.Category ~= false and not addedCategories[category.Category] then
            table.insert(elements, {
                label = category.Category,
                value = category,
                isCategory = true
            })
            addedCategories[category.Category] = true
        end
    end

    -- Si hay ítems en directItems, mostramos directamente la lista sin categorías
    if #directItems > 0 then
        MenuData.Open('default', GetCurrentResourceName(), 'crafting_prop_items_menu', {
            title = Config.Text.menuTitle,
            align = 'top-right',
            elements = directItems,
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
                TriggerServerEvent('rs_crafting:startPropCrafting', selectedItem, quantity)
                MenuData.CloseAll()
            else
                TriggerEvent("vorp:TipRight", Config.Text.tipInvalid, 3000)
            end
        end, function(data, menu)
            menu.close()
        end)
        return
    end

    -- Si no hay directItems, abrimos el menú de categorías normalmente
    MenuData.Open('default', GetCurrentResourceName(), 'crafting_prop_menu', {
        title   = Config.Text.menuTitle,
        subtext = Config.Text.menuCategory,
        align   = 'top-right',
        elements = elements,
    }, function(data, menu)
        local selectedCategory = data.current.value
        local categoryItems = selectedCategory.Items or {}
        local categoryElements = {}

        for _, craft in ipairs(categoryItems) do
            local rewardImage = craft.Reward and craft.Reward[1] and craft.Reward[1].image or "default.png"
            table.insert(categoryElements, {
                label = craft.Text,
                value = craft,
                image = "items/" .. rewardImage,
                descriptionimages = {}
            })

            for _, item in ipairs(craft.Items) do
                table.insert(categoryElements[#categoryElements].descriptionimages, {
                    src = "nui://vorp_inventory/html/img/items/" .. item.image,
                    text = item.label,
                    count = " x " .. item.count,
                })
            end
        end

        MenuData.Open('default', GetCurrentResourceName(), 'crafting_prop_category_menu', {
            title = selectedCategory.Category,
            subtext = Config.Text.menuTitle,
            align = 'top-right',
            elements = categoryElements,
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
                TriggerServerEvent('rs_crafting:startPropCrafting', selectedItem, quantity)
                MenuData.CloseAll()
            else
                TriggerEvent("vorp:TipRight", Config.Text.tipInvalid, 3000)
            end
        end, function(data, menu)
            menu.close()
        end)
    end, function(data, menu)
        menu.close()
    end)
end)

RegisterNetEvent("rs_crafting:craftable")
AddEventHandler("rs_crafting:craftable", function(animation, craftable, countz)
    local playerPed = PlayerPedId()
    iscrafting = true

    if not animation then
        animation = "craft"
    end

    Animations.playAnimation(playerPed, animation)

    progressbar.start(Config.Text.proCessing, Config.CraftTime, function()
        Animations.endAnimation(animation)
        iscrafting = false

        TriggerServerEvent("rs_crafting:animationComplete", craftable, countz)
    end)
end)
