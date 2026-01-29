local canvas = {}
canvas.__index = canvas

function canvas.new(width, height, r, g, b)
    local canvasMatrix = {}
    for y=0, height do
        local w = {}
        for x=0, width do
            table.insert(w, {r=r,g=g,b=b})
        end
        table.insert(canvasMatrix, w)
    end

    return setmetatable({[canvas]=canvasMatrix}, canvas)
end

function canvas:DrawPixel(x, y, r, g, b)
    self.canvas[y][x][r] = r
    self.canvas[y][x][g] = g
    self.canvas[y][x][b] = b
end

function canvas:GetPixel(x, y)
    return self.canvas[y][x]
end

-- function canvas:DrawFrame(x,y,width,height,r, g, b)
--     for _x=0, width+x do
--         self.canvas[y][x+_x] = num
--     end
--     for _y=1, y+height-1 do
--         self.canvas[y+_y][x] = num
--         self.canvas[y+_y][x+width] = num
--     end
--     for _x=0, width+x do
--         self.canvas[y+height][x+_x] = num
--     end
-- end

function canvas.from0to255(val)
    return math.min(255, math.max(0, val))
end

function canvas.FIX_COLOR(color)
    local R = math.min(255, math.max(0, color.r))
    local G = math.min(255, math.max(0, color.g))
    local B = math.min(255, math.max(0, color.b))

    return {r=R, g=G, b=B}
end

function canvas:DrawSquare(x, y, width, height, r, g, b)
    for _y=0, height do
        for _x=0, width do
            self:DrawPixel(_x+x, _y+y, r, g, b)
        end
    end
end

function canvas:clone()
    local new = canvas.new(#self.canvas[1], #self.canvas, 0, 0, 0)
    for y=1, #self.canvas do 
        for x=1, #self.canvas[1] do 
            new:DrawPixel(x, y, table.unpack(self:GetPixel(x, y)))
        end
    end
end

function canvas:AtkinsonDither(snap, spread, div)
    local function DitherFunc(x, y, r, g, b)
        local old = pixel
        local new = math.floor(pixel*snap + 0.5)/snap
        local err = old-new
        local spreadErr = err/div

        for SX=0, spread do
            for SY=0, spread do
                self:ExecuteOnPixel(x+SX,y+SY, function (_, _, r, g, b)
                    return canvas.FIX_COLOR({r=r + spreadErr, g=g + spreadErr, b=b + spreadErr})
                end)
            end
        end


        return {r=newR, g=newG, b=newB}
    end

    self:ExecuteForEveryPixel(DitherFunc)
end

function canvas:ExecuteOnPixel(x,y,func)
    self:DrawPixel(x, y, table.unpack(func(x, y, table.unpack(self.GetPixel(x, y)))))
end

function canvas:ExecuteForEveryPixel(func)
    for y=1, #self.canvas do 
        for x=1, #self.canvas[1] do 
            canvas:RunOnPixel(x,y,func)
        end
    end

end

function canvas:Merge(x, y, width, height, ParentCanvas)
    for _y=1, height do
        for _x=1, width do
            local x_Scale = _x/width
            local y_Scale = _x/width

            local X_pixel = math.ceil(#self.canvas[1]*x_Scale)
            local Y_pixel = math.ceil(#self.canvas*y_Scale)

            ParentCanvas:DrawPixel(x, y, table.unpack(self:GetPixel(X_pixel, Y_pixel)))
        end
    end
end

function canvas:DrawOnScreen(x, y)
    for _y = 1, math.floor(#self.canvas / 2) do
        for _x = 1, #self.canvas[1] do
            term.setTextColor(tonumber(self:GetPixel(_x, _y * 2 - 1)))
            term.setBackgroundColor(tonumber(self:GetPixel(_x, _y * 2)))
            term.setCursorPos(_x+x,_y+y)
            term.write(string.char(131))
        end
    end
end

--canvas = require 'canvas' test=canvas.new(25,25,1) for i=1, #test.canvas, 2 do test:DrawPixel(1, i, 5) end a = canvas.new(25,25,1) test:Merge(1,1,15,15, a) a:DrawOnScreen(15, 15)
--canvas = require 'canvas' test=canvas.new(25,25,15) for i=1, #test.canvas, 2 do test:DrawPixel(1, i, 5) end test:DrawOnScreen(15, 15)

return canvas
