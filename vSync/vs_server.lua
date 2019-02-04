------------------ change this -------------------

admins = {
    'steam:11000010ce9daa1',
}

-- Set this to false if you don't want the weather to change automatically every 10 minutes.
DynamicWeather = true

--------------------------------------------------
debugprint = false -- don't touch this unless you know what you're doing or you're being asked by Vespura to turn this on.
--------------------------------------------------



-------------------- DON'T CHANGE THIS --------------------
AvailableWeatherTypes = {
    'EXTRASUNNY', 
    'CLEAR', 
    'NEUTRAL', 
    'SMOG', 
    'FOGGY', 
    'OVERCAST', 
    'CLOUDS', 
    'CLEARING', 
    'RAIN', 
    'THUNDER', 
    'SNOW', 
    'BLIZZARD', 
    'SNOWLIGHT', 
    'XMAS', 
    'HALLOWEEN',
}
CurrentWeather = "EXTRASUNNY"
Time = {}
Time.h = 12
Time.m = 0
local freezeTime = false
local blackout = false
local newWeatherTimer = 10

RegisterServerEvent('vSync:requestSync')
AddEventHandler('vSync:requestSync', function(own)
    TriggerClientEvent('vSync:updateWeather', own and source or -1, CurrentWeather, blackout)
    TriggerClientEvent('vSync:updateTime', own and source or -1, Time.h, Time.m, freezeTime)
end)

function isAllowedToChange(player)
    local allowed = false
    for i,id in ipairs(admins) do
        for x,pid in ipairs(GetPlayerIdentifiers(player)) do
            if debugprint then print('admin id: ' .. id .. '\nplayer id:' .. pid) end
            if string.lower(pid) == string.lower(id) then
                allowed = true
            end
        end
    end
    return allowed
end

RegisterCommand('freezetime', function(source, args)
    if source ~= 0 then
        if isAllowedToChange(source) then
            freezeTime = not freezeTime
            if freezeTime then
                TriggerClientEvent('vSync:notify', source, 'Time is now ~b~frozen~s~.')
            else
                TriggerClientEvent('vSync:notify', source, 'Time is ~y~no longer frozen~s~.')
            end
        else
            TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^8Error: ^1You are not allowed to use this command.')
        end
    else
        freezeTime = not freezeTime
        if freezeTime then
            print("Time is now frozen.")
        else
            print("Time is no longer frozen.")
        end
    end
end)

RegisterCommand('freezeweather', function(source, args)
    if source ~= 0 then
        if isAllowedToChange(source) then
            DynamicWeather = not DynamicWeather
            if not DynamicWeather then
                TriggerClientEvent('vSync:notify', source, 'Dynamic weather changes are now ~r~disabled~s~.')
            else
                TriggerClientEvent('vSync:notify', source, 'Dynamic weather changes are now ~b~enabled~s~.')
            end
        else
            TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^8Error: ^1You are not allowed to use this command.')
        end
    else
        DynamicWeather = not DynamicWeather
        if not DynamicWeather then
            print("Weather is now frozen.")
        else
            print("Weather is no longer frozen.")
        end
    end
end)

