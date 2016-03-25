#!/bin/bash

log_start(){
  echo "#####################################################################"
  echo "Spawning *** $1 *** on" `date` `hostname`
  echo ---------------------------------------------------------------------
}

log_end(){
  echo ---------------------------------------------------------------------
  echo "Done *** $1 *** on" `date` `hostname` 
  echo "#####################################################################"
}

rm -f ./path.sh; cp ./path.cluster.sh ./path.sh;

. ./cmd.sh ## You'll want to change cmd.sh to something that will work on your system.
           ## This relates to the queue.
. ./path.sh ## update system path

ivdim=200
noise=babble
    
wav_noisy=/erasable/cxy110530/backup_folder/eval2000_${noise}
dir_clean=data/eval2000
data_noisy=data/eval2000_${noise}

prep_noisy_eval(){
    
    rm -rf $data_noisy; cp -r $dir_clean $data_noisy; rm $data_noisy/wav.scp; rm -rf $data_noisy/split*; rm -f $data_noisy/segments; rm -f $data_noisy/reco2file_and_channel
    
    for i in `cat $dir_clean/wav.scp | awk '{print $1}'` 
    do
        echo "$i $wav_noisy/${i}.wav" >> $data_noisy/wav.scp
    done   

}
#prep_noisy_eval


prep_noisy_feats(){

      mfccdir=exp/make_mfcc/${noise}  
      steps/make_mfcc.sh --nj 80 --cmd "$train_cmd" \
        $data_noisy $mfccdir $mfccdir
      steps/compute_cmvn_stats.sh $data_noisy $mfccdir $mfccdir
      utils/fix_data_dir.sh $data_noisy


}
#prep_noisy_feats

prep_ali(){

    steps/align_fmllr.sh --nj 40 --cmd "$train_cmd" \
      $data_noisy data/lang exp/tri4 exp/tri4_ali_eval2000_${noise}

}
#prep_ali

store_fmllr_feat(){
   # Store fMLLR features, so we can train on them easily,

   # eval2000
   gmmdir=exp/tri4
   data_fmllr=exp/data-fmllr-tri4
   has_fisher=false
   dir=$data_fmllr/eval2000_${noise}

   steps/nnet/make_fmllr_feats.sh --nj 80 --cmd "$train_cmd" \
     --transform-dir exp/tri4_ali_eval2000_${noise} \
     $dir $data_noisy $gmmdir $dir/log $dir/data || exit 1

}
#store_fmllr_feat


run_dnn_iv_extract(){
   log_start "DNN Based Ivector Extraction"

   scale=0.9

   #sid/extract_ivectors.sh --cmd "$train_cmd" --nj 80 --num-gselect 20 \
   #     exp/extractor_2048 data/eval2000_${noise} data/eval2000_${noise}.iv || exit 1;

   #sid/extract_ivectors_trans.sh --cmd "$train_cmd" --nj 40 \
   #     exp/extractor_senones $data_noisy  exp/tri4_ali_eval2000 data/eval2000_${noise}_${snr}.trans-iv || exit 1;

   sid/extract_ivectors_dnn.sh --cmd "$train_cmd" --nj 80 \
        exp/extractor_dnn exp/dnn5b_pretrain-dbn_dnn $data_noisy exp/data-fmllr-tri4/eval2000_${noise} data/eval2000_${noise}.dnn-iv || exit 1;

   #sid/extract_ivectors_dnn+trans.sh --cmd "$train_cmd" --nj 40 \
   #     exp/extractor_dnn+trans exp/dnn5b_pretrain-dbn_dnn $data_noisy exp/data-fmllr-tri4/eval2000_${noise} data/eval2000_${noise}.dnn+trans-iv exp/tri4_ali_eval2000_${noise} $scale || exit 1;

   log_end "DNN Based Ivector Extraction"
}
run_dnn_iv_extract;

