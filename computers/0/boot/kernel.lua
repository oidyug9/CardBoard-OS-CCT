-- info
KernelInfo = {}
KernelInfo.version = 0.01

-- logging
logging = {}
logging.warns = {}

function wPrint(string)
    table.insert(logging.warns, string)
    print(string)
end

-- kernel crash
KC = require 'boot/crashHandle'
Procsess = require 'boot/processManager'



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
    print("__ global objects __")
    local FoundObjects = {}

    for _, _objName in pairs(fs.list("/boot/objects")) do
        local objName = _objName:sub(1,-5)
        table.insert(FoundObjects, objName)
        print("Loading "..objName.." global object")
        KC.kernelCCall(function() KernelData.CBGlobals[objName] = require(fs.combine("/boot/objects", objName)) end, 2)
    end

    for _, obj in pairs(FoundObjects) do
        local WasFound = false
        local NotCorrupted = false

        if KernelData.CBGlobals[obj] then
            WasFound = true
            print('found object: '..obj)

            if type(KernelData.CBGlobals[obj]) == 'table' then
                print('object: '..obj..' is not corrupted')
                NotCorrupted = true
            end
        end

        if not (WasFound or NotCorrupted) then
            wPrint('Object '..obj..' is corrupted')
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

function StartProcess(file)
    local proc =  Procsess.create(
        file,
        load(file, nil, nil, KernelData.CBGlobals )
    )

    return proc
end

function RunStartupFiles()
    for _, file in pairs(fs.list('/boot/startup')) do
        local fileFS = fs.open(fs.combine('/boot/startup', file), 'r')

        local FileContent = fileFS.readAll()

        print('Starting ', file, FileContent)
        StartProcess(FileContent)
        fileFS.close()
    end
end

function SetupCustomEnv()
    KC.kernelCCall(LoadCustomGlobalObjects, 3)

end



function __tick()
    KC.kernelCCall(Procsess.tick())

end

function __main()
    term.clear()
    term.setCursorPos(1,1)
    KC.kernelCCall(SetupCustomEnv, 4)
    KC.kernelCCall(RunStartupFiles, 5)

    while KernelRunning do
        KC.kernelCCall(__tick, 7)
    end

    return true
end


local success, result = pcall(__main)

print()

if not success then
    KC.OnKernelCrash(2, result)
end

if KernelRunning and success then
    KC.OnKernelCrash(1, result)
end

if #logging.warns > 0 then
    print('----------------------')

    for _, warning in pairs(logging.warns) do
        print(warning)
    end


    sleep(1)
end


os.shutdown()