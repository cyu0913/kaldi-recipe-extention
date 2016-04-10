#!/bin/bash
cd /erasable/cxy110530/exp_scratch/apollo/v1
. ./path.sh
( echo '#' Running on `hostname`
  echo '#' Started at `date`
  echo -n '# '; cat <<EOF
gmm-gselect --n=20 "fgmm-global-to-gmm /erasable/cxy110530/exp_scratch/swbd/s5crss/exp/extractor_2048/final.ubm -|" "ark,s,cs:add-deltas --delta-window=3 --delta-order=2 scp:data/eecom_spk_train/split1/${SGE_TASK_ID}/feats.scp ark:- | apply-cmvn-sliding --norm-vars=false --center=true --cmn-window=300 ark:- ark:- |" ark:- | fgmm-global-gselect-to-post --min-post=0.025 /erasable/cxy110530/exp_scratch/swbd/s5crss/exp/extractor_2048/final.ubm "ark,s,cs:add-deltas --delta-window=3 --delta-order=2 scp:data/eecom_spk_train/split1/${SGE_TASK_ID}/feats.scp ark:- | apply-cmvn-sliding --norm-vars=false --center=true --cmn-window=300 ark:- ark:- |" ark,s,cs:- ark:- | scale-post ark:- 1.0 ark:- | ivector-extract --verbose=2 /erasable/cxy110530/exp_scratch/swbd/s5crss/exp/extractor_2048/final.ie "ark,s,cs:add-deltas --delta-window=3 --delta-order=2 scp:data/eecom_spk_train/split1/${SGE_TASK_ID}/feats.scp ark:- | apply-cmvn-sliding --norm-vars=false --center=true --cmn-window=300 ark:- ark:- |" ark,s,cs:- ark,scp,t:data/eecom_train.iv/ivector.${SGE_TASK_ID}.ark,data/eecom_train.iv/ivector.${SGE_TASK_ID}.scp 
EOF
) >data/eecom_train.iv/log/extract_ivectors.$SGE_TASK_ID.log
time1=`date +"%s"`
 ( gmm-gselect --n=20 "fgmm-global-to-gmm /erasable/cxy110530/exp_scratch/swbd/s5crss/exp/extractor_2048/final.ubm -|" "ark,s,cs:add-deltas --delta-window=3 --delta-order=2 scp:data/eecom_spk_train/split1/${SGE_TASK_ID}/feats.scp ark:- | apply-cmvn-sliding --norm-vars=false --center=true --cmn-window=300 ark:- ark:- |" ark:- | fgmm-global-gselect-to-post --min-post=0.025 /erasable/cxy110530/exp_scratch/swbd/s5crss/exp/extractor_2048/final.ubm "ark,s,cs:add-deltas --delta-window=3 --delta-order=2 scp:data/eecom_spk_train/split1/${SGE_TASK_ID}/feats.scp ark:- | apply-cmvn-sliding --norm-vars=false --center=true --cmn-window=300 ark:- ark:- |" ark,s,cs:- ark:- | scale-post ark:- 1.0 ark:- | ivector-extract --verbose=2 /erasable/cxy110530/exp_scratch/swbd/s5crss/exp/extractor_2048/final.ie "ark,s,cs:add-deltas --delta-window=3 --delta-order=2 scp:data/eecom_spk_train/split1/${SGE_TASK_ID}/feats.scp ark:- | apply-cmvn-sliding --norm-vars=false --center=true --cmn-window=300 ark:- ark:- |" ark,s,cs:- ark,scp,t:data/eecom_train.iv/ivector.${SGE_TASK_ID}.ark,data/eecom_train.iv/ivector.${SGE_TASK_ID}.scp  ) 2>>data/eecom_train.iv/log/extract_ivectors.$SGE_TASK_ID.log >>data/eecom_train.iv/log/extract_ivectors.$SGE_TASK_ID.log
ret=$?
time2=`date +"%s"`
echo '#' Accounting: time=$(($time2-$time1)) threads=1 >>data/eecom_train.iv/log/extract_ivectors.$SGE_TASK_ID.log
echo '#' Finished at `date` with status $ret >>data/eecom_train.iv/log/extract_ivectors.$SGE_TASK_ID.log
[ $ret -eq 137 ] && exit 100;
touch data/eecom_train.iv/q/done.15615.$SGE_TASK_ID
exit $[$ret ? 1 : 0]
## submitted with:
# qsub -v PATH -cwd -S /bin/bash -j y -l arch=*64* -o data/eecom_train.iv/q/extract_ivectors.log -q all.q\@compute-0-6 -r y -cwd -V   -t 1:1 /erasable/cxy110530/exp_scratch/apollo/v1/data/eecom_train.iv/q/extract_ivectors.sh >>data/eecom_train.iv/q/extract_ivectors.log 2>&1
