#!/bin/bash


# e.g., of using this script is as below
# ./local/noisify.sh data/eval2000/wav.scp /erasable/cxy110530/backup_folder/noises/BABBLE.raw /erasable/cxy110530/backup_folder/eval2000_babble_10dB

wavscp=$1
noise=$2
out_dir=$3

add_noise_bin=/erasable/cxy110530/backup_folder/noises/fant/filter_add_noise
temp_dir=$out_dir/temp

rm -rf $temp_dir $out_dir
mkdir --parent $temp_dir $out_dir

for file in `awk '{print $2}' $wavscp`; do 
    #sox -r 8000 -x -s -b 16 -t wav $IN_DIR/$file.wav -t raw -r 8000 $RAW/$file.raw
    bname=`basename $file`
    sox $file --bits 16 --encoding signed-integer --endian little $temp_dir/$bname.raw
done

for file in `awk '{print $2}' $wavscp`; do
    bname=`basename $file`
    echo "$temp_dir/$bname.raw" >> $temp_dir/cleanlist
    echo "$temp_dir/$bname.ns" >> $temp_dir/nslist
done

# add noise at SNR between 0 dB to (0+15) dB
$add_noise_bin -i $temp_dir/cleanlist -o $temp_dir/nslist -n $noise -f g712 -s 0 -w 15 -r 10 -e $temp_dir/fant.log

for file in `awk '{print $2}' $wavscp`; do
    #sox -r 8000 -x -s -b 16 -t raw $RAW/$file.raw -t wav -r 8000 $OUT_DIR/$file.wav
    bname=`basename $file`
    sox -r 8000 --bits 16 --encoding signed-integer --endian little -t raw $temp_dir/$bname.ns $out_dir/$bname
done
#
##rm -rf $TEMP
##rm fant.log
