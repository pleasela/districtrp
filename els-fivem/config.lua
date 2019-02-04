vcf_files = {
	"mobilecommand.xml",
	"F250.xml",
	"policet.xml",
	"AMBULANCE.xml",
	--"POLICE.xml",
	--"POLICE2.xml",
	--"police4.xml",
	--"police3.xml",
	"firetruk.xml",
    "so1.xml",
	"so2.xml",
	"so3.xml",
	"so4.xml",
	"so5.xml",
	"so6.xml",
	"laddertruk.xml",
	"rescue.xml",
	"engine.xml",
	"Flatbed.xml"

}

pattern_files = {
	"WIGWAG.xml",
	"WIGWAG2.xml",
	"WIGWAG3.xml",
	"LEFTRIGHT.xml",
	"LEFTSWEEP.xml",
	"RIGHTSWEEP.xml",
}

modelsWithFireSiren =
{
    "FIRETRUK",
	"laddertruk",
	"rescue",
	"engine",
}


modelsWithAmbWarnSiren =
{   
    "AMBULANCE",
    "FIRETRUK",
    "LGUARD",
	"laddertruk",
	"rescue",
	"engine",
}

stagethreewithsiren = true
playButtonPressSounds = true
vehicleStageThreeAdvisor = {
    "FBI3",
    "F250",
    "policet",
    "sheriff",
    "sheriff2",
    --"POLICE",
    --"police3",
    --"POLICE2",
    --"police4",
    "AMBULANCE",
    "firetruk",
    "mobilecommand",
    "so1",
	"so2",
	"so3",
	"so4",
	"so5",
	"so6",
	"LADDERTRUK",
	"rescue",
	"engine",
	"flatbed"

}


shared = {
	horn = 86,
}

keyboard = {
	modifyKey = 132,
	stageChange = 70,
	guiKey = 243,
	takedown = 245,
	siren = {
		tone_one = 157,
		tone_two = 158,
		tone_three = 160,
		dual_toggle = 164,
		dual_one = 165,
		dual_two = 159,
		dual_three = 161,
	},
	pattern = {
		primary = 246,
		secondary = 10,
		advisor = 182,
	},
}

controller = {
	modifyKey = 73,
	stageChange = 80,
	takedown = 74,
	siren = {
		tone_one = 173,
		tone_two = 85,
		tone_three = 172,
	},
}