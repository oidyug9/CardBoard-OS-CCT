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
                table.insert(Found, {file=file, dir=dir})
            end
        end
    
    end

    return Found
end

for _, obj in pairs(ScanRecursive('/')) do
    
    table.insert(BIOS.BootFiles, obj)
end

print()
print('Found: ')


for _, file in pairs(BIOS.BootFiles) do
    local path = file.dir..'/'..file.file
    print(path)
    local File = fs.open(path, 'r')

    local BootableData = textutils.unserialiseJSON(File.readAll())
    File.close()
    print(file.file, ' >>> ', BootableData.name)

    table.insert(BIOS.Bootables, BootableData)
end

local Cursor = 1
local keyname

while true do
    term.clear()
    term.setCursorPos(1, 2)

    print('Welcome to Sticker bios! version '.. BIOS.info.version)
    print('Please select OS / file to boot to')
    print()

    if keyname == 'up' then
        Cursor = Cursor - 1
    elseif keyname == 'down' then
        Cursor = Cursor + 1
    elseif keyname == 'enter' then
        local File = BIOS.Bootables[Cursor].file

        term.clear()
        if File == 'CC' then
            break
        else

            local FilePath = BIOS.BootFiles[Cursor-1].dir .. File
            print('Running: ', FilePath)
            local FileFS = fs.open(FilePath, 'r')
            
            local Executable = load(FileFS.readAll())
            Executable()

            os.shutdown()
        end


        break
    end

    Cursor = (Cursor-1)%(#BIOS.Bootables) +1

    for _, Option in pairs(BIOS.Bootables) do
        local X, Y = term.getSize()
        local Dif = math.floor((Y/1.5)-4)

        if (Cursor<_+Dif) and (Cursor>_-Dif) then

            

            if Cursor==_ then
                term.setTextColor(colors.black)
                term.setBackgroundColor(colors.white)
            end
            local MSG = Option.name -- .. ' - ' .. tostring(BIOS.BootFiles[Cursor-1])
            term.write(MSG .. string.rep(' ', math.max(0, X-#MSG)))
            print()
            term.setTextColor(colors.white)
            term.setBackgroundColor(colors.black)           
        end
    end

    local event, key, is_held = os.pullEvent("key")
    keyname = keys.getName(key)
end
