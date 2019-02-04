resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'FiveM FXServer speedometer'

version '1.1.0'

client_scripts {
	'config.lua',
	'client.lua',
	'skins/default.lua',
	'skins/default_middle.lua',
	'skins/id6.lua',
	'skins/id7.lua'
}

exports {
	'getAvailableSkins',
	'changeSkin',
	'addSkin',
	'toggleSpeedo',
	'getCurrentSkin',
	'addSkin',
	'toggleFuelGauge',
	'DoesSkinExist'
}

ui_page 'html/speedometer.html'

files {
	'html/speedometer.html',
	'html/sounds/initiald.ogg'
}