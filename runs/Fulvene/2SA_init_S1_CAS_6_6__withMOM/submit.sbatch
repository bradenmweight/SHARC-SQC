#!/bin/bash
#SBATCH -p standard
#SBATCH -J SQC_FUL
#SBATCH -o output.slurm
#SBATCH -t 5-00:00:00
#SBATCH -N 1
#SBATCH --ntasks-per-node=1
##SBATCH --mem 20GB

module load gcc
module load openblas
module load blas
module load openmpi
module load impi/2017.5

sh run.sh
