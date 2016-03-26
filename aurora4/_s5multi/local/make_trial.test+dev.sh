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

. cmd.sh
. path.sh
 
#set -e # exit on error
 
mkdir -p exp/trials;

combine_iv(){
   
    for mode in iv dnn-iv trans-iv dnn+trans-iv dnn+map-iv; do 
        local/combine_iv.sh data/test+dev.$mode data/test_eval92.$mode data/dev_1206.$mode data/test+dev data/test_eval92 data/dev_1206
    done
} 
combine_iv

make_trial(){
 

         rm -f exp/trials/trial.utt2utt; rm -f exp/trials/trial.utt2utt.keys; rm -f exp/trials/trial.utt2utt.keys;

         # Check similarity of all i-vectors belong to two desired speakers. Code below compare speaker '01jo' vs '40po'   
         for i in `cat data/test+dev.iv/ivector.scp | awk '{print $1}' | awk 'BEGIN {srand()} !/^$/ { if (rand() <= .2) print $0}'`;do
               for j in `cat data/test+dev.iv/ivector.scp | awk '{print $1}' | awk 'BEGIN {srand()} !/^$/ { if (rand() <= .2) print $0}'`;do
                   si=`grep $i data/test+dev/utt2spk | awk '{print $2}'`
                   sj=`grep $j data/test+dev/utt2spk | awk '{print $2}'`

                   exclude_i=`grep 'Did not' exp/tri2b_multi_ali*/log/* | awk '{print $8}' | awk -F',' '{print $1}' | egrep $i `;     
                   exclude_j=`grep 'Did not' exp/tri2b_multi_ali*/log/* | awk '{print $8}' | awk -F',' '{print $1}' | grep $j`; 

                   repi=`echo $i | rev | cut -c 2- | rev`
                   repj=`echo $j | rev | cut -c 2- | rev`

                   if [ -z $exclude_i ] && [ -z $exclude_j ] && [ "$repi" != "$repj" ] && [ "$i" != "$j" ]; then     

                           echo "$i $j" >> exp/trials/trial.utt2utt 
 
                           if [ "$si" == "$sj" ]; then
                              echo "target" >> exp/trials/trial.utt2utt.keys
                           else
                              echo "nontarget" >> exp/trials/trial.utt2utt.keys
                           fi
                  fi
               done
         done
 
}
make_trial

make_trial_clean(){
 
         rm -f exp/trials/trial.utt2utt; rm -f exp/trials/trial.utt2utt.keys; rm -f exp/trials/trial.utt2utt.keys;

         # Check similarity of all i-vectors belong to two desired speakers. Code below compare speaker '01jo' vs '40po'   
         for i in `cat data/test+dev.iv/ivector.scp | awk '{print $1}' | grep ".*0$" |  awk 'BEGIN {srand()} !/^$/ { if (rand() <= .7) print $0}'`;do
               for j in `cat data/test+dev.iv/ivector.scp | awk '{print $1}' | grep ".*0$" | awk 'BEGIN {srand()} !/^$/ { if (rand() <= .7) print $0}'`;do
                   si=`grep $i data/test+dev/utt2spk | awk '{print $2}'`
                   sj=`grep $j data/test+dev/utt2spk | awk '{print $2}'`

                   exclude_i=`grep 'Did not' exp/tri2b_multi_ali*/log/* | awk '{print $8}' | awk -F',' '{print $1}' | egrep $i `;     
                   exclude_j=`grep 'Did not' exp/tri2b_multi_ali*/log/* | awk '{print $8}' | awk -F',' '{print $1}' | grep $j`; 

                   repi=`echo $i | rev | cut -c 2- | rev`
                   repj=`echo $j | rev | cut -c 2- | rev`


                   if [ -z $exclude_i ] && [ -z $exclude_j ] && [ "$repi" != "$repj" ] && [ "$i" != "$j" ] ; then     

                           echo "$i $j" >> exp/trials/trial.utt2utt 
 
                           if [ "$si" == "$sj" ]; then
                              echo "target" >> exp/trials/trial.utt2utt.keys
                           else
                              echo "nontarget" >> exp/trials/trial.utt2utt.keys
                           fi
                  fi
               done
         done
 
}
#make_trial_clean

