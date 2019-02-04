resource_manifest_version '77731fab-63ca-442c-a67b-abc70f28dfa5'

files {
	'handling.meta',
	'vehicles.meta',
	'carcols.meta',
	'carvariations.meta',
	'dlctext.meta',
	'vehiclelayouts.meta',
}

-- specify data file entries to be added
-- these entries are the same as content.xml in a DLC pack
data_file 'HANDLING_FILE' 'handling.meta'
data_file 'VEHICLE_METADATA_FILE' 'vehicles.meta'
data_file 'CARCOLS_FILE' 'carcols.meta'
data_file 'VEHICLE_VARIATION_FILE' 'carvariations.meta'
data_file 'TEXTFILE_METAFILE' 'dlctext.meta'
data_file 'VEHICLE_LAYOUTS_FILE' 'vehiclelayouts.meta'

client_script 'vehicle_names.lua'