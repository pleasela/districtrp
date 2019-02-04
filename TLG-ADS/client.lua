--[[------------------------------------------------------------------------
    Remove Reticle on ADS (Third Person) Resource created by TheLukasGran
------------------------------------------------------------------------]]--
local scopedWeapons =
{
	[100416529]=true,  -- WEAPON_SNIPERRIFLE
	[205991906]=true,  -- WEAPON_HEAVYSNIPER
	[3342088282]=true,  -- WEAPON_MARKSMANRIFLE
	[GetHashKey('WEAPON_HEAVYSNIPER_MK2')]=true,
}

--Unarmed 2725352035
function ManageReticle()
	local ped = GetPlayerPed(-1)

	if (DoesEntityExist(ped) and not IsEntityDead(ped)) then
		local _, hash = GetCurrentPedWeapon(ped, true)
		--print("Weapon Hash: " .. tostring(hash))
		if hash > 0 and not scopedWeapons[hash] then
			HideHudComponentThisFrame(14)
		end
	end
end

Citizen.CreateThread( function()
	while true do
		ManageReticle()
		Citizen.Wait(0)
	end
end)