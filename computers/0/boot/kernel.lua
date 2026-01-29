-- info
KernelInfo = {}
KernelInfo.version = 0.01

print('Hello! welcome to cardboard box kernel version '..KernelInfo.version)
print('')
print('please click r to enter repair / toolkit menu')
local event, key, is_held = os.pullEvent("key")
if keys.getName(key) == 'r' then
    return nil
end

-- kernel sub files
Logging = require( 'boot/logging' )
Logging.new()

KC = require( 'boot/crashHandle' )
Procsess = require( 'boot/processManager' )
Hardware = require( 'boot/hardwareManager' )

KC.Logging = Logging
Procsess.Logging = Logging
Hardware.Logging = Logging


Hardware.LoadDrivers()



-- kernel
Kernel = {}
Kernel.Processes = {} -- processes
KernelRunning = true


-- custom enveriouvment
KernelData = {}
KernelData.AdminPassword = '123456' -- to do: add safe way to store password ( lock it behind custom fs so nobody can read it)
KernelData.Files = {}

KernelData.CBGlobals = {}
KernelData.CBGlobals.NotCraftOsGlobals = true

function LoadCustomGlobalObjects()
    Logging.print('Kernel > LoadCustomGlobalObjects', "__ global objects __")
    local FoundObjects = {}

    for _, _objName in pairs(fs.list("/boot/objects")) do
        local objName = _objName:sub(1,-5)
        table.insert(FoundObjects, objName)
        Logging.print('Kernel > LoadCustomGlobalObjects', "Loading "..objName.." global object")
        KC.kernelCCall(function() KernelData.CBGlobals[objName] = require(fs.combine("/boot/objects", objName)) end, 2)
    end

    for _, obj in pairs(FoundObjects) do
        local WasFound = false
        local NotCorrupted = false

        if KernelData.CBGlobals[obj] then
            WasFound = true
            Logging.print('Kernel > LoadCustomGlobalObjects', 'found object: '..obj)

            if type(KernelData.CBGlobals[obj]) == 'table' then
                Logging.print('Kernel > LoadCustomGlobalObjects', 'object: '..obj..' is not corrupted')
                NotCorrupted = true
            end
        end

        if not (WasFound or NotCorrupted) then
            Logging.warn('Kernel > LoadCustomGlobalObjects', 'Object '..obj..' is corrupted')
        end

    end

end


function KernelData.CBGlobals.__request_craftos_globals__() -- return globals with admin perms
    local tries = 5
    for i=1, tries do -- try 5 times
        
        print("please enter ")
        local password = read("*")

        if password == KernelData.AdminPassword then
            return _G -- return globals
        else
            print("wrong password, try again. tries left: "..(tries-i)+1)
        end
    end
    return nil
end

function CreateVirtualImageOfDir(dir)
    local VirtualImage = {}
end

function CustomFileSystem()
    
end

function StartProcess(name, file)
    local proc =  Procsess.create(
        file,
        load(name, nil, nil, KernelData.CBGlobals )
    )

    return proc
end

function RunStartupFiles()
    for _, file in pairs(fs.list('/boot/startup')) do
        local fileFS = fs.open(fs.combine('/boot/startup', file), 'r')

        local FileContent = fileFS.readAll()

        Logging.print('Kernel > RunStartupFiles', 'Starting '.. file..' '.. FileContent..' '.. name)
        StartProcess(file, FileContent)
        fileFS.close()
    end
end

function SetupCustomEnv()
    KC.kernelCCall(LoadCustomGlobalObjects, 3)

end



function __tick()
    Logging.print('Kernel > __tick', 'Executed')
    KC.kernelCCall(Hardware.checkHardware, 9)
    --KC.kernelCCall(Procsess.tick(), 10)

    Logging.print('Kernel > __tick', 'Ended')
end

function __main()
    Logging.print('Kernel > __main', 'Executed')
    term.clear()
    term.setCursorPos(1,1)
    KC.kernelCCall(SetupCustomEnv, 4)
    --KC.kernelCCall(RunStartupFiles, 5)

    while KernelRunning do
        KC.kernelCCall(__tick, 7)
    end

    Logging.print('Kernel > __main', 'Ended')
    return true
end


local success, result = pcall(__main)

Logging.print('Kernel','')

if not success then
    KC.OnKernelCrash(2, result)
end

if KernelRunning and success then
    KC.OnKernelCrash(1, result)
end


Logging.print('Kernel', 'END')
Logging.finish()
os.shutdown()