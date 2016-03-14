#!/bin/bash

in_file=$1
out_file=$2

rm -f $out_file;

while read line
do

    num_word=`echo $line | wc | awk '{print $2}'`
    
    if [ $num_word -lt 10 ]; then
        echo $line | awk '{print $1}' >> $out_file
    fi
done < $in_file


