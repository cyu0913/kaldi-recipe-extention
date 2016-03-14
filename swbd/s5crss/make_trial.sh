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
 
#set -e # exit on error

mkdir -p exp/trials;

find_short(){

    local/find_short_utt.sh `pwd`/data/eval2000/text `pwd`/exp/trials/utt_short

}
#find_short

make_trial_swbd(){
 
         rm -f exp/trials/trial.swbd.utt2utt; rm -f exp/trials/trial.swbd.utt2utt.keys; rm -f exp/trials/trial.swbd.utt2utt.keys;
 
         # Check similarity of all i-vectors belong to two desired speakers. Code below compare speaker '01jo' vs '40po'   
         for i in `cat data/eval2000.iv/ivector.scp | grep sw | awk '{print $1}' | awk 'NR == 1 || NR % 3 == 0'`;do
               for j in `cat data/eval2000.iv/ivector.scp | grep sw | awk '{print $1}' | awk 'NR == 1 || NR % 5 == 0'`;do
                   si=`echo $i | awk -F'-' '{print $1}' | awk -F'_' '{print $2 $3}'`
                   sj=`echo $j | awk -F'-' '{print $1}' | awk -F'_' '{print $2 $3}'`

                   exclude_i=`grep 'Did not' exp/tri4_ali_eval2000/log/* | awk '{print $8}' | awk -F',' '{print $1}' | egrep $i | uniq`
                   exclude_j=`grep 'Did not' exp/tri4_ali_eval2000/log/* | awk '{print $8}' | awk -F',' '{print $1}' | grep $j | uniq`
                   exclude_i_short=`grep $i exp/trials/utt_short` 
                   exclude_j_short=`grep $j exp/trials/utt_short` 

                   if [ -z $exclude_i ] && [ -z $exclude_j ] && [ -z $exclude_i_short ] && [ -z $exclude_j_short ]; then

                           echo "$i $j" >> exp/trials/trial.swbd.utt2utt

                           if [ "$si" == "$sj" ]; then
                              echo "target" >> exp/trials/trial.swbd.utt2utt.keys
                           else
                              echo "nontarget" >> exp/trials/trial.swbd.utt2utt.keys
                           fi
                  fi

               done
         done
 
}
#make_trial_swbd

make_trial_ch(){
 
         rm -f exp/trials/trial.ch.utt2utt; rm -f exp/trials/trial.ch.utt2utt.keys; rm -f exp/trials/trial.ch.utt2utt.keys;
 
         # Check similarity of all i-vectors belong to two desired speakers. Code below compare speaker '01jo' vs '40po'   
         for i in `cat data/eval2000.iv/ivector.scp | grep en | awk '{print $1}' | awk 'NR == 1 || NR % 3 == 0'`;do
               for j in `cat data/eval2000.iv/ivector.scp | grep en | awk '{print $1}' | awk 'NR == 1 || NR % 5 == 0'`;do
                   si=`echo $i | awk -F'-' '{print $1}' | awk -F'_' '{print $2 $3}'`
                   sj=`echo $j | awk -F'-' '{print $1}' | awk -F'_' '{print $2 $3}'`

                   exclude_i=`grep 'Did not' exp/tri4_ali_eval2000/log/align* | awk '{print $8}' | awk -F',' '{print $1}' | grep $i | uniq`
                   exclude_j=`grep 'Did not' exp/tri4_ali_eval2000/log/align* | awk '{print $8}' | awk -F',' '{print $1}' | grep $j | uniq`
                   exclude_i_short=`grep $i exp/trials/utt_short` 
                   exclude_j_short=`grep $j exp/trials/utt_short` 

                   if [ -z $exclude_i ] && [ -z $exclude_j ] && [ -z $exclude_i_short ] && [ -z $exclude_j_short ]; then


                           echo "$i $j" >> exp/trials/trial.ch.utt2utt

                           if [ "$si" == "$sj" ]; then
                              echo "target" >> exp/trials/trial.ch.utt2utt.keys
                           else
                              echo "nontarget" >> exp/trials/trial.ch.utt2utt.keys
                           fi  
                  fi  

               done
         done
 
}
make_trial_ch

