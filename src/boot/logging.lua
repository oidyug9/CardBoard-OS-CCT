local logging = {}


function logging.new()
    local LogFile = fs.open("/boot/logs/logs.txt", "w")
    logging.started = os.time()

    LogFile.write("logging started! "..logging.GetStamp())
    LogFile.close()
end

function logging.GetStamp()
    return os.date("%S:%M:%H %d-%m-%y")
end

function logging.finish()

    logging.ended = os.time()

    if not logging.started then
        print(logging.ended)
        print(logging.started)
        error("Logging has not been started! Call logging.new() first.")
    end

    
    -- to do add total work time
    --logging.print('logging', string.format('work time: %02d:%02d:%02d', hours, minutes, seconds))


    fs.copy('/boot/logs/logs.txt', '/boot/logs/logs-'..logging.GetStamp()..'.txt')
end

function logging.log(pre, post, str)
    local fileContent
    local lfr = fs.open('/boot/logs/logs.txt', 'r')
    fileContent = lfr.readAll()
    lfr.close()

    local lf = fs.open('/boot/logs/logs.txt', 'w')
    lf.write(fileContent .. '\n' .. pre .. str .. post)
    lf.close()
end

function logging.print(preInfo, str)
    preInfo = '> ( PRINT ) [ '..logging.GetStamp()..' ] '..preInfo..' '
    logging.log(preInfo, '', str)
end

function logging.error(preInfo, str)
    preInfo = 'E ( ERROR ) [ '..logging.GetStamp()..' ] '..preInfo..' '
    logging.log(preInfo, '', str)
end

function logging.crash(preInfo, code, info, message)
    preInfo = '\n\n-------------- CRASH --------------\n\nX ( CRASH ) [ '..logging.GetStamp()..' ] '..preInfo
    logging.log(preInfo, ' please report!', ' code: '..code.. ' \nmessage: '..message.. '\n-------------- INFO --------------\n\n'..info..'\n\n-------------- END --------------\n\n')
end

function logging.warn(preInfo, str)
    preInfo = 'W ( WARN ) [ '..logging.GetStamp()..' ] '..preInfo..' '
    logging.log(preInfo, '', str)
end


return logging