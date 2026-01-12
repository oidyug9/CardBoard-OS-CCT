-- info
KernelInfo = {}
KernelInfo.version = 0.01

-- kernel
Kernel = {}
Kernel.Processes = {} -- processes

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
