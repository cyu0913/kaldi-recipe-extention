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

run_trans_iv_extract(){
   log_start "Transcript Based Ivector Extraction"

   sid/train_full_ubm_trans.sh --nj 80 --cmd "$train_cmd" data/train_nodup \
       exp/tri4_ali_nodup exp/full_ubm_senones || exit 1;

   sid/train_ivector_extractor_trans.sh --nj 40 --cmd "$train_cmd" \
        --ivector-dim $ivdim --num-iters 5 exp/full_ubm_senones/final.ubm data/train_nodup exp/tri4_ali_nodup \
        exp/extractor_senones || exit 1;

   sid/extract_ivectors_trans.sh --cmd "$train_cmd" --nj 40 \
        exp/extractor_senones data/eval2000 exp/tri4_ali_eval2000 data/eval2000.trans-iv || exit 1;

   sid/extract_ivectors_trans.sh --cmd "$train_cmd" --nj 40 \
        exp/extractor_senones data/train_nodup exp/tri4_ali_nodup data/train_nodup.trans-iv || exit 1;

   log_end "Transcript Based Ivector Extraction"
}
run_trans_iv_extract

