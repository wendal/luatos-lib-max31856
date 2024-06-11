# luatos-lib-max31856

驱动 MAX31856 热电偶温度传感器

## 介绍

本库属于工具库,不依赖其他库, 纯lua编写, 可以直接拷贝到项目中使用

## 使用

```lua
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
```

## 变更日志

[changelog](changelog.md)

## LIcense

[MIT License](https://opensource.org/licenses/MIT)
