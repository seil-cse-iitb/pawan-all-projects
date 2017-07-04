-- file : application.lua
local module = {}  
m = nil

ID = 0000
PIRpin = 1
gpio.mode(PIRpin, gpio.INT)
delay=60000 --milisecond
counter=0
lasttemp=-999
movementsSinceLast = -1 
local function bxor(a,b)
   local r = 0
   for i = 0, 31 do
      if ( a % 2 + b % 2 == 1 ) then
         r = r + 2^i
      end
      a = a / 2
      b = b / 2
   end
   return r
end


local function getPIR()
print("Polling PIR pin...")
  tmr.alarm(5, 1000, 1, function() 
    if (gpio.read(PIRpin)==0) then
    print("0")
 
    else
        print("1")
       m:publish(config.ENDPOINT .. ID,"PIR1",2,0)
     
    end  
  end)
end


-- Sends a simple ping to the broker
local function send_ping()  
   -- m:publish(config.ENDPOINT .. "ping","id=" .. config.ID,0,0)
     print(lasttemp .. " lasttempo")  
    
    
    print ("Waiting for Wifi")


    if wifi.sta.status() ~= 5 or wifi.sta.getip() == nil then 
    print ("Wifi Up!")

    tmr.unregister(6)
    setup.start()


    end

     if (true ~= m:publish(config.ENDPOINT .. ID.."checklive",lasttemp,2,0)) then
  
    print("false_publish")
    tmr.unregister(6)
    setup.start()
    
        end
 print(lasttemp .. " after")
end


--- Get temperature from DS18B20 

-- Sends my id to the broker for registration
local function register_myself()  
    m:subscribe(config.ENDPOINT .. config.ID,2,function(conn)
        print("Successfully subscribed to data endpoint")
    end)
end




local function mqtt_start()  
    m = mqtt.Client(config.ID, 120)
 
    print("mqtt client")
    -- register message callback beforehand
    m:on("message", function(conn, topic, data) 
      if data ~= nil then
        print(topic .. ": " .. data)
        -- do something, we have received a message
      end
    end)
    
    
    -- Connect to broker
    m:connect(config.HOST, config.PORT, 0, 1, function(con) 
       -- register_myself()
        -- And then pings each 1000 milliseconds
        send_ping()
        tmr.stop(6)
        print("sending tempointh")
        tmr.alarm(6, delay, 1,function()
        --send_ping()
        end)

 getTemp()
        
    end)

end

function module.start()  
  print("new")
   print(ID)
  mqtt_start()

end

return module  
