-- file : application.lua
local module = {}  
 a = {}  
m = nil

relay1 = 1
relay2 = 2
relay3 = 3
relay4 = 4
relay5 = 5
relay6 = 6
relay7 = 7
relay8 = 8
--relay9 = 9
--relay10 = 10

relay_state = false

gpio.mode(relay1, gpio.OUTPUT)
gpio.mode(relay2, gpio.OUTPUT)
gpio.mode(relay3, gpio.OUTPUT)
gpio.mode(relay4, gpio.OUTPUT)
gpio.mode(relay5, gpio.OUTPUT)
gpio.mode(relay6, gpio.OUTPUT)
gpio.mode(relay7, gpio.OUTPUT)
gpio.mode(relay8, gpio.OUTPUT)
--gpio.mode(relay9, gpio.OUTPUT)
--gpio.mode(relay10, gpio.OUTPUT)

local function set_relay(relay_no,state)
    print("upcoming")
    print(relay_no)
    print(state)
    relay_state = state
    if state == true then
        gpio.write(relay_no,gpio.LOW )
        print("state true");
        a[relay_no]=1
        rtcmem.write32(relay_no,1)
    else
        gpio.write(relay_no, gpio.HIGH)
        print("state false");
        a[relay_no]=0
        rtcmem.write32(relay_no,0)
    end
end

-- Sends a simple ping to the broker
local function send_ping()  
   -- m:publish(config.ENDPOINT .. "ping","id=" .. config.ID,0,0)
  --  m:publish(config.ENDPOINT .. "temp","temp=100",0,0)
   if wifi.sta.status() ~= 5 or wifi.sta.getip() == nil then 
    print ("Wifi Up!")

    tmr.unregister(6)
    setup.start()


   end
end

-- Sends my id to the broker for registration
local function register_myself()  
    m:subscribe(config.ENDPOINT .. "001",0,function(conn)
       
        print("Successfully subscribed to data endpoint"..config.ENDPOINT .. "0011")
    end)
     m:subscribe("RELAY/LAB/001/status",0,function(conn)
       
        print("Successfully subscribed to data endpoint"..config.ENDPOINT .. "0011")
    end)
end

local function mqtt_start()  
    m = mqtt.Client(config.ID, 120)
    -- register message callback beforehand
    m:on("message", function(conn, topic, data) 
    
    print(topic .. ": " ..data)
    if(topic=="RELAY/LAB/001") then           
        temp="123456"
        print(type(data)..type(temp));
        print(string.byte(temp,2));
        objProp = {}
        index = 1
        for value in string.gmatch(data,"%w+") do 
        objProp [index] = value
        index = index + 1
        end
        
        relay_no=objProp[1]
        if(objProp[2]=='1') then
           relay_state=true;
           else
           relay_state=false;
           end
    
        set_relay(relay_no,relay_state)
    
        
          
       
   end
   if(topic=="RELAY/LAB/001/status") then
   
   print("Must be a binary string " .. data)
   end 
   
    for i=1, string.len(data) do
    print (i)
    print (data)
    if(string.byte(data,i)==48)then
        if(a[i]==0)then
        else
            set_relay(i,false)
            
        end

         
    end    
    
    if(string.byte(data,i)==49)then
        if(a[i]==1)then
        else
            set_relay(i,true)
        end

         
    end    


    end
   
    end) 
    -- Connect to broker
    m:connect(config.HOST, config.PORT, 0, 1, function(con) 
        register_myself()
        -- And then pings each 1000 milliseconds
        tmr.stop(6)
        tmr.alarm(6, 1000, 1, send_ping)
    end) 

end

--local function recv_cmd()  
 --   m:subscribe(config.ENDPOINT .. "cmd",0,function(conn) print("subscribe sucess") end)
  --  m:publish(config.ENDPOINT .. "temp","temp=100",0,0)
--end

function to_binary(value)

        -- Formats an incoming integer value into a 32 bit binary string

        convert = {["0"] = "0000",["1"] ="0001",["2"] ="0010",["3"] ="0011",
                ["4"] ="0100",["5"] ="0101",["6"] ="0110",["7"] ="0111",
                ["8"] ="1000",["9"] ="1001",["a"] ="1010",["b"] ="1011",
                ["c"] ="1100",["d"] ="1101",["e"] ="1110",["f"] ="1111"}

        -- Convert them to hex, because hex to binary is easy!

        sval = string.format("%08x",value)

        -- Look up binary equivalent of each hex digit

        local out = ""
        for c=1,8 do
                local vx = string.sub(sval,c,c)
                out = out .. convert[vx]
        end

        return out
end

function module.start()  
      print("Starting  Code")
      print(config.ID)
    for i=1, 8 do
      a[i] = 0
    end
    for i=1, 8 do
      a[i] = rtcmem.read32(i)
      if( a[i]==0)  then
      set_relay(i,false)
      end
      if( a[i]==1)  then
      set_relay(i,true)
      end
      print("value of"..i.."iss"..a[i].."\n")
    end    
     
    


    
    mqtt_start()
end

return module  
