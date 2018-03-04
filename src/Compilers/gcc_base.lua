import 'cmd'
import 'task'
import 'list'

local gcc_base = { }

local bool_options = {
    position_independent = '-fPIC'
}

function gcc_base:compile(t)
    local args = list {self.command, '-c', t.source, '-o', t.out_file}
    for k,v in pairs(bool_options) do
        if t[k] then args:append(v) end
    end
    -- TODO: Field attributes to return empty table
    if t.defines then for k,v in pairs(t.defines) do
        args:append('-D'..k..'='..v)
    end end
    args:append_list(t.raw_options)
    return task.cmd(args)
end

function gcc_base:preprocess(t)
    local args = list {self.command, '-E', t.source}
    if t.defines then for k,v in pairs(t.defines) do
        args:append('-D'..k..'='..v)
    end end
    args:append_list(t.raw_options)
    return task.cmd(args)
end

function gcc_base:link(t)
    local args = list {self.command, '-o', t.out_file}
    for k,v in ipairs(t.objects) do
        args:append(v.out_file)
    end
    if t.libs then for k,v in ipairs(t.libs) do
        args:append('-l:'..v.out_file)
    end end
    args:append_list(t.raw_options)
    return task.cmd(args)
end

return gcc_base
