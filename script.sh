#!/bin/bash

odp="0"
BACKUPDIR=""
DESTINATION=""
FREQUENCY=""
BACKUPLIFETIME=""


while [ $odp != "6" ]
do
	menu=("1" "Select catalog for backup" "=$BACKUPDIR" "2" "Backup destination" "=$DESTINATION" "3" "Backup frequency" "=$FREQUENCY" "4" "Backup lifetime" "=$BACKUPLIFETIME" "5" "Create" "-" "6" "Exit" "-")

	odp=$(zenity --list --column=Numer --column=Opcje --column=Kryteria "${menu[@]}" --title="Backup maker" --height=500 --width=500)
	
	
	if [ $odp == "1" ]
	then
		BACKUPDIR=$(zenity --file-selection --title="Choose directory to create backup" --directory)

	elif [ $odp == "2" ]
	then
		DESTINATION=$(zenity --file-selection --title="Choose destination directory" --directory)
		
	elif [ $odp == "3" ]
	then
		frequencyMenu=("Minute" "Hour" "Day")
		FREQUENCY=$(zenity --list --column="Select frequency" "${frequencyMenu[@]}" --title="Backup maker" --height=500 --width=500)
		
	elif [ $odp == "4" ]
	then
		lifetimeMenu=("Minute" "Hour" "Day")
		BACKUPLIFETIME=$(zenity --list --column="Select lifetime" "${lifetimeMenu[@]}" --title="Backup maker" --height=500 --width=500)
	
	elif [ $odp == "5" ]
	then 
		if [ ! -z "$BACKUPDIR" ] && [ ! -z "$DESTINATION" ]
		then 
		echo "" > crontabBackup.sh
			if [ ! -z "$FREQUENCY" ]
			then 
				if [ $FREQUENCY == "Minute" ]
				then 
					echo "* * * * * /home/adam/backupScript.sh -a $BACKUPDIR -b $DESTINATION" >> crontabBackup.sh
				elif [ $FREQUENCY == "Hour" ]
				then 
					echo "0 * * * * /home/adam/backupScript.sh -a $BACKUPDIR -b $DESTINATION" >> crontabBackup.sh
				elif [ $FREQUENCY == "Day" ]
				then 
					echo "0 0 * * * /home/adam/backupScript.sh -a $BACKUPDIR -b $DESTINATION" >> crontabBackup.sh
				fi
			fi
			if [ ! -z "$BACKUPLIFETIME" ]
			then
				if [ $BACKUPLIFETIME == "Minute" ]
				then
					TIMETODELETE=1
				elif [ $BACKUPLIFETIME == "Hour" ]
				then 
					TIMETODELETE=59
				elif [ $BACKUPLIFETIME == "Day" ]
				then 
					TIMETODELETE=1439
				fi	
				echo "* * * * * /home/adam/deleteScript.sh -a $DESTINATION -b $TIMETODELETE" >> crontabBackup.sh		
			fi
			./backupScript.sh -a $BACKUPDIR -b $DESTINATION 
			crontab crontabBackup.sh
			(zenity --info --title="Backup maker" --text="Backup was made")
			cd $BACKUPDIR
			ls | (zenity --text-info --height 200 --title="Backuped files")
			size=$(du -sh)
			(zenity --info --title="Backup maker" --text="Backuped files size: $size")
		else 
		 	(zenity --error --text="Fill catalog and destination")
		fi
		
	fi
	
done
