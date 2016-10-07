#!/bin/bash

_USR_=$1

function usage {
        echo "Usage: create_user.sh <username>"
        echo "Hint:"
        echo "The <username> cannot contain spaces"
        exit 1
} #END USAGE

function add_user {

        #Generate password
        usr_pwd=`< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c8`
        _PWD_=`pcrypt ${usr_pwd}`

        #create user
        /usr/bin/sudo /usr/sbin/useradd -m -g tunnel -p ${_PWD_} ${_USR_}


        #Setup Google Auth
        runuser -l ${_USR_} -c 'echo Y | /usr/local/bin/google-authenticator -t -d -f -u >> .authbk'

        #Change users shell
        usermod -s /usr/bin/tunnel_shell ${_USR_}

        #Display User info

        echo "User ${_USR_} added"
        echo "Users password = ${usr_pwd}"
        echo "Users google-authenticator QR code `head -n 1 /home/${_USR_}/.authbk`"
        echo "Users google-authenticator key `sed -n '2p' /home/${_USR_}/.authbk`"
        echo "usage: ssh -r 8500:localhost:22 ${_USR_}@supportconnect.scalearc.net"
        

        /usr/bin/sudo echo "${_USR_}:${usr_pwd}" >> ~/ftpusers
        exit 0

} #END add_user

if [ $# -eq 1 ]
        then
                add_user
        else
                usage
fi

exit 0
