-- JUST EDIT THE CONFIG.LUA! -- JUST EDIT THE CONFIG.LUA! -- JUST EDIT THE CONFIG.LUA! -- JUST EDIT THE CONFIG.LUA!
-- JUST EDIT THE CONFIG.LUA! -- JUST EDIT THE CONFIG.LUA! -- JUST EDIT THE CONFIG.LUA! -- JUST EDIT THE CONFIG.LUA!
-- JUST EDIT THE CONFIG.LUA! -- JUST EDIT THE CONFIG.LUA! -- JUST EDIT THE CONFIG.LUA! -- JUST EDIT THE CONFIG.LUA!

-- DO NOT EDIT THESE! -- DO NOT EDIT THESE! -- DO NOT EDIT THESE! -- DO NOT EDIT THESE! -- DO NOT EDIT THESE!
-- DO NOT EDIT THESE! -- DO NOT EDIT THESE! -- DO NOT EDIT THESE! -- DO NOT EDIT THESE! -- DO NOT EDIT THESE!
-- DO NOT EDIT THESE! -- DO NOT EDIT THESE! -- DO NOT EDIT THESE! -- DO NOT EDIT THESE! -- DO NOT EDIT THESE!
-- DO NOT EDIT THESE! -- DO NOT EDIT THESE! -- DO NOT EDIT THESE! -- DO NOT EDIT THESE! -- DO NOT EDIT THESE!
-- DO NOT EDIT THESE! -- DO NOT EDIT THESE! -- DO NOT EDIT THESE! -- DO NOT EDIT THESE! -- DO NOT EDIT THESE!
-- DO NOT EDIT THESE! -- DO NOT EDIT THESE! -- DO NOT EDIT THESE! -- DO NOT EDIT THESE! -- DO NOT EDIT THESE!

-- Error Check
if DiscordWebhookSystemInfos == nil and DiscordWebhookKillinglogs == nil and DiscordWebhookChat == nil then
	local Content = LoadResourceFile(GetCurrentResourceName(), 'config.lua')
	Content = load(Content)
	Content()
end
if DiscordWebhookSystemInfos == 'WEBHOOK_LINK_HERE' then
	print('\n\nERROR\n' .. GetCurrentResourceName() .. ': Please add your "System Infos" webhook\n\n')
else
	PerformHttpRequest(DiscordWebhookSystemInfos, function(Error, Content, Head)
		if Content == '{"code": 50027, "message": "Invalid Webhook Token"}' then
			print('\n\nERROR\n' .. GetCurrentResourceName() .. ': "System Infos" webhook non-existent!\n\n')
		end
	end)
end
if DiscordWebhookKillinglogs == 'WEBHOOK_LINK_HERE' then
	print('\n\nERROR\n' .. GetCurrentResourceName() .. ': Please add your "Killing Log" webhook\n\n')
else
	PerformHttpRequest(DiscordWebhookKillinglogs, function(Error, Content, Head)
		if Content == '{"code": 50027, "message": "Invalid Webhook Token"}' then
			print('\n\nERROR\n' .. GetCurrentResourceName() .. ': "Killing Log" webhook non-existent!\n\n')
		end
	end)
end
if DiscordWebhookChat == 'WEBHOOK_LINK_HERE' then
	print('\n\nERROR\n' .. GetCurrentResourceName() .. ': Please add your "Chat" webhook\n\n')
else
	PerformHttpRequest(DiscordWebhookChat, function(Error, Content, Head)
		if Content == '{"code": 50027, "message": "Invalid Webhook Token"}' then
			print('\n\nERROR\n' .. GetCurrentResourceName() .. ': "Chat" webhook non-existent!\n\n')
		end
	end)
end
	
-- System Infos
PerformHttpRequest(DiscordWebhookSystemInfos, function(Error, Content, Head) end, 'POST', json.encode({username = SystemName, content = '**FiveM server webhook started**'}), { ['Content-Type'] = 'application/json' })

AddEventHandler('playerConnecting', function()
	TriggerEvent('DiscordBot:ToDiscord', 'system', SystemName, '```css\n' .. GetPlayerName(source) .. ' connecting\n```', 'system', source, false, false)
end)

AddEventHandler('playerDropped', function(Reason)
	TriggerEvent('DiscordBot:ToDiscord', 'system', SystemName, '```fix\n' .. GetPlayerName(source) .. ' left (' .. Reason .. ')\n```', 'system', source, false, false)
end)

