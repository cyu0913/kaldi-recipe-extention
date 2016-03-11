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

   scale=0.9
 
   #sid/train_full_ubm_dnn+trans.sh --nj 40 --cmd "$train_cmd_04" data/train_nodup exp/data-fmllr-tri4/train_nodup exp/dnn5b_pretrain-dbn_dnn exp/full_ubm_dnn+trans exp/tri4_ali_nodup $scale || exit 1;

   sid/train_ivector_extractor_dnn+trans.sh --nj 40 --cmd "$train_cmd_05" \
        --ivector-dim $ivdim --num-iters 5 exp/full_ubm_dnn/final.ubm exp/dnn5b_pretrain-dbn_dnn data/train_nodup exp/data-fmllr-tri4/train_nodup \
        exp/extractor_dnn+trans exp/tri4_ali_nodup $scale || exit 1;

   sid/extract_ivectors_dnn+trans.sh --cmd "$train_cmd_05" --nj 40 \
        exp/extractor_dnn+trans exp/dnn5b_pretrain-dbn_dnn data/eval2000 exp/data-fmllr-tri4/eval2000 data/eval200.dnn+trans-iv exp/tri4_ali_nodup $scale || exit 1;

   sid/extract_ivectors_dnn+trans.sh --cmd "$train_cmd_05" --nj 80 \
        exp/extractor_dnn+trans exp/dnn5b_pretrain-dbn_dnn data/train_nodup exp/data-fmllr-tri4/train_nodup data/train_nodup.dnn-iv || exit 1;

   log_end "DNN Based Ivector Extraction"
}
run_dnn_iv_extract;

