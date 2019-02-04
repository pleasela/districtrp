local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local PlayerData        = {}
ESX                           = nil
local Blips                   = {}

local hasAlreadyEnteredMarker = false
local LastZone                = nil
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)


RegisterNetEvent('esx:playerLoaded') --get xPlayer
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)


function OpenRoomMenu(owner)

  local entering = nil
  local elements = {}

    table.insert(elements, {label = _U('player_clothes'), value = 'player_dressing'})
    table.insert(elements, {label = _U('remove_cloth'), value = 'remove_cloth'})

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'room',
    {
      title    = 'Wardrobe',
      align    = 'top-left',
      elements = elements,
    },
    function(data, menu)

      if data.current.value == 'player_dressing' then

        ESX.TriggerServerCallback('esx_wardrobe:getPlayerDressing', function(dressing)

          local elements = {}

          for i=1, #dressing, 1 do
            table.insert(elements, {label = dressing[i], value = i})
          end

          ESX.UI.Menu.Open(
            'default', GetCurrentResourceName(), 'player_dressing',
            {
              title    = _U('player_clothes'),
              align    = 'top-left',
              elements = elements,
            },
            function(data, menu)

              TriggerEvent('skinchanger:getSkin', function(skin)

                ESX.TriggerServerCallback('esx_wardrobe:getPlayerOutfit', function(clothes)

                  TriggerEvent('skinchanger:loadClothes', skin, clothes)
                  TriggerEvent('esx_skin:setLastSkin', skin)

                  TriggerEvent('skinchanger:getSkin', function(skin)
                    TriggerServerEvent('esx_skin:save', skin)
                  end)

                end, data.current.value)

              end)

            end,
            function(data, menu)
              menu.close()
            end
          )

        end)

      end
        
      if data.current.value == 'remove_cloth' then
          ESX.TriggerServerCallback('esx_wardrobe:getPlayerDressing', function(dressing)
              local elements = {}
      
              for i=1, #dressing, 1 do
                  table.insert(elements, {label = dressing[i], value = i})
              end
              
              ESX.UI.Menu.Open(
              'default', GetCurrentResourceName(), 'remove_cloth',
              {
                title    = _U('remove_cloth'),
                align    = 'top-left',
                elements = elements,
              },
              function(data, menu)
                  menu.close()
                  TriggerServerEvent('esx_wardrobe:removeOutfit', data.current.value)
                  ESX.ShowNotification(_U('removed_cloth'))
              end,
              function(data, menu)
                menu.close()
              end
            )
          end)
      end

    end,
    function(data, menu)

      menu.close()

      CurrentAction     = 'room_menu'
      CurrentActionMsg  = _U('press_to_menu')
      CurrentActionData = {}
    end
  )

end


AddEventHandler('esx_wardrobe:hasEnteredMarker', function(zone)
  if zone == 'Wardrobe' then
    CurrentAction     = 'room_menu'
    CurrentActionMsg  = _U('press_to_menu')
    CurrentActionData = {}
  end
end)

AddEventHandler('esx_wardrobe:hasExitedMarker', function(name, part)
  ESX.UI.Menu.CloseAll()
  CurrentAction = nil
end)

-- Display markers
Citizen.CreateThread(function()
  while true do
    Wait(0)

    local coords = GetEntityCoords(GetPlayerPed(-1))
    for k,v in pairs(Config.Zones) do
        if v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance then
          DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
        end
    end

  end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function ()
  while true do
    Wait(1)

    local coords      = GetEntityCoords(GetPlayerPed(-1))
    local isInMarker  = false
    local currentZone = nil

    for k,v in pairs(Config.Zones) do
      if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
        isInMarker  = true
        currentZone = k
      end
    end

    if isInMarker and not hasAlreadyEnteredMarker then
      hasAlreadyEnteredMarker = true
      lastZone                = currentZone
      TriggerEvent('esx_wardrobe:hasEnteredMarker', currentZone)
    end

    if not isInMarker and hasAlreadyEnteredMarker then
      hasAlreadyEnteredMarker = false
      TriggerEvent('esx_wardrobe:hasExitedMarker', lastZone)
    end

  end
end)

-- Key controls
Citizen.CreateThread(function()
	while true do

		Citizen.Wait(10)

		if CurrentAction ~= nil then

			SetTextComponentFormat('STRING')
			AddTextComponentString(CurrentActionMsg)
			DisplayHelpTextFromStringLabel(0, 0, 1, -1)

			if IsControlJustReleased(0, Keys['E']) then
				if CurrentAction == 'room_menu' then
					OpenRoomMenu()
				end

				CurrentAction = nil
			end

		else -- no current action, sleep mode
			Citizen.Wait(500)
		end
	end
end)
