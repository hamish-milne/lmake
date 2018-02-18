require 'util'

return {
	__uname = 'Linux',
	arch = function(t)
		local a = io.popen('uname -m'):read('*a'):trim()
		if not a then error('Unable to determine architecture from uname') end
		t.arch = function() return a end
		return a
	end,
	is = function(t)
		if system.pathseparator ~= '/' then return false end
		local n = io.popen('uname'):read('*a'):trim()
		return n == t.__uname
    end,
    path = {
		modified = function(p)
			return tonumber(io.execute(io.args('stat', '-c', '%Y', p)))
		end,
		workingDir = function(p)
			return io.execute('pwd')
		end,
		normalize = function(p)
			return io.execute('realpath -m '..io.args(p))
		end,
		relative = function(p)
			return io.execute(io.args('realpath', dir and ('--relative-to='..dir) or nil, p))
		end,
		fileType = function(p)
			return io.execute('file --mime-type -b '..io.args(p)):match('application/x%-(.+)')
		end,
		dirList = function(p, search)
			return io.execute('find ${PWD} -name '..io.args(search or '*'))
		end
    }
}
