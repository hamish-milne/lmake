require 'util'

return {
    setup = function()
        io.execute([[
            @"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe"
            -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command
            "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))"
            && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"]])
    end,
    install = function(p) io.execute('choco install '..io.args(p)) end,
    remove = function(p) io.execute('choco remove '..io.args(p)) end
}