-- Killing Log
RegisterServerEvent('DiscordBot:PlayerDied')
AddEventHandler('DiscordBot:PlayerDied', function(KillerId, Message, Weapon)
	local date = os.date('*t')
	
	if date.month < 10 then date.month = '0' .. tostring(date.month) end
	if date.day < 10 then date.day = '0' .. tostring(date.day) end
	if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end
	if date.min < 10 then date.min = '0' .. tostring(date.min) end
	if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end
	if Weapon then
		Message = Message .. ' [' .. Weapon .. ']'
	end
	local KillerSteamId = GetPlayerIdentifiers(KillerId)[1]
	TriggerEvent('DiscordBot:ToDiscord', 'kill', SystemName, KillerSteamId .. ' - ' .. Message .. ' `' .. date.day .. '.' .. date.month .. '.' .. date.year .. ' - ' .. date.hour .. ':' .. date.min .. ':' .. date.sec .. '`', 'system', source, false, false)
end)

-- Chat
AddEventHandler('chatMessage', function(Source, Name, Message)
	TriggerEvent('DiscordBot:ToDiscord', 'chat', Name .. ' [ID: ' .. Source .. ']', Message, 'steam', Source, false, false)
end)

--Event to actually send Messages to Discord
RegisterServerEvent('DiscordBot:ToDiscord')
AddEventHandler('DiscordBot:ToDiscord', function(WebHook, Name, Message, Image, Source, TTS, FromChatResource)
	if Message == nil or Message == '' then
		return nil
	end

	if WebHook:lower() == 'chat' then
		WebHook = DiscordWebhookChat
	elseif WebHook:lower() == 'system' then
		WebHook = DiscordWebhookSystemInfos
	elseif WebHook:lower() == 'kill' then
		WebHook = DiscordWebhookKillinglogs
	elseif not WebHook:find('discordapp.com/api/webhooks') then
		print('Please specify a webhook link!')
		return nil
	end
	
	if Image:lower() == 'user' then
		Image = UserAvatar
	elseif Image:lower() == 'system' then
		Image = SystemAvatar
	end
	
	if not TTS or TTS == '' then
		TTS = false
	end

	for i = 0, 9 do
		Name = Name:gsub('%^' .. i, '')
		Message = Message:gsub('%^' .. i, '')
	end

	MessageSplitted = stringsplit(Message, ' ')

	if FromChatResource and not IsCommand(MessageSplitted, 'Registered') then
		return nil
	end
	
	if not IsCommand(MessageSplitted, 'Blacklisted') and not (WebHook == DiscordWebhookSystemInfos or WebHook == DiscordWebhookKillinglogs) then
		--Checking if the message contains a command which has his own webhook
		if IsCommand(MessageSplitted, 'HavingOwnWebhook') then
			Webhook = GetOwnWebhook(MessageSplitted)
		end
		
		--Checking if the message contains a special command
		if IsCommand(MessageSplitted, 'Special') then
			MessageSplitted = ReplaceSpecialCommand(MessageSplitted)
		end
		
		---Checking if the message contains a command which belongs into a tts channel
		if IsCommand(MessageSplitted, 'TTS') then
			TTS = true
		end
		
		--Combining the message to one string again
		Message = table.concat(MessageSplitted, ' ')
		
		--Adding the username if needed
		if Source == 0 then
			Message = Message:gsub('USERNAME_NEEDED_HERE', 'Remote Console')
		else
			Message = Message:gsub('USERNAME_NEEDED_HERE', GetPlayerName(Source))
		end
		
		--Adding the userid if needed
		Message = Message:gsub('USERID_NEEDED_HERE', Source)
		
		-- Shortens the Name, if needed
		if Name:len() > 23 then
			Name = Name:sub(1, 23)
		end

		--Getting the steam avatar if available
		if not Source == 0 and GetIDFromSource('steam', Source) then
			PerformHttpRequest('http://steamcommunity.com/profiles/' .. tonumber(GetIDFromSource('steam', Source), 16) .. '/?xml=1', function(Error, Content, Head)
				local SteamProfileSplitted = stringsplit(Content, '\n')
				for i, Line in ipairs(SteamProfileSplitted) do
					if Line:find('<avatarFull>') then
						PerformHttpRequest(WebHook, function(Error, Content, Head) end, 'POST', json.encode({username = Name, content = Message, avatar_url = Line:gsub('	<avatarFull><!%[CDATA%[', ''):gsub(']]></avatarFull>', ''), tts = TTS}), {['Content-Type'] = 'application/json'})
						break
					end
				end
			end)
		else
			--Using the default avatar if no steam avatar is available
			PerformHttpRequest(WebHook, function(Error, Content, Head) end, 'POST', json.encode({username = Name, content = Message, avatar_url = Image, tts = TTS}), {['Content-Type'] = 'application/json'})
		end
	else
		PerformHttpRequest(WebHook, function(Error, Content, Head) end, 'POST', json.encode({username = Name, content = Message, avatar_url = Image, tts = TTS}), {['Content-Type'] = 'application/json'})
	end
end)

