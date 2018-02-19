import 'cmd'

return {
    setup = function()
        cmd.execute([[
            @"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe"
            -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command
            "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))"
            && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"]])
    end,
    install = function(p) cmd.execute('choco install '..cmd.args(p)) end,
    remove = function(p) cmd.execute('choco remove '..cmd.args(p)) end
}
