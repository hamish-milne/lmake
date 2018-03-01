import 'cmd'
import 'dielect'

return {
	arch = function(t)
		return dielect.arch[cmd.capture('reg query '..
	'"HKLM\\SYSTEM\\CurrentControlSet\\Control\\Session Manager\\Environment"'
		..' /v PROCESSOR_ARCHITECTURE'
        ):match('(%S+)%s*$')]
	end,
	is = function(t)
		return package.config:sub(1,1) == '\\'
    end,
    start_process = function(p)
        if type(p) ~= 'table' then error("Need to specify args as a list") end
        local pid = cmd.capture('PowerShell -NoLogo -Command $p='..
            io.args(p[1])..';$a='..io.args(p)..';(Start-Process -PassThru $p $a).Id')
        return tonumber(pid)
    end,
    is_alive = function(pid)
        return cmd.capture('TASKLIST /NH /FI "PID eq '..pid..'"'):match(tostring(pid))
    end,
    path = {
        separators = {'\\', '/'},
        modified = function(p)
            if not path.exists('fileModified.vbs') then
                io.writeAll('fileModified.vbs', [[
                wscript.echo(DateDiff("s",CDATE("01/01/1970"),
                CDATE(CREATEOBJECT("Scripting.FileSystemObject").
                GetFile(wscript.arguments(0)).DateLastModified)))
                ]])
            end
            return tonumber(cmd.capture(
                'cscript //Nologo fileModified.vbs '..cmd.args(p)))
        end,
        workingDir = function() return cmd.capture('cd') end,
        normalize = function(p)
            return cmd.capture('FOR /F %i IN ('..cmd.args(p)..') DO echo %~fi')
        end,
        dirList = function(p, search)
            return cmd.capture('for /r %i in ('..cmd.args(p)..'\\'..
                (search or '*')..') do @echo %~fi')
        end
    }
}
