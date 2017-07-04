import json
import time
from decimal import *


#print("staring amin")
#get_and_write("b2a6b3b4a6")
import paho.mqtt.client as mqtt
import paho.mqtt.publish as publish
#from config import MQTT_TOPIC, MQTT_HOST, MQTT_PORT, MQTT_CLIENT
from csv import writer
import time
import datetime as dt
#from pathlib import Path

#my_file = Path("temperature.json")

FILE_NAME = 'data_recived.csv'
#subscribe to topics whichsends data
MQTT_TOPIC = 'esp/i2c/temp/#'
MQTT_HOST = '10.129.23.43'
MQTT_PORT = 1883
MQTT_CLIENT = 'class_room temp_collector'

count = 00
#Global varibles
last_seq_no1 = 00001
last_seq_no2 = 00001
#on connection with the broker subscribe for the topic with quality of service level 2
def get_and_write(address,temp):
        temperature=Decimal(temp)
        print(temperature/1000)
        
        temperature_float=str(temperature/10000)

        print("this is tempereture")
        print(temperature_float)
        try:
               # my_abs_path = my_file.resolve()
               with open('temperature.json',"r+") as json_file:
                        pass
        except:
               print("File not Found Error/Creating a new file")
               with open('temperature.json',"w+") as json_file:
                         data ={"address":[{'Temperature':"temperature in decimal",'Time':"epoch format"}]}
                         json.dump(data, json_file)
        else:
                
      
                with open('temperature.json',"r+") as json_file:
               
                        data = json.load(json_file)
                       
                        try:
                                for p in data[address]:
                                    #print(type(p))
                                    #print(p)
                                    #print('Temperature')
                                    #print(p['Temperature'])
                                    p['Temperature']=temperature_float
                                    p['Time']=int(time.time())
                                    #print('')
                                    with open("temperature.json", "w") as jsonFile:
                                            json.dump(data, jsonFile)
                        except KeyError:
                                entry = {address:[{'Temperature':temperature_float,'Time':time.time()}]}
                                #print type(data)
                                with open('temperature.json',"w+") as json_file:
                                         data.update(entry)
                                         json.dump(data,json_file)


def read_temperature_data(address):
        try:
               # my_abs_path = my_file.resolve()
               with open('temperature.json',"r+") as json_file:
                        pass
                       
        except:
               print("File not Found Error/Creating a new file")
               return 0
        
        else:
                
               with open('temperature.json',"r+") as json_file:
               
                        data = json.load(json_file)
                       
                        try:
                                for p in data[address]:
                                    print('Temperature')
                                    print(p['Temperature'])
                                    print(type(p['Temperature']))
                                    p['Temperature']
                                    return 1;             

                        except KeyError:
                                print("Temperature data of "+address+" is not available")
                                return 0;         
def on_connect(client, userdata, flags, rc):
    print("Connected with result code " + str(rc))
    client.subscribe(MQTT_TOPIC, qos=2)

#following code will be executed when a message is recived
def on_message(client, userdata, msg):
        received_msg_topic = msg.topic
        now_dt = dt.datetime.now()
        str_time = dt.datetime.strftime(now_dt, '%Y-%m-%d %H:%M:%S')
        print '%s %s:%s %d' %(now_dt, received_msg_topic, msg.payload, len(msg.payload))
        print type (msg.payload)
        ls=msg.payload.split(" ")
        print ls[1]
        get_and_write(ls[0],ls[1])
        read_temperature_data(ls[0])             
                        
                

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