local mpGamerTags = {}
local mpGamerTagSettings = {}

local gtComponent = {
    GAMER_NAME = 0,
    CREW_TAG = 1,
    healthArmour = 2,
    BIG_TEXT = 3,
    AUDIO_ICON = 4,
    MP_USING_MENU = 5,
    MP_PASSIVE_MODE = 6,
    WANTED_STARS = 7,
    MP_DRIVER = 8,
    MP_CO_DRIVER = 9,
    MP_TAGGED = 10,
    GAMER_NAME_NEARBY = 11,
    ARROW = 12,
    MP_PACKAGES = 13,
    INV_IF_PED_FOLLOWING = 14,
    RANK_TEXT = 15,
    MP_TYPING = 16
}

local function makeSettings()
    return {
        alphas = {},
        colors = {},
        healthColor = false,
        toggles = {},
        wantedLevel = false
    }
end

local templateStr
local hideTags = false
local personalHide = true

RegisterNetEvent('playernames:toggleTagsLocal')
AddEventHandler('playernames:toggleTagsLocal', function()
	personalHide = not personalHide
	if personalHide then
		removeAllTags()
	end
	TriggerEvent('chatMessage', "Tags", { 200, 255, 200 }, "Player names are now " .. (personalHide and "off" or "on"))
end)

RegisterNetEvent('playernames:toggleTags')
AddEventHandler('playernames:toggleTags', function(hidden)
	hideTags = hidden
	if hideTags then
		removeAllTags()
	end
end)

function updatePlayerNames()
    -- re-run this function the next frame
    SetTimeout(500, updatePlayerNames)

    -- return if no template string is set
    if not templateStr or hideTags or personalHide then
        return
    end

    -- get local coordinates to compare to
    local localCoords = GetEntityCoords(PlayerPedId())

    -- for each valid player index
    for i = 0, 64 do
        -- if the player exists
        if NetworkIsPlayerActive(i) and i ~= PlayerId() then
            -- get their ped
            local ped = GetPlayerPed(i)
            local pedCoords = GetEntityCoords(ped)

            -- make a new settings list if needed
            if not mpGamerTagSettings[i] then
                mpGamerTagSettings[i] = makeSettings()
            end

            -- check the ped, because changing player models may recreate the ped
            -- also check gamer tag activity in case the game deleted the gamer tag
            if not mpGamerTags[i] or mpGamerTags[i].ped ~= ped or not IsMpGamerTagActive(mpGamerTags[i].tag) then
                local nameTag = formatPlayerNameTag(i, templateStr)

                -- remove any existing tag
                if mpGamerTags[i] then
                    RemoveMpGamerTag(mpGamerTags[i].tag)
                end

                -- store the new tag
                mpGamerTags[i] = {
                    tag = CreateMpGamerTag(GetPlayerPed(i), nameTag, false, false, '', 0),
                    ped = ped
                }
            end

            -- store the tag in a local
            local tag = mpGamerTags[i].tag

            -- should the player be renamed? this is set by events
            if mpGamerTagSettings[i].rename then
                SetMpGamerTagName(tag, formatPlayerNameTag(i, templateStr))
                mpGamerTagSettings[i].rename = nil
            end

            -- check distance
            local distance = #(pedCoords - localCoords)

            -- show/hide based on nearbyness/line-of-sight
            -- nearby checks are primarily to prevent a lot of LOS checks
            if distance < 15 and HasEntityClearLosToEntity(PlayerPedId(), ped, 17) then
                SetMpGamerTagVisibility(tag, gtComponent.GAMER_NAME, true)
                SetMpGamerTagVisibility(tag, gtComponent.healthArmour, IsPlayerTargettingEntity(PlayerId(), ped))
                SetMpGamerTagVisibility(tag, gtComponent.AUDIO_ICON, NetworkIsPlayerTalking(i))

                SetMpGamerTagAlpha(tag, gtComponent.AUDIO_ICON, 255)
                SetMpGamerTagAlpha(tag, gtComponent.healthArmour, 255)

                -- override settings
                local settings = mpGamerTagSettings[i]

                for k, v in pairs(settings.toggles) do
                    SetMpGamerTagVisibility(tag, gtComponent[k], v)
                end

                for k, v in pairs(settings.alphas) do
                    SetMpGamerTagAlpha(tag, gtComponent[k], v)
                end

                for k, v in pairs(settings.colors) do
                    SetMpGamerTagColour(tag, gtComponent[k], v)
                end

                if settings.wantedLevel then
                    SetMpGamerTagWantedLevel(tag, settings.wantedLevel)
                end

                if settings.healthColor then
                    SetMpGamerTagHealthBarColour(tag, settings.healthColor)
                end
            else
                SetMpGamerTagVisibility(tag, gtComponent.GAMER_NAME, false)
                SetMpGamerTagVisibility(tag, gtComponent.healthArmour, false)
                SetMpGamerTagVisibility(tag, gtComponent.AUDIO_ICON, false)
            end
        elseif mpGamerTags[i] then
            RemoveMpGamerTag(mpGamerTags[i].tag)

            mpGamerTags[i] = nil
        end
    end
end

local function getSettings(id)
    local i = GetPlayerFromServerId(tonumber(id))

    if not mpGamerTagSettings[i] then
        mpGamerTagSettings[i] = makeSettings()
    end

    return mpGamerTagSettings[i]
end

RegisterNetEvent('playernames:configure')

AddEventHandler('playernames:configure', function(id, key, ...)
    local args = table.pack(...)

    if key == 'tglc' then
        getSettings(id).toggles[args[1]] = args[2]
    elseif key == 'seta' then
        getSettings(id).alphas[args[1]] = args[2]
    elseif key == 'setc' then
        getSettings(id).colors[args[1]] = args[2]
    elseif key == 'setw' then
        getSettings(id).wantedLevel = args[1]
    elseif key == 'sehc' then
        getSettings(id).healthColor = args[1]
    elseif key == 'rnme' then
        getSettings(id).rename = true
    elseif key == 'name' then
        getSettings(id).serverName = args[1]
        getSettings(id).rename = true
    elseif key == 'tpl' then
        for _, v in pairs(mpGamerTagSettings) do
            v.rename = true
        end

        templateStr = args[1]
    end
end)

AddEventHandler('playernames:extendContext', function(i, cb)
    cb('serverName', getSettings(GetPlayerServerId(i)).serverName)
end)

function removeAllTags()
	for i, v in pairs(mpGamerTags) do
		RemoveMpGamerTag(v.tag)
	end
	mpGamerTags = {}
end

AddEventHandler('onResourceStop', function(name)
	if name == GetCurrentResourceName() then
		removeAllTags()
	end
end)

SetTimeout(0, function()
	TriggerServerEvent('playernames:init')
end)

-- run this function every frame
SetTimeout(0, updatePlayerNames)