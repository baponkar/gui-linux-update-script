#---------------------------------------------------------------------------------------------------------------
#This script update and upgrade installed packages and also removed broken packages
#Building Date : 02/05/2021
#Last Update : 02/05/2021
#Builder : Bapon Kar
#Third Party packages : zenity which can installed by 'sudo apt update -y && sudo apt install zenity -y' command
#Download from : https://github.com/baponkar/gui_update.sh
#License : GNU GPL v 3.0
#---------------------------------------------------------------------------------------------------------------


#!/bin/bash
r="\e[1;31m"   #red color
u="\e[0m"     #reinstall default color


function bell_sound(){
	tput bel
	if [[ $? -ne 0 ]]
	then
		printf "\a"
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
	zenity --question --text="Do you like to installed it in your machine?" --width=320 --height=150 --timeout=5 --title="GUI Update & Upgrade"
	if [[ $? -eq 0 ]]
	then
		pass=$(zenity --password --width=320 --height=150 --timeout=10 --title="GUI Update & Upgrade") 
		$pass | sudo apt install zenity -y
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

	echo 100
	echo "# All Done!"

) | zenity --title "GUI Update & Upgrade Bash script.." --progress --auto-close --auto-kill --width=320 --height=150 --title="GUI Update & Upgrade"
	bell_sound


fi

if [[ -s error.txt ]]
then
	zenity --text-info --filename="error.txt" --text="Error" --width=320 --height=150 --title="GUI Update & Upgrade"
else
	zenity --info  --text="The Script runs successfully!\n There is no Error!" --width=320 --height=150 --title="GUI Update & Upgrade"
fi

rm -r error.txt
rm -r success.txt
