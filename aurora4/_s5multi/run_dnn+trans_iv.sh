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
 
   #sid/train_full_ubm_dnn+trans.sh --nj 40 --cmd "$train_cmd" data/train_si84_multi data-fbank/train_si84_multi exp/tri3a_dnn exp/full_ubm_dnn+trans exp/tri2b_multi_ali_si84 $scale || exit 1;

   #sid/train_ivector_extractor_dnn+trans.sh --nj 40 --cmd "$train_cmd" \
   #     --ivector-dim $ivdim --num-iters 6 exp/full_ubm_dnn/final.ubm exp/tri3a_dnn data/train_si84_multi data-fbank/train_si84_multi \
   #     exp/extractor_dnn+trans exp/tri2b_multi_ali_si84 $scale || exit 1;

   sid/extract_ivectors_dnn+trans.sh --cmd "$train_cmd" --nj 80 \
        exp/extractor_dnn exp/tri3a_dnn data/test_eval92 data-fbank/test_eval92 data/test_eval92.dnn+trans-iv exp/tri2b_multi_ali_eval92 $scale || exit 1;

   #sid/extract_ivectors_dnn.sh --cmd "$train_cmd" --nj 80 \
   #     exp/extractor_dnn exp/tri3a_dnn data/train_si84_multi data-fbank/train_si84_multi data/train_si84_multi.dnn-iv || exit 1;

   log_end "DNN Based Ivector Extraction"
}
run_dnn_iv_extract;

