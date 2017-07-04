-- file : application.lua
local module = {}  
m = nil
pi = ""
ID = 1
pin = 3
ow.setup(pin)
delay=6000 --milisecond
counter=0
lasttemp=-999

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

--- Get temperature from DS18B20 
local function getTemp()

      addr = ow.reset_search(pin)
      print(addr)
      repeat
        tmr.wdclr()
      print("excexuting 11111")
      if (addr ~= nil) then
         print("Current address "..type(addr))
        crc = ow.crc8(string.sub(addr,1,7))
         print("excexuting 2   "..crc)
         for j = 1, 8 do
           print(string.format("pi = %x",addr:byte(j)))
         --  pi = pi..string.format("%x",addr:byte(j))
           print(string.format("di = %d",addr:byte(j)))
           
           end
           pi="28-"
          for j = 8, 2, -1 do
           print(string.format("pi = %x",addr:byte(j)))
           pi = pi..string.format("%x",addr:byte(j))
           print(string.format("di = %d",addr:byte(j)))  
           -- hex = hex .. ":"
         end 
         print(hex)
        if (crc == addr:byte(8)) then
          print("excexuting 3   "..pi)
        
          if ((addr:byte(1) == 0x10) or (addr:byte(1) == 0x28)) then
                print("excexuting 4")
                ow.reset(pin)
                ow.select(pin, addr)
                ow.write(pin, 0x44, 1)
                tmr.delay(1000000)
                present = ow.reset(pin)
                ow.select(pin, addr)
              
                ow.write(pin,0xBE, 1)
                data = nil
                data = string.char(ow.read(pin))
              --  print("data 1"..type(data))
                for i = 1, 8 do
                 
                  data = data .. string.char(ow.read(pin))
                --  print("data "..i .." "..string.byte(data))
                end
                crc = ow.crc8(string.sub(data,1,8))
                if (crc == data:byte(9)) then
                   t = (data:byte(1) + data:byte(2) * 256)
                   if (t > 32768) then
                    t = (bxor(t, 0xffff)) + 1
                    t = (-1) * t
                   end
                    t = t * 625
                    lasttemp = t
                       
                    print("Last temp: " .. lasttemp)
               end                   
               tmr.wdclr()
          end
        end
      
       if (true ~= m:publish(config.ENDPOINT .. ID,pi.." "..lasttemp,2,0)) then
  
               print("false_publish")
               tmr.unregister(6)
               setup.start()
                            
      end
       pi=""
     end
           addr = ow.search(pin)
      until(addr == nil)
end

-- Sends a simple ping to the broker
local function send_ping()  
   -- m:publish(config.ENDPOINT .. "ping","id=" .. config.ID,0,0)
     print(lasttemp .. " lasttempo"..pi)  
     getTemp()
    
 print ("Waiting for Wifi")
 print(wifi.sta.getip())
 print(wifi.sta.status())

 if wifi.sta.status() ~= 5 or wifi.sta.getip() == nil then 
 print ("Wifi Up!")

 tmr.unregister(6)
 setup.start()


 end
--[[
     if (true ~= m:publish(config.ENDPOINT .. ID,pi.." "..lasttemp,2,0)) then
  
    print("false_publish")
    tmr.unregister(6)
    setup.start()
    
end
--]]
 print(lasttemp .. " after")
end

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
        --tmr.delay(100) 
   --     print("timer")
       -- reconnect()
        tmr.alarm(6, delay, 1,function()
       -- reconnect()
        send_ping()
        end)

        
    --   send_ping()
         
         
    --    print("timer23")
     --  wifi.sta.disconnect()
 --tmr.delay(5000000)
      --  print("before_deep_sleeping90100")

    --  tmr.alarm(6, delay, 1,  node.dsleep(10000000,4))
        -- node.dsleep(10000000,4)
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
  print("new")
   print(ID)
  mqtt_start()

end

return module  