RegisterCommand('weather', function(source, args)
    if source == 0 then
        local validWeatherType = false
        if args[1] == nil then
            print("Invalid syntax, correct syntax is: /weather <weathertype> ")
            return
        else
            for i,wtype in ipairs(AvailableWeatherTypes) do
                if wtype == string.upper(args[1]) then
                    validWeatherType = true
                end
            end
            if validWeatherType then
                print("Weather has been upated.")
                CurrentWeather = string.upper(args[1])
                newWeatherTimer = 10
                TriggerEvent('vSync:requestSync')
            else
                print("Invalid weather type, valid weather types are: \nEXTRASUNNY CLEAR NEUTRAL SMOG FOGGY OVERCAST CLOUDS CLEARING RAIN THUNDER SNOW BLIZZARD SNOWLIGHT XMAS HALLOWEEN ")
            end
        end
    else
        if isAllowedToChange(source) then
            local validWeatherType = false
            if args[1] == nil then
                TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^8Error: ^1Invalid syntax, use ^0/weather <weatherType> ^1instead!')
            else
                for i,wtype in ipairs(AvailableWeatherTypes) do
                    if wtype == string.upper(args[1]) then
                        validWeatherType = true
                    end
                end
                if validWeatherType then
                    TriggerClientEvent('vSync:notify', source, 'Weather will change to: ~y~' .. string.lower(args[1]) .. "~s~.")
                    CurrentWeather = string.upper(args[1])
                    newWeatherTimer = 10
                    TriggerEvent('vSync:requestSync')
                else
                    TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^8Error: ^1Invalid weather type, valid weather types are: ^0\nEXTRASUNNY CLEAR NEUTRAL SMOG FOGGY OVERCAST CLOUDS CLEARING RAIN THUNDER SNOW BLIZZARD SNOWLIGHT XMAS HALLOWEEN ')
                end
            end
        else
            TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^8Error: ^1You do not have access to that command.')
            print('Access for command /weather denied.')
        end
    end
end, false)

RegisterCommand('blackout', function(source)
    if source == 0 then
        blackout = not blackout
        if blackout then
            print("Blackout is now enabled.")
        else
            print("Blackout is now disabled.")
        end
    else
        if isAllowedToChange(source) then
            blackout = not blackout
            if blackout then
                TriggerClientEvent('vSync:notify', source, 'Blackout is now ~b~enabled~s~.')
            else
                TriggerClientEvent('vSync:notify', source, 'Blackout is now ~r~disabled~s~.')
            end
            TriggerEvent('vSync:requestSync')
        end
    end
end)

RegisterCommand('morning', function(source)
    if source == 0 then
        print("For console, use the \"/time <hh> <mm>\" command instead!")
        return
    end
    if isAllowedToChange(source) then
        Time.h = 9
        Time.m = 0
        TriggerClientEvent('vSync:notify', source, 'Time set to ~y~morning~s~.')
        TriggerEvent('vSync:requestSync')
    end
end)
RegisterCommand('noon', function(source)
    if source == 0 then
        print("For console, use the \"/time <hh> <mm>\" command instead!")
        return
    end
    if isAllowedToChange(source) then
        Time.h = 12
        Time.m = 0
        TriggerClientEvent('vSync:notify', source, 'Time set to ~y~noon~s~.')
        TriggerEvent('vSync:requestSync')
    end
end)
RegisterCommand('evening', function(source)
    if source == 0 then
        print("For console, use the \"/time <hh> <mm>\" command instead!")
        return
    end
    if isAllowedToChange(source) then
        Time.h = 18
        Time.m = 0
        TriggerClientEvent('vSync:notify', source, 'Time set to ~y~evening~s~.')
        TriggerEvent('vSync:requestSync')
    end
end)
RegisterCommand('night', function(source)
    if source == 0 then
        print("For console, use the \"/time <hh> <mm>\" command instead!")
        return
    end
    if isAllowedToChange(source) then
        Time.h = 23
        Time.m = 0
        TriggerClientEvent('vSync:notify', source, 'Time set to ~y~night~s~.')
        TriggerEvent('vSync:requestSync')
    end
end)


