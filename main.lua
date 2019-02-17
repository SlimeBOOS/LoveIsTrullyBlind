local activeScene = nil

Vector2 = require("Vector2")
GUI = require("GUI")


love.graphics.setDefaultFilter("nearest", "nearest")

function rgb(r,g,b)
  return {r/255,g/255,b/255, 1}
end

function gradient(colors)
  local direction = colors.direction or "horizontal"
  if direction == "horizontal" then
      direction = true
  elseif direction == "vertical" then
      direction = false
  else
      error("Invalid direction '" .. tostring(direction) .. "' for gradient.  Horizontal or vertical expected.")
  end
  local result = love.image.newImageData(direction and 1 or #colors, direction and #colors or 1)
  for i, color in ipairs(colors) do
      local x, y
      if direction then
          x, y = 0, i - 1
      else
          x, y = i - 1, 0
      end
      result:setPixel(x, y, color[1], color[2], color[3], color[4] or 1)
  end
  result = love.graphics.newImage(result)
  result:setFilter('linear', 'linear')
  return result
end

function printTable(t, depth)
  if type(t) ~= "table" then return end
  depth = depth or 0
  for k,v in pairs(t) do
    if type(v) == "table" then
      print(string.rep("  ", depth)..tostring(k), "table:")
      printTable(v, depth+1)
    else
      print(string.rep("  ", depth)..tostring(k), tostring(v))
    end
  end
end

local function call(name, ...)
  if activeScene then
    if activeScene[name] then activeScene[name](...) end
    if GUI[name] then GUI[name](activeScene, ...) end
  end
end

function changeActiveScene(sceneName, ...)
  activeScene = require("Scenes."..sceneName)
  call("load", ...)
end

function love.run()
	if love.load then love.load(love.arg.parseGameArguments(arg), arg) end
 
	-- We don't want the first frame's dt to include time taken by love.load.
	if love.timer then love.timer.step() end
 
	local dt = 0
 
	-- Main loop time.
	return function()
		-- Process events.
		if love.event then
			love.event.pump()
			for name, a,b,c,d,e,f in love.event.poll() do
				if name == "quit" then
					if not love.quit or not love.quit() then
						return a or 0
					end
        end
        call(name, a,b,c,d,e,f)
				love.handlers[name](a,b,c,d,e,f)
			end
		end
 
		-- Update dt, as we'll be passing it to update
		if love.timer then dt = love.timer.step() end
 
		-- Call update and draw
		--if love.update then love.update(dt) end -- will pass 0 if love.timer is disabled
    call("update", dt)

		if love.graphics and love.graphics.isActive() then
      love.graphics.origin()
      love.graphics.setColor(1,1,1,1)
			love.graphics.clear(love.graphics.getBackgroundColor())
 
			--if love.draw then love.draw() end
      call("draw")

			love.graphics.present()
		end
 
		if love.timer then love.timer.sleep(0.001) end
	end
end

GUI.style.BEBAS = love.graphics.newFont("res/BEBAS___.ttf", 58)
GUI.style.Autobus = love.graphics.newFont("res/Autobus-Bold.ttf", 40)

GUI.loadElements("GUI/Elements")

changeActiveScene("mainMenu")