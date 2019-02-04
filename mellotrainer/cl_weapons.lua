--[[--------------------------------------------------------------------------
    *
    * Mello Trainer
    * (C) Michael Goodwin 2017
    * http://github.com/thestonedturtle/mellotrainer/releases
    *
    * This menu used the Scorpion Trainer as a framework to build off of.
    * https://github.com/pongo1231/ScorpionTrainer
    * (C) Emre Cürgül 2017
    * 
    * A lot of useful functionality has been converted from the lambda menu.
    * https://lambda.menu
    * (C) Oui 2017
    *
    * Additional Contributors:
    * WolfKnight (https://forum.fivem.net/u/WolfKnight)
    *
---------------------------------------------------------------------------]]

local playerPed = GetPlayerPed(-1) -- bad, each function should grab a new instance of the ped, or pass it as a param 

--[[------------------------------------------------------------------------
    Weapon Components 
------------------------------------------------------------------------]]--
local COMPONENTS = 
{
    [ "WEAPON_GRENADELAUNCHER" ] = { "COMPONENT_AT_SCOPE_SMALL", "COMPONENT_AT_AR_FLSH", "COMPONENT_AT_AR_AFGRIP" },
    [ "WEAPON_GRENADELAUNCHER_SMOKE" ] = { "COMPONENT_AT_SCOPE_SMALL", "COMPONENT_AT_AR_FLSH", "COMPONENT_AT_AR_AFGRIP" },
    [ "WEAPON_HEAVYSNIPER" ] = { "COMPONENT_AT_SCOPE_LARGE" }, 
    [ "WEAPON_MARKSMANRIFLE" ] = { "COMPONENT_MARKSMANRIFLE_CLIP_02", "COMPONENT_AT_AR_FLSH", "COMPONENT_AT_AR_SUPP", "COMPONENT_AT_AR_AFGRIP", "COMPONENT_MARKSMANRIFLE_VARMOD_LUXE" },
    [ "WEAPON_SNIPERRIFLE" ] = { "COMPONENT_AT_SCOPE_MAX", "COMPONENT_AT_AR_SUPP_02", "COMPONENT_SNIPERRIFLE_VARMOD_LUXE" },
    [ "WEAPON_ASSAULTSHOTGUN" ] = { "COMPONENT_ASSAULTSHOTGUN_CLIP_02", "COMPONENT_AT_AR_SUPP", "COMPONENT_AT_AR_AFGRIP", "COMPONENT_AT_AR_FLSH" },
    [ "WEAPON_BULLPUPSHOTGUN" ] = { "COMPONENT_BULLPUPRIFLE_CLIP_02", "COMPONENT_AT_AR_FLSH", "COMPONENT_AT_SCOPE_SMALL", "COMPONENT_AT_AR_SUPP", "COMPONENT_AT_AR_AFGRIP", "COMPONENT_BULLPUPRIFLE_VARMOD_LOW" },
    [ "WEAPON_HEAVYSHOTGUN" ] = { "COMPONENT_HEAVYSHOTGUN_CLIP_02", "COMPONENT_AT_AR_FLSH", "COMPONENT_AT_AR_SUPP_02", "COMPONENT_AT_AR_AFGRIP" },
    [ "WEAPON_PUMPSHOTGUN" ] = { "COMPONENT_AT_SR_SUPP", "COMPONENT_AT_AR_FLSH", "COMPONENT_PUMPSHOTGUN_VARMOD_LOWRIDER" },
    [ "WEAPON_SAWNOFFSHOTGUN" ] = { "COMPONENT_SAWNOFFSHOTGUN_VARMOD_LUXE" },
    [ "WEAPON_ADVANCEDRIFLE" ] = { "COMPONENT_ADVANCEDRIFLE_CLIP_02", "COMPONENT_AT_SCOPE_SMALL", "COMPONENT_AT_AR_SUPP", "COMPONENT_AT_AR_FLSH", "COMPONENT_ADVANCEDRIFLE_VARMOD_LUXE" },
    [ "WEAPON_ASSAULTRIFLE" ] = { "COMPONENT_ASSAULTRIFLE_CLIP_02", "COMPONENT_ASSAULTRIFLE_CLIP_03", "COMPONENT_AT_SCOPE_MACRO", "COMPONENT_AT_AR_SUPP_02", "COMPONENT_AT_AR_AFGRIP", "COMPONENT_AT_AR_FLSH", "COMPONENT_ASSAULTRIFLE_VARMOD_LUXE" },
    [ "WEAPON_BULLPUPRIFLE" ] = { "COMPONENT_AT_AR_FLSH", "COMPONENT_AT_AR_SUPP_02", "COMPONENT_AT_AR_AFGRIP" },
    [ "WEAPON_CARBINERIFLE" ] = { "COMPONENT_CARBINERIFLE_CLIP_02", "COMPONENT_CARBINERIFLE_CLIP_03", "COMPONENT_AT_SCOPE_MEDIUM", "COMPONENT_AT_AR_SUPP", "COMPONENT_AT_AR_AFGRIP", "COMPONENT_AT_AR_FLSH", "COMPONENT_AT_RAILCOVER_01", "COMPONENT_CARBINERIFLE_VARMOD_LUXE" },
    [ "WEAPON_COMPACTRIFLE" ] = { "COMPONENT_COMPACTRIFLE_CLIP_02", "COMPONENT_COMPACTRIFLE_CLIP_03" },
    [ "WEAPON_SPECIALCARBINE" ] = { "COMPONENT_SPECIALCARBINE_CLIP_02", "COMPONENT_SPECIALCARBINE_CLIP_03", "COMPONENT_AT_AR_FLSH", "COMPONENT_AT_SCOPE_MEDIUM", "COMPONENT_AT_AR_SUPP_02", "COMPONENT_AT_AR_AFGRIP" },
    [ "WEAPON_ASSAULTSMG" ] = { "COMPONENT_ASSAULTSMG_CLIP_02", "COMPONENT_AT_SCOPE_MACRO", "COMPONENT_AT_AR_SUPP_02", "COMPONENT_AT_AR_FLSH", "COMPONENT_ASSAULTSMG_VARMOD_LOWRIDER" },
    [ "WEAPON_COMBATMG" ] = { "COMPONENT_COMBATMG_CLIP_02", "COMPONENT_AT_SCOPE_MEDIUM", "COMPONENT_AT_AR_AFGRIP" },
    [ "WEAPON_COMBATPDW" ] = { "COMPONENT_COMBATPDW_CLIP_02", "COMPONENT_COMBATPDW_CLIP_03", "COMPONENT_AT_AR_FLSH", "COMPONENT_AT_SCOPE_SMALL", "COMPONENT_AT_AR_AFGRIP" },
    [ "WEAPON_GUSENBERG" ] = { "COMPONENT_GUSENBERG_CLIP_02" },
    [ "WEAPON_MACHINEPISTOL" ] = { "COMPONENT_MACHINEPISTOL_CLIP_02", "COMPONENT_MACHINEPISTOL_CLIP_03", "COMPONENT_AT_PI_SUPP" },
    [ "WEAPON_MG" ] = { "COMPONENT_MG_CLIP_02", "COMPONENT_AT_SCOPE_SMALL_02" },
    [ "WEAPON_MICROSMG" ] = { "COMPONENT_MICROSMG_CLIP_02", "COMPONENT_AT_SCOPE_MACRO", "COMPONENT_AT_AR_SUPP_02", "COMPONENT_AT_PI_FLSH", "COMPONENT_MICROSMG_VARMOD_LUXE" },
    [ "WEAPON_MINISMG" ] = { "COMPONENT_MINISMG_CLIP_02" },
    [ "WEAPON_SMG" ] = { "COMPONENT_SMG_CLIP_02", "COMPONENT_SMG_CLIP_03", "COMPONENT_AT_SCOPE_MACRO_02", "COMPONENT_AT_PI_SUPP", "COMPONENT_AT_AR_FLSH", "COMPONENT_SMG_VARMOD_LUXE" },
    [ "WEAPON_APPISTOL" ] = { "COMPONENT_APPISTOL_CLIP_02", "COMPONENT_AT_PI_SUPP", "COMPONENT_AT_PI_FLSH", "COMPONENT_APPISTOL_VARMOD_LUXE" },
    [ "WEAPON_COMBATPISTOL" ] = { "COMPONENT_COMBATPISTOL_CLIP_02", "COMPONENT_AT_PI_SUPP", "COMPONENT_AT_PI_FLSH", "COMPONENT_COMBATPISTOL_VARMOD_LOWRIDER" },
    [ "WEAPON_HEAVYPISTOL" ] = { "COMPONENT_HEAVYPISTOL_CLIP_02", "COMPONENT_AT_PI_FLSH", "COMPONENT_AT_PI_SUPP", "COMPONENT_HEAVYPISTOL_VARMOD_LUXE" },
    [ "WEAPON_MARKSMANPISTOL" ] = { "COMPONENT_REVOLVER_VARMOD_BOSS", "COMPONENT_REVOLVER_VARMOD_GOON" },
    [ "WEAPON_PISTOL" ] = { "COMPONENT_PISTOL_CLIP_02", "COMPONENT_AT_PI_SUPP_02", "COMPONENT_AT_PI_FLSH", "COMPONENT_PISTOL_VARMOD_LUXE" },
    [ "WEAPON_PISTOL50" ] = { "COMPONENT_PISTOL50_CLIP_02", "COMPONENT_AT_AR_SUPP_02", "COMPONENT_AT_PI_FLSH", "COMPONENT_PISTOL50_VARMOD_LUXE" },
    [ "WEAPON_SNSPISTOL" ] = { "COMPONENT_SNSPISTOL_CLIP_02", "COMPONENT_SNSPISTOL_VARMOD_LOWRIDER" },
    [ "WEAPON_VINTAGEPISTOL" ] = { "COMPONENT_VINTAGEPISTOL_CLIP_02", "COMPONENT_AT_PI_SUPP" },
    [ "WEAPON_KNUCKLE" ] = { "COMPONENT_KNUCKLE_VARMOD_BASE", "COMPONENT_KNUCKLE_VARMOD_PIMP", "COMPONENT_KNUCKLE_VARMOD_BALLAS", "COMPONENT_KNUCKLE_VARMOD_DOLLAR", "COMPONENT_KNUCKLE_VARMOD_DIAMOND", "COMPONENT_KNUCKLE_VARMOD_HATE", "COMPONENT_KNUCKLE_VARMOD_LOVE", "COMPONENT_KNUCKLE_VARMOD_PLAYER", "COMPONENT_KNUCKLE_VARMOD_KING", "COMPONENT_KNUCKLE_VARMOD_VAGOS" },
    [ "WEAPON_SWITCHBLADE" ] = { "COMPONENT_SWITCHBLADE_VARMOD_VAR1", "COMPONENT_SWITCHBLADE_VARMOD_VAR2" }
} 


--[[------------------------------------------------------------------------
    Loadout Saving and Loading 
------------------------------------------------------------------------]]--
local loadouts = {}
local loadoutsCount = 0 

-- event for grabbing info from server 

RegisterNUICallback( "loadsavedloadouts", function( data, cb )
    local validOptions = {}
 
    for k, v in pairs( loadouts ) do
        local loadoutOptions = CreateLoadoutOptions( k )

        table.insert( validOptions, 1, {
            [ "menuName" ] = v[ "saveName" ],
            [ "data" ] = {
                [ "sub" ] = k 
            },
            [ "submenu" ] = loadoutOptions
        } )
    end

    table.insert( validOptions, {
        [ "menuName" ] = "Create New Loadout Save", 
        [ "data" ] = {
            [ "action" ] = "loadoutsave"
        }
    } )
 
    local customJSON = "{}"

    if ( getTableLength( validOptions ) > 0 ) then
        customJSON = json.encode( validOptions, { indent = true } )
    end
 
    SendNUIMessage( {
        createmenu = true,
        menuName = "loadsavedloadouts",
        menudata = customJSON
    } )
   
    if ( cb ) then cb( "ok" ) end
end )

function GetWeaponComponentTable( weaponHash )
    for k, v in pairs( COMPONENTS ) do
        Citizen.Trace( k .. " ; " .. tostring( v ) )
        local hash = GetHashKey( k )

        if ( hash < 0 ) then 
            hash = hash + ( 2 ^ 32 )
        end 

        Citizen.Trace( hash .. " ; " .. weaponHash )

        if ( hash == weaponHash ) then 
            return v 
        end 
    end 

    return nil 
end 

RegisterNUICallback( "loadoutsave", function( data, cb ) 
    Citizen.CreateThread( function()
        local ped = GetPlayerPed( -1 )
        local loadoutTableData = {}
        local saveName = nil 
        local overwriting 
        local renaming 
        local index 

        if ( data.action == nil ) then 
            overwriting = false 
            renaming = false 
        else 
            if ( data.data[3] ~= nil ) then 
                renaming = true 
            else 
                overwriting = true 
            end 

            index = tonumber( data.action )
        end 

        if ( DoesEntityExist( ped ) and not IsEntityDead( ped ) ) then 
            while ( (saveName == nil and not overwriting) or (saveName == nil and renaming) ) do 
                saveName = requestInput( "Enter save name", 24 )
                Citizen.Wait( 1 )
            end 

            if ( saveName or overwriting or renaming ) then 
                local empty, model = GetCurrentPedWeapon( ped, true )

                if ( renaming or not overwriting ) then 
                    loadoutTableData[ "saveName" ] = saveName 
                else 
                    loadoutTableData[ "saveName" ] = loadouts[index][ "saveName" ]
                end 

                loadoutTableData[ "model" ] = tostring( model )

                local reserveAmmo = GetAmmoInPedWeapon( ped, model )
                local maxClipAmmo = GetMaxAmmoInClip( ped, model, true )

                loadoutTableData[ "reserveAmmo" ] = reserveAmmo
                loadoutTableData[ "maxClipAmmo" ] = maxClipAmmo

                local tintIndex = GetPedWeaponTintIndex( ped, model )

                loadoutTableData[ "tintIndex" ] = tintIndex

                local componentTable = GetWeaponComponentTable( model )

                Citizen.Trace( "Got table - " .. tostring( componentTable ) )

                -- use https://github.com/citizenfx/project-lambdamenu/blob/master/LambdaMenu/weapons.cpp#L720 for help 

                --[[if ( not renaming and not overwriting ) then 
                    loadoutsCount = loadoutsCount + 1
                    loadouts[loadoutsCount] = loadoutTableData
                    TriggerServerEvent( 'wk:DataSave', "loadouts", loadoutTableData, loadoutsCount )

                    SendNUIMessage({
                        reshowmenu = true 
                    })
                else 
                    loadouts[index] = loadoutTableData
                    TriggerServerEvent( 'wk:DataSave', "loadouts", loadoutTableData, index )

                    SendNUIMessage({
                        trainerback = true 
                    })

                    SendNUIMessage({
                        reshowmenu = true 
                    })
                end 

                resetTrainerMenus( "loadsavedloadouts" ) ]]--
            end 
        end 
    end )
end )

-- Max Clip
function maxAmmoWeapon(weaponName)
    local weapon = GetHashKey(weaponName)
    local ammoType = GetPedAmmoType(playerPed, weapon)
    if(HasPedGotWeapon(playerPed, weapon, 0))then
        -- SetPedAmmoByType(playerPed, ammoType, 9999)
        AddAmmoToPed( playerPed, weapon, 9999 )
        drawNotification("Max Ammo")
    end
end


-- Add Clip
function addWeaponClip(weaponName)
    local weapon = GetHashKey(weaponName)
    local ammoType = GetPedAmmoType(playerPed, weapon)

    if(HasPedGotWeapon(playerPed, weapon, 0))then
        -- local maxAmmo = GetWeaponClipSize(weapon)
        local maxAmmo = GetMaxAmmoInClip( playerPed, weapon, true )
        SetAmmoInClip(playerPed, weapon, maxAmmo) -- Refill Current Clip
        -- AddAmmoToPed(playerPed, weapon, maxAmmo)
        drawNotification("Ammo Clip Added")
    end
end


-- Equip/Remove weapon.
function toggleWeaponEquipped(weaponName)
    local weapon = GetHashKey(weaponName)
    if(HasPedGotWeapon(playerPed, weapon, 0))then
        RemoveWeaponFromPed(playerPed, weapon)
        drawNotification("Weapon Removed")
    else
        local ammoType = GetPedAmmoType(playerPed, weapon)
        local ammoAmmount = GetPedAmmoByType(playerPed, ammoType)

        local addClip = GetMaxAmmoInClip(playerPed, weapon, 1)
        if(ammoAmmount == 0) then
            GiveWeaponToPed(playerPed, weapon, addClip, true, true)
            drawNotification("Weapon Added")
            return
        elseif(ammoAmmount < addClip) then
            SetPedAmmoByType(playerPed, ammoType, addClip)
        end
        GiveWeaponToPed(playerPed, weapon, 0, true, true)
        drawNotification("Weapon Added")
        if(featurePlayerInfiniteAmmo)then
            toggleInfiniteAmmo(featurePlayerInfiniteAmmo)
        end
    end
end


-- Ensure they have the weapon.
function forceHasWeapon(weaponName)
    if(HasPedGotWeapon(playerPed, GetHashKey(weaponName)) == false)then
        toggleWeaponEquipped(weaponName)
    end

end


-- Toggle a weapon component on/off for a weapon.
function toggleWeaponComponent(weaponName,componentName)
    -- Citizen.Trace(weaponName.." "..componentName)
    local weapon = GetHashKey(weaponName)
    local component = GetHashKey(componentName)
    if(HasPedGotWeaponComponent(playerPed,weapon,component))then
        RemoveWeaponComponentFromPed(playerPed, weapon, component)
        drawNotification("Weapon Mod Removed")
    else
        GiveWeaponComponentToPed(playerPed, weapon, component)
        drawNotification("Weapon Mod Added")
    end

    maxAmmoWeapon( weaponName )
end


RegisterNUICallback("weapon", function(data)
    -- Update the current playerPed. Used inside functions.
    playerPed = GetPlayerPed(-1)
    local action = data.action
    local weaponString = data.data[3]

    if(action == "spawn") then
        toggleWeaponEquipped(weaponString)
        return
    elseif(action == "holdweapon")then
        local weapon = GetHashKey(weaponString)
        if(HasPedGotWeapon(playerPed,weapon))then
            SetCurrentPedWeapon(playerPed, weapon, 1)
        end
        return
    end

    if(action == "mod")then
        local modName = data.data[3]
        local weaponString = data.data[4]

        toggleWeaponComponent(weaponString, modName)

    elseif(action == "ammo")then
        local requestType = data.data[3]
        local weaponString = data.data[4]
        
        if(requestType == "add")then
            addWeaponClip(weaponString)
        elseif(requestType == "max")then
            maxAmmoWeapon(weaponString)
        end
    elseif(action == "tint")then
        local requestTint = data.data[3]
        local weaponString = data.data[4]

        SetPedWeaponTintIndex(playerPed,GetHashKey(weaponString), tonumber(requestTint))
        drawNotification("Weapon Tint Applied")

    elseif(action == "input")then
        local request = requestInput("",60)
        if(IsWeaponValid(GetHashKey(request)))then
            toggleWeaponEquipped(request)
        else
            drawNotification("Invalid Spawn Name")
        end
    else
        drawNotification("Error")
    end
end)




local allWeapons = {"WEAPON_KNIFE","WEAPON_KNUCKLE","WEAPON_NIGHTSTICK","WEAPON_HAMMER","WEAPON_BAT","WEAPON_GOLFCLUB","WEAPON_CROWBAR","WEAPON_BOTTLE","WEAPON_DAGGER","WEAPON_HATCHET","WEAPON_MACHETE","WEAPON_FLASHLIGHT","WEAPON_SWITCHBLADE","WEAPON_PISTOL","WEAPON_PISTOL_MK2","WEAPON_COMBATPISTOL","WEAPON_APPISTOL","WEAPON_PISTOL50","WEAPON_SNSPISTOL","WEAPON_HEAVYPISTOL","WEAPON_VINTAGEPISTOL","WEAPON_STUNGUN","WEAPON_FLAREGUN","WEAPON_MARKSMANPISTOL","WEAPON_REVOLVER","WEAPON_REVOLVER_MK2","WEAPON_MICROSMG","WEAPON_SMG","WEAPON_SMG_MK2","WEAPON_ASSAULTSMG","WEAPON_MG","WEAPON_COMBATMG","WEAPON_COMBATMG_MK2","WEAPON_COMBATPDW","WEAPON_GUSENBERG","WEAPON_MACHINEPISTOL","WEAPON_ASSAULTRIFLE","WEAPON_ASSAULTRIFLE_MK2","WEAPON_CARBINERIFLE","WEAPON_CARBINERIFLE_MK2","WEAPON_ADVANCEDRIFLE","WEAPON_SPECIALCARBINE","WEAPON_BULLPUPRIFLE","WEAPON_COMPACTRIFLE","WEAPON_PUMPSHOTGUN","WEAPON_SAWNOFFSHOTGUN","WEAPON_BULLPUPSHOTGUN","WEAPON_ASSAULTSHOTGUN","WEAPON_MUSKET","WEAPON_HEAVYSHOTGUN","WEAPON_DBSHOTGUN","WEAPON_SNIPERRIFLE","WEAPON_HEAVYSNIPER","WEAPON_HEAVYSNIPER_MK2","WEAPON_MARKSMANRIFLE","WEAPON_GRENADELAUNCHER","WEAPON_GRENADELAUNCHER_SMOKE","WEAPON_RPG","WEAPON_STINGER","WEAPON_MINIGUN","WEAPON_FIREWORK","WEAPON_RAILGUN","WEAPON_HOMINGLAUNCHER","WEAPON_GRENADE","WEAPON_STICKYBOMB","WEAPON_PROXMINE","WEAPON_BZGAS","WEAPON_SMOKEGRENADE","WEAPON_MOLOTOV","WEAPON_FIREEXTINGUISHER","WEAPON_PETROLCAN","WEAPON_SNOWBALL","WEAPON_FLARE","WEAPON_BALL"}


-- Toggle Infinite ammo for all weapons.
function toggleInfiniteAmmo(toggle)
    for i,v in ipairs(allWeapons) do
        local weapon = GetHashKey(v)
        SetPedInfiniteAmmo(playerPed, toggle, weapon)
    end 
end


-- Add All Weapons
function addAllWeapons()
    for i,v in ipairs(allWeapons) do
        forceHasWeapon(v)
    end 
end


-- Remove All Weapons
function removeAllWeapons()
    for i,v in ipairs(allWeapons) do
        local weapon = GetHashKey(v)
        RemoveWeaponFromPed(playerPed, weapon)
    end 
end


RegisterNUICallback("weaponoptions", function(data)
    -- Update the current playerPed. Used inside functions.
    playerPed = GetPlayerPed(-1)
    local action = data.action
    local weaponString = data.data[3]

    local text = "~r~OFF"
    if(data.newstate) then
        text = "~g~ON"
    end


    if(action == "infinitechutes")then
        featurePlayerInfiniteParachutes = data.newstate
        drawNotification("Infinite Parachutes: "..text)

    elseif(action == "noreload")then
        featurePlayerNoReload = data.newstate
        SetPedInfiniteAmmoClip(playerPed, featurePlayerNoReload)
        drawNotification("Infinite Clip: "..text)

    elseif(action == "infiniteammo")then
        featurePlayerInfiniteAmmo = data.newstate
        toggleInfiniteAmmo(featurePlayerInfiniteAmmo)
        drawNotification("Infinite Ammo: "..text)

    elseif(action == "addall")then
        addAllWeapons()
        drawNotification("Weapons Added")

    elseif(action == "removeall")then
        removeAllWeapons()
        drawNotification("Weapons Removed")
    end
end)


-- Citizen.CreateThread( function()
--     while true do 
--         SetPedInfiniteAmmo(GetPlayerPed(-1), true)
--         SetPedInfiniteAmmoClip(GetPlayerPed(-1), true)
--         SetPedAmmo(GetPlayerPed(-1), (GetSelectedPedWeapon(GetPlayerPed(-1))), 999)

--         Citizen.Wait( 0 )
--     end 
-- end )

-- Infinite Parachutes, checks 4 times per second
Citizen.CreateThread(function()
    while true do
        Wait(250)

        --Infinite Parachutes
        if(featurePlayerInfiniteParachutes)then
            local pState = GetPedParachuteState(playerPed)

            -- unarmed or falling - don't try and give p/chute to player already using one, crashes game
            if (pState == -1 or pState == 3)then
                GiveDelayedWeaponToPed(playerPed, 0xFBAB5776, 1, 0)
                SetPedParachuteTintIndex(PlayerPedId(), 6)
            end
        end
    end

end)