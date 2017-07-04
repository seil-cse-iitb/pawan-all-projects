-- file : application.lua
local module = {}  
m = nil




-- Sends a simple ping to the broker
local function send_ping()  
   -- m:publish(config.ENDPOINT .. "ping","id=" .. config.ID,0,0)
     print("nnnnnnn" .. " lasttempo")  
   --  getTemp()
     m:publish("nodemcu/" .. "temp101","909",0,0)
     print("las t" .. " after")
end

-- Sends my id to the broker for registration
local function register_myself()  
    m:subscribe("nodemcu/" .. node.chipid(),0,function(conn)
        print("Successfully subscribed to data endpoint")
    end)
end

local function mqtt_start()  
    m = mqtt.Client(node.chipid(), 120)
    -- register message callback beforehand
    m:on("message", function(conn, topic, data) 
      if data ~= nil then
        print(topic .. ": " .. data)
        -- do something, we have received a message
      end
    end)
    -- Connect to broker
    m:connect("10.129.23.43", 1883, 0, 1, function(con) 
        register_myself()
        -- And then pings each 1000 milliseconds
        tmr.stop(6)
        print("sending tempointh")
        --tmr.delay(100) 
   --     print("timer")
        
        tmr.alarm(6, 5000, 1, send_ping)
        send_ping()
         
      --  tmr.delay(10000000)     
    --    print("timer23")
       
      --  print("before_deep_sleeping90100")
          -- node.dsleep(20000000,1)
       --tmr.alarm(6, delay, 1, print("delaying"))
     --   tmr.delay(1000000) 
       -- setup.start() 
       -- print("after_deep_sleep60")
      -- app = require("applications")  
       -- config = require("config")  
       -- setup = require("setup")

      --  setup.start()  
      ---mqtt_start()
        
    end) 

end

function module.start()  
  print("after_deep_sleep1")
  mqtt_start()

end

return module  
