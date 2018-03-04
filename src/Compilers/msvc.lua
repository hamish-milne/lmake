import 'log'
import 'dielect'
import 'cmd'

msvc = { }

function msvc.generate_lib(dllPath, targetArch)
    local p = io.popen('dumpbin /NOLOGO /EXPORTS '..cmd.args(dllPath))
    local def = io.open(dllpath..'.def')
    def:write('LIBRARY '..path.basename(dllPath)..'\nEXPORTS\n')
    for line in p:read('*l') do
        local fn = line:match('.+%s+(%S+)')
        if fn then def:write(fn..'\n') end
    end
    def:close()
    p:close()
    cmd.execute('lib /def:'..cmd.args(dllPath..'.def')..
        ' /out:'..cmd.args(dllPath..'.lib')..' /machine:'..targetArch)
    return dllPath..'.lib'
end

function msvc.file_info(p)
    local content = cmd.capture('dumpbin /NOLOGO /HEADERS '..cmd.args(p))
    return dielect.fileType[content:match('File Type: (.-)\n')],
           dielect.arch[content:match('machine %((.-)%)')]
end
