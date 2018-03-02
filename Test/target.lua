function test.target_name()
    -- Given
    my_global_target = target { }
    local my_named_target = target { name = 'my_name' }
    local my_unnamed_target = target { }

    -- Then
    test.equal(tostring(my_global_target), 'my_global_target')
    test.equal(tostring(my_named_target), 'my_name')
    test.equal(tostring(my_unnamed_target), 'UNNAMED TARGET')
end

function test.target_multi()
    -- Given
    local foo = target {
        build = function() end,
        my_prop = target.multi { "a", "b", "c" }
    }

    -- Then
    test.is_true(target.is(foo))
    test.is_true(foo.isMulti)
    test.equal(#foo.depends, 3)
    test.equal(target.single(foo, {my_prop='a'}).my_prop, 'a')
    test.equal(target.single(foo, {my_prop='b'}).my_prop, 'b')
    test.equal(target.single(foo, {my_prop='c'}).my_prop, 'c')
end
