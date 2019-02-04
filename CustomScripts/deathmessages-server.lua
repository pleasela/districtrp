function getIdentity(source)
  local identifier = GetPlayerIdentifiers(source)[1]
  local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {['@identifier'] = identifier})
  if result[1] ~= nil then
    local identity = result[1]

    return {
      identifier = identity['identifier'],
      firstname = identity['firstname'],
      lastname = identity['lastname'],
      dateofbirth = identity['dateofbirth'],
      sex = identity['sex'],
      height = identity['height']
    }
  else
    return nil
  end
end


AddEventHandler('playerConnecting', function()
	local identity = getIdentity(source)
	if (identity ~=nil) then
		TriggerClientEvent('showNotification', -1,"~b~".. identity.firstname .. " " .. identity.lastname .."~w~ is entering the city.")
	end
end)

AddEventHandler('playerDropped', function()
	local identity = getIdentity(source)
	if (identity ~=nil) then
		TriggerClientEvent('showNotification', -1,"~b~".. identity.firstname .. " " .. identity.lastname .."~w~ left the city.")
	end
end)
--Why not use baseevents:onPlayerKilled and baseevents:onPlayerDied? 
RegisterServerEvent('playerDied')
AddEventHandler('playerDied',function(killer,reason)
	local identity = getIdentity(source)

	if killer == "**Invalid**" then --Can't figure out what's generating invalid, it's late. If you figure it out, let me know. I just handle it as a string for now.
		reason = 2
	end
	if (identity ~=nil) then
		if reason == 0 then
			TriggerClientEvent('showNotification', -1,"~o~".. identity.firstname .. " " .. identity.lastname.."~w~ incapacitated. ")
		elseif reason == 1 then
			local killerIdentity = getIdentity(killer)
			-- TriggerClientEvent('showNotification', -1,"~o~".. killerIdentity.firstname .. " " .. killerIdentity.lastname .. "~w~ killed ~o~".. identity.firstname .. " " .. identity.lastname.."~w~.")
			TriggerClientEvent('showNotification', -1,"~o~".. killerIdentity.firstname .. " " .. killerIdentity.lastname .. "~w~ incapacitated ~o~".. identity.firstname .. " " .. identity.lastname.."~w~.")
		else
			TriggerClientEvent('showNotification', -1,"~o~".. identity.firstname .. " " .. identity.lastname .."~w~ is incapacitated.")
		end
	end
end)