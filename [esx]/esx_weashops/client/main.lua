ESX                           = nil
local HasAlreadyEnteredMarker = false
local LastZone                = nil
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}
local Licenses                = {}
local hasLoaded = false

local IsZiptied              = false

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end
  if hasLoaded then return end
  ESX.TriggerServerCallback('esx_weashop:requestDBItems', function(ShopItems)
    for k,v in pairs(ShopItems) do
      Config.Zones[k].Items = v
    end
	hasLoaded = true
  end)
end)

RegisterNetEvent('esx_weashop:loadLicenses')
AddEventHandler('esx_weashop:loadLicenses', function (licenses)
  for i = 1, #licenses, 1 do
    Licenses[licenses[i].type] = true
  end
end)

AddEventHandler('onClientMapStart', function()
  if hasLoaded then return end
  ESX.TriggerServerCallback('esx_weashop:requestDBItems', function(ShopItems)
    for k,v in pairs(ShopItems) do
      Config.Zones[k].Items = v
    end
	hasLoaded = true
  end)
end)

function OpenBuyLicenseMenu (zone)
  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'shop_license',
    {
      title = _U('buy_license'),
      elements = {
        { label = _U('yes') .. ' ($' .. Config.LicensePrice .. ')', value = 'yes' },
        { label = _U('no'), value = 'no' },
      }
    },
    function (data, menu)
      if data.current.value == 'yes' then
        TriggerServerEvent('esx_weashop:buyLicense')
      end

      menu.close()
    end,
    function (data, menu)
      menu.close()
    end
  )
end

function OpenShopMenu(zone)

  local elements = {}

  for i=1, #Config.Zones[zone].Items, 1 do

    local item = Config.Zones[zone].Items[i]

    table.insert(elements, {
      label     = item.label .. ' - <span style="color:green;">$' .. item.price .. ' </span>',
      realLabel = item.label,
      value     = item.name,
      price     = item.price
    })

  end


  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'shop',
    {
      title  = _U('shop'),
      elements = elements
    },
    function(data, menu)
      TriggerServerEvent('esx_weashop:buyItem', data.current.value, data.current.price, zone)
    end,
    function(data, menu)

      menu.close()

      CurrentAction     = 'shop_menu'
      CurrentActionMsg  = _U('shop_menu')
      CurrentActionData = {zone = zone}
    end
  )
end

AddEventHandler('esx_weashop:hasEnteredMarker', function(zone)

  CurrentAction     = 'shop_menu'
  CurrentActionMsg  = _U('shop_menu')
  CurrentActionData = {zone = zone}

end)

AddEventHandler('esx_weashop:hasExitedMarker', function(zone)

  CurrentAction = nil
  ESX.UI.Menu.CloseAll()

end)

-- Create Blips
Citizen.CreateThread(function()
  for k,v in pairs(Config.Zones) do
  if v.legal==0 then
    for i = 1, #v.Pos, 1 do
    local blip = AddBlipForCoord(v.Pos[i].x, v.Pos[i].y, v.Pos[i].z)
    SetBlipSprite (blip, 487)
    SetBlipDisplay(blip, 4)
    SetBlipScale  (blip, 1.0)
    SetBlipColour (blip, 2)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(_U('map_blip'))
    EndTextCommandSetBlipName(blip)
    end
    end
  end
end)

-- Display markers
Citizen.CreateThread(function()
  while true do
    Wait(0)
    local coords = GetEntityCoords(GetPlayerPed(-1))
    for k,v in pairs(Config.Zones) do
      for i = 1, #v.Pos, 1 do
        if(Config.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, true) < Config.DrawDistance) then
          DrawMarker(Config.Type, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.Size.x, Config.Size.y, Config.Size.z, Config.Color.r, Config.Color.g, Config.Color.b, 100, false, true, 2, false, false, false, false)
        end
      end
    end
  end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()
  while true do
    Wait(0)
    local coords      = GetEntityCoords(GetPlayerPed(-1))
    local isInMarker  = false
    local currentZone = nil

    for k,v in pairs(Config.Zones) do
      for i = 1, #v.Pos, 1 do
        if(GetDistanceBetweenCoords(coords, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, true) < Config.Size.x) then
          isInMarker  = true
          ShopItems   = v.Items
          currentZone = k
          LastZone    = k
        end
      end
    end
    if isInMarker and not HasAlreadyEnteredMarker then
      HasAlreadyEnteredMarker = true
      TriggerEvent('esx_weashop:hasEnteredMarker', currentZone)
    end
    if not isInMarker and HasAlreadyEnteredMarker then
      HasAlreadyEnteredMarker = false
      TriggerEvent('esx_weashop:hasExitedMarker', LastZone)
    end
  end
end)

-- Key Controls
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    if CurrentAction ~= nil then

      SetTextComponentFormat('STRING')
      AddTextComponentString(CurrentActionMsg)
      DisplayHelpTextFromStringLabel(0, 0, 1, -1)

      if IsControlJustReleased(0, 38) then

        if CurrentAction == 'shop_menu' then
          if Config.EnableLicense == true then
            if Licenses['weapon'] ~= nil or Config.Zones[CurrentActionData.zone].legal == 1 then
              OpenShopMenu(CurrentActionData.zone)
            else
              OpenBuyLicenseMenu()
            end
          else
            OpenShopMenu(CurrentActionData.zone)
          end
        end

        CurrentAction = nil

      end

    end
  end
end)


