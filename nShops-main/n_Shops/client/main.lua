ESX = nil 

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local open = false
local MenuShops = RageUI.CreateMenu("Supérette", "Interaction")
local ShopNourritureMenu = RageUI.CreateSubMenu(MenuShops, "Nourriture", "INTERACTION")
local ShopBoissonMenu = RageUI.CreateSubMenu(MenuShops, "Boisson", "INTERACTION")
local ShopDiversMenu = RageUI.CreateSubMenu(MenuShops, "Divers", "INTERACTION")
MenuShops.Display.Header = true
MenuShops.Close = function() 
    open = false
end

function OpenMenuShops() 
    if open then 
        open = false
        RageUI.Visible(MenuShops, false)
        return
    else
        open = true
        RageUI.Visible(MenuShops, true)
        CreateThread(function()
            local cooldown = false
            while open do 
                RageUI.IsVisible(MenuShops, function()
                    RageUI.Separator("  ↓                         ~g~Supérette                        ~s~↓")
                    RageUI.Button("Nourriture", nil, {RightLabel = "→→"}, true , {}, ShopNourritureMenu)
                    RageUI.Button("Boissons", nil, {RightLabel = "→→"}, true , {}, ShopBoissonMenu)
                    RageUI.Button("Divers", nil, {RightLabel = "→→"}, true , {}, ShopDiversMenu)

                    
                    RageUI.Separator("  ↓                        ~r~Fermeture                        ~s~↓")              
                    RageUI.Button("~r~Fermer", nil, {RightLabel = "→→"}, true, {
                        onSelected = function()
                            RageUI.CloseAll()
                        end 
                    }) 
                end)

                -- Menu Nourriture
                RageUI.IsVisible(ShopNourritureMenu, function()
                    RageUI.Separator("↓    ~g~Nourriture    ~s~↓")
                    for k, v in pairs(Config.Nourriture) do 
                        RageUI.Button(v.Label .. '', nil, {RightLabel = "~r~" ..v.Price.. "$"}, true, {
                            onSelected = function()
                                TriggerServerEvent('n_shops:Nourriture', v.Label, v.Value, v.Price)
                            end
                        })
                    end
                    
                    RageUI.Separator("↓    ~r~Fermer    ~s~↓")
                    RageUI.Button("~r~Fermer", nil, {RightLabel = "~y~→→"}, true, {
                        onSelected = function()
                            RageUI.CloseAll()
                        end
                    })
                end)

                -- Menu Boissons
                RageUI.IsVisible(ShopBoissonMenu, function()
                    RageUI.Separator("↓    ~b~Boissons    ~s~↓")
                    for k, v in pairs(Config.Boissons) do 
                        RageUI.Button(v.Label .. '', nil, {RightLabel = "~r~" ..v.Price.. "$"}, true, {
                            onSelected = function()
                                TriggerServerEvent('n_shops:Nourriture', v.Label, v.Value, v.Price)
                            end
                        })
                    end

                    RageUI.Separator("↓    ~r~Fermer    ~s~↓")
                    RageUI.Button("~r~Fermer", nil, {RightLabel = "~y~→→"}, true, {
                        onSelected = function()
                            RageUI.CloseAll()
                        end
                    })
                end)

                RageUI.IsVisible(ShopDiversMenu, function()
                    RageUI.Separator("↓    ~o~Divers    ~s~↓")
                    for k, v in pairs(Config.Divers) do 
                        RageUI.Button(v.Label .. '', nil, {RightLabel = "~r~" ..v.Price.. "$"}, true, {
                            onSelected = function()
                                TriggerServerEvent('n_shops:Nourriture', v.Label, v.Value, v.Price)
                            end
                        })
                    end

                    RageUI.Separator("↓    ~r~Fermer    ~s~↓")
                    RageUI.Button("~r~Fermer", nil, {RightLabel = "~y~→→"}, true, {
                        onSelected = function()
                            RageUI.CloseAll()
                        end
                    })
                end)
            Wait(0)
            end
        end)
    end
end

Citizen.CreateThread(function()
    while true do
		local wait = 750

			for k in pairs(Config.Shops) do
			local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local pos = Config.Shops
			local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, pos[k].x, pos[k].y, pos[k].z)

            if dist <= Config.MarkerDistance then
                wait = 0
                ESX.ShowHelpNotification("Appuyer sur [~b~E~s~] pour accéder au ~b~shop !")
                DrawMarker(Config.MarkerType, pos[k].x, pos[k].y, pos[k].z, 0.0, 0.0, 0.0, 0.0,0.0,0.0, Config.MarkerSizeLargeur, Config.MarkerSizeEpaisseur, Config.MarkerSizeHauteur, Config.MarkerColorR, Config.MarkerColorG, Config.MarkerColorB, Config.MarkerOpacite, Config.MarkerSaute, true, p19, Config.MarkerTourne)  
            end

			if dist <= 4.0 then
                wait = 0
                Visual.Subtitle(Config.Text, 1)
                if IsControlJustPressed(1,51) then
                    OpenMenuShops()
                end
		    end
		end
    Wait(wait)
    end
end)

-- Blip
Citizen.CreateThread(function()
    for i=1, #Config.Shops, 1 do
        local nrcblips = AddBlipForCoord(Config.Shops[i].x, Config.Shops[i].y, Config.Shops[i].z)
        SetBlipSprite(nrcblips , Config.BlipSprite)
        SetBlipColour(nrcblips , Config.BlipColour)
        SetBlipScale(nrcblips , Config.BlipScale)
        SetBlipAsShortRange(nrcblips , true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString("Supérette")
        EndTextCommandSetBlipName(nrcblips )
    end
end)