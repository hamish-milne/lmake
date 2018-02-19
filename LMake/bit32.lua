if not bit32 then
    bit32 = load([[ return {
        band = function(a, b) return a & b end,
        bor = function(a, b) return a | b end,
        bxor = function(a, b) return a ~ b end,
        bnot = function(a) return ~a end,
        rshift = function(a, n) return a >> n end,
        lshift = function(a, n) return a << n end,
        rrotate = function(a, n)
            local y = (a >> n) & ~(-1 << (32 - n))
            local z = x << (32 - n)
            return y | z
        end
    }]])()
end
