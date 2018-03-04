import 'class'

function test.class_basic()
    
    -- Given
    local list = class 'list'
    function list:add(value)
        table.insert(self, value)
    end
    function list:count(value)
        class.mtag(self, 'property')
        return #self
    end
    function list:__index(i)
        if i <= 0 or i > self.count then
            error('Index out of range')
        end
    end

    -- When
    local foo = list { }
    foo:add('a')
    foo:add('b')

    -- Then
    test.equal(foo.count, 2)
    test.expect_error('Index out of range', function() return foo[0] end)
    test.equal(foo[1], 'a')
    test.equal(foo[2], 'b')
    test.expect_error('Index out of range', function() return foo[3] end)

end
