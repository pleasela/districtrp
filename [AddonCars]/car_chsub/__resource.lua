resource_manifest_version '77731fab-63ca-442c-a67b-abc70f28dfa5'

files {
	'handling.meta',
	'vehicles.meta',
	'carvariations.meta',
	'dlctext.meta',
	'chsubcontentunlocks.meta',
	'shop_vehicle',

}

-- specify data file entries to be added
-- these entries are the same as content.xml in a DLC pack
data_file 'HANDLING_FILE' 'handling.meta'
data_file 'VEHICLE_METADATA_FILE' 'vehicles.meta'
data_file 'VEHICLE_VARIATION_FILE' 'carvariations.meta'
data_file 'TEXTFILE_METAFILE' 'dlctext.meta'
data_file 'CONTENT_UNLOCKING_META_FILE' 'chsubcontentunlocks.meta'
data_file 'VEHICLE_SHOP_DLC_FILE' 'shop_vehicle.meta'



client_script 'vehicle_names.lua'