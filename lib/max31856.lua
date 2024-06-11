
--[[
@module max31856
@summary max31856热电偶温度传感器
@version 1.0.0
@date    2024.06.11
@author  wendal
@tag LUAT_USE_SPI
@usage
-- 具体用法请查阅demo

-- MAX31856 资料地址 https://www.analog.com/media/cn/technical-documentation/data-sheets/MAX31856_cn.pdf
]]

local max31856 = {}

function max31856.tri(spi_id, cs)
    max31856.write(spi_id, cs, 0x00, 0x40)
end

function max31856.temp(spi_id, cs)
    local tmp = max31856.read(spi_id, cs, 0x0C, 3)
    if tmp and #tmp == 3 then
        return tmp:byte(1) + tmp:byte(2) * 256 + tmp:byte(3) * 256 * 256
    end
end

function max31856.write(spi_id, cs, addr, value)
    gpio.set(cs, 0)
    spi.send(spi_id, string.char(addr & 0x80, value))
    gpio.set(cs, 1)
end

function max31856.read(spi_id, cs, addr, len)
    if not len then
        len = 1
    end
    local value = nil
    gpio.set(cs, 0)
    spi.send(spi_id, string.char(addr))
    if len then
        value = spi.recv(spi_id, len)
    else
        value = spi.recv(spi_id, 1)
    end
    gpio.set(cs, 1)
    if len then
        return value
    else
        return value and value:byte(1) or nil
    end
end

return max31856
