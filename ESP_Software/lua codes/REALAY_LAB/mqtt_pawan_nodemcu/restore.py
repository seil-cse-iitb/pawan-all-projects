import paho.mqtt.client as mqtt
import paho.mqtt.publish as publish
#from config import MQTT_TOPIC, MQTT_HOST, MQTT_PORT, MQTT_CLIENT
from csv import writer
import time
import datetime as dt
import datetime, threading, time
from status_list import status
import random
FILE_NAME = 'data_recived.csv'
#subscribe to topics whichsends data
MQTT_TOPIC = 'nodemcu/+/last_state'
MQTT_HOST = '10.129.23.43'
MQTT_PORT = 1883
MQTT_CLIENT = 'restore_previous_status'

count = 00
#Global varibles
#ast_seq_no1 = 00001
#last_seq_no2 = 00001
#on connection with the broker subscribe for the topic with quality of service level 2

def send_mqtt_to_esp(app_id,command):
    if app_id[0]=='F':
        status[int(app_id[1])]=int (command)
        msg=str(app_id[1])+" "+str(command)
        send_msg(msg)
    elif app_id[0]=='L':
        app_no=int(app_id[1])+6
        status[app_no]=int(command)
        msg=str(app_no)+" "+str(command)
        send_msg(msg)
    else:
        pass


def send_msg(msg):
    mqttTopicName="RELAY/LAB/001"
    client.publish(mqttTopicName,msg,2)
    print "msg sent "+msg


	

def on_connect(client, userdata, flags, rc):
    print("Connected with result code " + str(rc))
    client.subscribe(MQTT_TOPIC, qos=2) 
    for i in range(0,10):
	    send_mqtt_to_esp("F1",1)
	    time.sleep(1)
	    send_mqtt_to_esp("F2",1)
	    time.sleep(1)	
	    
    

#following code will be executed when a message is recived
def on_message(client, userdata, msg):
    received_msg_topic = msg.topic
    now_dt = dt.datetime.now()
    str_time = dt.datetime.strftime(now_dt, '%Y-%m-%d %H:%M:%S')
    print '%s %s:%s %d' %(now_dt, received_msg_topic, msg.payload, len(msg.payload))
    print type (msg.payload)
      
# ack_seq_no = msg.payload[0:6]
# exception handling if some messages is not recived 
# it will throw a error if he not able to convert ack_seq_no to integer    
#    try:
#        tobesend=int(ack_seq_no);
#    except ValueError:
#         print("OOPS ERROR")
#         flag=1
# count = count + 1
    print received_msg_topic
# print count

    if(received_msg_topic=="nodemcu/board1/last_state"):
   	 publish.single("RELAY/LAB/001/status", "P1 ")
		   		

def test_send():
	for i in range(0,5):
		z = random.randint(1,6)
		print z
		send_mqtt_to_esp("F"+str(z),"1")
		time.sleep(2)	

next_call = time.time()

def foo():
  global status
  global next_call
  print datetime.datetime.now()
  string = ""
  test_send()
  for x in status:
  	string = string + str(x)
  publish.single("RELAY/LAB/001/status",string)
  next_call = next_call + 30
  threading.Timer( next_call - time.time(), foo ).start()



#Following lines write the recivied messages in the file

#specify mqtt client name using which this client will  register at broker
print("something")
print(int("0111111110",2))
client = mqtt.Client(MQTT_CLIENT+'CSV')
client.on_connect = on_connect
client.on_message = on_message

client.connect(MQTT_HOST, MQTT_PORT, 60)

foo()	
#code_file = open(FILE_NAME,'ab')
#code_file_writer = writer(code_file)
#code_file_writer.writerow(['timestamp','topic','code'])
client.loop_forever()
