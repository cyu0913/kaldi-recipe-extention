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

run_iv_extract(){
   log_start "DNN Based Ivector Extraction"

   weight_org=0; 

   #sid/train_full_ubm_dnn.sh --nj 80 --cmd "$train_cmd" data/train_si84_multi data-fbank/train_si84_multi exp/tri3a_dnn exp/full_ubm_dnn || exit 1;

   #sid/train_ali2dnn_map.sh --nj 40 --nj-for-map 8 --cmd "$train_cmd" exp/tri3a_dnn data-fbank/train_si84_multi exp/tri2b_multi_ali_si84 exp/mapping_ali2dnn   

   #sid/train_ivector_extractor_dnn+map.sh --nj 40 --cmd "$train_cmd" \
   #     --ivector-dim $ivdim --num-iters 6 exp/full_ubm_dnn+trans/final.ubm exp/tri3a_dnn data/train_si84_multi data-fbank/train_si84_multi \
   #     exp/extractor_dnn+map exp/tri2b_multi_ali_si84 exp/mapping_ali2dnn $weight_org || exit 1;

   sid/extract_ivectors_dnn+map.sh --cmd "$train_cmd" --nj 80 \
        exp/extractor_dnn+map exp/tri3a_dnn data/test_eval92 data-fbank/test_eval92 data/test_eval92.dnn+map-iv exp/tri2b_multi_ali_eval92 exp/mapping_ali2dnn $weight_org || exit 1;

   #sid/extract_ivectors_dnn+map.sh --cmd "$train_cmd" --nj 80 \
   #     exp/extractor_dnn+map exp/tri3a_dnn data/dev_1206 data-fbank/dev_1206 data/dev_1206.dnn+map-iv exp/tri2b_multi_ali_dev_1206 exp/mapping_ali2dnn $weight_org || exit 1;

   #sid/extract_ivectors_dnn+map.sh --cmd "$train_cmd" --nj 40 \
   #     exp/extractor_dnn+map exp/tri3a_dnn data/train_si84_multi data-fbank/train_si84_multi data/train_si84_multi.dnn+map-iv exp/tri2b_multi_ali_si84 exp/mapping_ali2dnn $weight_org || exit 1;


   log_end "DNN Based Ivector Extraction"
}
run_iv_extract;

