local QrCode = {}

QrCode.AsciiStartOffset = 32
QrCode.AsciiEnd = 126
QrCode.Ascii = {}

for i = QrCode.AsciiStartOffset, QrCode.AsciiEnd do
    QrCode.Ascii[string.char(i)] = i
end

QrCode.__index = QrCode



function QrCode.new(canvas)
    return setmetatable({["canvas"]=canvas} ,QrCode)
end


function ToBinary(num)
    local bin = ""
    for i = 7, 0, -1 do
        bin = bin .. ((num >> i) & 1)
    end
    return bin
end

function QrCode:EnCode()
    self.width = #self.canvas
    self.height = #self.canvas[1]

    self.canvas:DrawFrame()
end



function QrCode:generate(data)
    self.burnPath = {}
    self.data = data
    self.QrData = ""
    self.QrHeader = ToBinary(#data)
    for character in string.gmatch(data, '.') do
        self.QrData = self.QrData .. ToBinary(QrCode.Ascii[character])
    end

    return self.QrData
end

function QrCode:getInfo()
    
end

function QrCode:paint(x, y)
    
end
-- create canvas, new, generate, encode, burn, paint (flow of tasks in order to generate and paint qr code)


return QrCode
