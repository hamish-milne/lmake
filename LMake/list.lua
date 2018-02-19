import 'log'

local mt_list = {
    __index = function(t, k)
        if list[k] then return list[k] end
        log.fatal("Index '$1' out of range for list with length '$2'", k, #t)
    end
}

return setmetatable({
    append = function(t, ...)
        for i=1,select('#', ...) do
            t[#t+1] = select(i, ...)
        end
        return t
    end,
    appendTable = function(t, t2)
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
    new = function(...)
        return setmetatable({...}, mt_list)
    end
}, {
    __call = function(t, ...)
        return list.new(...)
    end
})
