import 'log'

local list

local mt_list = {
    __index = function(t, k)
        if list[k] then return list[k] end
        if type(k) ~= 'number' or k ~= math.floor(k) then
            log.fatal("Index '$1' is not an integer", k)
        end
        if k > 0 and k <= #t then return nil end
        log.fatal("Index '$1' out of range for list with length '$2'", k, #t)
    end
}

list = {
    append = function(t, ...)
        for i=1,select('#', ...) do
            t[#t+1] = select(i, ...)
        end
        return t
    end,
    append_list = function(t, t2)
        if not t2 then return end
        for k,v in ipairs(t2) do
            t[#t+1] = v
        end
        return t
    end,
    find = function(t, value)
        for k,v in ipairs(t) do
            if v == value then return k end
        end
        return nil
    end,
    new = function(t, ...)
        if type(t) ~= 'table' or select('#',...) > 0 then
            t = {t, ...}
        end
        return setmetatable(t, mt_list)
    end
}

return setmetatable(list, {
    __call = function(t, ...)
        return list.new(...)
    end
})