RegisterNetEvent('esx_weashop:addArmor')
AddEventHandler('esx_weashop:addArmor', function ()
  local playerPed = GetPlayerPed(-1)
  SetPedArmour(playerPed, 100)
  ClearPedBloodDamage(playerPed)
end)

RegisterNetEvent('esx_weashop:ziptieTarget')
AddEventHandler('esx_weashop:ziptieTarget', function()
  local player, distance = ESX.Game.GetClosestPlayer()

  if distance ~= -1 and distance <= 3.0 then
    local isNearPlayerUnarmed = GetSelectedPedWeapon(GetPlayerPed(player)) == GetHashKey("WEAPON_UNARMED")
    if isNearPlayerUnarmed then
      if not IsEntityDead(GetPlayerPed(player)) then
        if not IsPedInAnyVehicle(GetPlayerPed(player), false) then
          TriggerServerEvent('esx_weashop:bundlehands', GetPlayerServerId(player), true, true)
          TriggerServerEvent('esx_weashop:removeZiptie')
        else
          ESX.ShowNotification('~r~Person is in a vehicle, cannot ziptie.')
        end
      else
        ESX.ShowNotification('~r~Person is dead, cannot ziptie.')
      end
    else
      ESX.ShowNotification('~r~Person is armed, cannot ziptie.')
    end
  else
    ESX.ShowNotification('No players nearby')
  end
end)

RegisterNetEvent('esx_weashop:unziptieTarget')
AddEventHandler('esx_weashop:unziptieTarget', function()
  local player, distance = ESX.Game.GetClosestPlayer()

  if distance ~= -1 and distance <= 3.0 then
    if not IsPedInAnyVehicle(GetPlayerPed(player), false) then
      TriggerServerEvent('esx_weashop:bundlehands', GetPlayerServerId(player), true, false)
      TriggerServerEvent('esx_weashop:removeZiptieBreaker')
    else
      ESX.ShowNotification('~r~Person is in a vehicle, cannot break ziptie.')
    end
  else
    ESX.ShowNotification('No players nearby')
  end
end)

RegisterNetEvent('esx_weashop:bundlehands')
AddEventHandler('esx_weashop:bundlehands', function(force, state)
  if force then
    IsZiptied = state
  else
    IsZiptied = not IsZiptied
  end

  local playerPed = GetPlayerPed(-1)

  Citizen.CreateThread(function()
    if IsZiptied then
      RequestAnimDict('mp_arresting')

      while not HasAnimDictLoaded('mp_arresting') do
        Wait(100)
      end

      SetCurrentPedWeapon(playerPed, GetHashKey("WEAPON_UNARMED"), true)
      TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)
      SetEnableHandcuffs(playerPed, true)
      SetPedCanPlayGestureAnims(playerPed, false)
      -- FreezeEntityPosition(playerPed, false)

    else
      ClearPedSecondaryTask(playerPed)
      SetEnableHandcuffs(playerPed, false)
      SetPedCanPlayGestureAnims(playerPed,  true)
      -- FreezeEntityPosition(playerPed, false)
    end

  end)


end)

-- Ziptie

Citizen.CreateThread(function()
  while true do
    Wait(0)
    if IsZiptied then
      DisableControlAction(0, 142, true) -- MeleeAttackAlternate
      -- DisableControlAction(0, 30,  true) -- MoveLeftRight
      -- DisableControlAction(0, 31,  true) -- MoveUpDown
      DisableControlAction(0, 288,  true) -- F1
      DisableControlAction(0, 289,  true) -- F2
      DisableControlAction(0, 170,  true) -- F3
      DisableControlAction(0, 167,  true) -- F6
      DisableControlAction(0, 45,  true) -- R
      DisableControlAction(0, 73,  true) -- X
      DisableControlAction(0, 44,  true) -- Q

      DisableControlAction(0,21,true) -- disable sprint
      DisableControlAction(0,24,true) -- disable attack
      DisableControlAction(0,25,true) -- disable aim
      DisableControlAction(0,47,true) -- disable weapon
      DisableControlAction(0,58,true) -- disable weapon
      DisableControlAction(0,263,true) -- disable melee
      DisableControlAction(0,264,true) -- disable melee
      DisableControlAction(0,257,true) -- disable melee
      DisableControlAction(0,140,true) -- disable melee
      DisableControlAction(0,141,true) -- disable melee
      DisableControlAction(0,142,true) -- disable melee
      DisableControlAction(0,143,true) -- disable melee

      for i=7, 29 do
        DisableControlAction(0, i,  true)
      end

      for j=59, 74 do
        DisableControlAction(0, j,  true)
      end
      DisableControlAction(0,86,true) -- disable veh horn

      EnableControlAction(0, 23, true) -- F
    end
  end
end)

local ziptieExpireTime = 600 -- seconds
local ziptieExpireTimer = 0

-- Ziptie Expire
Citizen.CreateThread(function()
  local playerPed = GetPlayerPed(-1)
  while true do
    Wait(1000)
    if IsZiptied then
      ziptieExpireTimer = ziptieExpireTimer + 1
      if (ziptieExpireTimer == ziptieExpireTime) then
        IsZiptied = false
        ziptieExpireTimer = 0
        TriggerServerEvent('esx_weashop:bundlehands', GetPlayerServerId(PlayerId()), true, false)
      end
    end
  end
end)

AddEventHandler('playerSpawned', function()
  if IsZiptied then
    TriggerServerEvent('esx_weashop:bundlehands', GetPlayerServerId(PlayerId()), true, false)
  end
end)