log = { }

local function format(s, ...)
	for i=1,select('#',...) do
		s = s:gsub('$'..tostring(i), tostring(select(i,...)))
	end
	return s
end

function log.verbose(msg, ...)
	print('[VERBOSE] '..format(msg, ...))
end

function log.info(msg, ...)
	print('[ INFO  ] '..format(msg, ...))
end

function log.warning(msg, ...)
	print('[WARNING] '..format(msg, ...))
end

function log.error(msg, ...)
	print('[ ERROR ] '..format(msg, ...))
end

function log.fatal(msg, ...)
	error('[ FATAL ] '..format(msg, ...))
end
