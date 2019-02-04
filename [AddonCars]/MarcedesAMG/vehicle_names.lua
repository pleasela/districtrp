function AddTextEntry(key, value)
	Citizen.InvokeNative(GetHashKey("ADD_TEXT_ENTRY"), key, value)
end

Citizen.CreateThread(function()
	-- Challenger SRT Demon 2018
	AddTextEntry('0xBB5C46D8', 'Mercedes S63 AMG W222')
end)