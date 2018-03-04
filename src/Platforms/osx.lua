import 'cmd'
import 'Platforms.linux'

return override {
    __base = linux,
	__uname = 'Darwin',
    path = override {
        __base = linux.path,
        modified = function(p)
            return tonumber(cmd.capture('stat -f %m '..cmd.args(p)))
        end
    }
}
