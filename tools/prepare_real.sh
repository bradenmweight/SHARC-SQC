#!/bin/sh


singl=/scratch/wzhou21/sharc-2.0/runs/Ethylene20/Singlet_1

echo "This script prepare real molecular system claculation using qdsqc"
echo "geom and veloc are $singl"

for i in {00001..00120}
do
    traj=TRAJ_$i
    yourpath=$singl/$traj
    f1=$yourpath/geom
    f2=$yourpath/veloc
    QM=$yourpath/QM
    if [ ! -e "$f1" ]
    then
      echo "file $f1 does not exist."
      exit
    fi
    if [ ! -e "$f2" ]
    then
      echo "file $f2 does not exist."
      exit
    fi
    mkdir $traj
    mkdir $traj/QM
    cp $f1 $traj/geom
    cp $f2 $traj/veloc
    cp -r $QM/* $traj/QM/ 
#prepare run.sh
    PRIMARY_DIR=/gpfs/fs2/scratch/wzhou21/qd-sqc/runs/Ethylene/$traj
    cat > run.sh <<!
#!/bin/bash
$PRIMARY_DIR
cd $PRIMARY_DIR
$QDSQC/qdsqc.x input
!
   cp run.sh $traj/run.sh
   chmod +x $traj/run.sh
#prepare input file
cat > input <<!
printlevel 1

geomfile "geom"
veloc external
velocfile "veloc"

nstates 2 0 0
actstates 2 0 0
state 2 mch
coeff auto
rngseed $RANDOM

ezero     -78.0114624609
tmax 250.0
stepsize 0.1
nsubsteps 100
trace 1

surf diagonal
coupling overlap
gradcorrect
ekincorrect parallel_nac
reflect_frustrated none
decoherence_scheme edc
decoherence_param 0.1
nospinorbit
write_overlap
write_grad
write_nacdr
!
mv input $traj/
done

#for i in {0001..2000}
#do
#   f1=geom$i
#   f2=velo$i
#   traj=TRAJ_$i
#   echo "f1=$f1"
#   echo "f2=$f2"
#   mypath=$(pwd)/$traj
#   echo "mypath=$mypath"
#   if [ ! -d "$mypath" ]; then
#      mkdir $mypath
#   fi
#   cp $f3 $mypath
#   cp $f1 $mypath
#   mv $mypath/$f1 $mypath/geom
#   cp $f2 $mypath
#   mv $mypath/$f2 $mypath/veloc
#   PRIMARY_DIR=/gpfs/fs2$mypath
#prepare run.sh
#   cat > run.sh <<!
#!/bin/bash
#$PRIMARY_DIR
#cd $PRIMARY_DIR
#$QDS/qdsharc.x input
#!
#  cp run.sh $mypath
#  chmod +x $mypath/run.sh
#done


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
