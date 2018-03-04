import 'native'
import 'Compilers.mingw'
import 'cmd'
import 'file'

function test.native_compile_mingw()
    -- Given
    local foo = native.compile {
        source = 'foo.c',
        out_file = 'foo.o',
        defines = {BAR = 123},
        compiler = mingw
    }

    -- Then
    test.equal('gcc -c foo.c -o foo.o -DBAR=123', cmd.args(foo.build.cmd):trim())
end

function test.native_link_mingw()
    -- Given
    local foo = native.link {
        objects = {file.single('foo.o')},
        out_file = 'foo.exe',
        linker = mingw
    }

    -- Then
    test.equal('gcc -o foo.exe foo.o', cmd.args(foo.build.cmd):trim())
end

