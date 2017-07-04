-- file : config.lua
local module = {}

module.SSID = {}  
module.SSID["test2"] = "12345678"

module.HOST = "192.168.4.1"  
module.PORT = 1883
module.ID = node.chipid()

module.ENDPOINT = "nodemcu/"  
return module 
