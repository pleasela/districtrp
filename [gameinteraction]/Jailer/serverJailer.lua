local defaultmins = 3
local maxminutes = 100
local ESX

local inJail = {}

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

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local function canUseJail(xPlayer, group)
	local isAdmin = group == "admin" or group == "superadmin"
	if xPlayer.job.name ~= "police" and not isAdmin then
		return false
	end
	return true
end

local function doJail(source, target, length, jailReason)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not canUseJail(xPlayer, xPlayer.getGroup()) then
		TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Insufficient Permissions.")
		return
	end
	CancelEvent()
	local jailTime = length or defaultmins
	if jailTime > maxminutes then
		jailTime = maxminutes
	end
	if GetPlayerName(target) ~= nil then
		local identity = getIdentity(target)
		local jailerIdentity = getIdentity(source)
		print("Jailing ".. identity.firstname .. " " .. identity.lastname .. " for ".. jailTime .." minutes - By ".. jailerIdentity.firstname .. " " .. jailerIdentity.lastname)
		TriggerClientEvent("JP", target, jailTime)
		TriggerClientEvent('chatMessage', -1, 'JUDGE', { 0, 0, 0 }, "^*^4" .. identity.firstname .. " " .. identity.lastname ..' ^rjailed for '.. jailTime ..' minutes for ^*^4' .. jailReason)
		local xTarget = ESX.GetPlayerFromId(target)
		inJail[xTarget.getIdentifier()] = jailTime
	else
		print("Invalid target id")
	end
end

RegisterServerEvent('Jailer:jail')
AddEventHandler('Jailer:jail', function(target, length, jailReason)
	doJail(source, target, length, jailReason)
end)

RegisterServerEvent('Jailer:leftJail')
AddEventHandler('Jailer:leftJail', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	inJail[xPlayer.getIdentifier()] = nil

	local identity = getIdentity(source)
	TriggerClientEvent('chatMessage', -1, 'NEWS', { 0, 0, 255 }, '^*^4' .. identity.firstname .. " " .. identity.lastname .." ^rwas released from jail.")
end)

RegisterServerEvent('Jailer:setJailSave')
AddEventHandler('Jailer:setJailSave', function(length)
	local xPlayer = ESX.GetPlayerFromId(source)
	inJail[xPlayer.getIdentifier()] = length
end)

ESX.RegisterServerCallback('Jailer:checkJail', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if inJail[xPlayer.getIdentifier()] then
		--Reconnected while jailed
		cb(true, inJail[xPlayer.getIdentifier()])
		return
	end
	cb(false)
end)

TriggerEvent( 'es:addGroupCommand', 'jail', 'user', function( source, args, user )
	doJail(source, tonumber(args[1]), tonumber(args[2]), args[3])
	TriggerEvent('esx_policejob:handcuff', tonumber(args[1]), true, false)
end, function( source, args, user )
end, {help = "Jails a user", params = {{name = 'TargetID'},{name = "JailTime"}, { name= 'Reason'}}})

TriggerEvent( 'es:addGroupCommand', 'unjail', 'user', function( source, args, user )
	local xPlayer = ESX.GetPlayerFromId(source)
	if not canUseJail(xPlayer, user.getGroup()) then
		TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Insufficient Permissions.")
		return
	end
	CancelEvent()
	local jailTarget = tonumber(args[1])
	if GetPlayerName(jailTarget) ~= nil then
		local identity = getIdentity(jailTarget)
		local unjailerIdentity = getIdentity(source)
		print("Unjailing ".. identity.firstname .. " " .. identity.lastname .. " - By ".. unjailerIdentity.firstname .. " " .. unjailerIdentity.lastname)
		TriggerClientEvent("UnJP", jailTarget)
	else
		print("Invalid target id")
	end
end, function( source, args, user )
end, {help = "Stop jailing a user", params = {{name = 'TargetID'}}})
