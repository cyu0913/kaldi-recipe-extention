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

. cmd.sh
. path.sh

set -e # exit on error

prep(){
    data_org=/scratch2/share/cxy110530/Interspeech2016/Apollo_EECOM_for_KWS
    data_dir=data/eecom
    mkdir -p $data_dir
    rm -f $data_dir/wav.scp $data_dir/spk2utt $data_dir/utt2spk
    for i in `ls -d1 $data_org/*`;do
        id=`basename $i .wav`
        echo $id $i >> $data_dir/wav.scp
        echo $id $id >> $data_dir/spk2utt
        echo $id $id >> $data_dir/utt2spk
    done

    querry_eecom=/scratch2/share/cxy110530/Apollo_EECOM_Querry/EECOM
    querry_eecom_dir=data/eecom_querry
    mkdir -p $querry_eecom_dir
    rm -f $querry_eecom_dir/wav.scp $querry_eecom_dir/spk2utt $querry_eecom_dir/utt2spk
    for i in `ls -d1 $querry_eecom/*`;do
        id=`basename $i .wav`
        echo $id $i >> $querry_eecom_dir/wav.scp
        echo $id $id >> $querry_eecom_dir/spk2utt
        echo $id $id >> $querry_eecom_dir/utt2spk
    done

    querry_eecom=/scratch2/share/cxy110530/Apollo_EECOM_Querry/EECOM_detected
    querry_eecom_dir=data/eecom_querry_detected
    mkdir -p $querry_eecom_dir
    rm -f $querry_eecom_dir/wav.scp $querry_eecom_dir/spk2utt $querry_eecom_dir/utt2spk
    for i in `ls -d1 $querry_eecom/*`;do
        id=`basename $i .wav`
        echo $id $i >> $querry_eecom_dir/wav.scp
        echo $id $id >> $querry_eecom_dir/spk2utt
        echo $id $id >> $querry_eecom_dir/utt2spk
    done

    querry_ecs=/scratch2/share/cxy110530/Apollo_EECOM_Querry/ECS
    querry_ecs_dir=data/ecs_querry
    mkdir -p $querry_ecs_dir
    rm -f $querry_ecs_dir/wav.scp $querry_ecs_dir/spk2utt $querry_ecs_dir/utt2spk
    for i in `ls -d1 $querry_ecs/*`;do
        id=`basename $i .wav`
        echo $id $i >> $querry_ecs_dir/wav.scp
        echo $id $id >> $querry_ecs_dir/spk2utt
        echo $id $id >> $querry_ecs_dir/utt2spk
    done

    querry_ecs=/scratch2/share/cxy110530/Apollo_EECOM_Querry/eecom_spk/eecom_train
    querry_ecs_dir=data/eecom_spk_train
    mkdir -p $querry_ecs_dir
    rm -f $querry_ecs_dir/wav.scp $querry_ecs_dir/spk2utt $querry_ecs_dir/utt2spk
    for i in `ls -d1 $querry_ecs/*`;do
        id=`basename $i .wav`
        echo $id $i >> $querry_ecs_dir/wav.scp
        echo $id $id >> $querry_ecs_dir/spk2utt
        echo $id $id >> $querry_ecs_dir/utt2spk
    done


    querry_ecs=/scratch2/share/cxy110530/Apollo_EECOM_Querry/eecom_spk/eecom_target
    querry_ecs_dir=data/eecom_spk_target
    mkdir -p $querry_ecs_dir
    rm -f $querry_ecs_dir/wav.scp $querry_ecs_dir/spk2utt $querry_ecs_dir/utt2spk
    for i in `ls -d1 $querry_ecs/*`;do
        id=`basename $i .wav`
        echo $id $i >> $querry_ecs_dir/wav.scp
        echo $id $id >> $querry_ecs_dir/spk2utt
        echo $id $id >> $querry_ecs_dir/utt2spk
    done

    querry_ecs=/scratch2/share/cxy110530/Apollo_EECOM_Querry/eecom_spk/eecom_nontarget
    querry_ecs_dir=data/eecom_spk_nontarget
    mkdir -p $querry_ecs_dir
    rm -f $querry_ecs_dir/wav.scp $querry_ecs_dir/spk2utt $querry_ecs_dir/utt2spk
    for i in `ls -d1 $querry_ecs/*`;do
        id=`basename $i .wav`
        echo $id $i >> $querry_ecs_dir/wav.scp
        echo $id $id >> $querry_ecs_dir/spk2utt
        echo $id $id >> $querry_ecs_dir/utt2spk
    done


}
#prep

run_mfcc(){
    mfccdir=mfcc
    #for x in eecom eecom_querry ecs_querry eecom_querry_detected; do
    for x in eecom_spk_train eecom_spk_target eecom_spk_nontarget; do
      steps/make_mfcc.sh --nj 1 --cmd "$train_cmd" \
        data/$x exp/make_mfcc/$x $mfccdir
      steps/compute_cmvn_stats.sh data/$x exp/make_mfcc/$x $mfccdir
      #utils/fix_data_dir.sh data/$x
    done
}
#run_mfcc

