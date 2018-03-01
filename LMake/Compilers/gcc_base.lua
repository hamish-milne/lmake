import 'cmd'
import 'task'

local gcc_base = { }

local bool_options = {
    position_independent = '-fPIC'
}

function gcc_base.compile(t)
    local args = list {t.command, '-c', '-o', t.out_file, t.in_file}
    for k,v in bool_options do
        if t[k] then args:append(v) end
    end
    for k,v in ipairs(t.defines) do
        args:append('-D'..k..'='..v)
    end
    args:append_list(t.raw_options)
    return task.cmd(args)
end

function gcc_base.preprocess(t)
    local args = list {t.command, '-E', t.in_file}
    for k,v in pairs(t.defines) do
        args:append('-D'..k..'='..v)
    end
    args:append_list(t.raw_options)
    return task.cmd(args)
end

function gcc_base.link(t)
    local args = list {t.command, '-o', t.out_file}
    for k,v in ipairs(t.objects) do
        args:append(v)
    end
    for k,v in ipairs(t.libs) do
        args:append('-l:'..v.out_file)
    end
    args:append_list(t.raw_options)
    return task.cmd(args)
end

return gcc_base
