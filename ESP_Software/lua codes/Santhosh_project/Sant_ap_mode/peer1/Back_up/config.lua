-- file : config.lua
local module = {}

module.SSID = {}  
module.SSID["SEIL"] = "deadlock123"

module.HOST = "10.129.23.43"  
module.PORT = 1883
module.ID = node.chipid()

module.ENDPOINT = "nodemcu/server/"  
return module 
