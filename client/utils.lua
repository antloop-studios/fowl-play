function math.lerp(a, b, t)
    return a + (b - a) * t
end

function math.cerp(a, b, t)
    local f = (1 - math.cos(t * math.pi)) * 0.5
    return a * (1 - f) + b * f
end

function math.fuzzy_equals(a, b, tolerance)
    return a == b or math.abs(a-b) < tolerance
end