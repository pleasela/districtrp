resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

-- Example custom radios
supersede_radio "RADIO_02_POP" { url = "http://stream.radioreklama.bg:80/radio1_low.ogg", volume = 0.4 }
supersede_radio "RADIO_03_HIPHOP_NEW" { url = "http://stream.radioreklama.bg/nrj.ogg", volume = 0.2 }

files {
	"index.html"
}

ui_page "index.html"

client_scripts {
	"data.js",
	"client.js"
}
