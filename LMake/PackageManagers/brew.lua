require 'util'

return {
    setup = function()
        io.execute('/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"')
        io.execute('brew install --force')
    end,
    install = function(p)  io.execute('brew install '..io.args(p)) end,
    remove = function(p) io.execute('brew remove '..io.args(p)) end
}
