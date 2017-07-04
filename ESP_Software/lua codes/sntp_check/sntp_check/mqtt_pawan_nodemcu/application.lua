-- file : application.lua
local module = {}  
m = nil
--Global variable section
ID = 1111
pin = 3
ow.setup(pin)
delay=6000 --milisecond
counter=0
lasttemp=-999
temperature = 00.00
temp1 = 0.0
humidity = 00.00
humi1 = 0.0
val = 0
--utility function for ds18 sensor
local function bxor(a,b)
   local r = 0
   for i = 0, 31 do
      if ( ((a % 2) + (b % 2)) == 1 )
      then
         r = r + 2^i
      end
      a = a / 2
      b = b / 2
   end
   return r
end


--Get temperature from DHT
function get_sensor_Data()
    dht=require("dht")
    status,temp,humi,temp_decimial,humi_decimial = dht.read(2)
        if( status == dht.OK ) then
            -- Prevent "0.-2 deg C" or "-2.-6"          
            temperature = temp--.."."..(math.abs(temp_decimial)/100)
            humidity = humi--.."."..(math.abs(humi_decimial)/100)
            temp1 = temp  
            humi1 = humi

            print(temp.." "..temp_decimial.." "..humi.." "..humi_decimial);
            rtcmem.write32(43,temp)
            rtcmem.write32(44,temp_decimial) 
            rtcmem.write32(45,humi)
            rtcmem.write32(46,humi_decimial)
            -- If temp is zero and temp_decimal is negative, then add "-" to the temperature string
            if(temp == 0 and temp_decimial<0) then
                temperature = "-"..temperature
            end
            print("Temperature: "..temperature.." deg C")
            print("Humidity: "..humidity.."%")
           
        elseif( status == dht.ERROR_CHECKSUM ) then          
            print( "DHT Checksum error" )
            temperature=-1 --TEST
        elseif( status == dht.ERROR_TIMEOUT ) then
            print( "DHT Time out" )
            temperature=-2 --TEST
        end
         
    -- Release module
    dht=nil
    package.loaded["dht"]=nil
end

--- Get temperature from DS18B20 
local function getTemp()

      addr = ow.reset_search(pin)
      print(addr)
      repeat
        tmr.wdclr()
      print("excexuting 11111")
      if (addr ~= nil) then
        print("excexuting 2")
        crc = ow.crc8(string.sub(addr,1,7))
        if (crc == addr:byte(8)) then
          print("excexuting 3")
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
                for i = 1, 8 do
                  data = data .. string.char(ow.read(pin))
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
         rtcmem.write32(42,lasttemp)
         print("Last tempreture: " .. lasttemp)
                end                   
                tmr.wdclr()
          end
        end
      end
      addr = ow.search(pin)
      until(addr == nil)
end

-- Sends a simple ping to the broker
local function send_ping()  
   -- m:publish(config.ENDPOINT .. "ping","id=" .. config.ID,0,0)
    
    
   getTemp()
     get_sensor_Data()
    print ("Waiting for Wifi")
    print(wifi.sta.getip())
    print(wifi.sta.status())

    if wifi.sta.status() ~= 5 or wifi.sta.getip() == nil then 
    print ("Wifi Up!")

    tmr.unregister(6)
    setup.start()


 end
        
    if (true ~= m:publish(config.ENDPOINT .. ID,lasttemp,2,0)) then
  
    print("false_publish")
    tmr.unregister(6)
    setup.start()
    
 end
  if (true ~= m:publish(config.ENDPOINT .. "temp_dht",temp1,2,0)) then
  
    print("false_publish")
    tmr.unregister(6)
    setup.start()
    
end
  if (true ~= m:publish(config.ENDPOINT .. "humi_dht",humi1,2,0)) then
  
    print("false_publish")
    tmr.unregister(6)
    setup.start()
    
end


 --print(lasttemp .. " after")
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
       
        send_ping()
        tmr.stop(6)
        print("sending 99 tempointh")
        print("sta disconnect"..wifi.sta.status())
        timerId = 0
        timerDelay = 1000 -- 5sec
        tmr.alarm(timerId, timerDelay, 1, function()
-- your routine
       -- send_ping()
        print("something")
        
        rtctime.dsleep(30000000,2)
end)

        
    end)

end

function module.start()  
--file testing




  print("newpawan")
                sec_rtc, usec_rtc=rtctime.get();
                print(sec_rtc,usec_rtc)
                if(sec_rtc==0) then
                  sntp.sync("10.200.1.15",
  function(sec, usec, server, info)
    print('sync', sec, usec, server)
    tm = rtctime.epoch2cal(sec+19800)
    print(string.format("%04d/%02d/%02d %02d:%02d:%02d", tm["year"], tm["mon"], tm["day"], tm["hour"], tm["min"], tm["sec"]))
    rtctime.set(sec+19800,0)
     
  
  end,
  function()
   print('failed!')
  end
)


                end
                val = rtcmem.read32(42)
                print("last value = ",val);
                val1 = rtcmem.read32(43)
                print("last temp = ",val1);
                val2 = rtcmem.read32(44)
                print("last tempdeci = "..val2.."after correction"..(math.abs(val2)/100));
                val3 = rtcmem.read32(45)
                print("last humi = ",val3);
                val4 = rtcmem.read32(45)
                print("last humideci = ",val4);
   print(ID)
  time_delay=0
  if(sec_rtc==0) then
  time_delay=2000;
  else
  time_delay=1;
  end 
 tmr.alarm(0, time_delay, 1, function()
-- your routine
       -- send_ping()
        print("something")
        
        rtctime.dsleep(30000000,2)
end)
  --mqtt_start()

end

return module  
