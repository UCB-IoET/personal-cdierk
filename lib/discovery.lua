require "storm"
require "cord"

cal svc_manifest = {id=”ATeam”}
local msg = storm.mp.pack(svc_manifest)
storm.os.invokePeriodically(5*storm.os.SECOND, function()
	storm.net.sendto(a_socket, msg, “ff02::1”, 1525)  --maybe storm.os.net
end)

ssock = storm.net.udpsocket(1525,
	function(payload, from, port)
	  print (string.format("from %s port %d: %s", from, port, payload))
	  blu:flash(1)
	  local unpacked = storm.mp.unpack(payload)
	  print unpacked
	end)

