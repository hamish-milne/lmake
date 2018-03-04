import 'cmd'

return {
    setup = function()
        cmd.execute('/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"')
        cmd.execute('brew install --force')
    end,
    install = function(p) cmd.execute('brew install '..cmd.args(p)) end,
    remove = function(p) cmd.execute('brew remove '..cmd.args(p)) end
}
