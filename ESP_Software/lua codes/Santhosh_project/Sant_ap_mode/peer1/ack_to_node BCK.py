import paho.mqtt.client as mqtt
import paho.mqtt.publish as publish
#from config import MQTT_TOPIC, MQTT_HOST, MQTT_PORT, MQTT_CLIENT
from csv import writer
import time
import datetime as dt

FILE_NAME = 'data_recived.csv'
#subscribe to topics whichsends data
MQTT_TOPIC = 'nodemcu/+/msg'
MQTT_HOST = '10.129.23.43'
MQTT_PORT = 1883
MQTT_CLIENT = 'san_nodemcu_temperature_data_collector'

count = 00
#Global varibles
last_seq_no1 = 00001
last_seq_no2 = 00001
#on connection with the broker subscribe for the topic with quality of service level 2
def on_connect(client, userdata, flags, rc):
    print("Connected with result code " + str(rc))
    client.subscribe(MQTT_TOPIC, qos=2)

#following code will be executed when a message is recived
def on_message(client, userdata, msg):
    global last_seq_no1
    global last_seq_no2
    global count
    received_msg_topic = msg.topic
    now_dt = dt.datetime.now()
    str_time = dt.datetime.strftime(now_dt, '%Y-%m-%d %H:%M:%S')
    print '%s %s:%s %d' %(now_dt, received_msg_topic, msg.payload, len(msg.payload))
    print type (msg.payload)
    flag=0   
    ack_seq_no = msg.payload[0:6]
#exception handling if some messages is not recived 
#it will throw a error if he not able to convert ack_seq_no to integer    
    try:
         tobesend=int(ack_seq_no);
    except ValueError:
         print("OOPS ERROR")
         flag=1
    count = count + 1
    print received_msg_topic
    print count
    if(flag==0):
    	if(tobesend>=0):
		if(received_msg_topic=="nodemcu/peer1/msg"):
		   	print "this is peer 1"
		   	str_last_seq_no1 = '%05d' %last_seq_no1
		   	print "string formated last seq no1 "+str_last_seq_no1
		   	if(last_seq_no1+1 != tobesend):
		   		#publish.single("nodemcu/peer1/ack", "P1"+ack_seq_no, qos=2)
		   		publish.single("nodemcu/peer1/ack", "P1 "+ str_last_seq_no1, qos=2)
		   		time.sleep(1)
		   		print("This is peer 1 requested ack  " + str_last_seq_no1)
		   	else:
		   		last_seq_no1 = tobesend
		    	#Following lines write the recivied messages in the file
			    	print("This is peer 1 written to file 1111111111111  " + str_last_seq_no1)
			    	code_file_writer.writerow([int(time.time()),received_msg_topic,msg.payload])
			    	code_file.flush()

		if(received_msg_topic=="nodemcu/peer2/msg"):
			print "this is peer 2 "
			print tobesend
			str_last_seq_no2 = '%05d' %last_seq_no2
			print "string formated last seq no2 "+str_last_seq_no2
			if(last_seq_no2+1 != tobesend):
				#publish.single("nodemcu/peer1/ack", "P2"+ack_seq_no, qos=2)
				publish.single("nodemcu/peer2/ack", "P2 "+ str_last_seq_no2, qos=2)
			    	print("This is peer 2 requested ack " + str_last_seq_no2)
			else:
			    	last_seq_no2 = tobesend
		    		print("This is peer 1 written to file 222222222  " + str_last_seq_no2)
				#Following lines write the recivied messages in the file
		    		code_file_writer.writerow([int(time.time()),received_msg_topic,msg.payload])
			       	code_file.flush()
			
	 	

#Following lines write the recivied messages in the file

#specify mqtt client name using which this client will  register at broker
client = mqtt.Client(MQTT_CLIENT+'CSV')
client.on_connect = on_connect
client.on_message = on_message

client.connect(MQTT_HOST, MQTT_PORT, 60)
code_file = open(FILE_NAME,'ab')
code_file_writer = writer(code_file)
code_file_writer.writerow(['timestamp','topic','code'])
client.loop_forever()
