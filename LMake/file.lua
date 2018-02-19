
require 'target'

local file = { }

function file.single(path)
	return target {
		inputData = target.alwaysInDate,
		output = path,
		type = file.detectType(path)
	}
end

function file.multi(t)
	return multi(table.select(t, file.single))
end

return file
