-- kernel crash
local KC = {}
KC.errorCodes = {[1]="get_crash_codes crash in crashHandle"}





function KC.OnKernelCrash(errCode, additionalInfo)

    local CrashData = {
        code = errCode,
        additionalInfo=additionalInfo,
        crashmsg=KC.errorCodes[tostring(errCode)] or KC.errorCodes['0']
    }


    local errorDesc = KC.errorCodes[tostring(errCode)] or KC.errorCodes['0']

    print('--------------')
    print()
    print('oh deer! your kernel has crashed!')
    print('Crash code: '..tostring(errCode)..' description: '..tostring(errorDesc))
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
    print('then send content of /boot/latestLog')
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

function KC.get_crash_codes()
    local CrashCodesFile = fs.open('/boot/crashMsg', 'r')

    if type(CrashCodesFile)=='string' or not CrashCodesFile then
        KC.OnKernelCrash(8, 'CrashCodeFiles does NOT exist')
    end

    while true do
        local line = CrashCodesFile.readLine()
        if not line then break end

        if not (line:sub(1,1) == '-' or line:sub(1,1) == '') then

            local code, msg = string.match(line, '^([%w%d]+)=(.+)')
            if code and msg then
                print('loading crash code: '..code..' with message: '..msg)
                KC.errorCodes[code] = msg
                print('Done')

            else
                print('skipping: '..line.." bcuz code or msg is nil ("..tostring(code)..' '..tostring(msg)..')')
            end

        end
    end

    --CrashCodesFile.close()
end

KC.kernelCCall(KC.get_crash_codes, 1)

return KC