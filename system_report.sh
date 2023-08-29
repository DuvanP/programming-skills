#!/bin/bash
#Author : Duvan Camilo Puerto Barjas
#secction: CST8102 - 313
#name of file: system_report.sh
#ready for submission on aug 06 2023
#Description: This is a program that get information
# of the system like the CPU, memory ram, memory rom and general info about the operative system 



# clear the screen of the shell
clear

#create a global variable and set it to 4
choice=4


#Print the welcome message
# Author name: Duvan Camilo Puerto Barajas ID: 041085718
# date witten: Aug 05 2023
function WellcomeMessage(){

echo "System Monitoring and Reporting"
echo "+++++++++++++++++++++++++++++++++"
echo "1. Generate System Report"
echo "2. Create Archive"
echo "3. Exit"
echo "+++++++++++++++++++++++++++++++++"
read -p "Enter your choice:" answer
choice=$answer
}

# this funtion print all the info requested and append the info to the file system_report.log
# Author name: Duvan Camilo Puerto Barajas ID: 041085718
# date witten: Aug 05 2023
function step1(){
	
	echo "Generating system report..."
	sleep 3
	touch system_report.log
	date >> system_report.log
	#-----------------------------------
	echo "System Information:"
	echo "Hostname:" $(hostname) >> system_report.log
	echo "Hostname:" $(hostname)
	echo "Operating System:" $(uname -s) >> system_report.log
	echo "Operating System:" $(uname -s)
	echo "Kernel Version:" $(uname -r) >> system_report.log
	echo "Kernel Version:" $(uname -r)
	
	#------------------------------------
	echo "CPU Information:"
	lscpu | grep 'Model name' >> system_report.log
	lscpu | grep 'Model name'

	totalMemory=$(free --mega | awk '/^Mem:/ {print $2}')
	printf "Total Memory RAM: %s Mb\n" "$totalMemory" >> system_report.log
	printf "Total Memory RAM: %s Mb\n" "$totalMemory"

	freeMemory=$(free --mega | awk '/^Mem:/ {print $4}')
	printf "Free Memory RAM: %s Mb\n" "$freeMemory" >> system_report.log
	printf "Free Memory RAM: %s Mb\n" "$freeMemory" 
	
	#--------------------------------
	echo "Disk Usage Information:"
	totalDisk=$(df -BG --total | sed -n '$p' | awk '{print $2}')
	usedDisk=$(df -BG --total | sed -n '$p' | awk '{print $3}')
	freeDisk=$(df -BG --total | sed -n '$p' | awk '{print $4}')
	printf "Total: %s, Used: %s, Free: %s\n\n" "$totalDisk" "$usedDisk" "$freeDisk"
	printf "Total: %s, Used: %s, Free: %s\n\n" "$totalDisk" "$usedDisk" "$freeDisk" >> system_report.log

	
	#-----------------------------------
	cpuLoad=$(top -b -n 1 | awk 'NR > 7 {sum += $9} END {print sum}')
        threshold=80

        result2=$(echo "$cpuLoad >= $threshold" | bc -l)
	
	#if the cpu load is bigger or equals to the threshold then print warning but else print success
        if ((result2 == 1));
        then
                printf "WARNING: the CPU Load exceeds the threshold recommended (%.2f%%)\n" "$cpuLoad" >> system_report.log
		printf "WARNING: the CPU Load exceeds the threshold recommended (%.2f%%)\n" "$cpuLoad"


        else
                 printf "SUCCESS: CPU load is within acceptable limits (%.2f%%)\n" "$cpuLoad" >> system_report.log
		 printf "SUCCESS: CPU load is within acceptable limits (%.2f%%)\n" "$cpuLoad"

        fi

	#----------------------------------------

	memoryUsage=$(top -b -n 1 | awk 'NR > 7 {sum += $10} END {print sum}')
        threshold2=50

        result2=$(echo "$memoryUsage >= $threshold2" | bc -l)

	#if the memory usage is bigger or equals to the threshold then print warning but else print success
        if ((result2 == 1));
        then
                 printf "WARNING: the Memory Usage exceeds the threshold recommended (%.2f%%)\n" "$memoryUsage" >> system_report.log
		 printf "WARNING: the Memory Usage exceeds the threshold recommended (%.2f%%)\n" "$memoryUsage"


        else
                 printf "SUCCESS: Memory Usage is within acceptable limits (%.2f%%)\n" "$memoryUsage"  >> system_report.log
		 printf "SUCCESS: Memory Usage is within acceptable limits (%.2f%%)\n" "$memoryUsage"

        fi

	#--------------------------------------
	
	diskUsage=$(df -h / | awk 'NR > 1 {sum += $5} END {print sum}')
        threshold3=70

        result2=$(echo "$diskUsage >= $threshold3" | bc -l)

	#if the Disk usage is bigger or equals to the threshold then print warning but else print success
        if ((result2 == 1));
        then
                 printf "WARNING: the Disk Usage exceeds the threshold recommended (%.2f%%)\n" "$diskUsage" >> system_report.log
		 printf "WARNING: the Disk Usage exceeds the threshold recommended (%.2f%%)\n" "$diskUsage"


        else
                 printf "SUCCESS: Disk usage is within acceptable limits (%.2f%%)\n" "$diskUsage" >> system_report.log
		 printf "SUCCESS: Disk usage is within acceptable limits (%.2f%%)\n" "$diskUsage"

        fi





}


# This funtion will create an archive file .gz with the system_report.log file within.
# Author name: Duvan Camilo Puerto Barajas ID: 041085718
# date witten: Aug 06 2023
function step2(){
	
	# check if the file system_report.log exist in the whole pc
        var=$(find / -type f -name "system_report.log" -print -quit 2>/dev/null)
        
	# if file exists , will create the archive .gz
	# but if the file does not exist will request the data and create the file, then create the archive.gz
	# but if the file exist and file is empty, will request the data and create the file, then  create the archive .gz

        if [ -z $var ]
        then
                
                echo "Error: Log file does not exist or is empty. Generating a new report before creating the archive"
                step1
        else 
                
                
		
		if [ -s $var ]
		then
			sleep 0.1 
		else
			echo "Error: Log file does not exist or is empty. Generating a new report before creating the archive"
			step1
		fi	
	
        fi


	# create the system_report.gz with the system_report.log within
	gzip -c system_report.log > system_report.gz
	echo "  "
	echo "Archive created successfully"





}


# main programm that will stop if user type #3
while [[ $choice != 3 ]]
do
	#print wellcome message calling the function WellcomeMessage
	WellcomeMessage

	# if option 1 is typed, it will call funtion step1
	if [[ $choice = 1 ]]
	then 
		
		step1
		echo "   "

	# if option 2 is typed, it will call function step2
	elif [[ $choice = 2 ]]
	then
		
		step2
		echo "   "

	# if option 3 is typed, it will print the message that the program is over
	elif [[ $choice = 3 ]]	
	then
		echo "Program is over"
	# if user type another option that is not 1, 2 or 3, programm will request for type one of the options
	else 
		echo "Invalid option! Please choose a valid menu item"
		echo "   "
		
	fi	
done







	

















