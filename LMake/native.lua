native = { }

local def_compile = {
    __required = {'source', 'linker'},
    build = function(t) return t.compiler.compile(t) end,
    dependentData = function(t)
        return {t.compiler.preprocess(t), t.compiler.cmd.compile(t)}
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
    __required = {'objects', 'lib_type', 'linker'},
    build = function(t) return t.linker.link(t) end,
    dependentData = function(t) return t.linker.cmd.link(t) end,
    depends = function(t) return t.objects end,
    out_type = 'object'
}

function native.link(t)
    return target.def(def_link, t)
end

function native.executable(t)
    return native.link(override {
        __base = t,
        out_type = 'executable',
        objects = native.compile(t),
        linker = t.linker or t.compiler.defaultLinker
    })
end

function native.static(t)
    return native.link(override {
        __base = t,
        out_type = 'staticlib',
        objects = native.compile(t),
        linker = t.linker or t.compiler.defaultLinker
    })
end

function native.shared(t)
    return native.link(override {
        __base = t,
        out_type = 'sharedlib',
        objects = native.compile(t),
        linker = t.linker or t.compiler.defaultLinker
    })
end
