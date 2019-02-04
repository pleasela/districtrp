RegisterServerEvent('hospital:price')
AddEventHandler('hospital:price', function()
  	local price = 750
	TriggerEvent('es:getPlayerFromId', source, function(user)
  	user:removeMoney((price))
 	end)
end)
