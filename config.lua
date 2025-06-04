Config = {}

Config.Prompt = {
    key = `INPUT_INTERACT_OPTION1`, -- Change this key as needed
    text = "Crafting Menu",         -- Custom prompt text
    distance = 2.0                  -- Distance at which the prompt activates
}

Config.Prompt2 = {
    key = `INPUT_INTERACT_OPTION1`, -- Change this key as needed
    text = "Crafting Menu",         -- Custom prompt text
    distance = 2.0                  -- Distance at which the prompt activates
}

Config.Text = {
    notifyTitle      = "Crafting",
    notifyNoJob      = "You don't have the necessary job",
    menuTitle        = "Preparation Menu",
    menuCategory     = "Select a category",
    menuSubtext      = "Select an item to craft",
    inputButton      = "Confirm",
    inputPlaceholder = "Amount to craft",
    inputHeader      = "Amount",
    inputTitle       = "Only numbers",
    tipInvalid       = "Invalid quantity",
    notMaterials     = "You don't have enough materials",
    notSpace         = "You don't have enough space",
    sucCess          = "Successful Crafting",
    ipInvalid        = "Invalid crafting type",
    proCessing       = "Processing",
}

Config.CraftTime = 10000

Config.ShowBlip = true -- Config.ShowBlip = false blips are not displayed on the map.
Config.BlipZone = {
    -- Location for crafting enterprise
    {coords = vector3(-314.34, 809.98, 118.98),  blips = 1879260108, blipsName = "Valentine Saloon"},      -- Valentine Saloon
    {coords = vector3(2640.24, -1228.82, 53.38), blips = 1879260108, blipsName = "Foundry Saint Denis"},   -- Saint Denis Saloon
    -- add more blips to mark the crafting area
}

Config.CraftingZones = {
    [1] = {
        coords = {
            vector3(-314.34, 809.98, 118.98),    -- Valentine Saloon
            vector3(2640.24, -1228.82, 53.38),   -- Saint Denis Saloon
        },
        craftingItems = {
            {
                Items = {
                    {
                        Text = "5 x Chicken Soup",      -- name of the recipe
                        Job = {"salonvl", "salonsd"},   -- you can add as many jobs as you want, even just one so only that business sees the recipe -- Job = 0, all players can access the crafting
                        Type = "item",                  -- crafting type: item or weapon
                        Animation = 'craft',            -- type of animation, check the list at the end of the script
                        Items = {                       -- list of required items for crafting
                            -- name = item name in the DB -- label = name shown in the menu -- count = required amount -- image = image shown in the menu
                            {name = "bread", label = "Bread", count = 1, image = "bread.png"}, 
                            {name = "water", label = "Water", count = 2, image = "water.png"},
                            -- Add the necessary items for the recipe.
                        },
                        Reward = {
                            -- name = item name in the DB -- count = amount of rewards -- image = image shown in the menu
                            {name = "consumable_soup_chickenveg", count = 5, image = "consumable_soup_chickenveg.png"}
                        },
                    },
                }
            },
            -- add more recipes for these locations
        }
    },

    -- add more crafting zones by continuing with [2]
}

