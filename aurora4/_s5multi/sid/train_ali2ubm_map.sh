#!/bin/bash

# Copyright 
#            2016  Chengzhu Yu (UTDallas)
# Apache 2.0.

# This script trains the i-vector extractor using a DNN-based UBM. It also requires
# an fGMM, usually created by the script sid/init_full_gmm_from_dnn.sh.
# Note: there are 3 separate levels of parallelization: num_threads, num_processes, 
# and num_jobs.  This may seem a bit excessive.  It has to do with minimizing 
# memory usage and disk I/O, subject to various constraints.  The "num_threads" 
# is how many threads a program uses; the "num_processes" is the number of separate
# processes a single  job spawns, and then sums the accumulators in memory.
# Our recommendation:
#  - Set num_threads to the minimum of (4, or how many virtual cores your machine has).
#    (because of needing to lock various global quantities, the program can't
#    use many more than 4 threads with good CPU utilization).
#  - Set num_processes to the number of virtual cores on each machine you have, divided by 
#    num_threads.  E.g. 4, if you have 16 virtual cores.   If you're on a shared queue
#    that's busy with other people's jobs, it may be wise to set it to rather less
#    than this maximum though, or your jobs won't get scheduled.  And if memory is
#    tight you need to be careful; in our normal setup, each process uses about 5G.
#  - Set num_jobs to as many of the jobs (each using $num_threads * $num_processes CPUs)
#    your queue will let you run at one time, but don't go much more than 10 or 20, or
#    summing the accumulators will possibly get slow.  If you have a lot of data, you
#    may want more jobs, though.

# Begin configuration section.
nj=10   # this is the number of separate queue jobs we run, but each one 
        # contains num_processes sub-jobs.. the real number of threads we 
        # run is nj * num_processes * num_threads, and the number of
        # separate pieces of data is nj * num_processes.
nj_for_map=8
num_threads=1
num_processes=1 # each job runs this many processes, each with --num-threads threads
cmd="run.pl"
stage=-4
cleanup=true
# End configuration section.

echo "$0 $@"  # Print the command line for logging

if [ -f path.sh ]; then . ./path.sh; fi
. parse_options.sh || exit 1;

if [ $# != 4 ]; then
  exit 1;
fi

fgmm_model=$1
data=$2
alidir=$3
dir=$4
srcdir=$(dirname $fgmm_model)

# Set various variables.
mkdir -p $dir/log

sdata=$data/split$nj;
utils/split_data.sh --per-utt $data $nj || exit 1;

delta_opts=`cat $srcdir/delta_opts 2>/dev/null`
if [ -f $srcdir/delta_opts ]; then
  cp $srcdir/delta_opts $dir/ 2>/dev/null
fi

feats="ark,s,cs:add-deltas $delta_opts scp:$sdata/JOB/feats.scp ark:- | apply-cmvn-sliding --norm-vars=false --center=true --cmn-window=300 ark:- ark:- |"

alignments="ark,s,cs:ali-to-pdf $alidir/final.mdl \"ark:gunzip -c $alidir/ali.JOB.gz|\"  ark:- |"

ali_size=`grep -oP -m 1 'pdfs\ \K[0-9]+' <(gmm-info $alidir/final.mdl 2> /dev/null) | head -1`
ubmpost_size=`grep -oP -m 1 'gaussians\ \K[0-9]+' <(fgmm-global-info $srcdir/final.ubm 2> /dev/null) | head -1`

cp $fgmm_model $dir/final.ubm || exit 1;
$cmd $dir/log/convert.log \
    fgmm-global-to-gmm $dir/final.ubm $dir/final.dubm || exit 1;

$cmd JOB=1:$nj_for_map $dir/log/map.JOB.log \
   gmm-gselect --n=$ubmpost_size $dir/final.dubm "$feats" ark:- \| \
   fgmm-global-gselect-to-post --min-post=0 $dir/final.ubm "$feats" \
      ark,s,cs:-  ark:- \| \
   ali-to-post-map-train "$alignments" ark:- $ali_size $ubmpost_size $dir/MAP.JOB || exit 1;

ali-to-post-map-sum $dir/MAP* $dir/MAP.final || exit 1;