RegisterCommand('time', function(source, args, rawCommand)
    if source == 0 then
        if tonumber(args[1]) ~= nil and tonumber(args[2]) ~= nil then
            local argh = tonumber(args[1])
            local argm = tonumber(args[2])
            if argh < 24 then
                Time.h = argh
            else
                Time.h = 0
            end
            if argm < 60 then
                Time.m = argm
            else
                Time.m = 0
            end
            print("Time has changed to " .. Time.h .. ":" .. Time.m .. ".")
            TriggerEvent('vSync:requestSync')
        else
            print("Invalid syntax, correct syntax is: time <hour> <minute> !")
        end
    elseif source ~= 0 then
        if isAllowedToChange(source) then
            if tonumber(args[1]) ~= nil and tonumber(args[2]) ~= nil then
                local argh = tonumber(args[1])
                local argm = tonumber(args[2])
                if argh < 24 then
                    Time.h = argh
                else
                    Time.h = 0
                end
                if argm < 60 then
                    Time.m = argm
                else
                    Time.m = 0
                end
                local newtime = Time.h .. ":"
                if Time.m < 10 then
                    newtime = newtime .. "0" .. Time.m
                else
                    newtime = newtime .. Time.m
                end
                TriggerClientEvent('vSync:notify', source, 'Time was changed to: ~y~' .. newtime .. "~s~!")
                TriggerEvent('vSync:requestSync')
            else
                TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^8Error: ^1Invalid syntax. Use ^0/time <hour> <minute> ^1instead!')
            end
        else
            TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^8Error: ^1You do not have access to that command.')
            print('Access for command /time denied.')
        end
    end
end)

--Allow variations in each pattern, -1 goes to next
local wPatternState = 0
--Timer in minutes for each pattern to last
local wNextUpdate = 0
--The current weather pattern
local wState = "Clear"

local weatherPatterns = {
	['Clear'] = { update = function()
		local wTime = math.random(2,4)
		if wPatternState == 0 then
			CurrentWeather = "EXTRASUNNY"
		elseif wPatternState == 1 then
			CurrentWeather = "CLEAR"
		elseif wPatternState == 2 then
			CurrentWeather = "EXTRASUNNY"
			wPatternState = -2
		end
		return wTime
	end, ending = function()
		--Pick something near clear randomly
		local rnd = math.random(1,10)
		if rnd < 4 then
			return 'Overcast'
		end
		return 'Cloudy'
	end},
	
	['Cloudy'] = { update = function()
		local wTime = math.random(3,4)
		if wPatternState == 0 then
			CurrentWeather = "CLOUDS"
		elseif wPatternState == 1 then
			CurrentWeather = "CLEAR"
		elseif wPatternState == 2 then
			CurrentWeather = "CLOUDS"
			wPatternState = -2
		end
		return wTime
	end, ending = function()
		local rnd = math.random(1,10)
		if rnd < 5 then
			return 'Clear'
		elseif rnd < 9 then
			return 'Overcast'
		end
		return 'LightRain'
	end},
	['Overcast'] = { update = function()
		local wTime = math.random(5,7)
		if wPatternState == 0 then
			CurrentWeather = "OVERCAST"
			wPatternState = -2
		end
		return wTime
	end, ending = function()
		local rnd = math.random(1,10)
		if rnd < 1 then
			return 'Storm'
		elseif rnd < 8 then
			return 'Clear'
		end
		return 'Cloudy'
	end},
	['Foggy'] = { update = function()
		local wTime = math.random(5,7)
		if wPatternState == 0 then
			CurrentWeather = "FOGGY"
			wPatternState = -2
		end
		return wTime
	end, ending = function()
		local rnd = math.random(1,10)
		if rnd < 4 then
			return 'Cloudy'
		end
		return 'Overcast'
	end},
	['LightRain'] = { update = function()
		local wTime = math.random(3,5)
		if wPatternState == 0 then
			CurrentWeather = "OVERCAST"
		elseif wPatternState == 1 then
			CurrentWeather = "RAIN"
		elseif wPatternState == 2 then
			CurrentWeather = "OVERCAST"
			wPatternState = -2
		end
		return wTime
	end, ending = function()
		local rnd = math.random(1,10)
		if rnd < 1 then
			return 'Storm2'
		elseif rnd < 8 then
			return 'Clear'
		end
		return 'Rain'
	end},
	['Rain'] = { update = function()
		local wTime = math.random(3,4)
		if wPatternState == 0 then
			CurrentWeather = "RAIN"
		elseif wPatternState == 1 then
			CurrentWeather = "RAIN"
		elseif wPatternState == 2 then
			CurrentWeather = "CLEARING"
			wTime = 1
			wPatternState = -2
		end
		return wTime
	end, ending = function()
		local rnd = math.random(1,10)
		if rnd < 1 then
			return 'Storm'
		end
		return 'Cloudy'
	end},
	['Storm'] = { update = function()
		local wTime = 1
		if wPatternState == 0 then
			CurrentWeather = "CLEARING"
		elseif wPatternState == 1 then
			CurrentWeather = "THUNDER"
		elseif wPatternState == 2 then
			CurrentWeather = "RAIN"
			wTime = 7
		elseif wPatternState == 3 then
			CurrentWeather = "CLEARING"
			wPatternState = -2
		end
		return wTime
	end, ending = function()
		local rnd = math.random(1,10)
		if rnd < 4 then
			return 'Overcast'
		end
		return 'Cloudy'
	end},
	['Storm2'] = { update = function()
		local wTime = 1
		if wPatternState == 0 then
			CurrentWeather = "CLEARING"
		elseif wPatternState == 1 then
			CurrentWeather = "RAIN"
			wTime = 7
		elseif wPatternState == 2 then
			CurrentWeather = "THUNDER"
		elseif wPatternState == 3 then
			CurrentWeather = "CLEARING"
			wPatternState = -2
		end
		return wTime
	end, ending = function()
		local rnd = math.random(1,10)
		if rnd < 4 then
			return 'Overcast'
		end
		return 'Foggy'
	end},
	--These are not used, but if we want snow from commands, it should work
	['LightSnow'] = { update = function()
		local wTime = math.random(2,4)
		if wPatternState == 0 then
			CurrentWeather = "CLOUDS"
		elseif wPatternState == 1 then
			CurrentWeather = "SNOWLIGHT"
		elseif wPatternState == 2 then
			CurrentWeather = "CLOUDS"
			wPatternState = -2
		end
		return wTime
	end, ending = function()
		--Pick something near LightSnow randomly
		return 'Cloudy'
	end},
	['Snow'] = { update = function()
		local wTime = math.random(2,4)
		if wPatternState == 0 then
			CurrentWeather = "SNOWLIGHT"
		elseif wPatternState == 1 then
			CurrentWeather = "SNOW"
		elseif wPatternState == 2 then
			CurrentWeather = "SNOWLIGHT"
			wPatternState = -2
		end
		return wTime
	end, ending = function()
		--Pick something near Snow randomly
		return 'Cloudy'
	end},
	--]]
}