make_trial_channel(){
 
         rm -f exp/trials/trial.utt2utt; rm -f exp/trials/trial.utt2utt.keys; rm -f exp/trials/trial.utt2utt.keys;

         # Check similarity of all i-vectors belong to two desired speakers. Code below compare speaker '01jo' vs '40po'   
         for i in `cat data/test+dev.iv/ivector.scp | awk '{print $1}' | grep ".*7$" |  awk 'BEGIN {srand()} !/^$/ { if (rand() <= .01) print $0}'`;do
               for j in `cat data/test+dev.iv/ivector.scp | awk '{print $1}' | grep ".*7$" |  awk 'BEGIN {srand()} !/^$/ { if (rand() <= .01) print $0}'`;do
                   si=`grep $i data/test+dev/utt2spk | awk '{print $2}'`
                   sj=`grep $j data/test+dev/utt2spk | awk '{print $2}'`

                   exclude_i=`grep 'Did not' exp/tri2b_multi_ali*/log/* | awk '{print $8}' | awk -F',' '{print $1}' | egrep $i `;     
                   exclude_j=`grep 'Did not' exp/tri2b_multi_ali*/log/* | awk '{print $8}' | awk -F',' '{print $1}' | grep $j`; 

                   repi=`echo $i | rev | cut -c 2- | rev`
                   repj=`echo $j | rev | cut -c 2- | rev`


                   if [ -z $exclude_i ] && [ -z $exclude_j ] && [ "$repi" != "$repj" ] && [ "$i" != "$j" ] ; then     

                           echo "$i $j" >> exp/trials/trial.utt2utt 
 
                           if [ "$si" == "$sj" ]; then
                              echo "target" >> exp/trials/trial.utt2utt.keys
                           else
                              echo "nontarget" >> exp/trials/trial.utt2utt.keys
                           fi
                  fi
               done
         done
 
}
#make_trial_channel

make_trial_noise(){
 
         rm -f exp/trials/trial.utt2utt; rm -f exp/trials/trial.utt2utt.keys; rm -f exp/trials/trial.utt2utt.keys;

         # Check similarity of all i-vectors belong to two desired speakers. Code below compare speaker '01jo' vs '40po'   
         for i in `cat data/test+dev.iv/ivector.scp | awk '{print $1}' | grep ".*[1-6]$" |  awk 'BEGIN {srand()} !/^$/ { if (rand() <= .2) print $0}'`;do
               for j in `cat data/test+dev.iv/ivector.scp | awk '{print $1}' | grep ".*[1-6]$" |  awk 'BEGIN {srand()} !/^$/ { if (rand() <= .2) print $0}'`;do
                   si=`grep $i data/test+dev/utt2spk | awk '{print $2}'`
                   sj=`grep $j data/test+dev/utt2spk | awk '{print $2}'`

                   exclude_i=`grep 'Did not' exp/tri2b_multi_ali*/log/* | awk '{print $8}' | awk -F',' '{print $1}' | egrep $i `;     
                   exclude_j=`grep 'Did not' exp/tri2b_multi_ali*/log/* | awk '{print $8}' | awk -F',' '{print $1}' | grep $j`; 

                   repi=`echo $i | rev | cut -c 2- | rev`
                   repj=`echo $j | rev | cut -c 2- | rev`

                   if [ -z $exclude_i ] && [ -z $exclude_j ] && [ "$repi" != "$repj" ] && [ "$i" != "$j" ]; then     

                           echo "$i $j" >> exp/trials/trial.utt2utt 
 
                           if [ "$si" == "$sj" ]; then
                              echo "target" >> exp/trials/trial.utt2utt.keys
                           else
                              echo "nontarget" >> exp/trials/trial.utt2utt.keys
                           fi
                  fi
               done
         done
 
}
#make_trial_noise

make_trial_channel_noise(){
 
         rm -f exp/trials/trial.utt2utt; rm -f exp/trials/trial.utt2utt.keys; rm -f exp/trials/trial.utt2utt.keys;

         # Check similarity of all i-vectors belong to two desired speakers. Code below compare speaker '01jo' vs '40po'   
         for i in `cat data/test+dev.iv/ivector.scp | awk '{print $1}' | grep ".*[8-d]$" |  awk 'BEGIN {srand()} !/^$/ { if (rand() <= .05) print $0}'`;do
               for j in `cat data/test+dev.iv/ivector.scp | awk '{print $1}' | grep ".*[8-d]$" |  awk 'BEGIN {srand()} !/^$/ { if (rand() <= .05) print $0}'`;do
                   si=`grep $i data/test+dev/utt2spk | awk '{print $2}'`
                   sj=`grep $j data/test+dev/utt2spk | awk '{print $2}'`

                   exclude_i=`grep 'Did not' exp/tri2b_multi_ali*/log/* | awk '{print $8}' | awk -F',' '{print $1}' | egrep $i `;     
                   exclude_j=`grep 'Did not' exp/tri2b_multi_ali*/log/* | awk '{print $8}' | awk -F',' '{print $1}' | grep $j`; 

                   repi=`echo $i | rev | cut -c 2- | rev`
                   repj=`echo $j | rev | cut -c 2- | rev`

                   if [ -z $exclude_i ] && [ -z $exclude_j ] && [ "$repi" != "$repj" ] && [ "$i" != "$j"  ]; then     

                           echo "$i $j" >> exp/trials/trial.utt2utt 
 
                           if [ "$si" == "$sj" ]; then
                              echo "target" >> exp/trials/trial.utt2utt.keys
                           else
                              echo "nontarget" >> exp/trials/trial.utt2utt.keys
                           fi
                  fi
               done
         done
 
}
#make_trial_channel_noise

