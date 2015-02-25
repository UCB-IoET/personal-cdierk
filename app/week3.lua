require "cord"
LED = require("led")

storm.io.set_mode(storm.io.OUTPUT, storm.io.D2)

function onconnect(state)
   if tmrhandle ~= nil then
       storm.os.cancel(tmrhandle)
       tmrhandle = nil
   end
   if state == 1 then
       storm.os.invokePeriodically(1*storm.os.SECOND, function()
           tmrhandle = storm.bl.notify(char_handle, 
              string.format("Time: %d", storm.os.now(storm.os.SHIFT_16)))
       end)
   end
end


storm.bl.enable("unused", onconnect, function()
   local svc_handle = storm.bl.addservice(0x1337)
   char_handle = storm.bl.addcharacteristic(svc_handle, 0x1338, function(x)
       print ("received: ",x)
   end)
   local svc_handle2 = storm.bl.addservice(0x2727)
   char_handle2 = storm.bl.addcharacteristic(svc_handle, 0x2728, function(x)
       --turn led on
	storm.io.set(x, storm.io.D2)
   end)
end)
cord.enter_loop()
