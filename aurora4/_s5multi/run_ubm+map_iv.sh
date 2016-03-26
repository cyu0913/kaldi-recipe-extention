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

ubmdim=2048
ivdim=200
run_iv_extract(){
   log_start "Ivector Extraction"

   weight_org=0

   #sid/train_diag_ubm.sh --parallel-opts "" --nj 80 --cmd "$train_cmd" data/train_si84_multi ${ubmdim} \
   #    exp/diag_ubm_${ubmdim} || exit 1;

   #sid/train_full_ubm.sh --nj 80 --cmd "$train_cmd" data/train_si84_multi \
   #    exp/diag_ubm_${ubmdim} exp/full_ubm_${ubmdim} || exit 1;

   #sid/train_ali2ubm_map.sh --nj 40 --nj-for-map 40 --cmd "$train_cmd" exp/full_ubm_${ubmdim}/final.ubm data/train_si84_multi exp/tri2b_multi_ali_si84 exp/mapping_ali2ubm 

   #sid/train_ivector_extractor_ubm+map.sh --nj 40 --cmd "$train_cmd_04" --num-gselect 20 \
   #   --ivector-dim $ivdim --num-iters 7 exp/full_ubm_${ubmdim}/final.ubm data/train_si84_multi \
   #   exp/tri2b_multi_ali_si84 exp/mapping_ali2ubm $weight_org exp/extractor_${ubmdim}_ubm+map || exit 1;

   #sid/extract_ivectors_ubm+map.sh --cmd "$train_cmd_04" --nj 80 --num-gselect 20 \
   #    exp/extractor_${ubmdim}_ubm+map data/test_eval92 exp/tri2b_multi_ali_eval92 exp/mapping_ali2ubm $weight_org data/test_eval92.ubm+map-iv || exit 1;

   sid/extract_ivectors_ubm+map.sh --cmd "$train_cmd_04" --nj 40 --num-gselect 20 \
       exp/extractor_${ubmdim}_ubm+map data/train_si84_multi exp/tri2b_multi_ali_si84 exp/mapping_ali2ubm $weight_org data/train_si84_multi.ubm+map-iv || exit 1;

   sid/extract_ivectors_ubm+map.sh --cmd "$train_cmd_04" --nj 80 --num-gselect 20 \
       exp/extractor_${ubmdim}_ubm+map data/dev_1206 exp/tri2b_multi_ali_dev_1206 exp/mapping_ali2ubm $weight_org data/dev_1206.ubm+map-iv || exit 1;

   log_end "Ivector Extraction"
}
run_iv_extract




