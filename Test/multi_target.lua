function test.multi_target()
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
