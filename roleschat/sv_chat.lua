--- DO NOT REMOVE ME FROM THE CONFIG, ITS THERE TO GIVE ME CREDIT WHEN I JOIN SERVERS.
--- DO NOT REMOVE ME FROM THE CONFIG, ITS THERE TO GIVE ME CREDIT WHEN I JOIN SERVERS.
--- DO NOT REMOVE ME FROM THE CONFIG, ITS THERE TO GIVE ME CREDIT WHEN I JOIN SERVERS.
--- DO NOT REMOVE ME FROM THE CONFIG, ITS THERE TO GIVE ME CREDIT WHEN I JOIN SERVERS.
--- DO NOT REMOVE ME FROM THE CONFIG, ITS THERE TO GIVE ME CREDIT WHEN I JOIN SERVERS.

--"",
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

local LeadAdmin = {
"steam:", 
"ip:",}
local Admin = {
"steam:",
"ip:",}
local HighwayPatrol = {}
local Police = {"steam:","ip:",}
local Fire = {"steam:","ip:",}
local EMS = {"steam:","ip:",}
local Moderator = {"steam:","ip:",}


TriggerEvent('es:addGroupCommand', 'adm', "admin", function(source, args, user)
  local identity = getCachedIdentity(source)
  TriggerClientEvent('chatMessage', -1, "OOC Admin | " .. identity.firstname .. " " .. identity.lastname, { 42,201,104 }, "" .. table.concat(args, " "))
end, function(source, args, user)
  TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Insufficient permissions!")
end, {help = "Speak with an admin tag", params = {{name = "message", help = "The message to speak with an admin tag"}}})

AddEventHandler('chatMessage', function(Source, Name, Msg)
    args = stringsplit(Msg, " ")
    CancelEvent()
    if string.find(args[1], "/") then
        local cmd = args[1]
        table.remove(args, 1)
    else     
        local player = GetPlayerIdentifiers(Source)[1]
        local identity = getCachedIdentity(Source)        
        if has_value(LeadAdmin, player) then
            TriggerClientEvent('chatMessage', -1, "OOC Lead Admin | " .. identity.firstname .. " " .. identity.lastname, { 0, 255, 194 }, Msg)
        elseif has_value(Admin, player) then
            TriggerClientEvent('chatMessage', -1, "OOC Admin | " .. identity.firstname .. " " .. identity.lastname, { 42,201,104 }, Msg)
        elseif has_value(Police, player) then
            TriggerClientEvent('chatMessage', -1, "Police | " .. Name, { 0, 0, 255 }, Msg)
        elseif has_value(Fire, player) then
            TriggerClientEvent('chatMessage', -1, "Fire | " .. Name, { 0, 0, 255 }, Msg)
        elseif has_value(EMS, player) then
            TriggerClientEvent('chatMessage', -1, "EMS | " .. Name, { 0, 0, 255 }, Msg)
	    elseif has_value(Moderator, player) then
            TriggerClientEvent('chatMessage', -1, "OOC Moderator | " .. identity.firstname .. " " .. identity.lastname, { 0, 255, 247 }, Msg)
        else
            TriggerClientEvent('chatMessage', -1, "OOC | " .. identity.firstname .. " " .. identity.lastname, { 128, 128, 128 }, Msg)
        end
            
    end
end)

function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

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