-- Functions
function IsCommand(String, Type)
	if Type == 'Blacklisted' then
		for Key, BlacklistedCommand in ipairs(BlacklistedCommands) do
			if String[1]:lower() == BlacklistedCommand:lower() then
				return true
			end
		end
	elseif Type == 'Special' then
		for Key, SpecialCommand in ipairs(SpecialCommands) do
			if String[1]:lower() == SpecialCommand[1]:lower() then
				return true
			end
		end
	elseif Type == 'HavingOwnWebhook' then
		for Key, OwnWebhookCommand in ipairs(OwnWebhookCommands) do
			if String[1]:lower() == OwnWebhookCommand[1]:lower() then
				return true
			end
		end
	elseif Type == 'TTS' then
		for Key, TTSCommand in ipairs(TTSCommands) do
			if String[1]:lower() == TTSCommand:lower() then
				return true
			end
		end
	elseif Type == 'Registered' then
		local RegisteredCommands = GetRegisteredCommands()
		for Key, RegisteredCommand in ipairs(GetRegisteredCommands()) do
			if String[1]:lower():gsub('/', '') == RegisteredCommand.name:lower() then
				return true
			end
		end
	end
	return false
end

function ReplaceSpecialCommand(String)
	for i, SpecialCommand in ipairs(SpecialCommands) do
		if String[1]:lower() == SpecialCommand[1]:lower() then
			String[1] = SpecialCommand[2]
		end
	end
	return String
end

function GetOwnWebhook(String)
	for i, OwnWebhookCommand in ipairs(OwnWebhookCommands) do
		if String[1]:lower() == OwnWebhookCommand[1]:lower() then
			if OwnWebhookCommand[2] == 'WEBHOOK_LINK_HERE' then
				print('Please enter a webhook link for the command: ' .. String[1])
				return DiscordWebhookChat
			else
				return OwnWebhookCommand[2]
			end
		end
	end
end

function stringsplit(input, seperator)
	if seperator == nil then
		seperator = '%s'
	end
	
	local t={} ; i=1
	
	for str in string.gmatch(input, '([^'..seperator..']+)') do
		t[i] = str
		i = i + 1
	end
	
	return t
end

function GetIDFromSource(Type, ID) --(Thanks To WolfKnight [forum.FiveM.net])
    local IDs = GetPlayerIdentifiers(ID)
    for k, CurrentID in pairs(IDs) do
        local ID = stringsplit(CurrentID, ':')
        if (ID[1]:lower() == string.lower(Type)) then
            return ID[2]:lower()
        end
    end
    return nil
end

-- Version Checking down here, better don't touch this
local CurrentVersion = '1.5.2'
local GithubResourceName = 'DiscordBot'

PerformHttpRequest('https://raw.githubusercontent.com/Flatracer/FiveM_Resources/master/' .. GithubResourceName .. '/VERSION', function(Error, NewestVersion, Header)
	PerformHttpRequest('https://raw.githubusercontent.com/Flatracer/FiveM_Resources/master/' .. GithubResourceName .. '/CHANGES', function(Error, Changes, Header)
		print('\n')
		print('##############')
		print('## ' .. GetCurrentResourceName())
		print('##')
		print('## Current Version: ' .. CurrentVersion)
		print('## Newest Version: ' .. NewestVersion)
		print('##')
		if CurrentVersion ~= NewestVersion then
			print('## Outdated')
			print('## Check the Topic')
			print('## For the newest Version!')
			print('##############')
			print('CHANGES:\n' .. Changes)
		else
			print('## Up to date!')
			print('##############')
		end
		print('\n')
	end)
end)

