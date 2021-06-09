#!/bin/bash
#Name: Dominik Hackl

#Function for counting the number of Files in a given directory
nrFiles ()
{
	find $1 -type f 2> /dev/null | wc -l
}

#Function for counting the number of Directories in a given directory
nrDirectories ()
{
	find $1 -type d 2> /dev/null | wc -l
}

#Function for counting the number of Files in a given .tar.gz file
nrFilesArchive ()
{
	tar -tvf $1 | grep "^-" | wc -l
}

#Function for counting the number of Directories in a given .tar.gz file
nrDirectoriesArchive ()
{
	tar -tvf $1 | grep "^d" | wc -l
}

#Backup-function
backup ()
{
	# Set variables for current date, input folder and output file
	date=$(date +%Y-%m-%d_%H-%M-%S)
	input="/home/${1}"
	output="/tmp/${1}_${date}.tar.gz"

	#Pack the given input folder in a archive file
	tar -zczf $output $input 2> /dev/null

	#Count the files and directories in input folder and output file
	numberOfFiles=($(nrFiles $input))
	numberOfFilesInA=($(nrFilesArchive $output))
	numberOfDirs=($(nrDirectories $input))
	numberOfDirsInA=($(nrDirectoriesArchive $output))
	
	#Increase overall-counter
	let ctr=$ctr+$numberOfFiles
	let ctr=$ctr+$numberOfDirs
	
	#Check if the number of files/directories in archive file is equal to the number in input folder
	if [ $numberOfFiles == $numberOfFilesInA ] && [ $numberOfDirs == $numberOfDirsInA ]
	then
		#Read the password from the user
		echo "Enter password:"
		read -s password
		#Encrypt the archive file with given password
		openssl enc -aes-256-cbc -salt -in ${output} -out ${output}.enc -k $password 2> /dev/null
		#Delete unencrypted archive file and set output variable on the new (encrypted) file		
		rm ${output}
		output="${output}.enc"
		
		#Output with details of the file
		echo -e "Backup successful!\nInput folder: ${input}\nOutput file: ${output}\nDetails:"
		ls -l $output
		echo -e "\n"
	else
		echo -e "Backup failed!\nInput folder: ${input}\n"
		rm ${output}
	fi
}

#Overall-counter
ctr=0
#User variable (default value is the currently logged on user)
user=$USER

#When programm is launched without argument, backup the currently logged on user
if [ $# == 0 ]
then
	backup $USER
	#Increase overall counter
	let ctr++
else
	#Use every argument of the launced command and try to backup it
	for username in "$@"
	do
		#Check if directory exists, if not, currently logged on user will be used
		if [ -d "/home/${1}" ]
		then
			backup $username
			#Increase overall counter
			let ctr++
		else
			echo "Default directory will be used!" ;
			backup $USER
			#Increase overall counter
			let ctr++
		fi
	done
fi
#Output overall counter
echo -e "Final counter: ${ctr}"
