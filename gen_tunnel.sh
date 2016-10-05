#!/usr/bin/expect -f
#/opt/idb/support/gen_tunnel
#usage /opt/idb/support/gen_tunnel <port>
port=$1

spawn ssh ${port}:localhost:22 supporttunnel@supportrt.scalearc.net
expect "assword:"
send "hqf4AQCftA\r"
interact