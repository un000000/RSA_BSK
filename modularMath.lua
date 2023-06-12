local function modInverse(a, n)
    local i, v, d;
    i = n
    v = 0
    d = 1

    while a > 0 do
        local t = math.floor(i / a)
        local x = a
        a = i % x
        i = x
        x = d
        d = v - t * x
        v = x
    end
    v = v % n
    if v < 0 then
        v = (v + n) % n
    end
    return v
end

local function powerMod(base, exponent, mod)
    if mod == 1 then return 0 end
    local result = 1
    base = base % mod

    while exponent > 0 do
        if exponent % 2 == 1 then
            result = (result * base) % mod
        end
        exponent = math.floor(exponent / 2)
        base = (base ^ 2) % mod
    end

    return result
end

local ret = {
    modInverse = modInverse,
    powerMod = powerMod,
}
return ret