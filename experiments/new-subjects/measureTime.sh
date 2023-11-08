# bash时间戳
SUBJECT="grep"
mailAfter ./run.sh $SUBJECT build WinMut
mailAfter ./run.sh $SUBJECT run WinMut

# bash time
RUN_COMMAND="./run.sh $SUBJECT run WinMut"
output=$( (time $RUN_COMMAND > 1 2>&1) 2>&1 )
echo "$output" | mail -s "执行完毕通知" 2379637215@qq.com

# WinMut log分析
log=$( ./readTP.sh $SUBJECT WinMut )
echo "$log" | mail -s "执行完毕通知" 2379637215@qq.com