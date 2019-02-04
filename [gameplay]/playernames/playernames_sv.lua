local curTemplate
local curTags = {}
local hideTags = false

local function detectUpdates()
    SetTimeout(3000, detectUpdates)

    local template = GetConvar('playerNames_template', '[{{id}}] {{name}}')
    
    if curTemplate ~= template then
        setNameTemplate(-1, template)

        curTemplate = template
    end

    template = GetConvar('playerNames_svTemplate', '[{{id}}] {{name}}')

    --[[for _, v in ipairs(GetPlayers()) do
        local newTag = formatPlayerNameTag(v, template)

        if newTag ~= curTags[v] then
            setName(v, newTag)

            curTags[v] = newTag
        end
    end]]
end

TriggerEvent( 'es:addGroupCommand', 'nametags', 'admin', function( source, args, user )
	hideTags = not hideTags
	TriggerClientEvent("playernames:toggleTags", -1, hideTags)
	TriggerClientEvent( 'chatMessage', source, "Tags", { 200, 255, 200 }, "Name tags are now " .. (hideTags and "off" or "on"))
end, function( source, args, user )
	TriggerClientEvent( 'chatMessage', source, "SYSTEM", { 255, 0, 0 }, "Insufficient permissions!" )
end )

TriggerEvent( 'es:addGroupCommand', 'tags', 'admin', function( source, args, user )
	TriggerClientEvent("playernames:toggleTagsLocal", source)
end, function( source, args, user )
end, {help = "Toggle names over heads"})

RegisterNetEvent('playernames:init')
AddEventHandler('playernames:init', function()
	reconfigure(source)
	TriggerClientEvent('playernames:toggleTags', source, hideTags)
end)

SetTimeout(500, detectUpdates)
detectUpdates()