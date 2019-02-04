dots = "hahah im not a dot i have fooled you!!!!1111"
Citizen.CreateThread(function()
	config = json.decode( LoadResourceFile(GetCurrentResourceName(), "config.json") )[1]
	
	PerformHttpRequest('http://api.steampowered.com/ISteamUser/GetPlayerBans/v1/?key='..config.APIKey..'&steamids=76561198081509001', function(statusCode, text, headers)
	    if statusCode == 403 then
				Citizen.Trace("\n--------------------------------")
				Citizen.Trace("\nPlayTrust is incorrectly configured!\nPlease verify that your Steam API Key is present/valid!")
				Citizen.Trace("\n--------------------------------\n")
	    end
	end, 'GET', json.encode({}), { ["Content-Type"] = 'application/json' })
	
	AddEventHandler('playerConnecting', function(name, setCallback, deferrals)
		local numIds = GetPlayerIdentifiers(source)
		deferrals.defer()
		deferrals.update("Checking Steam Account.")
		local s = source
		local n = name
		local deferrals = deferrals
		
		local decline = false
		Wait(100)
		local steamid = GetPlayerIdentifier(s,0)
		if not steamid then 
			Wait(1000)
			deferrals.done("Steam must be running to play on this server.")
			return 
		end
		if not string.find(steamid,"steam:") then
			Wait(1000)
			deferrals.done("Steam must be running to play on this server.")
			return
		end
		
		if #GetPlayers() == GetConvarInt("sv_maxclients", 32) then
			deferrals.done("This Server is Full.")
		end
		local steam64 = tonumber(string.gsub(steamid,"steam:", ""),16)
		if not steam64 then
			Wait(1000)
			deferrals.done("Steam must be running to play on this server.")
			return
		end

		
		local gotBans = false -- make sure we wait for our response
		local vacBans = false
		local vacBanned = false
		PerformHttpRequest('http://api.steampowered.com/ISteamUser/GetPlayerBans/v1/?key='..config.APIKey..'&steamids='..steam64..'', function(statusCode, text, headers)
		    if text then
		        local info = json.decode(text)
												
						vacBanned = info['players'][1]['VACBanned']
		        vacBans = info['players'][1]['NumberOfVACBans']

				if info['players'][1]['DaysSinceLastBan'] > config.MaxDaysSinceLastBan then
					vacBanned = false
				end

				gotBans = true
		    end
		end, 'GET', json.encode({}), { ["Content-Type"] = 'application/json' })
		
		deferrals.update("Checking Steam Account..")
		Wait(1000)
		deferrals.update("Checking Steam Account...")
		dots = "..."
		Wait(1000)
		local gotAccountAge = false -- make sure we wait for our response
		local timecreated = false
		PerformHttpRequest('http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key='..config.APIKey..'&steamids='..steam64..'', function(statusCode, text, headers)
		    if text then
		        local info = json.decode(text)
						if info['response']['players'][1]['timecreated'] then
							timecreated = info['response']['players'][1]['timecreated']
						else
							timecreated = false
						end
						profileVisibility = info['response']['players'][1]['communityvisibilitystate']
						gotAccountAge = true
		    end
		end, 'GET', json.encode({}), { ["Content-Type"] = 'application/json' })
		
		local playtime = false
		PerformHttpRequest('http://api.steampowered.com/IPlayerService/GetRecentlyPlayedGames/v0001/?key='..config.APIKey..'&steamid='..steam64..'´&format=json', function(statusCode, text, headers)
			if text then
	        local response = json.decode(text)
	        local data = response['response']
					if data.games then
		        for i,v in pairs(data.games) do
								if v.appid == 218 then
		            	playtime = math.ceil(v.playtime_forever / 60)
									break
								end
		        end
					end
	    end
		end, 'GET', json.encode({}), { ["Content-Type"] = 'application/json' })
		
		local gotOwnedGames = false
		local ownedGames = 0
		local globalplaytime = false
		PerformHttpRequest('http://api.steampowered.com/IPlayerService/GetOwnedGames/v0001/?key='..config.APIKey..'&steamid='..steam64..'´&format=json', function(statusCode, text, headers)
			if text then
	        local response = json.decode(text)
	        local data = response['response']
					if data.games then
						globalplaytime = 0
						for i,a in pairs(data.games) do
							if a.playtime_forever then
								globalplaytime = globalplaytime+a.playtime_forever 
							end
						end
					end
					
					if not globalplaytime or globalplaytime == 0 then
						globalplaytime = 9999 -- user game data is private, this is a dirty hack to fix this issue
					end
					
					ownedGames = data.game_count
					gotOwnedGames = true
	    end
		end, 'GET', json.encode({}), { ["Content-Type"] = 'application/json' })
		
		deferrals.update("Checking Steam Account."..dots)
		repeat
			Wait(500)
			dots = dots.."."
			if string.len(dots) > 20 then
				deferrals.update("Taking too long? Try Reconnecting or Contact the Server Owner!")
			else
				deferrals.update("Checking Steam Account"..dots)
			end
		until (gotBans and gotAccountAge and gotOwnedGames)
		dots = dots.."."
		deferrals.update("Checking Steam Account"..dots)
		Wait(500)
		local strikes = 0
		string = "You are not allowed to join this server, reason(s): "
		if config.EnableVACBans and vacBanned and vacBans >= config.MaxVACCount then
			string = string.."[Error 1] More than ".. config.MaxVACCount-1 .." VAC Ban(s) on Record "
			decline = true
			strikes = strikes+1
		end
		if config.EnableAccountAgeCheck and timecreated and (os.time() - timecreated) < config.MinimumAccountAge then
			string = string.."[Error 2] Account is younger than "..config.MinimumAccountAgeLabel..", contact an administrator on Discord for help"
			decline = true
			strikes = strikes+1
		end
		if config.EnableMinimumPlaytime and playtime and playtime < config.MinimumPlaytimeHours then
			string = string.."[Error 3] Less than "..config.MinimumPlaytimeHours.." hours playtime on FiveM ("..config.MinimumPlaytimeHours-playtime.." hours left)"
			decline = true
			strikes = strikes+1
		end 
		if config.EnableMinimumOwnedGames and ownedGames and ownedGames < config.MinimumOwnedGames then
			string = string.."[Error 4] Less than "..config.MinimumOwnedGames.." owned Games on Steam ("..config.MinimumOwnedGames-ownedGames.." games missing)"
			decline = true
			strikes = strikes+1
		end
		if globalplaytime and config.MinimumTotalPlaytimeHours > globalplaytime then
			string = string.."[Error 5] Less than "..config.MinimumTotalPlaytimeHours.." hours played on Steam ("..config.MinimumTotalPlaytimeHours-globalplaytime.." hours left)"
			decline = true
			strikes = strikes+1
		end
		if profileVisibility == 1 and (not globalplaytime or not playtime or not timecreated) then
			string = string.."[Error 6] Steam Account checks Failed, please set your Steam Profile to 'Public' and rejoin the Server."
			decline = true
			strikes = strikes+1
		end

		
		if decline and strikes >= config.MaxStrikes then
			deferrals.done(string)
		else
			deferrals.done()
		end
	end)
end)
