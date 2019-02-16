local ffi = assert(require("ffi"), "Vector2 needs ffi to be enabled")
local Vector2 = {}
setmetatable(Vector2, Vector2)

ffi.cdef[[
typedef struct {
  double x, y;
} vector2;
]]

function Vector2.copy(t)
  return ffi.new("vector2", t.x, t.y)
end

function Vector2.__call(t, x, y)
  return ffi.new("vector2", x or 0, y or 0)
end

function Vector2.__concat(v1, v2)
  return v1 .. tostring(v2)
end

function Vector2.__tostring(t)
  return string.format("Vector2(%.4f,%.4f)", t.x, t.y)
end

function Vector2.__eq(v1, v2)
  if (not ffi.istype("vector2", v2)) or (not ffi.istype("vector2", v1)) then return false end
  return v1.x == v2.x and v1.y == v2.y
end

function Vector2.__unm(v)
  return Vector2(-v.x, -v.y)
end

function Vector2.__div(v1, op)
  if type(op) ~= "number" then error("Vector2 must be divided by scalar") end
  return Vector2(v1.x / op, v1.y / op)
end

function Vector2.__mul(v1, op)
  if type(op)  == "number" then
    return Vector2(v1.x * op, v1.y * op)
  elseif type(v1) == "number" then
    return Vector2(op.x * v1, op.y * v1)
  end
  return Vector2(v1.x * op.x, v1.y * op.y)
end

function Vector2.__sub(v1, v2)
  if type(v1) == "number" then
    return Vector2(v1 - v2.x, v1 - v2.y)
  elseif type(v2) == "number" then
    return Vector2(v1.x - v2, v1.y - v2)
  end
  return Vector2(v1.x - v2.x, v1.y - v2.y)
end

function Vector2.__add(v1, v2)
  if type(v1) == "number" then
    return Vector2(v1 + v2.x, v1 + v2.y)
  elseif type(v2) == "number" then
    return Vector2(v1.x + v2, v1.y + v2)
  end
  return Vector2(v1.x + v2.x, v1.y + v2.y)
end

function Vector2.split(v)
  return v.x, v.y
end

function Vector2.setAngle(v, angle)
  local magnitude = v.magnitude
  return Vector2(math.cos(angle) * magnitude, math.sin(angle) * magnitude)
end

function Vector2.setMagnitude(t, mag)
  return t.normalized * mag
end

function Vector2.__newindex(t, k, v)
  if k == "magnitude" then
    local result = t:setMagnitude(v)
    t:set(result)
  elseif k == "angle" then
    local result = t:setAngle(v)
    t:set(result)
  elseif type(t) == "cdata" then
    error("Cannot assign new property '" .. k .. "' to a Vector2")
  else
    rawset(t, k, v)
  end
end

function Vector2.getAngle(v)
  return math.atan2(v.y, v.x)
end

function Vector2.getNormalized(v)
  local magnitude = v.magnitude
  if magnitude == 0 then return Vector2() end
  return Vector2(v.x / magnitude, v.y / magnitude)
end

function Vector2.getMagnitude(v)
  return (v.x^2 + v.y^2)^0.5
end

function Vector2.__index(t, k)
  if k == "magnitude" then
    return Vector2.getMagnitude(t)
  elseif k == "normalized" then
    return Vector2.getNormalized(t) 
  elseif k == "angle" then
    return Vector2.getAngle(t)
  end
  return rawget(Vector2, k)
end

function Vector2.rotate(t, rad)
  return Vector2.setAngle(t, t:getAngle() + rad)
end

function Vector2.set(t, v)
  if ffi.istype("vector2", v) then
    t.x = v.x
    t.y = v.y
  end
end

function Vector2.distance(v1, v2)
  return ((v1.x-v2.x)^2 + (v1.y-v2.y)^2)^0.5
end

ffi.metatype("vector2", Vector2)

return Vector2