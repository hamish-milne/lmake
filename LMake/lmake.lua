print('======= LMAKE ========')

-- Include the script directory in the search path
package.path = package.path..';'..
    debug.getinfo(1, "S").source:sub(2):match("(.*/)")..'?.lua'

local imports = { }

function import(p)
    local s = debug.getinfo(2,'S').source
    if not imports[s] then imports[s] = { } end
    imports[s][p] = require(p)
end

function global(p)
    _G[p] = require(p)
end

setmetatable(_G, {
    __index = function(t, k)
        local imp = imports[debug.getinfo(2,'S').source]
        if imp then return imp[k] end
    end
})

require 'util'
global 'platform'
global 'target'
