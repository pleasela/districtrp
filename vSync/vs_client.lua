CurrentWeather = 'EXTRASUNNY'
local lastWeather = CurrentWeather
Time = {}
Time.h = 12
Time.m = 0
local freezeTime = false
local blackout = false
local firstTime = true

RegisterNetEvent('vSync:updateWeather')
AddEventHandler('vSync:updateWeather', function(NewWeather, newblackout)

	blackout = newblackout
	--ClearOverrideWeather()
	--ClearWeatherTypePersist()
	--SetBlackout(blackout)
	if CurrentWeather ~= NewWeather or firstTime then
		SetWeatherTypeOverTime(NewWeather, firstTime and 1.0 or 60.0)
	end
	firstTime = false
	CurrentWeather = NewWeather
end)

Citizen.CreateThread(function()
    TriggerServerEvent('vSync:requestSync',true)
end)

RegisterNetEvent('vSync:updateTime')
AddEventHandler('vSync:updateTime', function(hours, minutes, freeze)
    freezeTime = freeze
    Time.h = hours
    Time.m = minutes
end)

Citizen.CreateThread(function()
    while true do
        if not freezeTime then
            Citizen.Wait(2000)
            NetworkOverrideClockTime(Time.h, Time.m, 0)
            Time.m = Time.m + 1
            if Time.m > 59 then
                Time.m = 0
                Time.h = Time.h + 1
                if Time.h > 23 then
                    Time.h = 0
                end
            end
        else
            Citizen.Wait(0)
            NetworkOverrideClockTime(Time.h, Time.m, 0)
        end
    end
end)

AddEventHandler('playerSpawned', function()
    TriggerServerEvent('vSync:requestSync')
end)

Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/weather', 'Change the weather.', {{ name="weatherType", help="Available types: extrasunny, clear, neutral, smog, foggy, overcast, clouds, clearing, rain, thunder, snow, blizzard, snowlight, xmas & halloween"}})
    TriggerEvent('chat:addSuggestion', '/time', 'Change the time.', {{ name="hours", help="A number between 0 - 23"}, { name="minutes", help="A number between 0 - 59"}})
    TriggerEvent('chat:addSuggestion', '/freezetime', 'Freeze / unfreeze time.')
    TriggerEvent('chat:addSuggestion', '/freezeweather', 'Enable/disable dynamic weather changes.')
    TriggerEvent('chat:addSuggestion', '/morning', 'Set the time to 09:00')
    TriggerEvent('chat:addSuggestion', '/noon', 'Set the time to 12:00')
    TriggerEvent('chat:addSuggestion', '/evening', 'Set the time to 18:00')
    TriggerEvent('chat:addSuggestion', '/night', 'Set the time to 23:00')
    TriggerEvent('chat:addSuggestion', '/blackout', 'Toggle blackout mode.')
end)

-- Display a notification above the minimap.
function ShowNotification(text, blink)
    if blink == nil then blink = false end
    SetNotificationTextEntry("STRING")
    AddTextComponentSubstringPlayerName(text)
    DrawNotification(blink, false)
end

RegisterNetEvent('vSync:notify')
AddEventHandler('vSync:notify', function(message, blink)
    ShowNotification(message, blink)
end)
