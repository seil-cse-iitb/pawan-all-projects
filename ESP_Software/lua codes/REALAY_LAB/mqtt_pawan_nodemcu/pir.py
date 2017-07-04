import paho.mqtt.client as mqtt  #import the client1
import time

MQTT_TOPIC = 'esp/fck/pir/0'
MQTT_HOST = '10.129.23.43'
MQTT_PORT = 1883
flag=0
def on_connect(client, userdata, flags, rc):
    m="Connected flags"+str(flags)+"result code "\
    +str(rc)+"client1_id  "+str(client)
    print(m)








def on_message(client1, userdata, message):
    global flag
    print("message received  "  ,str(message.payload.decode("utf-8")))
    if(str(message.payload)=="PIR1"):
        client1.disconnect()
        client1.loop_stop()
        flag=1


def PIR_Start(): 
    global flag
    flag=0   	
    # broker_address="192.168.1.184"
    #broker_address="iot.eclipse.org"
    client1 = mqtt.Client("PIR")    #create new instance
    client1.on_connect= on_connect        #attach function to callback
    client1.on_message=on_message        #attach function to callback
    time.sleep(1)
    client1.connect(MQTT_HOST, MQTT_PORT,60)    #connect to broker
    client1.loop_start()    #start the loop
    client1.subscribe("esp/fck/pir/0")
    while(1):
            if(flag==1):
                print("Calling after pir triggered")
                return 1
                break
    return 0    
    #client1.loop_forever()



