local AppSurface = {}
AppSurface.__index = AppSurface

function AppSurface.new(x, y, width, height, caption)
    local self = setmetatable({}, AppSurface)

    return self
end

function AppSurface:SetSize(width, height)
    
end

function AppSurface:SetPosition(x, y)
    
end

function AppSurface:SetCaption(name)
    
end

function AppSurface:SetDecoVisibility(width, height)
    
end

function AppSurface:SetTopBar(width, height)
    
end

return AppSurface