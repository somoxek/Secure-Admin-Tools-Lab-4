#!/bin/bash
#Name: Dominik Hackl

#Check if a file is specified
if [ $# == 0 ]
then
	echo "Please specify an archive-file!"
else
	#Set input to given argument and output to helper-file
	input=$1
	output="/tmp/output.tar.gz"
	
	#Check if file is existing
	if [ -f $1 ]
	then
		#Read password
		echo "Enter password:"
		read -s password
		
		#Decrypt file
		openssl enc -aes-256-cbc -d -in ${input} -out ${output} -k $password 2> /dev/null
		
		#If decryption is successfull unzip file in current place and delete helper-file
		if [ $? == 0 ]
		then
			tar -xf ${output}
			rm ${output}
			echo "Restore successful!"
		else
			echo "False password!"
		fi
	else
		echo "File not existing!"
	fi
fi
