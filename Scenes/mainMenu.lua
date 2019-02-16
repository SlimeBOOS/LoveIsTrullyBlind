local mainMenu = {}
local w,h = love.graphics.getDimensions()
local brokenHeart = love.graphics.newImage("res/brokenHeart.png")
local BGGradient = gradient{rgb(198, 76, 27), rgb(178, 55, 21)}

GUI.addElement(mainMenu, "Button", {size = Vector2(150,25), text = "Play", pos = Vector2(50,50)})

function drawinrect(img, x, y, w, h, r, ox, oy, kx, ky)
  return -- tail call for a little extra bit of efficiency
  love.graphics.draw(img, x, y, r, w / img:getWidth(), h / img:getHeight(), ox, oy, kx, ky)
end

function mainMenu.draw()
  local t = love.timer.getTime()
  drawinrect(BGGradient, 0, 0, w, h)
  love.graphics.draw(brokenHeart, w/2, h/3+math.sin(t)*23, math.cos(t)*0.2, 5+ math.sin(t)*0.3, nil, 32, 32)
end

return mainMenu