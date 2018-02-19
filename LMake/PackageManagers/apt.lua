import 'cmd'

return {
    install = function(p) cmd.execute('sudo apt-get install '..cmd.args(p)) end,
    remove = function(p) cmd.execute('sudo apt-get install '..cmd.args(p)) end
}
