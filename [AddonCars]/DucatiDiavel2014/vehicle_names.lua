function AddTextEntry(key, value)
	Citizen.InvokeNative(GetHashKey("ADD_TEXT_ENTRY"), key, value)
end

Citizen.CreateThread(function()
	-- Challenger SRT Demon 2018
	AddTextEntry('0x6400C100', 'Ducati Diavel 2014')
end)