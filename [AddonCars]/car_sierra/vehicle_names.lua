function AddTextEntry(key, value)
	Citizen.InvokeNative(GetHashKey("ADD_TEXT_ENTRY"), key, value)
end

Citizen.CreateThread(function()
	-- 2017 NISSAN GTR
	AddTextEntry('0xD8195844', 'GMC Sierra')
	
end)