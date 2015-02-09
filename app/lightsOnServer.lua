require "cord"
LED = require("led")
REG = require "i2creg"
TMP006 = require "tmp006"

cport = 49152
storm.io.set_mode(storm.io.OUTPUT, storm.io.D2)
blu = LED:new("D2")

-- create echo server as handler
server = function()
   ssock = storm.net.udpsocket(2001, 
	function(payload, from, port)
	  print (string.format("from %s port %d: %s",from,port,payload))
	  blu:flash(1)
	  cord.new(function ()
	    tmpsnsr = TMP006:new()
	    tmpsnsr:init()
	    local value = tmpsnsr:readDieTempC()
	    print(string.format("Temperature is %d degrees Celsius", value))
	    print(storm.net.sendto(ssock, value, from, cport))
	  end)
	  --value = tonumber(payload)
	  --storm.io.set(value, storm.io.D2)
	end)
end

function temp_setup()
	cord.new(function()
		tmpsnsr = TMP006:new()
		tmpsnsr:init()
		local i = 0
		while true do
		  i = i + 1
		  print (i, tmpsnsr:readDieTempC())
		end
	end)
end

server()			-- every node runs the echo server

sh = require "stormsh"
sh.start()
cord.enter_loop()
