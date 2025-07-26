fx_version 'cerulean'
game 'gta5'

author 'dakotascripts'
description 'Multi-drug selling script for QBCore beta'
version '1.0.0'

shared_scripts {
    '@qb-core/shared/locale.lua',
    'config.lua'
}

client_scripts {
    'client.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua',
    'version_check.lua'
}

lua54 'yes'
