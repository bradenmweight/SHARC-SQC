#!/bin/bash

echo "This shell is used to find which trajectory is not finished"

MYVAR="172:! 15 Gradients (MCH) State  1"
echo ${MYVAR%%:*}   #get 172

myPath=$(pwd)/Dmatrix

if [ ! -d "$myPath" ]; then
   echo "$myPath does not exist."
   mkdir $myPath
else
   echo "$myPath exists."
   #echo "Please change the name of folder"
   #exit
fi
echo "Hello"

#grep -n "Gradients" output.dat1 > abc.temp

#cat abc.temp | while read line
for i in {00001..00120}
do 
   traj=TRAJ_$i
   f1=$traj/output.log
   f2=$traj/density.dat
   echo "f1=$f1"
   grep "wallclock" $f1 | while read line
   do
   echo "line=$line"
   read -r -a Words <<< "$line"
   echo "Wrods[1]=${Words[1]}"
   if [ "${Words[1]}" != "" ]; then
      echo "Hello" 
      #j=${i:1:4}
      #echo "j=$j"
      f3=$myPath/density$i.dat
      cp $f2 $f3
   fi
   done
done
