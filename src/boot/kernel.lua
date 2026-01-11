-- info
KernelInfo = {}
KernelInfo.version = 0.01

-- kernel
Kernel = {}
Kernel.Terminals = {} -- multi terminal





-- custom enveriouvment
KernelData = {}
KernelData.AdminPassword = '123456' -- to do: add safe way to store password ( lock it behind custom fs so nobody can read it)
KernelData.Files = {}

KernelData.CustomGlobals = {}
KernelData.CustomGlobals.NotCraftOsGlobals = true

function KernelData.CustomGlobals.__request_craftos_globals__() -- return globals with admin perms
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
