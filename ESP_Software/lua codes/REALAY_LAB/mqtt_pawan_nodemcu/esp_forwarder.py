import paho.mqtt.client as mqtt
#from restore import status
#from restore import client
#from status_list import status
from restore import send_msg

def send_mqtt_to_esp(app_id,command):
    if app_id[0]=='F':
   #     status[int(app_id[1])]=int (command)
        msg=str(app_id[1])+" "+str(command)
        send_msg(msg)
    elif app_id[0]=='L':
        app_no=int(app_id[1])+6
    #	status[app_no]=int(command)
        msg=str(app_no)+" "+str(command)
        send_msg(msg)
    else:
        pass






