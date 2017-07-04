 local module = {}
  
flag=0
abc="000000"


local function get_data()

print("ESP8266 Client")


          tmr.alarm(2, 2000, 1, function() 
          print("alarm triggered")
            uart.on("data", "\r",
              function(data)
                print("receive from uart:", data)
                abc=data
                flag=1
                if data=="quit\r" then
                  uart.on("data") -- unregister callback function
                end
            end, 0)

 if(flag==1) then
      --   cl:send(abc)
        --  m:publish("nodemcu/" .. "peer1",abc,2,0)
            print("msg send")
         end
         flag=0

         --[[
            uart.on("data",44, 
                    function(data)
                        print("Received from Arduino:", data)
                       abc = data
                       flag=1
                     end, 0)
      ]]--
       --mqtt_start()
          end)
    

end
 


local function mqtt_start()  
  
            print (uart.getconfig(0))
            print("HELLO WORLD\n\n\n\n")
               uart.write(0,string.byte(5))
    
end



function module.start()  
 print("starting star")

 uart.alt(0)
 uart.setup(0, 115200, 8, uart.PARITY_NONE, uart.STOPBITS_1, 1)
 --mqtt_start()
get_data()
 
end

return module  


     
