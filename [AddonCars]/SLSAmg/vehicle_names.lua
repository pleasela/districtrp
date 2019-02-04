function AddTextEntry(key, value)
	Citizen.InvokeNative(GetHashKey("ADD_TEXT_ENTRY"), key, value)
end

Citizen.CreateThread(function()
	-- Challenger SRT Demon 2018
	AddTextEntry('0x422F6B6F', 'Mercedes SLS AMG')
end)