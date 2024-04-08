#!/bin/bash
#SBATCH --job-name=YOUR_JOB_NAME        # create a short name for your job
#SBATCH --nodes=1                       # node count
#SBATCH --ntasks=12                     # total number of tasks across all nodes
#SBATCH --mem=60G                       # total memory per node (4 GB per cpu-core is default)
#SBATCH --gres=gpu:2                    # number of gpus per node
#SBATCH --time=25:00:00                 # total run time limit (HH:MM:SS)
#SBATCH --mail-type=begin               # send mail when job begins
#SBATCH --mail-type=end                 # send mail when job ends
#SBATCH --mail-type=fail                # send mail if job fails
#SBATCH --mail-user=YOUR_EMAIL
#SBATCH --output=train_%x.out           
#SBATCH --account=YOUR_PROJECT_NAME     # project name
#SBATCH --partition=boost_usr_prod      # https://wiki.u-gov.it/confluence/display/SCAIUS/UG3.2%3A+LEONARDO+UserGuide#UG3.2:LEONARDOUserGuide-Productionenvironment
#SBATCH --qos=boost_qos_lprod

NUM_GPU=2

# setting wandb offline mode
export WANDB_MODE=offline

export CUDA_VISIBLE_DEVICES="0,1,2,3"
export TRANSFORMERS_CACHE=$WORK/transformers_cache  # set transformers library cache
export HF_DATASETS_CACHE=$WORK/hugginface_hub_cache
export OMP_NUM_THREADS=12

# load bashrc
source $HOME/.bashrc

module purge
module load anaconda3/2023.03
module load profile/deeplrn
conda activate YOUR_CONDA_ENV

wandb_run_name='YOUR_WANDB_RUN_NAME'

# this is an config from my previous work, just to have an idea
# WANDB args are mine, not the official ones
flag1="--exp_name $wandb_run_name
      --run-type train
      --exp-config run_r2r/iter_train.yaml
      SIMULATOR_GPU_IDS [$(seq -s, 0 $((NUM_GPU-1)))]
      TORCH_GPU_IDS [$(seq -s, 0 $((NUM_GPU-1)))]
      GPU_NUMBERS $NUM_GPU
      NUM_ENVIRONMENTS 8
     
      MODEL.DEPTH_ENCODER.ddppo_checkpoint $WORK/models/gibson-2plus-resnet50.pth

      MODEL.WANDB.use True    
      MODEL.WANDB.run_name $wandb_run_name
     
      TASK_CONFIG.DATASET.SCENES_DIR $WORK/dataset/scene_datasets/

      CHECKPOINT_FOLDER $WORK/train_res_bevbert/checkpoints/
      "

##### Number of total processes 
echo "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX "
echo "Nodelist:= " $SLURM_JOB_NODELIST
echo "Number of nodes:= " $SLURM_JOB_NUM_NODES
echo "Ntasks per node:= "  $SLURM_NTASKS_PER_NODE
echo "NUM gpu per done:=" $NUM_GPU
echo "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX "

echo "Run started at:- "
date


echo "###### train mode ######"
torchrun --nnodes 1 --nproc_per_node $NUM_GPU --standalone run.py $flag1

echo ""
echo "################################################################"
echo "@@@@@@@@@@@@@@@@@@ Run completed at:- @@@@@@@@@@@@@@@@@@@@@@@@@"
date
echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
echo "################################################################"