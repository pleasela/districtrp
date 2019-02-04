local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F4"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}


local PlayerData			  = {}
local hasAlreadyEnteredMarker = false
local LastZone                = nil
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}
local GUI                     = {}

ESX                           = nil
GUI.Time                      = 0

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(1)
	end
end)

RegisterNetEvent('esx:playerLoaded') --get xPlayer
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)	
  PlayerData.job = job												
end)


-- RegisterNetEvent('esx_phone:loaded')
-- AddEventHandler('esx_phone:loaded', function (phoneNumber, contacts)
--   	local specialContact = {
--     	name       = 'Weazel News',
--     	number     = 'reporter',
--     	base64Icon = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAQAAAAEACAYAAABccqhmAAAACXBIWXMAAC4jAAAuIwF4pT92AAAGU2lUWHRYTUw6Y29tLmFkb2JlLnhtcAAAAAAAPD94cGFja2V0IGJlZ2luPSLvu78iIGlkPSJXNU0wTXBDZWhpSHpyZVN6TlRjemtjOWQiPz4gPHg6eG1wbWV0YSB4bWxuczp4PSJhZG9iZTpuczptZXRhLyIgeDp4bXB0az0iQWRvYmUgWE1QIENvcmUgNS42LWMxNDIgNzkuMTYwOTI0LCAyMDE3LzA3LzEzLTAxOjA2OjM5ICAgICAgICAiPiA8cmRmOlJERiB4bWxuczpyZGY9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkvMDIvMjItcmRmLXN5bnRheC1ucyMiPiA8cmRmOkRlc2NyaXB0aW9uIHJkZjphYm91dD0iIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtbG5zOmRjPSJodHRwOi8vcHVybC5vcmcvZGMvZWxlbWVudHMvMS4xLyIgeG1sbnM6cGhvdG9zaG9wPSJodHRwOi8vbnMuYWRvYmUuY29tL3Bob3Rvc2hvcC8xLjAvIiB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1sbnM6c3RFdnQ9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZUV2ZW50IyIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgQ0MgKFdpbmRvd3MpIiB4bXA6Q3JlYXRlRGF0ZT0iMjAxOC0wNi0xOVQwMjo0MDo0NyswODowMCIgeG1wOk1vZGlmeURhdGU9IjIwMTgtMDYtMTlUMDI6NDE6MzYrMDg6MDAiIHhtcDpNZXRhZGF0YURhdGU9IjIwMTgtMDYtMTlUMDI6NDE6MzYrMDg6MDAiIGRjOmZvcm1hdD0iaW1hZ2UvcG5nIiBwaG90b3Nob3A6Q29sb3JNb2RlPSIzIiBwaG90b3Nob3A6SUNDUHJvZmlsZT0ic1JHQiBJRUM2MTk2Ni0yLjEiIHhtcE1NOkluc3RhbmNlSUQ9InhtcC5paWQ6N2NiMDk3ZmEtNWNkYi1mNTRiLWE2NDMtYmVhNWExNjdjNWIwIiB4bXBNTTpEb2N1bWVudElEPSJhZG9iZTpkb2NpZDpwaG90b3Nob3A6ODVhNmZkZTYtY2NjNy1mMTRkLWE2MDItODAzMWFlZGIyN2Y1IiB4bXBNTTpPcmlnaW5hbERvY3VtZW50SUQ9InhtcC5kaWQ6ZWNlM2I1MDEtNGYzMS0zNjRjLThjM2ItMTdlYTA0NzczNGQ5Ij4gPHhtcE1NOkhpc3Rvcnk+IDxyZGY6U2VxPiA8cmRmOmxpIHN0RXZ0OmFjdGlvbj0iY3JlYXRlZCIgc3RFdnQ6aW5zdGFuY2VJRD0ieG1wLmlpZDplY2UzYjUwMS00ZjMxLTM2NGMtOGMzYi0xN2VhMDQ3NzM0ZDkiIHN0RXZ0OndoZW49IjIwMTgtMDYtMTlUMDI6NDA6NDcrMDg6MDAiIHN0RXZ0OnNvZnR3YXJlQWdlbnQ9IkFkb2JlIFBob3Rvc2hvcCBDQyAoV2luZG93cykiLz4gPHJkZjpsaSBzdEV2dDphY3Rpb249ImNvbnZlcnRlZCIgc3RFdnQ6cGFyYW1ldGVycz0iZnJvbSBhcHBsaWNhdGlvbi92bmQuYWRvYmUucGhvdG9zaG9wIHRvIGltYWdlL3BuZyIvPiA8cmRmOmxpIHN0RXZ0OmFjdGlvbj0ic2F2ZWQiIHN0RXZ0Omluc3RhbmNlSUQ9InhtcC5paWQ6N2NiMDk3ZmEtNWNkYi1mNTRiLWE2NDMtYmVhNWExNjdjNWIwIiBzdEV2dDp3aGVuPSIyMDE4LTA2LTE5VDAyOjQxOjM2KzA4OjAwIiBzdEV2dDpzb2Z0d2FyZUFnZW50PSJBZG9iZSBQaG90b3Nob3AgQ0MgKFdpbmRvd3MpIiBzdEV2dDpjaGFuZ2VkPSIvIi8+IDwvcmRmOlNlcT4gPC94bXBNTTpIaXN0b3J5PiA8L3JkZjpEZXNjcmlwdGlvbj4gPC9yZGY6UkRGPiA8L3g6eG1wbWV0YT4gPD94cGFja2V0IGVuZD0iciI/PkqvaKsAADCOSURBVHja7Z13fJRV1sdHRbCAq6hgFyuIICW0NJJAIKSXmUx6ZtILICqIErqAoiIqIIrCShEXXBFQpENooYZeE5IAtvVlV7GtZS3nPefOM2EIk2SSTHnK+eP3mRCSyTP3ued7T7v30YE+W8dSqAw5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'
-- 	}
--   	TriggerEvent('esx_phone:addSpecialContact', specialContact.name, specialContact.number, specialContact.base64Icon)
-- end)


