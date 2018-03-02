import 'log'
import 'path'
import 'sha2'

local multi_mt = {
    __index = function(t, k)
        return rawget(t, '__private')[k] or log.fatal('Index out of range')
    end,
	__newindex = function(t, k, v) log.fatal('Modifying a multi-list is not permitted') end,
	__pairs = function(t)
		return pairs(rawget(t, '__private'))
	end
}

local mt_target = {
	__index = function(t, k)
		local priv = rawget(t, '__private')
		local value = priv[k]
		if type(k) ~= 'string' or k[1] == '_' then
			return value
		end
		if not value then
			priv = priv.inherit
			if not priv then return nil end
			value = priv[k]
		end
		if type(value) == 'function' then
			value = value(priv)
		end
		return value
	end,
	__newindex = function(t, k, v)
		local priv = rawget(t, '__private')
		if type(k) ~= 'string' or k[1] == '_' then
			priv[k] = v
			return
		end
		local value = priv[k]
		if type(value) == 'function' then
			log.fatal('Attempted to manually set derived property $1 of $2', k, t)
		end
		if value ~= nil and type(value) ~= type(v) then
			log.fatal('Type mismatch when setting property: $1 and $2', type(value), type(v))
		end
		if table.getKey(target.building, t) then
			log.fatal('Cannot modify properties of "$1" while it is being built', t)
		end
		priv[k] = v
	end,
	__tostring = function(t)
		return t.name or table.getKey(_G, t) or "UNNAMED TARGET"
	end
}

local function trueFn() return true end

local function target_multi(t)
	local multiVars = { }
	local varTypes = { }
	for k,v in next, t do
		if getmetatable(v) == multi_mt then
			multiVars[k] = v
			varTypes[k] = 'multi'
		end
	end
	if not next(multiVars) then return nil end
	local valueSets = { }
	for name,m in next, multiVars do
		for j,v in pairs(m) do
			if not valueSets[j] then valueSets[j] = { } end
			valueSets[j][name] = v
		end
	end
	local parts = { }
	for i,set in next, valueSets do
		local p = { }
		for name,v in next, set do
			p[name] = v
		end
		p.inherit = t
		p.build = t.build -- TODO: Use inherit better
		table.insert(parts, target(p))
	end
	return target {depends = parts, isMulti = trueFn, build = trueFn}
end

local target = setmetatable({ }, {
	__call = function(n, t)
		return target_multi(t) or setmetatable({__private=t}, mt_target)
	end
})

function target.multi(t)
	if not type(t) == 'table' then
		log.fatal('Expected a table, got a $1', type(t))
	end
	return setmetatable({__private = t}, multi_mt)
end

target.globals = {
	output_dir = 'lmake-build'
}

target.alwaysInDate = ''
target.alwaysOutOfDate = nil

function target.is(t)
	return type(t) == 'table' and getmetatable(t) == mt_target
end

function target.base(t, requires, overrides)

end

local function target_filter_check(t, filter)
	for k,v in next, filter do
		if t[k] ~= v then return false end
	end
	return true
end

function target.where(t, filter)
	local r = { }
	if t.isMulti then
		for k,v in next, t.depends do
			if target_filter_check(v, filter) then
				table.insert(r, v)
			end
		end
	elseif nil then
		if target_filter_check(t, filter) then
			table.insert(r, v)
		end
	end
	return r
end

function target.single(t, filter)
	local r = target.where(t, filter)
	if #r == 0 then log.fatal("No sub-target with that filter")
	elseif #r > 1 then log.fatal("Ambiguous selection")
	else return r[1] end
end

function target.def(d, t)
	for k,v in pairs(d) do
		if type(k) ~= 'string' or not k:starts('__') then
			t[k] = v
		end
	end
	if d.__required then
		for i,k in ipairs(d.__required) do
			if not t[k] then
				log.error('Missing required field "$1"', k)
			end
		end
	end
	return target(t)
end

function target.listDependencies(t, deps)
	if not deps then deps = { } end
	if table.getKey(deps, t) then
		log.fatal("Circular dependency around "..tostring(t))
	end
	local depends = t.depends
	if depends then
		for k,v in next, depends do
			if not target.is(v) then
				log.fatal('Target "$1" has a missing required dependency', t)
			end
			target.listDependencies(v, deps)
		end
	end
	table.insertUnique(deps, t)
	return deps
end

local function target_inDate(t)
	local outFile = t.out_file
	if not io.exists(outFile) then
		log.verbose('"$1" out of date because its output does not exist', t)
		t._inDate = false
		return false
	end

	local hashFile = path.combine(t.output_dir, outFile..'.stamp')
	local oldHash = io.readAll(hashFile)
	if not oldHash then
		log.verbose('"$1" out of date because its stamp file does not exist', t)
		t._inDate = false
		return false
	end
	
	if t._inDate ~= nil then return t._inDate end
	local inputStr = t.dependentData
	if type(inputStr) == 'table' then
		inputStr = table.concat(inputStr, ';')
	end
	local newHash = sha2.hash256(tostring(inputStr):trim())
	if oldHash:trim() == newHash then
		t._inDate = true
	else
		log.verbose('"$1" out of date because its stamp differs', t)
		t._inDate = false
	end
	return t._inDate
end

local function target_update(t)
	local outFile = t.out_file
	if not io.exists(outFile) then
		log.warning("Target $1 did not produce an output file at $2", t, outFile)
	end
	if t._inDate then return end
	local inputStr = t.dependentData
	if type(inputStr) == 'table' then
		inputStr = table.concat(inputStr, ';')
	end
	local newHash = sha2.hash256(tostring(inputStr):trim())
	io.writeAll(path.combine(t.output_dir, outFile..'.stamp'), newHash)
end

local function create_build_set(tList, targetBuildSet)
	if not targetBuildSet then targetBuildSet = { } end
	-- NB: This only works when tList is a linearized dependency tree.
	-- This allows us to only check the direct dependencies for each target,
	-- as the transitive ones will have already been processed.
	for k,v in ipairs(tList) do
		if not targetBuildSet[v] then
			local buildThis = false
			for k1,v1 in next, (v.depends or {}) do
				if targetBuildSet[v1] then
					log.info('Building "$1" because we are building one of its dependencies', v)
					buildThis = true
					break
				end
			end
			if not buildThis and not target_inDate(v) then
				log.info('Building "$1" because it is out of date', v)
				buildThis = true
			end
			if buildThis then
				targetBuildSet[v] = true
			end
		end
	end
	return targetBuildSet
end

function target.build(t)
	if target.building then
		log.fatal("It looks like we are already building something")
	end
	log.info("Getting dependencies of target $1", t)
	local tList = target.listDependencies(t)
	local buildSet = create_build_set(tList)
	target.building = tList
	for k,v in ipairs(tList) do
		if not buildSet[v] then
			log.info('Target "$1" is up to date', v)
		else
			log.info('Building "$1"', v)
			if v.build then
				target_update(v)
				log.info('Successfully built "$1"', v)
			else
				log.error('Error building "$1"', v)
				target.building = nil
				return false
			end
		end
	end
	target.building = nil
	return true
end

function target.dependsAny(t, checkFn)
	if not target.building then
		log.fatal("Can't check dependencies until a build has started")
	end
	local idx = table.getKey(target.building, t)
	if not idx then
		log.fatal("Target '$1' is not in the build set", t)
	end
	for i=idx+1,#target.building do
		if table.getKey(target.building[i].depends, t) then
			if checkFn(target.building[i]) then
				return true
			end
		end
	end
	return false
end

return target
