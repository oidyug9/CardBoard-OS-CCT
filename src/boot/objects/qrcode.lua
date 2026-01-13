
local QrCode = {}

QrCode.AsciiStartOffset = 32
QrCode.AsciiEnd = 126
QrCode.Ascii = {}

for i = QrCode.AsciiStartOffset, QrCode.AsciiEnd do
    QrCode.Ascii[string.char(i)] = i
end

QrCode.__index = QrCode

function QrCode.new()
    return setmetatable({} ,QrCode)
end


function ToBinary(num)
    local bin = ""
    for i = 7, 0, -1 do
        bin = bin .. ((num >> i) & 1)
    end
    return bin
end

function QrCode:generate(data)
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



return QrCode
