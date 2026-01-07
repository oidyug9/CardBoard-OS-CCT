kernel = {}

--kernel.TermUtils = require '/apps/TermUtils/main'
kernel.HardwareManager = require '/apps/CardboardOS-HardWareManager/main'

function kernel.SaveKernelData()    -- update system info
    kernel.kernel = {}

    kernel.kernel.Version = "v 0.1 - Experimental"
    kernel.kernel.MadeBy = "Bluescreen (discord: bluescreen_yt)"
    kernel.kernel.DownloadLink = "https://pastebin.com/X7ESQ1JC"
    kernel.kernel.QuickInfo = "Cardboard os kernel code. created for cardboard os v 0.1 (exp)"



    local kerneldata = ''

    for K, V in pairs(kernel.kernel) do
        kerneldata = kerneldata .. K.."="..V .. "\n"
    end

    local DataFile = fs.open("/sys/kernel", 'w')
    DataFile.write(kerneldata)
    DataFile.close()
end

function kernel.__init__()
    kernel.HardwareManager.Check(0.1)
    kernel.HardwareManager.Save(0.1)
    kernel.SaveKernelData()

    --kernel.TermUtils.draw.frame(0,0,10,10, colors.blue)


end

return kernel
