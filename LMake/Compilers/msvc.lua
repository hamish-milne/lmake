require 'log'
require 'dielect'

msvc = { }

function msvc.generate_lib(dllPath, targetArch)
    local p = io.popen('dumpbin /NOLOGO /EXPORTS '..io.args(dllPath))
    local def = io.open(dllpath..'.def')
    def:write('LIBRARY '..io.basename(dllPath)..'\nEXPORTS\n')
    for line in p:read('*l') do
        local fn = line:match('.+%s+(%S+)')
        if fn then def:write(fn..'\n') end
    end
    def:close()
    p:close()
    io.execute('lib /def:'..io.args(dllPath..'.def')..
        ' /out:'..io.args(dllPath..'.lib')..' /machine:'..targetArch)
    return dllPath..'.lib'
end

function msvc.file_info(p)
    local content = io.execute('dumpbin /NOLOGO /HEADERS '..io.args(p))
    return dielect.fileType[content:match('File Type: (.-)\n')],
           dielect.arch[content:match('machine %((.-)%)')]
end
