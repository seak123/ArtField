local this = {}

this.diagonalFactor = 1.4142135

--a is attacker ,b is defender
this.damageCal = function(value, damageFeature)
    return value
end

this.bitAND = function(a, b)
    local p, c = 1, 0
    while a > 0 and b > 0 do
        local ra, rb = a % 2, b % 2
        if ra + rb > 1 then
            c = c + p
        end
        a, b, p = (a - ra) / 2, (b - rb) / 2, p * 2
    end
    return c
end

this.bitOR = function(a, b)
    local p, c = 1, 0
    while a + b > 0 do
        local ra, rb = a % 2, b % 2
        if ra + rb > 0 then
            c = c + p
        end
        a, b, p = (a - ra) / 2, (b - rb) / 2, p * 2
    end
    return c
end

this.bitNOT = function(n)
    local p, c = 1, 0
    while n > 0 do
        local r = n % 2
        if r < 1 then
            c = c + p
        end
        n, p = (n - r) / 2, p * 2
    end
    return c
end

this.Vector2 = {
    distance = function(a, b)
        local d_x = a.x - b.x
        local d_z = a.z - b.z
        return math.sqrt(d_x * d_x + d_z * d_z)
    end,
    normalize = function(a)
        local factor = math.sqrt(a.x * a.x + a.z * a.z)
        return {x = a.x / factor, z = a.z / factor}
    end
}

return this
