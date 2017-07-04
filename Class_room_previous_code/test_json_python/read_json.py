import json
import time

def get_and_write(address):
	with open('temperature.json',"r+") as json_file:  
		 address="b2a6b3b4a6"
		 data = json.load(json_file)
		 for p in data[address]:
			print(type(p))
			print(p)
			print('Temperature' + p['Temperature'])
			p['Time']=int(time.time())
			print('')
		 with open("temperature.json", "w") as jsonFile:
    			json.dump(data, jsonFile)
print("staring amin")
get_and_write("b2a6b3b4a6")
		
