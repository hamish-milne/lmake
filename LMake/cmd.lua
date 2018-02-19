import 'log'

if not os.execute() then
    error('No system shell')
end

return {
    execute = function(c)
        local t, e = os.execute(c)
        if t ~= 'exit' or e ~= 0 then
            log.fatal("Command terminated unexpectedly: $1 with code '$2'", t, e)
        end
    end,
    args = function(a, ...)
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
    end,
    capture = function(p)
        local f = io.popen(p)
        local o = f:read('*a')
        if not f:close() then
            log.fatal("Error executing process '$1'", p)
        end
        return o
    end
}
