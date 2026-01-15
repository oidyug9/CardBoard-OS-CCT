-- kernel crash
local KC = {}


function KC.OnKernelCrash(errCode, additionalInfo)
    local errorCodes = {
        [1]="__main() function finished before seting KernelRunning to false",
        [2]="__main() function finished with unsuccessful result",
        [3]="LoadCustomGlobalObjects function error",
        [4]="boot/objects/{obj} error",
        [5]="Startup function error",
        [6]="SetupCustomEnv error",
        ['_']="Unknown"
    }

    local errorDesc = errorCodes[errCode] or errorCodes['_']

    print('--------------')
    print()
    print('oh deer! your kernel has crashed!')
    print('Crash code: '..tostring(errCode)..' description: '..errorDesc)
    print('additionalInfo: '..tostring(additionalInfo))
    print('please report this error.')
    print()
    print('--------------')
    print()
    print('report by:')
    print()
    print('1.joining this discord server')
    print(' https://discord.gg/Kcg3mNxEWy')
    print('2. creating ticket on "error-report" channel')
    print()
    print('or just direct message bluescreen_yt on discord')
    print()
    print('--------------')
    print()

    local func

    while true do
        print('[r]estart / [s]hutdown / [c]raft-os / [e]mergency shell / repair [t]ools')
        local ans = read()

        local options = {
            r=os.reboot,
            s=os.shutdown,
            c=function() shell.run('rom/programs/shell.lua') end,
            e=function () end,
            t=function () end
        }
        
        ans = ans:lower():sub(1,1)

        func = options[ans]
        if func then
            break
        end
    end

    func()
end

function KC.kernelCCall(func, crashCode)
    local success, result = pcall(func)

    if (not success) and success ~= nil then
        KC.OnKernelCrash(crashCode, result)
        os.shutdown()
    end

    return result
end

return KC