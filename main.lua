test = require 'u-test/u-test'
require 'LMake/lmake'

rawset(test, 'expect_error', function (err, fn, ...)
    local status, msg = pcall(fn, ...)
    if status then
        error('Expected '..tostring(fn)..' to raise an error')
    end
    if (type(msg) == 'string' and not msg:match(err))
    or (type(msg) ~= 'string' and not msg == err) then
        error('Unexpected error: '..msg)
    end
end)

require 'test.class'
require 'test.target'
require 'test.native'

test.summary()
