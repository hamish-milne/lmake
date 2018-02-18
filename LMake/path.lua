require 'util'
require 'platforms'

local pathDefaults = { }

path = setmetatable({ }, {
	__index = function(t, k)
		return platform.current.path[k] or pathDefaults[k] or log.fatal('No path operation "$1"', k)
	end
})

pathDefaults.separators = {'/'}

function pathDefaults.combine(...)
	local s = ''
	for i=1,select('#', ...) do
		local b = select(i, ...)
		if b then
			if s == '' or s[#s] == system.pathseparator then
				s = s..tostring(b)
			else
				s = s..system.pathseparator..tostring(b)
			end
		end
	end
	return s
end

local function relative(p, dir)
	local norm = path.normalize(p)
	if dir[0] ~= norm[0] then return norm end
	if #norm < #dir then
		norm:sub(#dir + 2)
	elseif #norm > #dir then
		return '..'..path.separators[1]..relative(p..path.separators[1]..'..', dir)
	else
		return '.'
	end
end

function pathDefaults.relative(p, dir)
	if not dir then dir = path.workingDir()
	else dir = path.normalize(dir) end
	return relative(p, dir)
end

function pathDefaults.split(p)
	local t = { }
	for p in p:gmatch('[^'..table.concat(path.separators)..']+') do
		table.insert(t, p)
	end
	return t
end

function pathDefaults.directory(p)
	local seps = table.concat(path.separators)
	return p:match('^(.+)['..seps..'][^'..seps..']-$') or p
end

function pathDefaults.basename(p)
	local seps = table.concat(path.separators)
	return p:match('^.+['..seps..'](.-)$') or p
end

function pathDefaults.ext(p)
	return p:match('.+(%..+)$')
end

function pathDefaults.stripExt(p)
	return p:match('(.+)%..+$') or p
end

function pathDefaults.changeExt(p, newExt)
	if #newExt > 0 and newExt[1] ~= '.' then newExt = '.'..newExt end
	return path.stripExt(p)..(newExt or '')
end