function DisplayHelpText(str)
	BeginTextCommandDisplayHelp("STRING")
	AddTextComponentScaleform(str)
	EndTextCommandDisplayHelp(0, 0, 1, -1)
end

-- Create Blips
Citizen.CreateThread(function()
  local blip = AddBlipForCoord(Config.Zones.ReporterActions.Pos.x, Config.Zones.ReporterActions.Pos.y, Config.Zones.ReporterActions.Pos.z)
  SetBlipSprite (blip, 184)
  SetBlipDisplay(blip, 4)
  SetBlipScale  (blip, 0.9)
  SetBlipColour (blip, 1)
  SetBlipAsShortRange(blip, true)
  BeginTextCommandSetBlipName("STRING")
  AddTextComponentString("Weazel News")
  EndTextCommandSetBlipName(blip)
end)

-- Display markers
Citizen.CreateThread(function()
  while true do
    Wait(0)

    local coords = GetEntityCoords(GetPlayerPed(-1))
    for k,v in pairs(Config.Zones) do
        if(PlayerData.job ~= nil and PlayerData.job.name == 'reporter' and v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
        DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
        end
    end

  end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function ()
  while true do
    Wait(1)

    if(PlayerData.job ~= nil and PlayerData.job.name == 'reporter') then
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
        TriggerEvent('esx_propaganda:hasEnteredMarker', currentZone)
      end

      if not isInMarker and hasAlreadyEnteredMarker then
        hasAlreadyEnteredMarker = false
        TriggerEvent('esx_propaganda:hasExitedMarker', lastZone)
      end
    end

  end
end)

AddEventHandler('esx_propaganda:hasEnteredMarker', function (zone)
	if zone == 'ReporterActions' and PlayerData.job ~= nil and PlayerData.job.name == 'reporter' then
		CurrentAction = 'reporter_actions_menu'
		CurrentActionMsg  = 'Press ~INPUT_CONTEXT~ to access the actions menu.'
    CurrentActionData = {}
	end

  -- if zone == 'Garage' then
  --   CurrentAction     = 'mecano_harvest_menu'
  --   CurrentActionMsg  = _U('harvest_menu')
  --   CurrentActionData = {}
  -- end
end)

AddEventHandler('esx_propaganda:hasExitedMarker', function (zone)
	CurrentAction = nil
	ESX.UI.Menu.CloseAll()
end)

-- Open Gui and Focus NUI
function openGui()
  SendNUIMessage({openPropaganda = true})
  Citizen.CreateThread(function()
	Citizen.Wait(500)
	SetNuiFocus(true, true)
  end)
end

-- Close Gui and disable NUI

function closeGui()
  SetNuiFocus(false)
  SendNUIMessage({openPropaganda = false})
end

-- NUI Callback Methods
RegisterNUICallback('closePropaganda', function(data, cb)
  closeGui()
  cb('ok')
end)

RegisterNUICallback('postArticle', function(data, cb)
  
  TriggerServerEvent('esx_propaganda:postArticle', data)
  
  cb('ok')
end)

function openPropaganda()
	openGui()
end

RegisterNetEvent('esx_propaganda:openPropaganda')
AddEventHandler('esx_propaganda:openPropaganda', function()	
  openPropaganda()											
end)


function OpenReporterActionsMenu()
  local elements = {
    {label = 'Redeem Pay',   value = 'redeem_pay'},
  }

  if PlayerData.job.grade_name == 'boss' then
    table.insert(elements, {label = 'Boss Actions',   value = 'boss_actions'})
  end

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'reporter_actions',
    {
      title    = 'Reporter Actions',
      align    = 'bottom-right',
      elements = elements,
    },
    function (data, menu)
		if data.current.value == 'redeem_pay' then
      		TriggerServerEvent('esx_propaganda:getPaid', "ok")
    	end

		if data.current.value == 'boss_actions' then
			TriggerEvent('esx_society:openBossMenu', 'reporter', function(data, menu)
				menu.close()
			end)
		end
    end,
    function (data, menu)
      menu.close()

      CurrentAction     = 'reporter_actions_menu'
      CurrentActionMsg  = 'Press ~INPUT_CONTEXT~ to access the actions menu.'
      CurrentActionData = {}
    end
  )
