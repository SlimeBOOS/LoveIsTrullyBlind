local Button = GUI.newTemplate("Button")
local marker = love.graphics.newImage("res/Marker.png")

function Button:load()
  local minHeight = GUI.style.BEBAS:getHeight()

  if self.size.y < minHeight then
    self.size.y = minHeight
  end
end

function Button:draw()
  local scale = math.min(self.size.x/16, self.size.y/16)/2
  love.graphics.setFont(GUI.style.BEBAS)
  love.graphics.setColor(0,0,0,1)
  
  love.graphics.printf(self.text, self.pos.x, self.pos.y + (love.mouse.isDown(1) and self.isHover and 3 or 0), self.size.x, "center")
  love.graphics.setColor(1,1,1,1)
  if self.isHover then
    love.graphics.draw(marker, self.pos.x, self.pos.y, 0, scale)
    love.graphics.draw(marker, self.pos.x+self.size.x, self.pos.y, 0, -scale, scale)
    love.graphics.draw(marker, self.pos.x, self.pos.y+self.size.y, 0, scale, -scale)
    love.graphics.draw(marker, self.pos.x+self.size.x, self.pos.y+self.size.y, 0, -scale, -scale)
  end
end

function Button:mousemoved(x, y)
  self.isHover = self:inBounds(x,y)
end

function Button:mousereleased(x, y, button)
  if self.isHover and button == 1 and self.mouseclicked then
    self.mouseclicked()
    self.isHover = false
  end
end