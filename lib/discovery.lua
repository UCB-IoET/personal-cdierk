require "cord"
sh = require "stormsh"

table = {}

function svc_stdout(from_ip, from_port, msg)
	print (string.format("[STDOUT] (ip=%s, port=%d) %s", from_ip, from_port, msg))
end

serviceSock = storm.net.udpsocket(1526,
        function(payload, from, port)
          print (string.format("from %s port %d: %s", from, port, payload))
        end)

ssock = storm.net.udpsocket(1525,
        function(payload, from, port)
          print (string.format("from %s port %d: %s", from, port, payload))
          local unpacked = storm.mp.unpack(payload)
          table[from] = unpacked
	  local svc_invocation = {"svc_stdout", {"hi from Sin Nombre"}}
 	  local msg = storm.mp.pack(svc_invocation)
	  storm.net.sendto(serviceSock, msg, from, 1526)
          print (string.format("to %s port %d: %s", from, 1526, msg))
	end)

--local svc_invocation = {"setLed", {1}, }
--local msg = storm.mp.pack(svc_invocation)
--storm.os.invokePeriodically(storm.os.SECOND, function()
--	storm.net.sendto(serviceSock, msg, "fe80::212:6d02:0:3001", 1526)
--	print (string.format("to fe80::212:6d02:0:3001 port %d: %s", 1526, msg))
--	end)

local svc_manifest = {id="insert team name", setRlyA={"setBool", desc="red LED"}, svc_stdout={"", desc="write to shell"} } 
local msg = storm.mp.pack(svc_manifest)
storm.os.invokePeriodically(5*storm.os.SECOND, function()
	storm.net.sendto(ssock, msg, "ff02::1", 1525)
	end)

sh.start()
cord.enter_loop()
