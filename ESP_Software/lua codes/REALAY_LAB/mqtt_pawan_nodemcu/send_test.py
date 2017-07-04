from restore import send_mqtt_to_esp
import random 

for i in range(0,100):
	z = random.randint(1,6)
	print z
	send_mqtt_to_esp("F"+str(z),random.randint(0,1))
	sleep(10)	