run_gmm(){

   ubmdim=64
 
   #sid/train_diag_ubm.sh --parallel-opts "" --nj 8 --cmd "$train_cmd" data/eecom ${ubmdim} \
   #    exp/diag_ubm_${ubmdim} || exit 1;

   #sid/train_full_ubm.sh --nj 8 --cmd "$train_cmd" data/eecom \
   #    exp/diag_ubm_${ubmdim} exp/full_ubm_${ubmdim} || exit 1;

   #sid/gmm_postgram.sh --nj 8 --cmd "$train_cmd" exp/full_ubm_${ubmdim}/final.ubm data/eecom exp/gmm_postgram 
   #sid/gmm_postgram.sh --nj 1 --cmd "$train_cmd" exp/full_ubm_${ubmdim}/final.ubm data/eecom_querry exp/gmm_postgram_eecom_querry 
   #sid/gmm_postgram.sh --nj 1 --cmd "$train_cmd" exp/full_ubm_${ubmdim}/final.ubm data/ecs_querry exp/gmm_postgram_ecs_querry 
   sid/gmm_postgram.sh --nj 1 --cmd "$train_cmd" exp/full_ubm_${ubmdim}/final.ubm data/eecom_querry_detected exp/gmm_postgram_eecom_querry_detected 
}
#run_gmm

#================= IV extraction ============================================#
siddir=/erasable/cxy110530/exp_scratch/swbd/s5crss

ubmdim=2048
ivdim=400
run_iv_extract(){
   log_start "Ivector Extraction"

   $siddir/sid/extract_ivectors.sh --cmd "$train_cmd" --nj 1 --num-gselect 20 \
       $siddir/exp/extractor_${ubmdim} data/eecom_spk_train data/eecom_train.iv || exit 1;

   $siddir/sid/extract_ivectors.sh --cmd "$train_cmd" --nj 1 --num-gselect 20 \
        $siddir/exp/extractor_${ubmdim} data/eecom_spk_target data/eecom_target.iv || exit 1;

   $siddir/sid/extract_ivectors.sh --cmd "$train_cmd" --nj 1 --num-gselect 20 \
        $siddir/exp/extractor_${ubmdim} data/eecom_spk_nontarget data/eecom_nontarget.iv || exit 1;


   log_end "Ivector Extraction"
}
#run_iv_extract

run_cds_score_target(){

    mkdir -p score.target;
    rm -rf score.target/*

    for i in `cat data/eecom_train.iv/ivector.scp | awk '{print $1}'`;do
       for j in `cat data/eecom_target.iv/ivector.scp | awk '{print $1}' `;do
              echo $i $j >> score.target/trial

       done
    done

    cat score.target/trial | awk '{print $1, $2}' | \
          ivector-compute-dot-products - \
          scp:data/eecom_train.iv/ivector.scp \
          scp:data/eecom_target.iv/ivector.scp \
          score.target/cds.output 2> score.target/cds.log

}
run_cds_score_target

run_cds_score_nontarget(){

    mkdir -p score.nontarget;
    rm -rf score.nontarget/*

    for i in `cat data/eecom_train.iv/ivector.scp | awk '{print $1}'`;do
       for j in `cat data/eecom_nontarget.iv/ivector.scp | awk '{print $1}' `;do
              echo $i $j >> score.nontarget/trial

       done
    done

    cat score.nontarget/trial | awk '{print $1, $2}' | \
          ivector-compute-dot-products - \
          scp:data/eecom_train.iv/ivector.scp \
          scp:data/eecom_nontarget.iv/ivector.scp \
          score.nontarget/cds.output 2> score.nontarget/cds.log

}
run_cds_score_nontarget



#================== DNN Postgram =============================================
dnnroot=/erasable/cxy110530/exp_scratch/swbd/s5crss
gmmdir=/erasable/cxy110530/exp_scratch/swbd/s5crss/exp/tri4
dnndir=/erasable/cxy110530/exp_scratch/swbd/s5crss/exp/dnn5b_pretrain-dbn_dnn
graph_dir=$dnnroot/exp/tri4/graph_sw1_tg
data_fmllr=exp/data-fmllr-tri4
has_fisher=false

store_fmllr_feat(){
   for x in eecom eecom_querry ecs_querry; do 

       dir=$data_fmllr/$x

       steps/decode_fmllr.sh --nj 8 --cmd "$train_cmd" \
         --config conf/decode.config \
         $graph_dir data/${x} $gmmdir/decode_${x}_sw1_tg.text

       steps/nnet/make_fmllr_feats.sh --nj 8 --cmd "$train_cmd" \
            --transform-dir $gmmdir/decode_${x}_sw1_tg.text  $dir data/$x $gmmdir $dir/log $dir || exit 1

   done    
}
#store_fmllr_feat

get_dnn_post(){

    
   for x in eecom eecom_querry ecs_querry; do 

        dir=$data_fmllr/$x

        local/getDnnPostGram.sh --nj 8 --cmd "$train_cmd" --use_gpu "no" \
            --config conf/decode_dnn.config --acwt 0.08333 \
            $gmmdir/graph_sw1_tg $dir $dnndir \
            exp/dnn_postgram/$x || exit 1;
   done

}
#get_dnn_post

prep_triple(){

    show-transitions /erasable/cxy110530/exp_scratch/swbd/s5crss/data/lang/phones.txt $dnndir/final.mdl | grep Transition-state | awk '{print $5 " " $8 " " $11}' > exp/dnn_postgram/dnn_infopdfs.txt
    cp /erasable/cxy110530/exp_scratch/swbd/s5crss/data/lang/phones.txt exp/dnn_postgram
}
#prep_triple





