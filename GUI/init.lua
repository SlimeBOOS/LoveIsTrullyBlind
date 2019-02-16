local GUI = {}
local templates = {}
GUI.style = {}


local function getPos(self)
  if self._parent then
    local x0, y0 =  self._parent:getPos()
    return self.pos.x + x0, self.pos.y + y0
  else
    return self.pos.x, self.pos.y
  end
end

local function getSize(self)
  return self.size.x, self.size.y
end

local function getBounds(self)
  local x, y = getPos(self) 
  return x, y, self.size.x, self.size.y
end

local function inBounds(self, x, y)
  local Ex, Ey, width, height = getBounds(self)
  return (x > Ex and x < Ex + width and y > Ey and y < Ey + height)
end

local function clone(data)
  if type(data) ~= "table" then
    return data
  else

    local new = {}
    for k, v in pairs(data) do
      new[k] = clone(v)
    end
    return setmetatable(new, getmetatable(data))
  end
end

local function revipairs(t)
  return function(t, i) i = i - 1 if i > 0 then return i, t[i] end end, t, #t+1
end

local function sortByDepth(a, b)
  return a.depth < b.depth
end

function GUI.createElement(elementType, elementData)
  assert(templates[elementType], "Element '"..elementType.."' not found.")

  local element = elementData or {}
  for k, v in pairs(templates[elementType]) do
    if not (type(k) == "string" and k:find("^__")) and type(element[k]) == "nil" then
      element[k] = clone(v)
    end
  end
  setmetatable(element, templates[elementType])
  
  -- Ensure that the mandatory varaibles are declered
  element.depth = element.depth or 0
  element.pos = element.pos or Vector2()
  element.size = element.size or Vector2()
  if type(element.visible) ~= "boolean" then
    element.visible = true
  end

  if element.load then element:load() end
  return element
end

function GUI.newTemplate(name)
  local template = {}

  template.getPos = getPos
  template.getSize = getSize
  template.getBounds = getBounds
  template.inBounds = inBounds

  templates[name] = template
  return template
end

function GUI.addElement(parent, elementType, elementData)
  local elem = GUI.createElement(elementType, elementData)
  parent._elements = parent._elements or {}
  
  -- Add it to the list
  table.insert(parent._elements, elem)
  table.sort(parent._elements, sortByDepth)
  return elem
end

function callMethod(parent, name, ...)
  if not parent._elements then return end
  for _, element in revipairs(parent._elements) do
    if element.visible then
      
      if type(element._elements) == "table" then
        GUI.callMethod(element, name, ...)
        return
      end

      if element[name] then
        element[name](element, ...)
      end
    end
  end
end

function GUI.draw(parent, ...)
  if not parent._elements then return end
  for _, element in ipairs(parent._elements) do
    if element.visible then

      if element["draw"] then
        element["draw"](element, ...)
      end

      if type(element._elements) == "table" then
        GUI.draw(element, ...)
      end
    end
  end
end

function GUI.loadElements(path)
  if not path then return end
  local dotPath = string.gsub(path,"/","%.")

  -- Load all GUI elements
  for _, file in pairs(love.filesystem.getDirectoryItems(path)) do
    require(dotPath.."."..string.sub(file, 1, -5))
  end
end

for i, name in pairs{"keypressed", "keyreleased", "mousemoved", "mousepressed", "mousereleased", "textinput"} do
  GUI[name] = function(self, ...)
    return callMethod(self, name, ...)
  end
end


return GUI