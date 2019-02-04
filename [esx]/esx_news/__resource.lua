resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'ESX News'

version '1.0.0'

ui_page 'html/ui.html'
files {
	'html/ui.html',
	'html/styles.css',
	'html/scripts.js',
	'html/debounce.min.js',
	'html/img/navbar.jpg',
    'html/img/tabletti.png',
	'html/img/source.gif'
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'config.lua',
	'client/main.lua'
}

exports {
  'openremote'
}
