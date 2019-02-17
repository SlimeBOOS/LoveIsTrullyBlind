local mainMenu = {}
local showControls = false
local w,h = love.graphics.getDimensions()
local bigHeart = love.graphics.newImage("res/BigHeart.png")
local psystem = love.graphics.newParticleSystem(love.graphics.newImage("res/miniHeart.png"), 32)
local BGGradient = gradient{rgb(198, 76, 27), rgb(178, 55, 21)}

psystem:setParticleLifetime(2, 5) -- Particles live at least 2s and at most 5s.
psystem:setEmissionRate(5)
psystem:setSizes(0.6,0.8,1,1.2,1.4)
psystem:setSizeVariation(1)
psystem:setLinearAcceleration(-20, -20, 20, 20) -- Random movement in all directions.
psystem:setColors(255, 255, 255, 255, 255, 255, 255, 0) -- Fade to transparency.

psystem:update(2)
local function switchControlView() 
  showControls = not showControls
  for _, element in ipairs(mainMenu._elements) do element.visible = not element.visible end 
end

controlsText = [[
  Use the mouse to move around.
  Hold the left mouse button to blind yourself.




  When you are blind you can go through problems.
]]

GUI.addElement(mainMenu, "Button", {size = Vector2(150,45), text = "Play", pos = Vector2(w*0.21, h*0.7), mouseclicked = function() changeActiveScene("arena") end})
GUI.addElement(mainMenu, "Button", {size = Vector2(275,45), text = "Controls", pos = Vector2(w*0.52, h*0.7), mouseclicked = switchControlView})
GUI.addElement(mainMenu, "Button", {visible=false, size = Vector2(165,45), text = "Back", pos = Vector2(w*0.05, h*0.8), mouseclicked = switchControlView})
GUI.addElement(mainMenu, "Label", {visible=false, size = Vector2(w*0.9,h*0.7), text = controlsText, pos = Vector2(w*0.05, h*0.05)})

function drawinrect(img, x, y, w, h, r, ox, oy, kx, ky)
  return love.graphics.draw(img, x, y, r, w / img:getWidth(), h / img:getHeight(), ox, oy, kx, ky)
end

function mainMenu.load()
  love.window.setFullscreen(false)
  w,h = love.graphics.getDimensions()
  love.mouse.setVisible(true)
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
  if not showControls then
    love.graphics.draw(bigHeart, w/2, h/3+math.sin(t)*23, math.cos(t)*0.2, 5+math.sin(t)*0.3, nil, 32, 32)
  end
end

return mainMenu