#!/bin/bash

for i in {00001..00120}
do 
    f1=TRAJ_$i/run.sh
    #change tmp4
    sed -i 's/runs/runs2/' $f1  
done
