local Label = GUI.newTemplate("Label")

Label.text = ""

function Label:draw()
  love.graphics.setFont(GUI.style.Autobus)
  love.graphics.printf(self.text, self.pos.x, self.pos.y, self.size.x)
end