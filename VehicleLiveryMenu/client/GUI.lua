GUI = {}
Menu = {}

GUI.maxVisOptions = 21

GUI.titleText = {255, 255, 255, 255, 1}
GUI.titleRect = {0, 51, 0, 255}
GUI.optionText = {255, 255, 255, 255, 6}
GUI.optionRect = {40, 40, 40, 190}
GUI.scroller = {127, 140, 140, 240}

local menuX = 0.825
local selectPressed = false
local leftPressed = false
local rightPressed = false
local currentOption = 1
local optionCount = 0

function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

function GUI.Text(text, color, position, size, center)
	SetTextCentre(center)
	SetTextColour(color[1], color[2], color[3], color[4])
	SetTextFont(1)
	SetTextScale(size[1], size[2])
	Citizen.InvokeNative(0x61BB1D9B3A95D802, 7)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(position[1], position[2])
end

function GUI.Rect(color, position, size)
	Citizen.InvokeNative(0x61BB1D9B3A95D802, 6)
	DrawRect(position[1], position[2], size[1], size[2], color[1], color[2], color[3], color[4])
end

function Menu.Title(title)
	GUI.Text(title, GUI.titleText, {menuX, 0.095}, {0.85, 0.85}, true)
	GUI.Rect(GUI.titleRect, {menuX, 0.1175}, {0.23, 0.085})
end

function Menu.Option(option)
	optionCount = optionCount + 1

	local thisOption = nil
	if(currentOption == optionCount) then
		FloatIntArray = false
		thisOption = true
	else
		thisOption = false
	end

	if(currentOption <= GUI.maxVisOptions and optionCount <= GUI.maxVisOptions) then
		GUI.Text(option, GUI.optionText, {menuX - 0.1, optionCount * 0.035 + 0.125},  {0.5, 0.5 }, false)
		GUI.Rect(GUI.optionRect, { menuX, optionCount * 0.035 + 0.1415 }, { 0.23, 0.035 })
		if(thisOption) then
			GUI.Rect(GUI.scroller, { menuX, optionCount * 0.035 + 0.1415 }, { 0.23, 0.035 })
		end
	elseif (optionCount > currentOption - GUI.maxVisOptions and optionCount <= currentOption) then
		GUI.Text(option, GUI.optionText, { menuX - 0.1, optionCount - (currentOption - GUI.maxVisOptions) * 0.035 + 0.125 }, { 0.5, 0.5 }, false);
		GUI.Rect(GUI.optionRect, { menuX, optionCount - (currentOption - GUI.maxVisOptions) * 0.035+0.1415 }, { 0.23, 0.035 });
		if(thisOption) then
			GUI.Rect(GUI.scroller, { menuX, optionCount - (currentOption - maxVisOptions) * 0.035 + 0.1415 }, { 0.23, 0.035 })
		end
	end

	if (optionCount == currentOption and selectPressed) then
		return true
	end

	return false
end

function Menu.Int(option, int, min, max, cb)
	Menu.Option(option)

	if (optionCount == currentOption) then
		FloatIntArray = true
		if (leftPressed) then
			if (int == min) then
				int = max
			elseif (int > min) then
				int = int - 1
			end
		end
		if (rightPressed) then
			if (int == max) then
				int = min
			elseif (int < max) then
				int = int + 1
			end
		end
	end

	if (currentOption <= GUI.maxVisOptions and optionCount <= GUI.maxVisOptions) then
		GUI.Text("< " .. tostring(int) .. " >", GUI.optionText, { menuX + 0.068, optionCount * 0.035 + 0.125 }, { 0.5, 0.5 }, true)
	elseif (optionCount > currentOption - GUI.maxVisOptions and optionCount <= currentOption) then
		GUI.Text("< " .. tostring(int) .. " >", GUI.optionText, { menuX + 0.068, optionCount - (currentOption - maxVisOptions) * 0.035 + 0.125 }, { 0.5, 0.5 }, true)
	end

	if (optionCount == currentOption and selectPressed) then
		cb(int)
		return true
	elseif (optionCount == currentOption and leftPressed) then
		cb(int)
		return true
	elseif (optionCount == currentOption and rightPressed) then
		cb(int)
		return true
	end

	return false
end

function Menu.updateSelection()
	selectPressed = false;
	leftPressed = false;
	rightPressed = false;

	if IsDisabledControlJustPressed(1, 173) then --Down
		if(currentOption < optionCount) then
			currentOption = currentOption + 1
		else
			currentOption = 1
		end
	elseif IsDisabledControlJustPressed(1, 172) then --Up
		if(currentOption > 1) then
			currentOption = currentOption - 1
		else
			currentOption = optionCount
		end
	elseif IsDisabledControlJustPressed(1, 174) then --Left
		leftPressed = true
	elseif IsDisabledControlJustPressed(1, 175) then --Right
		rightPressed = true
	elseif IsDisabledControlJustPressed(1, 176) then --Select
		selectPressed = true
	elseif (currentOption > optionCount) then
		currentOption = 1
	end
	optionCount = 0
end

function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end