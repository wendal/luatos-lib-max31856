--[[
wifi定位演示
]]

-- LuaTools需要PROJECT和VERSION这两个信息
PROJECT = "max31856demo"
VERSION = "1.0.0"

log.info("main", PROJECT, VERSION)

-- 一定要添加sys.lua !!!!
sys = require("sys")
max31856 = require("max31856")

-- 用户代码已开始---------------------------------------------

sys.taskInit(function()
    local spiId = 0 -- 按实际情况选取SPI总线
    spi.setup(
            spiId,--串口id
            nil, -- 不要传CS脚
            0,--CPHA
            0,--CPOL
            8,--数据宽度
            20 * 1000000 --频率
        )
    
    sys.taskInit(function()
        local cs = 10 -- CS脚
        gpio.setup(cs, 1, gpio.PULLUP)
        while true do
            -- 首先, 触发一次测量
            max31856.tri(spiId, cs)
            -- 等待测量完成, 大概200ms
            sys.wait(200)
            -- 读取温度
            local temp = max31856.temp(spiId, cs)
            log.info("max31856", temp)
    
            sys.wait(800) -- 累计1秒后,继续测量
        end
    end)
end)

-- 用户代码已结束---------------------------------------------

-- 结尾总是这一句
sys.run()
-- sys.run()之后后面不要加任何语句!!!!!
