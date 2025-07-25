fx_version 'cerulean'
game 'rdr3'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

author 'riversafe'
description 'crafting script'
version '1.0.0'

ui_page {
	'html/ui.html'
}

files {
	'html/ui.html',
	'html/css/app.css',
	'html/css/*.png',
	'html/js/mustache.min.js',
	'html/js/app.js',
	'html/fonts/crock.ttf',
	'html/fonts/HapnaSlabSerif-Medium.ttf',
}

shared_script 'config.lua'

client_scripts {
  '@uiprompt/uiprompt.lua',
  'client/anim.lua',
  'client/client.lua',
  'client/menu.lua'
}

server_script 'server/server.lua'

