native = { }

local def_compile = {
    __required = {'source', 'compiler'},
    build = function(t) return t.compiler:compile(t) end,
    dependentData = function(t)
        return {t.compiler:preprocess(t).now(), t.compiler:compile(t).cmd}
    end,
    depends = function(t) return t.input end
}

function native.compile(t)
    return target.def(def_compile, t)
end

function native.system_lib(name)
    return target {
        lib_name = name,
        lib_path = 'system',
        dependentData = target.alwaysInDate,
    }
end

local def_link = {
    __required = {'objects', 'out_type', 'linker'},
    build = function(t) return t.linker:link(t) end,
    dependentData = function(t) return t.linker:link(t).cmd end,
    depends = function(t) return t.objects end,
    out_type = 'object'
}

function native.link(t)
    return target.def(def_link, t)
end

local name_fn = function(t) return t.out_type end

function native.executable(t)
    return native.link(defaults {
        __base = t,
        name = name_fn,
        out_type = 'executable',
        objects = native.compile(t),
        position_independent = false,
        linker = t.compiler and t.compiler.defaultLinker
    })
end

function native.static(t)
    return native.link(defaults {
        __base = t,
        name = name_fn,
        out_type = 'staticlib',
        objects = native.compile(t),
        position_independent = true,
        linker = t.compiler and t.compiler.defaultLinker
    })
end

function native.shared(t)
    return native.link(defaults {
        __base = t,
        name = name_fn,
        out_type = 'sharedlib',
        objects = native.compile(t),
        position_independent = true,
        linker = t.compiler and t.compiler.defaultLinker
    })
end
