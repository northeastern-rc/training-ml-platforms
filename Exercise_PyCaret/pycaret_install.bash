#!/bin/bash
#####Use after training##############
##SBATCH --partition=gpu
##SBATCH --gres=gpu:p100:1  # Choose any GPU other than the Kepler series
#####################################

#####Use during training###############
#SBATCH --partition=reservation
#SBATCH --reservation=bootcamp_gpu_2023
#SBATCH --gres=gpu:1
#######################################

#SBATCH --job-name=pycaret_build
#SBATCH -N 1
#SBATCH -c 2

# Loading the modules required
module load anaconda3/2022.05 cuda/11.8

conda create --prefix=/scratch/$USER/pycaret_env_bootcamp python=3.10 -y  
source activate /scratch/$USER/pycaret_env_bootcamp

pip install pycaret[full] 
conda install jupyterlab -y
pip install chardet
