import paho.mqtt.client as mqtt
import paho.mqtt.publish as publish
#from config import MQTT_TOPIC, MQTT_HOST, MQTT_PORT, MQTT_CLIENT
from csv import writer
import time
import datetime as dt

FILE_NAME = 'data_recived.csv'

MQTT_TOPIC = 'RELAY/LAB/001'
MQTT_HOST = '10.129.23.30'
MQTT_PORT = 1883
MQTT_CLIENT = 'san_nodemcu_temperature_data_collector'

def on_connect(client, userdata, flags, rc):
    print("Connected with result code " + str(rc))
    client.subscribe(MQTT_TOPIC, qos=2)
    while(1):
	import time
	time.sleep(0.5)	       
	publish.single("RELAY/LAB/001", "1 1", qos=2)
	time.sleep(0.5)	       
	publish.single("RELAY/LAB/001", "2 1", qos=2)
	time.sleep(0.5)	       
	publish.single("RELAY/LAB/001", "3 1", qos=2)
	time.sleep(0.5)	       
	publish.single("RELAY/LAB/001", "4 1", qos=2)
	time.sleep(0.5)	       
	publish.single("RELAY/LAB/001", "5 1", qos=2)
	time.sleep(0.5)	       
	publish.single("RELAY/LAB/001", "6 1", qos=2)
	time.sleep(0.5)	       
	publish.single("RELAY/LAB/001", "7 1", qos=2)
	time.sleep(0.5)	       
	publish.single("RELAY/LAB/001", "8 1", qos=2)
	time.sleep(0.5)	       
	publish.single("RELAY/LAB/001", "9 1", qos=2)
	time.sleep(0.5)	       
	publish.single("RELAY/LAB/001", "10 1", qos=2)	
        time.sleep(0.5)
	publish.single("RELAY/LAB/001", "1 0", qos=2)
	time.sleep(0.5)
	publish.single("RELAY/LAB/001", "2 0", qos=2)
	time.sleep(0.5)
	publish.single("RELAY/LAB/001", "3 0", qos=2)
	time.sleep(0.5)
	publish.single("RELAY/LAB/001", "4 0", qos=2)
	time.sleep(0.5)
	publish.single("RELAY/LAB/001", "5 0", qos=2)
	time.sleep(0.5)
	publish.single("RELAY/LAB/001", "6 0", qos=2)
	time.sleep(0.5)
	publish.single("RELAY/LAB/001", "7 0", qos=2)
	time.sleep(0.5)
	publish.single("RELAY/LAB/001", "8 0", qos=2)
	time.sleep(0.5)
	publish.single("RELAY/LAB/001", "9 0", qos=2)
	time.sleep(0.5)
	publish.single("RELAY/LAB/001", "10 0", qos=2)
    print("This is seq_ack")


def on_message(client, userdata, msg):
    received_msg_topic = msg.topic
    now_dt = dt.datetime.now()
    str_time = dt.datetime.strftime(now_dt, '%Y-%m-%d %H:%M:%S')
    print '%s %s:%s %d' %(now_dt, received_msg_topic, msg.payload, len(msg.payload))
    print type (msg.payload)
  
    code_file_writer.writerow([int(time.time()),received_msg_topic,msg.payload])
    code_file.flush()

client = mqtt.Client(MQTT_CLIENT+'CSV')
client.on_connect = on_connect
client.on_message = on_message
client.connect(MQTT_HOST, MQTT_PORT, 60)
code_file = open(FILE_NAME,'ab')
code_file_writer = writer(code_file)
code_file_writer.writerow(['timestamp','topic','code'])
client.loop_forever()