local function updatePattern()
	wNextUpdate = wNextUpdate - 1
	--Is it time for a pattern update?
	if wNextUpdate <= 0 then
		--If this pattern is done, get the next one
		if wPatternState == -1 then
			wState = weatherPatterns[wState].ending()
			wPatternState = 0
		end
		--Update the current or new weather state
		wNextUpdate = weatherPatterns[wState].update()
		--Don't increment pattern if we are frozen
		if DynamicWeather then
			wPatternState = wPatternState + 1
		end
	end
end

--Update weather/time thread
Citizen.CreateThread(function()
	local clientTimer = 0
	while true do
		clientTimer = clientTimer + 1
		Citizen.Wait(2000)
		if not freezeTime then
			Time.m = Time.m + 1
			if Time.m > 59 then
				Time.m = 0
				Time.h = Time.h + 1
				if Time.h > 23 then
					Time.h = 0
				end
			end
		end
		
		--Update weather every 30x2 seconds, time every 3x2 seconds
		if (clientTimer%30) == 0 then
			updatePattern()
			TriggerClientEvent('vSync:updateWeather', -1, CurrentWeather, blackout)
			TriggerClientEvent('vSync:updateTime', -1, Time.h, Time.m, freezeTime)
		elseif (clientTimer%3) == 0 then
			TriggerClientEvent('vSync:updateTime', -1, Time.h, Time.m, freezeTime)
		end
	end
end)