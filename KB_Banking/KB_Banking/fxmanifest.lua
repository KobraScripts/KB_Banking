fx_version 'cerulean'
games { 'gta5' }

lua54 'yes'

author 'KB Scripts'
description 'Banking Script'
version '1.0'

escrow_ignore {
	'client/main.lua',
	'server/main.lua',
	'shared/config.lua',
    'sql/pin.sql'
}

shared_scripts {
    '@NativeUILua_Reloaded/src/NativeUIReloaded.lua',
	'@oxmysql/lib/MySQL.lua',
	'@ox_lib/init.lua',
	'shared/*.lua'
}

client_scripts {
	'client/*.lua'
}

server_scripts {
	'server/*.lua'
}