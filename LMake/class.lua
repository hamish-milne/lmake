

local class = { }
setmetatable(class, {__call = function(t, ...) return class.def(...) end })

local mt_class = { }

function mt_class.__call(t, ...)
    return t.new(t, ...)
end

local mt_instance = { }

local class_mtags = { }

local default_metamethods = {
    __index = function(t, k) return t.__private[k] or t.__class[k] end,
    __len = function(t) return #(t.__private) end,
    __newindex = function(t, k, v) t.__private[k] = v end
}

local function mt_instance_fn(fname, t, k, ...)
    local k_tag = t.__class.__mtags[k]
    if k_tag and class_mtags[k_tag][fname] then
        return class_mtags[k_tag][fname](t, k, ...)
    end
    if default_metamethods[fname] then
        local v = default_metamethods[fname](t, k, ...)
        if not rawequal(v, nil) then return v end
    end
    if t.__class[fname] then return t.__class[fname](t, k, ...) end
end

for k,fname in pairs{
    '__index',
    '__newindex',
    '__call',
    '__len',
    '__tostring'
} do
    local fn = function(t, k, ...) return mt_instance_fn(fname, t, k, ...) end
    mt_instance[fname] = fn
end

local mtag_marker = { }
local function class_get_mtags(t)
    if not t.__mtags then
        local mtags = { }
        t.__mtags = mtags
        for k,v in pairs(t) do
            if type(v) == 'function' then
                local status, msg = pcall(v, mtag_marker)
                if (not status) and type(msg) == 'string' then
                    mtags[k] = msg:match('MTAG:(.+)$')
                end
            end
        end
    end
    return t.__mtags
end

local function class_new_default(c, t)
    class_get_mtags(c)
    return setmetatable({ __class = c, __private = t }, mt_instance)
end

function class.def(name)
    return setmetatable({ __name = name, new = class_new_default }, mt_class)
end

function class.mtag(obj, tag)
    if rawequal(mtag_marker, obj) then
        error('MTAG:'..tag)
    end
end

function class.def_mtag(name, t)
    class_mtags[name] = t
end

-------------------------------------------------------------------------------

class.def_mtag('property', {
    __index = function(t, k)
        return default_metamethods.__index(t, k)(t)
    end
})


return class
