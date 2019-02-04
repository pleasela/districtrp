ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_moneywash:withdraw')
AddEventHandler('esx_moneywash:withdraw', function(amount, selfWash)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	amount = tonumber(amount)
	local accountMoney = 0
	accountMoney = xPlayer.getAccount('black_money').money
	if amount == nil or amount <= 0 or amount > accountMoney then
		TriggerClientEvent('esx:showNotification', _source, _U('invalid_amount'))
	else
		xPlayer.removeAccountMoney('black_money', amount)
		local gainedCleanMoney = amount
		if (selfWash) then
			gainedCleanMoney = amount/100*80
			xPlayer.addMoney(gainedCleanMoney)
		else
			xPlayer.addMoney(gainedCleanMoney)
		end
		
		TriggerClientEvent('esx:showNotification', _source, _U('wash_money') .. amount .. '~s~.')
		TriggerClientEvent('esx_moneywash:closeWASH', _source)
	end
end)