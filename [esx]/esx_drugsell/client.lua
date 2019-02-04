ESX                 = nil
local PlayerData              = {}
local myJob     = nil
local selling       = false
local has       = false
local copsc     = false
local enableAlert = true
local showcopsmisbehave = false

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end
  PlayerData = ESX.PlayerData
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

currentped = nil
Citizen.CreateThread(function()

while true do
  Wait(0)
  local player = GetPlayerPed(-1)
  local playerloc = GetEntityCoords(player, 0)
  local handle, ped = FindFirstPed()
  repeat
    success, ped = FindNextPed(handle)
    local pos = GetEntityCoords(ped)
    local distance = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, playerloc['x'], playerloc['y'], playerloc['z'], true)
    if IsPedInAnyVehicle(GetPlayerPed(-1)) == false then
      if DoesEntityExist(ped)then
        if IsPedDeadOrDying(ped) == false and IsEntityDead(player) == false then
          if IsPedInAnyVehicle(ped) == false then
            local pedType = GetPedType(ped)
            if pedType ~= 28 and pedType ~= 6 and pedType ~= 20 and IsPedAPlayer(ped) == false then
              currentped = pos
              if distance <= 2 and ped  ~= GetPlayerPed(-1) and ped ~= oldped then
                TriggerServerEvent('checkD')
                if has == true then
                  drawTxt(0.90, 1.40, 1.0,1.0,0.4, "Press ~g~E ~w~to sell drugs", 255, 255, 255, 255)
                  if IsControlJustPressed(1, 86) then
                      oldped = ped
                      SetEntityAsMissionEntity(ped)
                      TaskStandStill(ped, 9.0)
                      pos1 = GetEntityCoords(ped)
                      TriggerServerEvent('drugs:trigger')
                      Citizen.Wait(2850)
                      TriggerEvent('sell', oldped)
                      SetPedAsNoLongerNeeded(oldped)
                  end
                end
              end
            end
          end
        end
      end
    end
  until not success
  EndFindPed(handle)
end
end)

RegisterNetEvent('sell')
AddEventHandler('sell', function(pedId)
    local player = GetPlayerPed(-1)
    local playerloc = GetEntityCoords(player, 0)
    local distance = GetDistanceBetweenCoords(pos1.x, pos1.y, pos1.z, playerloc['x'], playerloc['y'], playerloc['z'], true)

    if distance <= 2 then
      TriggerServerEvent('drugs:sell', pedId)
    elseif distance > 2 then
      TriggerServerEvent('sell_dis')
    end
end)


RegisterNetEvent('checkR')
AddEventHandler('checkR', function(test)
  has = test
end)



-- RegisterNetEvent('notifyc')
-- AddEventHandler('notifyc', function()

--     local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
--     local plyPos = GetEntityCoords(GetPlayerPed(-1),  true)
--     local streetName, crossing = Citizen.InvokeNative( 0x2EB41072B4C1E4C0, plyPos.x, plyPos.y, plyPos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt() )
--     local streetName, crossing = GetStreetNameAtCoord(x, y, z)
--     streetName = GetStreetNameFromHashKey(streetName)
--   TriggerServerEvent('fetchjob')

--   if myJob == 'police' then
--     if crossing ~= nil then
--       crossing = GetStreetNameFromHashKey(crossing)
--       TriggerEvent('chatMessage', "^4911", {0, 153, 204}, "^7Someone was trying to sell me drugs on ^1" .. streetName .. " ^7and ^1" .. crossing .. " ^7please hurry")
--     else
--       TriggerEvent('chatMessage', "^4911", {0, 153, 204}, "^7Someone was trying to sell me drugs on ^1" .. streetName .. " ^7please hurry")
--     end
--   end
-- end)

RegisterNetEvent('notifyc')
AddEventHandler('notifyc', function()
    tellServer('sellDrugsInProgressPos', 'sellDrugsInProgressS1', 'sellDrugsInProgress')
end)

RegisterNetEvent('animation')
AddEventHandler('animation', function()
  local pid = PlayerPedId()
  RequestAnimDict("amb@prop_human_bum_bin@idle_b")
  while (not HasAnimDictLoaded("amb@prop_human_bum_bin@idle_b")) do Citizen.Wait(0) end
    TaskPlayAnim(pid,"amb@prop_human_bum_bin@idle_b","idle_d",100.0, 200.0, 0.3, 120, 0.2, 0, 0, 0)
    Wait(750)
    StopAnimTask(pid, "amb@prop_human_bum_bin@idle_b","idle_d", 1.0)
end)

function drawTxt(x,y ,width,height,scale, text, r,g,b,a, outline)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    if(outline)then
      SetTextOutline()
    end
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

-- OL
local blipSellDrugsTime = 120 --in second

function tellServer(sePos, seS1, se, extra)
	ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
		local sex = nil
		if skin.sex == 0 then
			sex = "male"
		else
			sex = "female"
		end
		local plyPos = GetEntityCoords(GetPlayerPed(-1),  true)
		local s1, s2 = Citizen.InvokeNative( 0x2EB41072B4C1E4C0, plyPos.x, plyPos.y, plyPos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt() )
		local street1 = GetStreetNameFromHashKey(s1)
		local street2 = GetStreetNameFromHashKey(s2)
		TriggerServerEvent(sePos, plyPos.x, plyPos.y, plyPos.z)
		if s2 == 0 then
			TriggerServerEvent(seS1, street1, sex, extra)
		elseif s2 ~= 0 then
			TriggerServerEvent(se, street1, street2, sex, extra)
		end
	end)
end

GetPlayerName()
RegisterNetEvent('outlawNotify')
AddEventHandler('outlawNotify', function(alert)
	if PlayerData.job ~= nil and PlayerData.job.name == 'police' then
        Notify(alert)
    end
end)

RegisterNetEvent('drugs:notify')
AddEventHandler('drugs:notify', function(alert)
    if PlayerData.job ~= nil and PlayerData.job.name == 'police' then
        TriggerEvent("pNotify:SetQueueMax", "drugsnotify", 10)
        TriggerEvent("pNotify:SendNotification", {
              text = alert,
              type = "error",
              queue = "drugsnotify",
              timeout = 6500,
              layout = "centerRight"
            })
    end
end)

RegisterNetEvent('drugs:notifyS1')
AddEventHandler('drugs:notifyS1', function(alert)
  
    if PlayerData.job ~= nil and PlayerData.job.name == 'police' then
        TriggerEvent("pNotify:SetQueueMax", "drugsnotify", 10)
        TriggerEvent("pNotify:SendNotification", {
              text = alert,
              type = "error",
              queue = "drugsnotify",
              timeout = 6500,
              layout = "centerRight"
            })
    end
end)

function Notify(text)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
    DrawNotification(false, false)
end

RegisterNetEvent('sellDrugsPlace')
AddEventHandler('sellDrugsPlace', function(tx, ty, tz)
	if PlayerData.job ~= nil and PlayerData.job.name == 'police' then
		if enableAlert then
			local transT = 250
			local sellDrugsBlip = AddBlipForCoord(tx, ty, tz)
			SetBlipSprite(sellDrugsBlip,  10)
			SetBlipColour(sellDrugsBlip,  1)
			SetBlipAlpha(sellDrugsBlip,  transT)
			SetBlipAsShortRange(sellDrugsBlip,  1)
			while transT ~= 0 do
				Wait(blipSellDrugsTime * 1)
				transT = transT - 1
				SetBlipAlpha(sellDrugsBlip,  transT)
				if transT == 0 then
					SetBlipSprite(sellDrugsBlip,  2)
					return
				end
			end
			
		end
	end
end)
