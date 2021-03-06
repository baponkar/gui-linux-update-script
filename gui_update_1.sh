#---------------------------------------------------------------------------------------------------------------
#This script update and upgrade installed packages and also removed broken packages
#Building Date : 02/05/2021
#Last Update : 03/05/2021
#Builder : Bapon Kar
#Third Party packages : zenity which can installed by 'sudo apt update -y && sudo apt install zenity -y' command
#Download from : https://github.com/baponkar/gui_update.sh
#License : GNU GPL v 3.0
#---------------------------------------------------------------------------------------------------------------


#!/bin/bash
r="\e[1;31m"   #red color
u="\e[0m"     #reinstall default color


function bell_sound(){
	echo -e '\a'
	if [[ $? -ne 0 ]]
	then
		tput bel
		if [[ $? -ne 0 ]]
		then
			printf "\a"
		fi
	fi
}

#check internet is connect or not


#Checking either zwnity installed or not
zenity --version
if [[ $? -ne 0 ]]
then
	bell_sound
	echo -e "$r Please run \'~$ sudo apt install zenity\'\n before run this script $u" #zenity installation command
	zenity --warning --text="No Zenity packages found" --width=320 --height=150 --timeout=3 --title="GUI Update & Upgrade"
	bell_sound
	zenity --question --text="Do you like to installed it in your machine?" --width=320 --height=150 --timeout=5 \
	--title="GUI Update & Upgrade"
	if [[ $? -ne 0 ]]
	then
		bell_sound
		pass=$(zenity --password --width=320 --height=150 --timeout=10 --title="GUI Update & Upgrade") 
		bell_sound
		$pass | sudo apt install zenity -y > error.txt
		
		if [[ $? -eq 0 ]]
				then
					bell_sound
					zenity --info  --text="The zenity package installed successfully.Now run again this script." \
					--width=320 --height=150 --title="GUI Update & Upgrade" --timeout=3
				else
					bell_sound
					zenity --text-info --filename="error.txt" --text="Error" --width=320 --height=150 -\
					-title="GUI Update & Upgrade"
				fi
			else
				exit
		
		fi


else
	pass=$(zenity --password --width=320 --height=150 --timeout=10 --title="GUI Update & Upgrade") #Storing password into pass variable
	(
	echo 25
	echo "# Updating..."
	echo "$pass" | sudo -S apt-get update -y 1> success.txt 2> error.txt
	
	echo 30
	echo "# Upgrading..."
	echo "$pass" | sudo -S apt-get upgrade -y 1>> success.txt 2>> error.txt   

	echo 70
	echo "# Dist. Upgrading.."
	echo "$pass" | sudo -S apt-get dist-upgrade -y 1>> success.txt 2>> error.txt

	echo 90
	echo "# Cleaning..."
	echo "$pass" | sudo -S apt-get autoclean -y 1>> success.txt 2>> error.txt

	echo 95
	echo "# Removing..."
	echo "$pass" | sudo -S apt-get autoremove -y 1>> success.txt 2>> error.txt

	echo 99
	echo "# All Done!"
	sleep 1

) | zenity --title "GUI Update & Upgrade Bash script.." --progress --auto-close\
       	--auto-kill --width=320 --height=150 --title="GUI Update & Upgrade" --time-remaining
	bell_sound


fi

if [[ -s error.txt ]]
then
	bell_sound
	zenity --text-info --filename="error.txt" --text="Error" --width=320 --height=150 --title="GUI Update & Upgrade"
else
	bell_sound
	zenity --info  --text="The Update and Upgrade of packages runs successfully!\n There is no Error!" --width=320 --height=150 \
	--timeout=1 --title="GUI Update & Upgrade"
fi

rm -r error.txt
rm -r success.txt
#---------------------------------------------------------------------------------------------------------------------------------
#security check by rkhunter
zenity --question --text="Do you like to security check in your machine?" --width=320 --height=150 --timeout=5 \
--title="GUI Update & Upgrade"
	if [[ $? -eq 0 ]]
	then
		rkhunter --version
		if [[ $? -eq 0 ]]
		then
		(	echo 0
			echo "# Security Check [1] ... "
			echo "$pass" | sudo -S  rkhunter --sk --propupd 
			
			
			echo 10
			echo "# Security Check [2] ... "
			echo "$pass" | sudo -S rkhunter --sk -c 
			
			echo 99
			echo "# Security check successfully done!"
			sleep 1
			
		) | zenity --title "GUI Update & Upgrade Bash script.." --progress --pulsate --auto-close --auto-kill \
		--width=320 --height=150 --title="GUI Update & Upgrade" --time-remaining
			
			touch temp
			echo -e "The rkhunter security risks.\n"  >> temp
			now=$(date +%d-%m-%Y-%r)
			echo "System last run : $now" >> temp
			cat -n /var/log/rkhunter.log | grep -i warning >> temp
			
	 		zenity --text-info --filename="temp" --text="Security Warning!" --width=650 --height=350 \
			--title="GUI Update & Upgrade"
			rm -r temp
			
			
			
			
		else
			bell_sound
			zenity --warning --text="No rkhunter package found" --width=320 --height=150 --timeout=3 \
			--title="GUI Update & Upgrade" --timeout=2
			bell_sound
			zenity --question --text="Do you like to install rkhunter in your machine?" --width=320 --height=150 \
			--timeout=5 --title="GUI Update & Upgrade"
			if [[ $? -eq 0 ]]
			then
				#pass=$(zenity --password --width=320 --height=150 --timeout=10 --title="GUI Update & Upgrade") 
				$pass | sudo apt install rkhunter -y 2>> error.txt
				if [[ $? -eq 0 ]]
				then
					bell_sound
					zenity --info  --text="The rkhunter installed successfully.Now run again this script." \
					--width=320 --height=150 --title="GUI Update & Upgrade" --timeout=3
				else
					bell_sound
					zenity --text-info --filename="error.txt" --text="Error" --width=320 --height=150 -\
					-title="GUI Update & Upgrade"
				fi
			else
				exit
		
			fi
			
		fi 
	fi
