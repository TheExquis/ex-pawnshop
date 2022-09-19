fx_version 'cerulean'
game 'gta5'
author 'Tony'
description 'TS Pawnshop'
version '1.0'
lua54 'yes'

shared_scripts{
	'@ox_lib/init.lua',
	'shared/config.lua'
}
client_script {
	'client/client.lua'
}

server_script {
	'server/server.lua'
}