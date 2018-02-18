function string.trim(s)
	return s:match("^%s*(.-)%s*$")
end

function switch(value, t)
	local v = t[value]
	if v == nil then
		error('Switch value ' .. value .. ' not defined!')
	end
	return v
end

function io.exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
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

function table.concatenate(t1,t2)
    for i=1,#t2 do
        t1[#t1+1] = t2[i]
    end
    return t1
end

function table.append(t1, ...)
	for i=1,select('#', ...) do
		t1[#t1+1] = select(i, ...)
	end
	return t1
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

function io.args(a, ...)
	if not a then
		if select('#', ...) == 0 then return '' end
		return io.args(...)
	end
	if type(a) == 'table' then
		return io.args(table.unpack(table.append(a, ...)))
	end
	-- TODO: Additional escapes? Platform specific?
	local escaped = tostring(a):gsub('\\', '\\\\'):gsub('"', '\\"')
	if escaped:match('.*%s+.*') then
		escaped = '"'..escaped..'"'
	end
	return escaped..' '..io.args(...)
end

function io.execute(p)
	local f = io.popen(p)
	local o = f:read('*a')
	if not f:close() then
		error("Error executing process "..p)
	end
	return o
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
	if not f then error('Unable to open '..path..' for writing') end
	f:write(content)
	f:close()
end
