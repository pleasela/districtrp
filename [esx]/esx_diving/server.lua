ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)



-------------Light Diving suit
ESX.RegisterUsableItem('plongee1', function(source)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    xPlayer.removeInventoryItem('plongee1', 1)
        TriggerClientEvent('esx_tenues:settenueplongee1', _source)
end)

-------------diving suit
ESX.RegisterUsableItem('plongee2', function(source)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    xPlayer.removeInventoryItem('plongee2', 1)
        TriggerClientEvent('esx_tenues:settenueplongee2', _source)
end)
