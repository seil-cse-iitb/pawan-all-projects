
import paho.mqtt.client as mqtt
import time, json

from kafka import KafkaProducer
from kafka.errors import KafkaError

# ----- CHANGE THESE FOR YOUR SETUP -----
MQTT_HOST = "10.129.23.43"
MQTT_PORT = 1883
# ---------------------------------------

producer = None

# The callback function for when the client connects to broker
def on_connect(client, userdata, rc):
    global producer
    print("\nConnected with result code " + str(rc) + "\n")
    #Subscribing in on_connect() means that if we lose the connection and
    # reconnect then subscriptions will be renewed.
    client.subscribe("nodemcu/temp")  # Connect to everything in /mcu topic
    print("Subscibed to nodemcu/#")
    producer = KafkaProducer(bootstrap_servers=['10.129.23.30:9092'], acks=1,
                             value_serializer=lambda m: json.dumps(m).encode('ascii'))

def on_message(client, userdata, msg):
    print(msg.topic+" "+str(msg.payload))
    json_data = {}
    json_data['topic'] = msg.topic
    json_data['payload'] = msg.payload
    future = producer.send('nodeMCU', partition=0, value=json_data)
    record_metadata= future.get(timeout=3)
    print record_metadata.topic, record_metadata.offset, record_metadata.partition


# The callback function for when a message on /mcu/rgbled_status/ is published
def on_message_rgbled(client, userdata, msg):
    print("\n\t* LED UPDATED ("+msg.topic+"): " + str(msg.payload))


# Call this if input is invalid
def command_error():
    print("Error: Unknown command")


# Create an MQTT client instance
client = mqtt.Client(client_id="python-client")

# Callback declarations (functions run based on certain messages)
client.on_connect = on_connect
#client.message_callback_add("/mcu/rgbled_status/", on_message_rgbled)
client.on_message = on_message
# This is where the MQTT service connects and starts listening for messages
client.connect(MQTT_HOST, MQTT_PORT, 60)
client.loop_start()  # Background thread to call loop() automatically

# Main program loop
while True:

    #print client.subscribe("nodemcu/temp");
    time.sleep(5)
                  
