import 'cmd'
import 'platform'

local task = { }

local function task_now(t)
    local s = true
    local o1, o2
    while s do
        s, o1 = coroutine.resume(t.routine)
        if s then o2 = o1 end
    end
    return o2
end

function task.custom(t)
    t.routine = coroutine.create(function() t:run() end)
    t.now = task_now
    return t
end

-------------------------------------------------------------------------------

local function task_cmd(t)
    local a = t.cmd
    if type(a) == 'table' then a = cmd.args(a) end
    if not platform.host.start_process or not platform.host.is_alive then
        return cmd.check(a)
    end
    local pid = platform.host.start_process(a)
    if not pid then return false end
    while platform.host.is_alive(pid) do
        coroutine.yield()
    end
    return true
end

function task.cmd(a)
    return task.custom({cmd = a, run = task_cmd})
end

return task
