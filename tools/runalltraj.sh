#!/bin/bash
#SBATCH -p standard
#SBATCH -J 18ethylene
#SBATCH -o output
#SBATCH -t 10:00:00
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 1

CWD=/gpfs/fs2/scratch/wzhou21/qd-sqc/runs/Tully2

k=0
for i in {0101..2000}  #cannot exceed 30
#for i in {00081..00100}
do
   echo "$i"
   cat > sb.$i <<!
#!/bin/bash
#SBATCH -p debug
#SBATCH -J tully-$i
#SBATCH -o output
#SBATCH -t 1:00:00
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 1

module load impi/2017.5

starttime=\$(date +%T%t%m/%d/%Y)
echo TRAJ_$i start \$starttime  >> DONE

cd $CWD/TRAJ_$i/
bash run.sh
cd $CWD
endtime=\$(date +%T%t%m/%d/%Y)
echo TRAJ_$i end \$endtime >> DONE
!
sbatch sb.$i
((k++))
j=`expr $k % 2`
if [ $j -eq 0 ]; then
       echo "j=$j"
       sleep 3s
fi
done
