
require 'target'

local file = { }

function file.single(path, type)
	return target {
		inputData = target.alwaysInDate,
		out_file = path,
		out_type = type
	}
end

function file.multi(t)
	return multi(table.select(t, file.single))
end

return file
