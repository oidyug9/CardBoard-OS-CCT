local window = {}
window.__index = window

function window.new(width, height)
    local self = setmetatable({}, window)

    self.width = width
    self.height = height

    self.RenderBufer = {}
    
    return self
end




return window