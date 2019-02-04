ESX 		= nil
local myJob = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)



RegisterServerEvent('thiefInProgress')
AddEventHandler('thiefInProgress', function(street1, street2, sex, veh)
	if veh == "NULL" then
		TriggerClientEvent("outlawNotify", -1, "~r~Vehicle theft by ~w~"..sex.." ~r~between ~w~"..street1.."~r~ and ~w~"..street2)
	else
		TriggerClientEvent("outlawNotify", -1, "~r~Vehicle theft ~w~"..veh.." ~r~ by ~w~"..sex.." ~r~between ~w~"..street1.."~r~ and ~w~"..street2)
	end
end)

RegisterServerEvent('thiefInProgressS1')
AddEventHandler('thiefInProgressS1', function(street1, sex, veh)
	if veh == "NULL" then
		TriggerClientEvent("outlawNotify", -1, "~r~Vehicle theft by ~w~"..sex.." ~r~at ~w~"..street1)
	else
		TriggerClientEvent("outlawNotify", -1, "~r~Vehicle theft ~w~"..veh.." ~r~by ~w~"..sex.." ~r~at ~w~"..street1)
	end
end)

RegisterServerEvent('meleeInProgress')
AddEventHandler('meleeInProgress', function(street1, street2, sex)
	TriggerClientEvent("outlawNotify", -1, "~r~A fight broke out ~w~"..sex.." ~r~between ~w~"..street1.."~r~ and ~w~"..street2)
end)

RegisterServerEvent('meleeInProgressS1')
AddEventHandler('meleeInProgressS1', function(street1, sex)
	TriggerClientEvent("outlawNotify", -1, "~r~A fight broke out ~w~"..sex.." ~r~at ~w~"..street1)
end)


RegisterServerEvent('gunshotInProgress')
AddEventHandler('gunshotInProgress', function(street1, street2, sex)
	TriggerClientEvent("outlawNotify", -1, "~r~Shots fired by a ~w~"..sex.." ~r~between ~w~"..street1.."~r~ and ~w~"..street2)
end)

RegisterServerEvent('gunshotInProgressS1')
AddEventHandler('gunshotInProgressS1', function(street1, sex)
	TriggerClientEvent("outlawNotify", -1, "~r~Shots fired by a ~w~"..sex.." ~r~at ~w~"..street1)
end)

RegisterServerEvent('thiefInProgressPos')
AddEventHandler('thiefInProgressPos', function(tx, ty, tz)
	TriggerClientEvent('thiefPlace', -1, tx, ty, tz)
end)

RegisterServerEvent('gunshotInProgressPos')
AddEventHandler('gunshotInProgressPos', function(gx, gy, gz)
	TriggerClientEvent('gunshotPlace', -1, gx, gy, gz)
end)

RegisterServerEvent('meleeInProgressPos')
AddEventHandler('meleeInProgressPos', function(mx, my, mz)
	TriggerClientEvent('meleePlace', -1, mx, my, mz)
end)