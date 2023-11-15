#!/bin/bash


CURR_TIME=`date +%Y-%m-%d-%H-%M-%S`
RESULT_DIR="test-about-maxBBSize/result/${CURR_TIME}"
RUN_DIR=".."

# MAIN
ALL_SUBJECTS=(grep)
# MAX_BB_SIZE=(4 8 16 24 32)
MAX_BB_SIZE=(15)
# MAX_RUN_CASES=15
MAX_RUN_CASES=6
ALGOS=(WinMut WinMutNo AccMut AccMutNo)

# tmpCtrl
# MAX_BB_SIZE=(15 16)
# MAX_RUN_CASES=1
# ALGOS=(WinMut WinMutNo)

if [ ! -d ${RESULT_DIR} ]; then
    mkdir -p ${RESULT_DIR}
fi

echo "ALL_SUBJECTS=(${ALL_SUBJECTS[@]})" > ${RESULT_DIR}/config.sh
echo "MAX_BB_SIZE=(${MAX_BB_SIZE[@]})" >> ${RESULT_DIR}/config.sh
echo "ALGOS=(${ALGOS[@]})" >> ${RESULT_DIR}/config.sh
echo "MAX_RUN_CASES=(${MAX_RUN_CASES})" >> ${RESULT_DIR}/config.sh

for subject in ${ALL_SUBJECTS[@]}
do
    if [ ! -d $subject ]; then
        echo $subject???
        exit -1
    fi
    subject_result_dir="${RESULT_DIR}/${subject}"
    # mkdir ${RESULT_DIR}/${subject}
    mkdir $subject_result_dir

    for maxBBSize in ${MAX_BB_SIZE[@]}
    do
        subject_result_maxBBSize_dir="${RESULT_DIR}/${subject}/$maxBBSize"
        mkdir $subject_result_maxBBSize_dir


        for algo in ${ALGOS[@]}
        do 
            subject_result_maxBBSize_algo_dir="${RESULT_DIR}/${subject}/$maxBBSize/$algo"
            mkdir $subject_result_maxBBSize_algo_dir
            # compile
            ./run0.sh  $subject build  $algo $MAX_RUN_CASES $maxBBSize
            
            # run
            RUN_COMMAND="./run0.sh  $subject run  $algo $MAX_RUN_CASES"
            (time $RUN_COMMAND) 2> $subject_result_maxBBSize_algo_dir/time_output.txt

            # collect result
            cp -r $subject/$algo/winmut-log-dir/* $subject_result_maxBBSize_algo_dir

            # WinMut log分析
            # log=$( ./readTP.sh $subject $algo )
            # echo "$log" | mail -s "执行完毕通知" 2379637215@qq.com  
        done
              
    done
done




