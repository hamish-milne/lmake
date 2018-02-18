require 'util'

platform = { }

for k,v in next, {'windows', 'linux', 'osx'} do
	platform[v] = require('Platforms.'..v)
end

system = { }

function system.configure(t)

	t.pathseparator = package.config:sub(1,1)
	
	local valid = { }
	platform.current = nil
	for k,v in next, platform do
		if v:is() then table.insert(valid, k) end
	end
	if #valid == 0 then
		error('Unable to determine platform')
	elseif #valid > 1 then
		error('Ambiguous platform: ' .. table.concat(valid, ', '))
	end
	platform.current = platform[valid[1]]
	
	t.platform = valid[1]
	t.arch = platform.current:arch()
	t.pathSeparators = platform.current.pathSeparators
	
end

print('======= LMAKE ========')
system:configure()
print('platform: ', system.platform)
print('architecture: ', system.arch)
