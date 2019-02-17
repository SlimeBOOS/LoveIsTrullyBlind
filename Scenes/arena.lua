local arena = {}
local BGGradient = gradient{rgb(198, 76, 27), rgb(178, 55, 21)}
local psystem = love.graphics.newParticleSystem(love.graphics.newImage("res/miniHeart.png"), 32)
local w,h

local openHeart = love.graphics.newImage("res/OpenPlayerHeart.png")
local closedHeart = love.graphics.newImage("res/ClosedPlayerHeart.png")

local mouseSpeed = Vector2()
local trailPositions = {}
local maxTrailLength = 10
local blindLimit = 0.2
local blindTime = 0


psystem:setParticleLifetime(2, 10) -- Particles live at least 2s and at most 5s.
psystem:setEmissionRate(3)
psystem:setSizes(0.6,0.8,1,1.2,1.4)
psystem:setSizeVariation(1)
psystem:setLinearAcceleration(-15, -45, 15, -10) -- Random movement in all directions.
psystem:setColors(255, 255, 255, 255, 255, 255, 255, 0) -- Fade to transparency.

psystem:update(2)

function drawinrect(img, x, y, w, h, r, ox, oy, kx, ky)
  return love.graphics.draw(img, x, y, r, w / img:getWidth(), h / img:getHeight(), ox, oy, kx, ky)
end

function arena.update(dt)
  psystem:update(dt)
  if love.mouse.isDown(1) and blindTime < blindLimit then
    blindTime = blindTime + dt
  elseif blindTime > 0 then
    blindTime = blindTime - dt
  end

  if mouseSpeed.magnitude > 6 then
    table.insert(trailPositions, Vector2(love.mouse.getPosition()))
    if #trailPositions > maxTrailLength then
      table.remove(trailPositions, 1)
    end
  elseif #trailPositions > 0 then
    table.remove(trailPositions, 1)
  end
end

function arena.mousemoved(x,y,dx,dy)
  mouseSpeed.x = dx
  mouseSpeed.y = dy
end

function arena.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end

function arena.load()
  love.window.setFullscreen(true)
  w,h = love.graphics.getDimensions()
  love.mouse.setVisible(false)
end

function arena.draw()
  drawinrect(BGGradient, 0, 0, w, h)
  love.graphics.draw(psystem, w*0.5, h*1.1, 0, 5)
  love.graphics.draw(psystem, w*0.25, h*1.1, 0, 5)
  love.graphics.draw(psystem, w*0.75, h*1.1, 0, 5)
  love.graphics.draw(psystem, w, h*1.1, 0, 2.5)
  love.graphics.draw(psystem, 0, h*1.1, 0, 2.5)
  local blindnessProgress = blindTime/blindLimit

  for i, pos in ipairs(trailPositions) do
    local opacity = (0.5/#trailPositions)*i*0.75

    love.graphics.setColor(1,1,1,(1 - blindnessProgress) * opacity)
    love.graphics.draw(openHeart, pos.x, pos.y, 0, 2, nil, 16, 16)

    love.graphics.setColor(1,1,1,blindnessProgress * opacity)
    love.graphics.draw(closedHeart, pos.x, pos.y, 0, 2, nil, 16, 16)
  end

  love.graphics.setColor(1,1,1,1 - blindnessProgress)
  love.graphics.draw(openHeart, love.mouse.getX(), love.mouse.getY(), 0, 2, nil, 16, 16)

  love.graphics.setColor(1,1,1,blindnessProgress)
  love.graphics.draw(closedHeart, love.mouse.getX(), love.mouse.getY(), 0, 2, nil, 16, 16)
end


return arena