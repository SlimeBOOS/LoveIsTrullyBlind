local mainMenu = {}
local w,h = love.graphics.getDimensions()
local brokenHeart = love.graphics.newImage("res/brokenHeart.png")
local psystem = love.graphics.newParticleSystem(love.graphics.newImage("res/miniHeart.png"), 32)
local BGGradient = gradient{rgb(198, 76, 27), rgb(178, 55, 21)}

psystem:setParticleLifetime(2, 5) -- Particles live at least 2s and at most 5s.
psystem:setEmissionRate(5)
psystem:setSizeVariation(1)
psystem:setLinearAcceleration(-20, -20, 20, 20) -- Random movement in all directions.
psystem:setColors(255, 255, 255, 255, 255, 255, 255, 0) -- Fade to transparency.

psystem:update(2)

GUI.addElement(mainMenu, "Button", {size = Vector2(150,45), text = "Play", pos = Vector2(w*0.15, h*0.7)})
GUI.addElement(mainMenu, "Button", {size = Vector2(250,45), text = "Controls", pos = Vector2(w*0.6, h*0.7)})

function drawinrect(img, x, y, w, h, r, ox, oy, kx, ky)
  return -- tail call for a little extra bit of efficiency
  love.graphics.draw(img, x, y, r, w / img:getWidth(), h / img:getHeight(), ox, oy, kx, ky)
end

function mainMenu.update(dt)
  psystem:update(dt)
end

function mainMenu.draw()
  local t = love.timer.getTime()
  drawinrect(BGGradient, 0, 0, w, h)
  love.graphics.draw(psystem, w*0.1, h*0.1, 0, 5)
  love.graphics.draw(psystem, w*0.9, h*0.9, 0, 5)
  love.graphics.draw(psystem, w*0.1, h*0.9, 0, 5)
  love.graphics.draw(psystem, w*0.9, h*0.1, 0, 5)
  love.graphics.draw(psystem, w*0.5, h*0.5, 0, 5)
  love.graphics.draw(brokenHeart, w/2, h/3+math.sin(t)*23, math.cos(t)*0.2, 5+ math.sin(t)*0.3, nil, 32, 32)
end

return mainMenu