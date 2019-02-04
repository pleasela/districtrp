--[[

-- ESX Voice
-- Original Author of Script: github.com/aabbfive
-- Edited by: nearbyplayer

--]]

local voice = {default = 12.0, shout = 24.0, whisper = 1.0, current = 0, level = nil}
local showVoiceHud = true

RegisterNetEvent('esx_voice:show')
AddEventHandler('esx_voice:show', function(show)
  showVoiceHud = show
end)

function drawLevel(r, g, b, a)
  SetTextFont(4)
  SetTextProportional(1)
  SetTextScale(0.5, 0.5)
  SetTextColour(r, g, b, a)
  SetTextDropShadow(0, 0, 0, 0, 255)
  SetTextEdge(1, 0, 0, 0, 255)
  SetTextDropShadow()
  SetTextOutline()
  SetTextEntry("STRING")
  AddTextComponentString("~y~Voice:~s~ " .. voice.level)
  DrawText(0.175, 0.92)
end

AddEventHandler('onClientMapStart', function()
  if voice.current == 0 then
    NetworkSetTalkerProximity(voice.default)
  elseif voice.current == 1 then
    NetworkSetTalkerProximity(voice.shout)
  elseif voice.current == 2 then
    NetworkSetTalkerProximity(voice.whisper)
  end
end)

Citizen.CreateThread(function()
  NetworkSetTalkerProximity(voice.default)
  while true do
    Citizen.Wait(0)
    if IsControlJustPressed(1, 74) and IsControlPressed(1, 21) then
      voice.current = (voice.current + 1) % 3
      if voice.current == 0 then
        NetworkSetTalkerProximity(voice.default)
        voice.level = "Normal"
      elseif voice.current == 1 then
        NetworkSetTalkerProximity(voice.shout)
        voice.level = "Shout"
      elseif voice.current == 2 then
        NetworkSetTalkerProximity(voice.whisper)
        voice.level = "Whisper"
      end
    end
    if voice.current == 0 then
      voice.level = "Normal"
    elseif voice.current == 1 then
      voice.level = "Shout"
    elseif voice.current == 2 then
      voice.level = "Whisper"
    end
    if showVoiceHud then
      if NetworkIsPlayerTalking(PlayerId()) then
        drawLevel(41, 128, 185, 255)
      elseif not NetworkIsPlayerTalking(PlayerId()) then
        drawLevel(185, 185, 185, 255)
      end
    elseif not showVoiceHud then
      drawLevel(0, 0, 0, 0)
    end
  end
end)
