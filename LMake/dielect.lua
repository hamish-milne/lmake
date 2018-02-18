dielect = { }

local mt_ci = {
    __index = function(t, k)
        if type(k) == 'string' then return rawget(t, k:lower()) end
    end,
    __newindex = function(t, k, v)
        if type(k) == 'string' then rawset(t, k:lower(), v) end
    end
}

function dielect.makeCaseInsensitive(t)
    return setmetatable(t, mt_ci)
end

function dielect.add(t, id, list)
    for k,v in next, list do
        t[v] = id
    end
    t[id] = id
end

dielect.arch = dielect.makeCaseInsensitive({ })
dielect.add(dielect.arch, 'x86',    { 'i386', 'i486', 'i586', 'i686' })
dielect.add(dielect.arch, 'x86_64', { 'x64', 'AMD64', 'i386:x86_64', 'i686:x86_64' })
dielect.add(dielect.arch, 'ia64',   { 'itanium', 'x86_ia64' })

dielect.fileType = dielect.makeCaseInsensitive({ })
dielect.add(dielect.fileType, 'executable', { })
dielect.add(dielect.fileType, 'object',     { })
dielect.add(dielect.fileType, 'sharedlib',  { 'DLL' })
dielect.add(dielect.fileType, 'staticlib',  { 'archive', 'library' })
