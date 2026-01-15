-- info
KernelInfo = {}
KernelInfo.version = 0.01

-- logging
function wPrint(...)
    term.blit(..., string.rep('1', #...))
end









-- kernel
Kernel = {}
Kernel.Processes = {} -- processes
KernelRunning = true

process = {}
process.__index = process

function process.new(func)
    local self = setmetatable({}, process)

    self.func = func
    self.id = #Kernel.Processes
    table.insert(Kernel.Processes, self)
    
    return self
end

function process:run(...)
    self.func(self, ...)
end

function process:kill()
    table.remove(Kernel.Processes, self)
end


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
        KernelData.CBGlobals[objName] = require fs.combine("/boot/objects", objName)
    end

    for _, obj in pairs(FoundObjects) do
        local WasFoundAndNotCorrupted

        error("bruh", 1)
        --warn("testt", 0)

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




function SetupCustomEnv()
    LoadCustomGlobalObjects()

end

-- build in events

function OnKernelCrash(errcode, additionalInfo)

end




function __main()
    term.clear()
    term.setCursorPos(1,1)
    SetupCustomEnv()



    return 0
end


local success, result = pcall(__main)

if not success then
    OnKernelCrash(2, result)
    return
end

if KernelRunning then
    OnKernelCrash(1, result)
    return
end

return result