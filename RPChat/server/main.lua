local cachedIdentity = {}

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1800000)
    cachedIdentity = {}
  end
end)

function getIdentity(source)
  local identifier = GetPlayerIdentifiers(source)[1]
  local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {['@identifier'] = identifier})
  if result[1] ~= nil then
    local identity = result[1]

    local returnIdentity = {
      identifier = identity['identifier'],
      firstname = identity['firstname'],
      lastname = identity['lastname'],
      dateofbirth = identity['dateofbirth'],
      sex = identity['sex'],
      height = identity['height'],
    }

    cachedIdentity[source] = returnIdentity

    return returnIdentity
  else
    return nil
  end
end

function getCachedIdentity(source)
  if (cachedIdentity[source]) then
    local identity = cachedIdentity[source]
    return {
      identifier = identity['identifier'],
      firstname = identity['firstname'],
      lastname = identity['lastname'],
      dateofbirth = identity['dateofbirth'],
      sex = identity['sex'],
      height = identity['height'],
    }
  else
    return getIdentity(source)
  end
end

  AddEventHandler('chatMessage', function(source, name, message)
      if string.sub(message, 1, string.len("/")) ~= "/" then
          local name = getCachedIdentity(source)
		TriggerClientEvent("sendProximityMessage", -1, source, name, message)
      end
      CancelEvent()
  end)
  
  RegisterCommand('me', function(source, args, user)
      local name = getCachedIdentity(source)
      TriggerClientEvent("sendProximityMessageMe", -1, source, "^*^1" ..  name.firstname .. " " .. name.lastname, "^1 " .. table.concat(args, " "))
  end, false)

  RegisterCommand('do', function(source, args, user)
      local name = getCachedIdentity(source)
      TriggerClientEvent("sendProximityMessageDo", -1, source, name.firstname .. " " .. name.lastname, table.concat(args, " "))
  end, false)

	-- Use ESX.TriggerServerCallback('esx_policejob:getOtherPlayerData', function(data) 
	-- If we want firstnames? Maybe keep a cache of names to prevent lots of database calls
  RegisterCommand('twt', function(source, args, user)
    local name = getCachedIdentity(source)
  	TriggerClientEvent('chatMessage', -1, "^0[^4Twitter^0] (^5@" .. name.firstname .. " " .. name.lastname .. "^0)", {30, 144, 255}, table.concat(args, " "))
  end, false)

  -- RegisterCommand('tor', function(source, args, user)
  --   local name = getCachedIdentity(source)
  --   TriggerClientEvent('chatMessage', -1, "^0[^4Twitter^0] (^5@Anonymous^0)", {30, 144, 255}, table.concat(args, " "))
  -- end, false)

  RegisterCommand('ad', function(source, args, user)
    local name = getCachedIdentity(source)
  	TriggerClientEvent('chatMessage', -1, "[ADVERT]: " .. name.firstname .. " " .. name.lastname, {255,215,0}, table.concat(args, " "))
  end, false)

function stringsplit(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t={} ; i=1
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end
