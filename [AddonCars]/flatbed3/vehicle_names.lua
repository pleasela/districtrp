function AddTextEntry(key, value)
	Citizen.InvokeNative(GetHashKey("ADD_TEXT_ENTRY"), key, value)
end

Citizen.CreateThread(function()
	-- flatbed3
	AddTextEntry('0x22CD2099', 'flatbed3')
	-- flatbed3
	AddTextEntry('0x58A38C45', 'flatbed3')
	-- flatbed3
	AddTextEntry('0x877A69F2', 'flatbed3')
	-- flatbed3
	AddTextEntry('0x74924422', 'flatbed3')
	-- flatbed3
	AddTextEntry('0xBB8B5213', 'flatbed3')
	-- flatbed3
	AddTextEntry('0xCDC5F688', 'flatbed3')
end)