touch host_count.out
nmap -v -sP 172.31.10.0/24 | grep -v down | grep -v up| grep report >> host_count.out
nmap -v -sP 172.31.15.0/24 | grep -v down | grep -v up| grep report >> host_count.out
nmap -v -sP 172.31.20.0/24 | grep -v down | grep -v up| grep report >> host_count.out
nmap -v -sP 172.31.21.0/24 | grep -v down | grep -v up| grep report >> host_count.out
nmap -v -sP 172.31.22.0/24 | grep -v down | grep -v up| grep report >> host_count.out
nmap -v -sP 172.31.23.0/24 | grep -v down | grep -v up| grep report >> host_count.out
nmap -v -sP 172.31.25.0/24 | grep -v down | grep -v up| grep report >> host_count.out
nmap -v -sP 172.31.30.0/24 | grep -v down | grep -v up| grep report >> host_count.out
nmap -v -sP 10.10.0.0/16 | grep -v down | grep -v up| grep report >> host_count.out
nmap -v -sP 10.11.0.0/16 | grep -v down | grep -v up| grep report >> host_count.out
nmap -v -sP 10.12.0.0/16 | grep -v down | grep -v up| grep report >> host_count.out
nmap -v -sP 10.13.0.0/16 | grep -v down | grep -v up| grep report >> host_count.out
nmap -v -sP 10.14.0.0/16 | grep -v down | grep -v up| grep report >> host_count.out
nmap -v -sP 10.15.0.0/16 | grep -v down | grep -v up| grep report >> host_count.out
nmap -v -sP 10.16.0.0/16 | grep -v down | grep -v up| grep report >> host_count.out
nmap -v -sP 10.17.0.0/16 | grep -v down | grep -v up| grep report >> host_count.out
nmap -v -sP 10.18.0.0/16 | grep -v down | grep -v up| grep report >> host_count.out
nmap -v -sP 10.19.0.0/16 | grep -v down | grep -v up| grep report >> host_count.out
nmap -v -sP 10.20.0.0/16 | grep -v down | grep -v up| grep report >> host_count.out
nmap -v -sP 10.21.0.0/16 | grep -v down | grep -v up| grep report >> host_count.out
nmap -v -sP 10.22.0.0/16 | grep -v down | grep -v up| grep report >> host_count.out
nmap -v -sP 10.23.0.0/16 | grep -v down | grep -v up| grep report >> host_count.out
nmap -v -sP 10.24.0.0/16 | grep -v down | grep -v up| grep report >> host_count.out
nmap -v -sP 10.25.0.0/16 | grep -v down | grep -v up| grep report >> host_count.out
nmap -v -sP 10.26.0.0/16 | grep -v down | grep -v up| grep report >> host_count.out
nmap -v -sP 10.27.0.0/16 | grep -v down | grep -v up| grep report >> host_count.out
nmap -v -sP 10.0.0.0/8 | grep -v down | grep -v up| grep report >> host_count.out