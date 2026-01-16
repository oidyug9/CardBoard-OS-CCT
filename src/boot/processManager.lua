local processManager = {}
local CrashHandle = require "/boot/crashHandle"

processManager.processes = {}
processManager.nextPID = 1
processManager.currentPID = nil
processManager.Global = {}

function processManager.create(name, func, parentPID)
    local pid = processManager.nextPID
    processManager.nextPID = pid + 1

    local proc = {
        name = name,
        pid = pid, -- process id
        parent = parent, -- parent of current process
        children = {}, --child processes (might be usefull)
        mailbox = {}, -- mailbox (send, recive data between processes)
        co = coroutine.create(func), -- create corutine
        state = "ready" -- status
    }

    processManager.processes[pid] = proc


    if parentPID then -- if parent has been given
    
        if processManager.processes[parentPID] then -- check if parent process exists

            table.insert(processManager.processes[parentPID].children, pid)
        
        else -- if parent process doen't exist crash because funny

            CrashHandle.OnKernelCrash(7, 'parent process not found ( '..tostring(parentPID)..') for '..tostring(proc.pid)..'.')
        
        end
    end


    return pid
end

function processManager.send(TargetPID, data) --send data
    local Target = processManager.processes[tTargetPID]
    if Target then
        table.insert(Target.mailbox,
            {
                sender=processManager.currentPID,
                data = data
            }
        )
    end
end

function processManager.recv()
    local currentProcess = processManager.processes[processManager.currentPID]
    if #currentProcess.mailbox == 0 then
        coroutine.yield() -- suspend process
    end
    return table.remove(currentProcess.mailbox, 1)
end

function processManager.GlobalGet(key)
    return processManager.Global[key]
end

function processManager.GlobalSet(key, value)
    processManager.Global[key] = value
end

function processManager.tick()

    for pid, proc in pairs(processManager.processes) do
        print(proc.name)
        if proc.state ~= "dead" then
            processManager.currentPID = pid

            local ok, err = coroutine.resume(proc.co)

            processManager.currentPID = 0
            if not ok then
                proc.state = "dead"
            end

            if coroutine.status(proc.co) == "dead" then
                proc.state = "dead"
            end
        end
    end
end

return processManager