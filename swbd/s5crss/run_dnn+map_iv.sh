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

   weight_org=0;
 
   #sid/train_full_ubm_dnn+trans.sh --nj 40 --cmd "$train_cmd_04" data/train_nodup exp/data-fmllr-tri4/train_nodup exp/dnn5b_pretrain-dbn_dnn exp/full_ubm_dnn+trans exp/tri4_ali_nodup $scale || exit 1;

   #sid/train_ali2dnn_map.sh --nj 40 --nj-for-map 20 --cmd "$train_cmd_05" exp/dnn5b_pretrain-dbn_dnn exp/data-fmllr-tri4/train_nodup exp/tri4_ali_nodup exp/mapping_ali2dnn || exit 1;

   #sid/train_ivector_extractor_dnn+map.sh --nj 40 --cmd "$train_cmd_05" \
   #     --ivector-dim $ivdim --num-iters 7 exp/full_ubm_dnn/final.ubm exp/dnn5b_pretrain-dbn_dnn data/train_nodup exp/data-fmllr-tri4/train_nodup \
   #     exp/extractor_dnn+map exp/tri4_ali_nodup exp/mapping_ali2dnn $weight_org || exit 1;

   sid/extract_ivectors_dnn+map.sh --cmd "$train_cmd_05" --nj 80 \
        exp/extractor_dnn+map exp/dnn5b_pretrain-dbn_dnn data/eval2000 exp/data-fmllr-tri4/eval2000 exp/tri4_ali_eval2000 exp/mapping_ali2dnn $weight_org data/eval2000.dnn+map-iv|| exit 1;


   log_end "DNN Based Ivector Extraction"
}
run_dnn_iv_extract;