Config.CraftingProps = {
    {
        Category = false, -- Category name is associated with the prop --If it's false, only the items will be shown in a list. If Category = 'Tools', the category will appear with the items inside.
        Items = {
            {
                Text = "Roasted Chicken",
                Type = "item",
                Animation = 'knifecooking',
                props = {"p_campfire05x", "p_campfire04x", "s_cookfire01x", "p_campfire01x"},
                Items = {
                    {name = "bird", label = "bird meat", count = 1, image = "bird.png"},
                    -- Add the necessary items for the recipe.
                },
                Reward = {
                    {name = "consumable_meat_plump_bird_cooked", count = 1, image = "consumable_meat_plump_bird_cooked.png"}
                },
            },
            {
                Text = "Grilled Meat",
                Type = "item",
                Animation = 'knifecooking',
                props = {"p_campfire05x", "p_campfire04x", "s_cookfire01x", "p_campfire01x"},
                Items = {
                    {name = "meat", label = "Meat", count = 1, image = "meat.png"},
                    -- Add the necessary items for the recipe.
                },
                Reward = {
                    {name = "consumable_meat_pork_cooked", count = 1, image = "consumable_meat_pork_cooked.png"}
                },
            },
            {
                Text = "Grilled Snake",
                Type = "item",
                Animation = 'knifecooking',
                props = {"p_campfire05x", "p_campfire04x", "s_cookfire01x", "p_campfire01x"},
                Items = {
                    {name = "provision_meat_herptile", label = "Reptile Meat", count = 1, image = "provision_meat_herptile.png"},
                },
                Reward = {
                    {name = "consumable_meat_snake_cooked", count = 1, image = "consumable_meat_snake_cooked.png"}
                },
            },
            {
                Text = "Grilled Fish",
                Type = "item",
                Animation = 'pescado',
                props = {"p_campfire05x", "p_campfire04x", "s_cookfire01x", "p_campfire01x"},
                Items = {
                    {name = "fishmeat", label = "Fish Meat", count = 1, image = "fishmeat.png"},
                },
                Reward = {
                    {name = "consumable_meat_fish_gritty_cooked", count = 1, image = "consumable_meat_fish_gritty_cooked.png"}
                },
            },
            {
                Text = "Grilled Beef",
                Type = "item",
                props = {"p_campfire05x", "p_campfire04x", "s_cookfire01x", "p_campfire01x"},
                Items = {
                    {name = "beef", label = "Beef", count = 1, image = "beef.png"},
                },
                Animation = 'knifecooking',
                Reward = {
                    {name = "consumable_meat_beef_cooked", count = 1, image = "consumable_meat_beef_cooked.png"}
                },
            },
            {
                Text = "Grilled Alligator Skewers",
                Type = "item",
                Animation = 'knifecooking',
                props = {"p_campfire05x", "p_campfire04x", "s_cookfire01x", "p_campfire01x"},
                Items = {
                    {name = "aligatormeat", label = "Alligator Meat", count = 1, image = "aligatormeat.png"},
                },
                Reward = {
                    {name = "consumable_meat_alligator_cooked", count = 1, image = "consumable_meat_alligator_cooked.png"}
                },
            },
        }
    },
    -- {
    --     Category = "Tools",  -- If Category = 'Tools', the category will appear with the items inside.
    --     Items = {
    --         {
    --             Text = "",
    --             Type = "", -- crafting type: item or weapon
    --             Animation = 'craft',
    --             props =  {""},
    --             Items = {
    --                 {name = "", label = "", count = 1, image = "".png"},
    --                 --  Add the necessary items for the recipe.
    --             },
    --             Reward = {
    --                 {name = "", count = 1, image = "".png"}
    --             },
    --         },
    --     }
    -- },
}

Config.Anim = {
    ["craft"] = { --Default Animation
        dict = "mech_inventory@crafting@fallbacks",
        name = "full_craft_and_stow",
        flag = 27,
        type = 'standard'
    },
    ["spindlecook"] = {
        dict = "amb_camp@world_camp_fire_cooking@male_d@wip_base",
        name = "wip_base",
        flag = 17,
        type = 'standard',
        prop = {
            model = 'p_stick04x',
            coords = {
                x = 0.2,
                y = 0.04,
                z = 0.12,
                xr = 170.0,
                yr = 50.0,
                zr = 0.0
            },
            bone = 'SKEL_R_Finger13',
            subprop = {
                model = 's_meatbit_chunck_medium01x',
                coords = {
                    x = -0.30,
                    y = -0.08,
                    z = -0.30,
                    xr = 0.0,
                    yr = 0.0,
                    zr = 70.0
                }
            }
        }
    },
    ["knifecooking"] = {
        dict = "amb_camp@world_player_fire_cook_knife@male_a@wip_base",
        name = "wip_base",
        flag = 17,
        type = 'standard',
        prop = {
            model = 'w_melee_knife06',
            coords = {
                x = -0.01,
                y = -0.02,
                z = 0.02,
                xr = 190.0,
                yr = 0.0,
                zr = 0.0
            },
            bone = 'SKEL_R_Finger13',
            subprop = {
                model = 'p_redefleshymeat01xa',
                coords = {
                    x = 0.00,
                    y = 0.02,
                    z = -0.20,
                    xr = 0.0,
                    yr = 0.0,
                    zr = 0.0
                }
            }
        }
    },
    ["pescado"] = {
        dict = "amb_camp@world_player_fire_cook_knife@male_a@wip_base",
        name = "wip_base",
        flag = 17,
        type = 'standard',
        prop = {
            model = 'w_melee_knife06',
            coords = {
                x = -0.01,
                y = -0.02,
                z = 0.02,
                xr = 190.0,
                yr = 0.0,
                zr = 0.0
            },
            bone = 'SKEL_R_Finger13',
            subprop = {
                model = 'p_cs_catfish_chop01x',
                coords = {
                    x = 0.00,
                    y = 0.02,
                    z = -0.20,
                    xr = 0.0,
                    yr = 0.0,
                    zr = 0.0
                }
            }
        }
    },
}
