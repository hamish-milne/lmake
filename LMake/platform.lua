local platform = { }

for k,v in next, {'windows', 'linux', 'osx'} do
	platform[v] = require('Platforms.'..v)
	platform[v].name = v
end
	
local valid = { }
for k,v in next, platform do
	if v:is() then table.insert(valid, k) end
end
if #valid == 0 then
	error('Unable to determine host platform')
elseif #valid > 1 then
	error('Ambiguous platform: ' .. table.concat(valid, ', '))
end
platform.host = platform[valid[1]]

print('platform: ', platform.host.name)
print('architecture: ', platform.host:arch())

return platform
