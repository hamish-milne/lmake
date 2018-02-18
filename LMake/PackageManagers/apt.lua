require 'util'

return {
    install = function(p) io.execute('sudo apt-get install '..io.args(p)) end,
    remove = function(p) io.execute('sudo apt-get install '..io.args(p)) end
}
