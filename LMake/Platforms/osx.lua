require 'util'
local linux = require 'Platforms.linux'

return {
	__uname = 'Darwin',
	arch = linux.arch,
    is = linux.is,
    path = {
        modified = function(p)
            return tonumber(io.execute(io.args('stat', '-f', '%m', p)))
        end,
        normalize = linux.normalize,
        relative = linux.relative,
        workingDir = linux.workingDir
    }
}
