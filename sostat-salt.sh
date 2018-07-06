#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

sudo salt '*' cmd.run 'sostat' | tee sostat-salt.txt &&

csplit -f sostat-split- sostat-salt.txt '/Service Status/-2' {*}  

for file in $(ls sostat-split-*); do 
    WC=$(wc -l $file | awk '{ print $1 }')
    if [[ $WC -lt 1 ]]; then
        rm $file
    fi
done

for file in $(ls sostat-split-*); do
    HOST=$(head -1 $file | tr -d ':')
    mv $file $HOST.txt
done

rm sostat-salt.txt
