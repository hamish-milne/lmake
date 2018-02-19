import 'cmd'
local linux = require 'Platforms.linux'

return inherit {
    __base = linux,
	__uname = 'Darwin',
    path = inherit {
        __base = linux.path,
        modified = function(p)
            return tonumber(cmd.capture('stat -f %m '..cmd.args(p)))
        end
    }
}
