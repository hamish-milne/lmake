import 'log'

function switch(value, t)
	local v = t[value]
	if v == nil then
		log.fatal('Switch value "$1" not defined!', value)
	end
	return v
end

function coalesce(a, b)
	return  a == nil and b or a
end

function inherit(t)
	for k,v in pairs(t.__base) do
		if t[k] == nil then t[k] = v end
	end
	return t
end

local mt_noNil = {
	__index = function(t, k)
		log.fatal("The key '$1' does not exist in '$2'", k, t)
	end
}

function noNilTable(t)
	if getmetatable(t) then log.fatal('Table already has a metatable') end
	return setmetatable(t, mt_noNil)
end

function string.trim(s)
	return s:match("^%s*(.-)%s*$")
end

function string.starts(String,Start)
	if type(Start) == 'table' then
		for k,v in next, e do
			if string.starts(String, v) then return true end
		end
		return false
	end
    return string.sub(String,1,string.len(Start))==Start
end

function string.ends(String,End)
	if type(End) == 'table' then
		for k,v in next, e do
			if string.ends(String, v) then return true end
		end
		return false
	end
   return End=='' or string.sub(String,-string.len(End))==End
end

function table.select(t, f)
	local r = { }
	for k,v in next, t do
		r[k] = f(v, k)
	end
	return r
end

function table.insertUnique(t, v)
	if not table.getKey(t) then
		table.insert(t, v)
		return true
	end
	return false
end

function table.getKey(t, search)
	for k,v in next, t do
		if v == search then return k end
	end
end

function io.readAll(path)
	local f = io.open(path, 'r')
	if not f then return nil end
	local c = f:read('*a')
	f:close()
	return c
end

function io.writeAll(path, content)
	local f = io.open(path, 'w')
	if not f then log.fatal('Unable to open "$1" for writing', path) end
	f:write(content)
	f:close()
end

function io.exists(name)
	local f=io.open(name,"r")
	if f~=nil then io.close(f) return true else return false end
 end
