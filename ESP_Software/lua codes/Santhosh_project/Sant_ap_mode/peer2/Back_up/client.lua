local module = {} 
flag=0
abc="000000"
count=00
function client_start()
--print("ESP8266 Client")


tmr.alarm(1, 2000, 1, function()
     if(wifi.sta.getip()~=nil) then
          tmr.stop(1)
        --  print("Connected!")
       --  print("Client IP Address:",wifi.sta.getip())
          
          cl=net.createConnection(net.TCP, 0)
          cl:connect(88,"192.168.4.1")
             tmr.delay(1000000)
           tmr.alarm(2, 300, 1, function()
         cl:on("receive", function(sck, no)  uart.write(0,"$"..no.."$") end)
          --   print("alrm triggeredmmmm")
         uart.on("data","\r",
              function(data)
              --    print("receive from uart:", data)
                abc=data
                
                
                flag=1
                if data=="quit\r" then
                  uart.on("data") -- unregister callback function
                end
            end, 0)
        --cl:send(abc)
        count=count+1
        if(flag==1) then
        cl:send(abc)
            count=0
           --  print("msg send")
         end
         
      --   print(count)
      if(count==300) then 
      node.restart()
      end
         flag=0

       
          end)
      else
       --  print("Connecting...")
      end
        
end)
end 
function module.start()  
   -- print("starting star")
 
   if pcall(client_start) then
        --      print("Not trasnsfered")
            else
        --      print("Trasp")

             end
            -- client_start()
          
end

return module  

