#!/bin/bash

dest_dir=$1
dir1=$2
dir2=$3
map_dir=$4
mapdir1=$5
mapdir2=$6

mkdir -p $dest_dir
cat $dir1/ivector.scp > $dest_dir/ivector.scp
cat $dir2/ivector.scp >> $dest_dir/ivector.scp

mkdir -p $map_dir
cat $mapdir1/utt2spk > $map_dir/utt2spk
cat $mapdir2/utt2spk >> $map_dir/utt2spk

cat $mapdir1/spk2utt > $map_dir/spk2utt
cat $mapdir2/spk2utt >> $map_dir/spk2utt

