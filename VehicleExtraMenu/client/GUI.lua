GUI = {}
Menu = {}

GUI.maxVisOptions = 16

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
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(position[1], position[2])
end

function GUI.Rect(color, position, size)
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

function Menu.Bool(option, bool, cb)
	Menu.Option(option)

	if(currentOption <= GUI.maxVisOptions and optionCount <= GUI.maxVisOptions) then
		if(bool) then
			GUI.Text("~g~ON", GUI.optionText, { menuX + 0.068, optionCount * 0.035 + 0.125 }, { 0.5, 0.5 }, true)
		else
			GUI.Text("~r~OFF", GUI.optionText, { menuX + 0.068, optionCount * 0.035 + 0.125 }, { 0.5, 0.5 }, true)
		end
	elseif(optionCount > currentOption - GUI.maxVisOptions and optionCount <= currentOption) then
		if(bool) then
			GUI.Text("~g~ON", GUI.optionText, { menuX + 0.068, optionCount - (currentOption - GUI.maxVisOptions) * 0.035 + 0.125 }, { 0.5, 0.5 }, true)
		else
			GUI.Text("~r~OFF", GUI.optionText, { menuX + 0.068, optionCount - (currentOption - GUI.maxVisOptions) * 0.035 + 0.125 }, { 0.5, 0.5 }, true)
		end
	end

	if (optionCount == currentOption and selectPressed) then
		cb(not bool)
		return true
	end

	return false
end

function Menu.updateSelection()
	selectPressed = false;
	leftPressed = false;
	rightPressed = false;

	if IsDisabledControlJustPressed(1, 173)  then --Down
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
	elseif IsDisabledControlJustPressed(1, 176)  then --Select
		selectPressed = true
	end
	optionCount = 0
end