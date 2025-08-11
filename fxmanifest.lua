-- ⚠️ CRITICAL WARNING: DO NOT CHANGE THE RESOURCE NAME "ritwik-houserobberies" ⚠️
-- Changing the resource name will break all functionality as it's hardcoded throughout the system
fx_version 'cerulean'
game 'gta5'

name 'ritwik-houserobberies'
description 'Comprehensive house robbery system for FiveM servers with advanced features including cooldown systems, multiple minigames, and Black Market integration'
author 'Ritwik (Enhanced version based on md-houserobberies by Mustachedom)'
version '2.0.0'
license 'MIT'

-- GitHub repository
repository 'https://github.com/ItsRitwik/ritwik-houserobberies'

-- Dependencies
dependencies {
    'qb-core',
    'ox_lib'
}

-- Optional dependencies for enhanced features
-- ps-ui: Advanced minigames (Circle, Maze, Scrambler, VarHack, Thermite)
-- okok-notify: Enhanced notification system
-- Various dispatch systems: ps-dispatch, aty_dispatch, qs-dispatch, cd_dispatch

-- Lua version
lua54 'yes'

-- Shared configuration
shared_scripts {
    'config.lua',
    '@qb-core/shared/locale.lua',
    '@ox_lib/init.lua',
}

-- Client-side scripts
client_script {
   'client/**.lua',
}

-- Server-side scripts
server_script {
'server/**.lua'
}
