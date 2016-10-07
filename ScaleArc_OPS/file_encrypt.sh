#!/bin/bash

# Encryption algorhythm to use. 
algo="aes-256-cbc" 
 
# Panic if we don't have the right number of 
# arguments 
if [ "$3" == "" ]; then 
	echo "Usage: $0 [ encrypt|decrypt ] filename passphrase"
	exit 2 
else
	#echo -n "Passphrase: " 
	#stty -echo   
	#read passwd
	#stty echo
	#echo
 
case "$1" in 
	encrypt)
		openssl enc -$algo -e -in $2 -out $2.enc -pass pass:$3
		;;
	decrypt)
		openssl enc -$algo -d -in $2 -out `echo $2 | sed -e 's/\.enc//'` -pass pass:$3
		;;
 
	*)
		echo "Usage: $0 [ encrypt|decrypt ] filename passphrase"
		;;
esac
fi

exit 0