end

function OpenReportersMenu()
  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'reporter_menu',
    {
      title    = "Reporter Menu",
      align    = 'bottom-right',
      elements = {
        {label = 'Write News', value = 'open_propaganda'},
        {label = 'Send Announcement', value = 'open_send_announcement'},
      },
    },
    function (data, menu)
      if data.current.value == 'open_propaganda' then
        openPropaganda()
      end

      if data.current.value == 'open_send_announcement' then
        OpenNewAnnouncementMenu()
      end

    end,
    function (data, menu)
      menu.close()

      CurrentAction     = 'reporter_menu'
      CurrentActionMsg  = ''
      CurrentActionData = {}
    end
  )
end

function OpenNewAnnouncementMenu()
  --set reason to announce
  ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'reporter_announce',
  {
    title = 'News Announcement Message'
  },
  function(data, menu)

    local announcementMessage = data.value

    if announcementMessage == nil then
      ESX.ShowNotification('Set news message')
    else
      menu.close()
      TriggerEvent('chatMessage', "[WEAZEL NEWS]", {166,253,255}, announcementMessage)
    end
  end,
  function(data, menu)
    menu.close()
  end)
end

function OpenDevicesMenu()
  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'devices',
    {
      title    = "Devices",
      align    = 'bottom-right',
      elements = {
        {label = 'Phone', value = 'open_phone'},
        {label = 'News Tablet', value = 'open_news'},
      },
    },
    function (data, menu)
      if data.current.value == 'open_phone' then
        TriggerEvent('esx_phone:open')
      end

      if data.current.value == 'open_news' then
        TriggerEvent('esx_news:openNews')
      end
    end,
    function (data, menu)
      menu.close()

      CurrentAction     = 'devices_menu'
      CurrentActionMsg  = ''
      CurrentActionData = {}
    end
  )
end

-- Key Controls
Citizen.CreateThread(function ()
  while true do
    Citizen.Wait(0)

    if IsControlPressed(0, Keys['~']) and GetLastInputMethod(2) and (GetGameTimer() - GUI.Time) > 150 then
        -- OpenDevicesMenu()
        TriggerEvent('esx_news:openNews')
        GUI.Time = GetGameTimer()
      end

    if IsControlPressed(0, Keys['F6']) and PlayerData.job ~= nil and PlayerData.job.name == 'reporter' and (GetGameTimer() - GUI.Time) > 150 then
     	OpenReportersMenu()
     	GUI.Time = GetGameTimer()
    end

    if CurrentAction ~= nil then
      SetTextComponentFormat('STRING')
      AddTextComponentString(CurrentActionMsg)
      DisplayHelpTextFromStringLabel(0, 0, 1, -1)

      if IsControlPressed(0, Keys['E']) and PlayerData.job ~= nil and PlayerData.job.name == 'reporter' and (GetGameTimer() - GUI.Time) > 150 then
        if CurrentAction == 'reporter_actions_menu' then
          OpenReporterActionsMenu()
        end

        CurrentAction = nil
        GUI.Time      = GetGameTimer()
      end
    end

  end
end)