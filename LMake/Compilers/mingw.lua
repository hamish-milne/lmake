import 'dielect'
import 'cmd'
import 'path'

mingw = { }

local types = {
    ['file format: pe-'] = 'object',
    ['In archive'] = 'archive',
    ['file format: pei-'] = 'image'
}

function mingw.file_info(p)
    local content = cmd.capture('objdump -a '..io.args(p))
    local arch = content:match('architecture: (.-),')
    arch = dielect.arch[arch:match(':(.*)') or arch]
    local type
    for k,v in next, types do
        local type = content:match(v)
        if type == 'image' then
            type = path.ext(p) == '.dll' and 'sharedlib' or 'executable'
        end
        if type then break end
    end
    return type, arch
end
