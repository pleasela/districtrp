AddEventHandler("chatMessage", function(source, n, message)
	local cm = stringsplit(message, " ")
	
	if cm[1] == "/get" then
		if cm[2] == "coords" then
			CancelEvent()
			TriggerClientEvent("SendCoords", source)
		end
	end
end)

function stringsplit(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end