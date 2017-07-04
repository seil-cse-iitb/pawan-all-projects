import paho.mqtt.client as mqtt
#import paho.mqtt.publish as publish
#from config import MQTT_TOPIC, MQTT_HOST, MQTT_PORT, MQTT_CLIENT
#from csv import writer
import time
import datetime as dt

#FILE_NAME = 'data_recived.csv'

MQTT_TOPIC = 'RELAY/class/001'
MQTT_HOST = '10.129.23.30'
MQTT_PORT = 1883
MQTT_CLIENT = 'relay_test'

def quick_test():
	#for i in range(0,5):
		for j in range(1,9):
	
			time.sleep(0.2)	       
			print client.publish("RELAY/LAB/001", str(j)+" 1", qos=1)
			print("starting "+str(j))
			

		for j in range(8,0,-1):
	
			time.sleep(0.2)	       
			print client.publish("RELAY/LAB/001", str(j)+" 0", qos=1)
			print("closing "+str(j))
			
	
		time.sleep(0.5)	  
	#	i=i+1	     
def on_connect(client, userdata, flags, rc):
    print("Connected with result code " + str(rc))
    
    client.subscribe(MQTT_TOPIC, qos=1)


def on_message(client, userdata, msg):
    received_msg_topic = msg.topic
    now_dt = dt.datetime.now()
    str_time = dt.datetime.strftime(now_dt, '%Y-%m-%d %H:%M:%S')
    print '%s %s:%s %d' %(now_dt, received_msg_topic, msg.payload, len(msg.payload))
  #  print type (msg.payload)
  
 #   code_file_writer.writerow([int(time.time()),received_msg_topic,msg.payload])
 #   code_file.flush()

client = mqtt.Client(MQTT_CLIENT+'CSV')
client.on_connect = on_connect
client.on_message = on_message
#client.connect(MQTT_HOST, MQTT_PORT,30)
#code_file = open(FILE_NAME,'ab')
#code_file_writer = writer(code_file)
#code_file_writer.writerow(['timestamp','topic','code'])
#client.loop_forever()
for i in range(0,100):
	client.connect(MQTT_HOST, MQTT_PORT,30)
	quick_test()
	i=i+1	

