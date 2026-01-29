local BIOS = {}
BIOS.info = {}

BIOS.info.version = '0.1 test'
BIOS.info.vid = 0
BIOS.BootFiles = {}
BIOS.Bootables = {
    {file='CC', name='Craft-os'}
}

function ScanRecursive(dir)
    local Files = fs.list(dir)
    local Found = {}
    print('Scaning: '..dir)

    for _, file in pairs(Files) do
        local FullPath = fs.combine(dir, file)
        print(FullPath)

        if fs.isDir(FullPath) then
            for _, obj in pairs(ScanRecursive(FullPath)) do
                table.insert(Found, obj)
            end
        else
            if file == 'SysBoot.json' then
                table.insert(Found, FullPath)
            end
        end
    end

    return Found
end

 for _, name in ipairs(peripheral.getNames()) do
    local wraped = peripheral.find(name)
    if peripheral.getType(wraped)=='Disk' then
        for _, obj in pairs(ScanRecursive(disk.getMountPath(name))) do
            table.insert(BIOS.BootFiles, obj)
        end
    end
 end



for _, obj in pairs(ScanRecursive('/')) do
    table.insert(BIOS.BootFiles, obj)
end

print()
print('Found: ')
for _, file in pairs(BIOS.BootFiles) do
    local File = fs.open(file, 'r')

    local BootableData = textutils.unserialiseJSON(File.readAll())
    File.close()
    print(file, ' >>> ', BootableData.name)

    table.insert(BIOS.Bootables, BootableData)
end

local Cursor = 0
local keyname

while true do
    term.clear()
    term.setCursorPos(2, 2)

    print('Welcome to Sticker bios! version '.. BIOS.info.version)
    print('Please select boot file')
    print()

    if keyname == 'up' then
        Cursor = Cursor - 1
    elseif keyname == 'down' then
        Cursor = Cursor + 1
    elseif keyname == 'enter' then
        local File = BIOS.Bootables[Cursor].file
        if File == 'CC' then
            break
        else
            require(File)
        end


        break
    end

    Cursor = (Cursor-1)%(#BIOS.Bootables) +1

    for _, Option in pairs(BIOS.Bootables) do
        local prefix = ''
        if Cursor==_ then
            prefix = '> '
        end
        print(prefix, Option.name)
    end

    local event, key, is_held = os.pullEvent("key")
    keyname = keys.getName(key)
end
