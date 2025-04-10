#!/bin/bash
#SBATCH --job-name=renv_restore
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --cpus-per-task=2
#SBATCH --mem-per-cpu=10gb          
#SBATCH --time=4:00:00
#SBATCH --partition=batch
#SBATCH -o logs/%x_%j.out

# Load necessary modules
module load R/4.4.1-foss-2022b

# Sync with renv.lock using `pak` for installation
export RENV_CONFIG_PAK_ENABLED=TRUE
R -e 'renv::restore()'
