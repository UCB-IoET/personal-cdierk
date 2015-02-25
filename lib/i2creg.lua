require "cord"
require "table"

local REG = {}

-- Create a new I2C register binding
function REG:new(port, address)
    local obj = {port=port, address=address}
    setmetatable(obj, self)
    self.__index = self
    return obj
end

<<<<<<< HEAD
-- Read a given register address
function REG:r(reg)
    -- TODO:
    -- create array with address
    -- write address
    -- read register with RSTART
    -- storm.i2c.read()
    -- check all return values
    local arr = storm.array.create(1, storm.array.UINT8)
    arr:set(1, reg)
    local status = cord.await(storm.i2c.write, self.port + self.address, storm.i2c.START, arr)
    print(string.format("Write to address 0x%02x: %d", self.address, status))
    if (status ~= storm.i2c.OK) then return nil end
    status = cord.await(storm.i2c.read, self.port + self.address, storm.i2c.RSTART + storm.i2c.STOP, arr)
    print(string.format("Read from address 0x%02x: %d. Value: %d", self.address, status, arr:get(1)))
    return arr:get(1)
    
end

function REG:w(reg, value)
    -- TODO:
    -- create array with address and value
    -- write
    -- check return value
    local arr = storm.array.create(2, storm.array.UINT8)
    arr:set(1, reg)
    arr:set(2, value)
    local status = cord.await(storm.i2c.write, self.port + self.address, storm.i2c.START + storm.i2c.STOP, arr)
    print(string.format("Write to address 0x%02x: %d", self.address, status))
=======
-- Read from a given register address
-- REG: the register address to be read from
-- NUM: the number of bytes to be read [OPTIONAL]
-- Return: a number when NUM is nil or a storm array of UNIT8
function REG:r(reg, num)
    num = num or 1
    local arr = storm.array.create(1, storm.array.UINT8)
    arr:set(1, reg)
    local rv = cord.await(storm.i2c.write, self.port + self.address, storm.i2c.START, arr)
    if (rv ~= storm.i2c.OK) then
        print ("ERROR ON I2C: ",rv)
        return nil
    end
    local result = storm.array.create(num, storm.array.UINT8)
    rv = cord.await(storm.i2c.read, self.port + self.address, storm.i2c.RSTART + storm.i2c.STOP, result)
    if (rv ~= storm.i2c.OK) then
        print ("ERROR ON I2C: ",rv)
        return nil
    end
    if num == 1 then
        return result:get(1)
    else
        return result
    end
end

-- Write to a given register address
-- REG: the register address to be written to
-- VALUES: a lua 1-dimentional list of UINT8 values to be written to OR just 1 UINT8 lua value
-- No return value
function REG:w(reg, values)
    if (type(values) ~= "table") then
        values = {values}
    end
    local arr = storm.array.create(table.maxn(values) + 1, storm.array.UINT8)
    arr:set(1,reg)
    local i = 2
    for key, value in pairs(values) do
        arr:set(i, value)
        i = i + 1
    end
    local rv = cord.await(storm.i2c.write, self.port + self.address, storm.i2c.START + storm.i2c.STOP, arr)
    if (rv ~= storm.i2c.OK) then
        print ("ERROR ON I2C: ",rv)
    end
<<<<<<< HEAD
>>>>>>> 82896052d15746bfa7bd9258c581db62b20a6195
=======
    return 1
>>>>>>> d2f7de8428d1a0ef6d729e0671f624a0a17f7e8a
end

return REG
