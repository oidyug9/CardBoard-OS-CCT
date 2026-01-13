local canvas = {}
canvas.__index = canvas

function canvas.new(width, height, color)
    local canvasMatrix = {}
    for y=0, height do
        local w = {}
        for x=0, width do
            table.insert(w, color)
        end
        table.insert(canvasMatrix, w)
    end

    return setmetatable({["canvas"]=canvasMatrix}, canvas)
end

function canvas:DrawPixel(x, y, num)
    self.canvas[y][x] = num
end

function canvas:GetPixel(x, y)
    return self.canvas[y][x]
end

function canvas:DrawFrame(x,y,width,height,num)
    for _x=0, width+x do
        self.canvas[y][x+_x] = num
    end
    for _y=1, y+height-1 do
        self.canvas[y+_y][x] = num
        self.canvas[y+_y][x+width] = num
    end
    for _x=0, width+x do
        self.canvas[y+height][x+_x] = num
    end
end

function canvas:DrawSquare(x, y, width, height, num)
    for _y=0, height do
        for _x=0, width do
            self:DrawPixel(_x+x, _y+y, num)
        end
    end
end


function canvas:Merge(x, y, width, height, ParentCanvas)
    for _y=1, height do
        for _x=1, width do
            local x_Scale = _x/width
            local y_Scale = _x/width

            local X_pixel = math.floor(#self.canvas[1]*x_Scale)
            local Y_pixel = math.floor(#self.canvas*y_Scale)

            ParentCanvas:DrawPixel(self:GetPixel(X_pixel, Y_pixel))
        end
    end
end

function canvas:DrawOnScreen()
    for y = 1, math.floor(#self.canvas / 2) do
        for x = 1, #self.canvas[1] do
            term.setTextColor(tonumber(self:GetPixel(x, y * 2 - 1)))
            term.setBackgroundColor(tonumber(self:GetPixel(x, y * 2)))
            term.setCursorPos(x,y)
            term.write(string.char(131))
        end
    end
end

--canvas = require 'canvas' test=canvas.new(25,25,15) for i=1, #test.canvas, 2 do test:DrawPixel(1, i, 5) end a = canvas.new(50,50,1) test:Merge(1,1,10,10, a) a:DrawOnScreen()
--canvas = require 'canvas' test=canvas.new(25,25,15) for i=1, #test.canvas, 2 do test:DrawPixel(1, i, 5) end test:DrawOnScreen()

return canvas