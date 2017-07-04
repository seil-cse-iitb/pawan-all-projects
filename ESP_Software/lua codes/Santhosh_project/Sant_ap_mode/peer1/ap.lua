  local module = {} 
    function run_ap()
     print("Ready to Set up wifi mode")
     wifi.setmode(wifi.STATION)
     
     wifi.sta.config("SEIL","deadlock123")
     wifi.sta.connect()
     local cnt = 0
     tmr.alarm(3, 2000, 1, function() 
         if (wifi.sta.getip() == nil) and (cnt < 20) then 
         print("Trying Connect to Router, Waiting...")
         cnt = cnt + 1 
         else 
         tmr.stop(3)
         if (cnt < 20) then print("Config done, IP is "..wifi.sta.getip())
         else print("Wifi setup time more than 20s, Please verify wifi.sta.config() function. Then re-download the file.")
        end
             cnt = nil;
             collectgarbage();
         end 
          end)

          end

function module.start()  
 print("starting star")
 run_ap()
end
return module  
