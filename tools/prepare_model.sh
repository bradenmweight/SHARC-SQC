#!/bin/sh

echo "This script is used to prepare qd-sqc calculation of model system"

f1=geom
if [ ! -e "$f1" ]; then
      echo "file $f1 does not exist."
      exit
fi

f2=veloc
if [ ! -e "$f2" ]; then
      echo "file $f2 does not exist."
      exit
fi

for i in {0001..2000}
do
   echo "$i"
   cat > input <<!
printlevel 1

geomfile "geom"
veloc external
velocfile "veloc"

nstates 2 0 0
actstates 2 0 0
state 1 mch
coeff auto
rngseed $RANDOM

ezero     -78.0114624609
tmax 48.3776865301
stepsize 0.012094421632525
nsubsteps 25
model tully2

surf diagonal
coupling overlap
gradcorrect
ekincorrect parallel_nac
reflect_frustrated none
decoherence_scheme edc
decoherence_param 0.1
!
   traj=TRAJ_$i
   if [ ! -d "$traj" ]; then
      mkdir $traj
   fi
   mv input $traj/
   cp $f1 $traj/
   cp $f2 $traj/

   mypath=$(pwd)/$traj
   #echo "mypath=$mypath"
   PRIMARY_DIR=/gpfs/fs2$mypath
#prepare run.sh
   cat > run.sh <<!
#!/bin/bash
$PRIMARY_DIR
cd $PRIMARY_DIR
$QDSQC/qdsqc.x input
!
  cp run.sh $traj
  chmod +x $traj/run.sh
done


#myPath=$(pwd)/Conf

#if [ ! -d "$myPath" ]; then  
#   echo "$myPath does not exist."
#   mkdir $myPath
#else
#   echo "$myPath exists."
#   echo "Please change the name of folder"
   #exit 
#fi
#echo "Hello"

#xyzPath=$(pwd)/Singlet_1
#for i in {00001..00100}
#do
#   traj=TRAJ_$i
#   echo "traj=$traj"
#   anafile=$xyzPath/$traj/DONT_ANALYZE
#   echo "anafile=$anafile"
#   if [ -e "$anafile" ]
#   then
#      continue
#   fi
#   xyzfile=$xyzPath/$traj/output.xyz
#   echo "xyzfile=$xyzfile"
#   if [ ! -e "$xyzfile" ]; then
#      echo "$xyzfile does not exist."
#   else
#      echo "$xyzfile exists."
#      cp $xyzfile $myPath/output$i.xyz
#   fi 
#done
