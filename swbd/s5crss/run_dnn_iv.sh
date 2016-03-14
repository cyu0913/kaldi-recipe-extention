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

run_dnn_iv_extract(){
   log_start "DNN Based Ivector Extraction"

   #sid/train_full_ubm_dnn.sh --nj 80 --cmd "$train_cmd" data/train_nodup exp/data-fmllr-tri4/train_nodup exp/dnn5b_pretrain-dbn_dnn exp/full_ubm_dnn || exit 1;

   sid/train_ivector_extractor_dnn.sh --nj 40 --cmd "$train_cmd" \
        --ivector-dim $ivdim --num-iters 10 exp/full_ubm_dnn/final.ubm exp/dnn5b_pretrain-dbn_dnn data/train_nodup exp/data-fmllr-tri4/train_nodup \
        exp/extractor_dnn || exit 1;

   sid/extract_ivectors_dnn.sh --cmd "$train_cmd" --nj 80 \
        exp/extractor_dnn exp/dnn5b_pretrain-dbn_dnn data/eval2000 exp/data-fmllr-tri4/eval2000 data/eval2000.dnn-iv || exit 1;

   sid/extract_ivectors_dnn.sh --cmd "$train_cmd" --nj 80 \
        exp/extractor_dnn exp/dnn5b_pretrain-dbn_dnn data/train_nodup exp/data-fmllr-tri4/train_nodup data/train_nodup.dnn-iv || exit 1;

   log_end "DNN Based Ivector Extraction"
}
run_dnn_iv_extract;

