local hardwareManager = {}
hardwareManager.foundHardware = {}
hardwareManager.Logging = require('/boot/logging')
hardwareManager.CrashHandle = require "/boot/crashHandle"

hardwareManager.Drivers = {}

function hardwareManager.LoadDrivers()
    for _, file in pairs(fs.list('/boot/drivers')) do
        hardwareManager.Logging.print('Kernel > hardwareManager > LoadDrivers', 'Loading '..file)
        hardwareManager.CrashHandle.kernelCCall(function() hardwareManager.Drivers[file] = require(fs.combine('/boot/drivers', file:sub(1, -5))) end, 8)
    end
end


hardwareManager.Hardware = {}
hardwareManager.Hardware.__index = hardwareManager.Hardware

function hardwareManager.Hardware.new(table)

end

function hardwareManager.checkHardware()
    hardwareManager.Logging.print('Kernel > hardwareManager > checkHardware', 'executed!')
    local foundList = {}

    -- for _, side in pairs( { "left", "right", "top", "bottom", "front", "back" } ) do
    --     local SidePheripherial = peripheral.wrap(side)
    --     if SidePheripherial then -- if pheripherial found
            
        
        
    --     end
    -- end
    for _, name in ipairs(peripheral.getNames()) do
        hardwareManager.Logging.print('Kernel > hardwareManager > checkHardware', 'pheripherial deteccted! '..name..' '..pheripherial.getType(data.wraped))
        data = {}
        data.wraped = peripheral.find(name)
        data.name = name
        data.type = pheripherial.getType(data.wraped)

        print()
    end
end


return hardwareManager