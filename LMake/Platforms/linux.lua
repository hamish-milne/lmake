import 'cmd'

return {
	__uname = 'Linux',
	arch = function(t)
		local a = cmd.capture('uname -m'):trim()
		if not a then error('Unable to determine architecture from uname') end
		return a
	end,
	is = function(t)
		if package.config:sub(1,1) ~= '/' then return false end
		local n = cmd.capture('uname'):trim()
		return n == t.__uname
	end,
	start_process = function(p)
		return tonumber(cmd.capture(p..' & echo $!'))
	end,
	is_alive = function(pid)
		return cmd.check('ps -o pid -p '..pid..' >/dev/null')
	end,
    path = {
		separators = {'/'},
		modified = function(p)
			return tonumber(cmd.capture('stat -c %Y '..cmd.args(p)))
		end,
		workingDir = function(p)
			return cmd.capture('pwd')
		end,
		normalize = function(p)
			return cmd.capture('realpath -m '..cmd.args(p))
		end,
		relative = function(p)
			return cmd.capture('realpath '..cmd.args(dir and ('--relative-to='..dir) or nil, p))
		end,
		fileType = function(p)
			return cmd.capture('file --mime-type -b '..cmd.args(p)):match('application/x%-(.+)')
		end,
		dirList = function(p, search)
			return cmd.capture('find ${PWD} -name '..cmd.args(search or '*'))
		end
    }
}
