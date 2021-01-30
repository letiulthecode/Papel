--Author: letiulthecode
function class(base, init) --soviet im trying to make smaller than rxi/classic so dont speak "I found a global here"
    local c = {}
    if not init and type(base) == 'function' then
       init = base
       base = nil
    elseif type(base) == 'table' then
       for i,v in pairs(base) do
          c[i] = v
       end
       c._base = base
    else
        error("You need a base or init")
    end
    c.__index = c
    local mt = {}
    mt.__call = function(_, ...)
      local obj = {}
      setmetatable(obj,c)
      if init then
         init(obj,...)
      else
         if base and base.init then
            base.init(obj, ...)
         end
      end
      return obj
    end
    c.init = init
    c.IsA = function(self, klass)
       local m = getmetatable(self)
       while m do 
          if m == klass then return true end
          m = m._base
       end
       return false
    end
    setmetatable(c, mt)
    return c
end