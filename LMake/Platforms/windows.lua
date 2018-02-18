require 'util'
require 'dielect'

return {
	arch = function(t)
		return dielect.arch[io.execute('reg query '..
	'"HKLM\\SYSTEM\\CurrentControlSet\\Control\\Session Manager\\Environment"'
		..' /v PROCESSOR_ARCHITECTURE'
		):match('(%S+)%s*$')]
	end,
	is = function(t)
		return system.pathseparator == '\\'
	end,
    path = {
        separators = {'\\', '/'},
        modified = function(p)
            if not io.exists('fileModified.vbs') then
                io.writeAll('fileModified.vbs', 
                'wscript.echo(DateDiff("s",CDATE("01/01/1970"),'..
                'CDATE(CREATEOBJECT("Scripting.FileSystemObject").'..
                'GetFile(wscript.arguments(0)).DateLastModified)))')
            end
            return tonumber(io.execute(
                io.args('cscript', '//Nologo', 'fileModified.vbs', p)))
        end,
        workingDir = function() return io.execute('cd') end,
        normalize = function(p)
            return io.execute('FOR /F %i IN ('..io.args(p)..') DO echo %~fi')
        end,
        dirList = function(p, search)
            return io.execute('for /r %i in ('..io.args(p)..'\\'..
                (search or '*')..') do @echo %~fi')
        end
    }
}
