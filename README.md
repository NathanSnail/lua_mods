# Lua Mod Loader
This allows you to easily install and use lua mods, which can register new creatures and control their ai
## Installing
To install add this to your scripts folder, so the path should look like data/scripts/lua_mods/README.md
Then add the following the very start of your data/scripts/init.lua (so that it's the first line)
```lua
dofile("data/scripts/lua_mods/pre.lua")
```
Then this to the end of data/scripts/init.lua (so that it's the last line)
```lua
dofile("data/scripts/lua_mods/post.lua")
```
## Getting mods
Currently only the example mod exists, but when there are new mods made you should add them to the mods folder so that the path looks like data/scripts/lua_mods/mods/mod_id/init.lua
Then to enable the mods edit data/scripts/lua_mods/mod_list.lua to add them to the table
