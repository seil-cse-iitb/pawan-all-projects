from pir import *
response=0
def main():
	global response
	print("inside Main")
	while(1):
		response=PIR_Start()
		if(response == 1):
			print("++++++++Pir_ Triggered+++++++")
			time.sleep(5)
			response=0			
			


main()
		
