 local module = {} 
 function star()
 
 print("Ready to start soft ap AND station")
 app = require("applications")
     local str=wifi.ap.getmac();
     local ssidTemp=string.format("%s%s%s",string.sub(str,10,11),string.sub(str,13,14),string.sub(str,16,17));
     wifi.setmode(wifi.STATIONAP)
     
     local cfg={}
     cfg.ssid="ESP8266_"..ssidTemp;
     cfg.pwd="12345678"
     wifi.ap.config(cfg)
     cfg={}
     cfg.ip="192.168.2.1";
     cfg.netmask="255.255.255.0";
     cfg.gateway="192.168.2.1";
     wifi.ap.setip(cfg);
     
     wifi.sta.config("SEIL","deadlock123")
     wifi.sta.connect()
     
     local cnt = 0
     gpio.mode(0,gpio.OUTPUT);
     tmr.alarm(0, 5000, 1, function() 
         if (wifi.sta.getip() == nil) and (cnt < 20) then 
             print("Trying Connect to Router, Waiting...")
             cnt = cnt + 1 
                 if cnt%2==1 then gpio.write(0,gpio.LOW);
                  else gpio.write(0,gpio.HIGH); end
         else 
             tmr.stop(0);
             print("Soft AP started")
             print("Heep:(bytes)"..node.heap());
             print("MAC:"..wifi.ap.getmac().."\r\nIP:"..wifi.ap.getip());
             if (cnt < 50) then print("Conected to Router\r\nMAC:"..wifi.sta.getmac().."\r\nIP:"..wifi.sta.getip())
                        app.start()
                 else print("Conected to Router Timeout")
             end
             gpio.write(0,gpio.LOW);
             cnt = nil;cfg=nil;str=nil;ssidTemp=nil;
             collectgarbage()
         end 
     end)
end
function module.start()  
 print("starting star")
 star()
end

return module  


     
