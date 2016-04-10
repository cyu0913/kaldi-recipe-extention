#!/bin/bash
cd /erasable/cxy110530/exp_scratch/apollo/v1
. ./path.sh
( echo '#' Running on `hostname`
  echo '#' Started at `date`
  echo -n '# '; cat <<EOF
ivector-normalize-length scp:data/eecom_nontarget.iv/ivector.scp ark:- | ivector-mean ark:data/eecom_spk_nontarget/spk2utt ark:- ark:- ark,t:data/eecom_nontarget.iv/num_utts.ark | ivector-normalize-length ark:- ark,scp:data/eecom_nontarget.iv/spk_ivector.ark,data/eecom_nontarget.iv/spk_ivector.scp 
EOF
) >data/eecom_nontarget.iv/log/speaker_mean.log
time1=`date +"%s"`
 ( ivector-normalize-length scp:data/eecom_nontarget.iv/ivector.scp ark:- | ivector-mean ark:data/eecom_spk_nontarget/spk2utt ark:- ark:- ark,t:data/eecom_nontarget.iv/num_utts.ark | ivector-normalize-length ark:- ark,scp:data/eecom_nontarget.iv/spk_ivector.ark,data/eecom_nontarget.iv/spk_ivector.scp  ) 2>>data/eecom_nontarget.iv/log/speaker_mean.log >>data/eecom_nontarget.iv/log/speaker_mean.log
ret=$?
time2=`date +"%s"`
echo '#' Accounting: time=$(($time2-$time1)) threads=1 >>data/eecom_nontarget.iv/log/speaker_mean.log
echo '#' Finished at `date` with status $ret >>data/eecom_nontarget.iv/log/speaker_mean.log
[ $ret -eq 137 ] && exit 100;
touch data/eecom_nontarget.iv/q/done.15797
exit $[$ret ? 1 : 0]
## submitted with:
# qsub -v PATH -cwd -S /bin/bash -j y -l arch=*64* -o data/eecom_nontarget.iv/q/speaker_mean.log -q all.q\@compute-0-6 -r y -cwd -V    /erasable/cxy110530/exp_scratch/apollo/v1/data/eecom_nontarget.iv/q/speaker_mean.sh >>data/eecom_nontarget.iv/q/speaker_mean.log 2>&1
