#!/bin/bash
#####Use after training##############
##SBATCH --partition=gpu
##SBATCH --gres=gpu:v100-sxm2:1  # Choose any GPU other than the Kepler series
#####################################

#####Use during training###############
#SBATCH --partition=reservation
#SBATCH --reservation=bootcamp_gpu_2023
#SBATCH --gres=gpu:1
#######################################

#SBATCH --job-name=rapid_build
#SBATCH --nodes=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=10G
#SBATCH --time=02:00:00

# Loading the modules required
module load anaconda3/2022.05 cuda/11.8 gcc/9.2.0

# From https://docs.rapids.ai/install
conda create --prefix=/scratch/$USER/rapids-23.04 -c rapidsai -c conda-forge -c nvidia rapids=23.04 python=3.10 cudatoolkit=11.8 -y  
source activate /scratch/$USER/rapids-23.04

conda install -c rapidsai -c conda-forge -c nvidia dask-sql jupyterlab dash graphistry xarray-spatial -y
conda install -c anaconda pytest -y

#TF installation from https://www.tensorflow.org/install/pip
pip install nvidia-cudnn-cu11==8.6.0.163
CUDNN_PATH=$(dirname $(python -c "import nvidia.cudnn;print(nvidia.cudnn.__file__)"))
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CONDA_PREFIX/lib/:$CUDNN_PATH/lib
mkdir -p $CONDA_PREFIX/etc/conda/activate.d
echo 'CUDNN_PATH=$(dirname $(python -c "import nvidia.cudnn;print(nvidia.cudnn.__file__)"))' >> $CONDA_PREFIX/etc/conda/activate.d/env_vars.sh
echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CONDA_PREFIX/lib/:$CUDNN_PATH/lib' >> $CONDA_PREFIX/etc/conda/activate.d/env_vars.sh
pip install --upgrade pip
pip install tensorflow==2.12.*
