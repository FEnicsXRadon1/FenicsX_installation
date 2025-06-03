  #!/bin/bash
  
  #SBATCH --job-name=ID_dolfinXtest
  #SBATCH --partition=compute-purley
  #SBATCH --ntasks=8
  #SBATCH --nodes=1
  ##SBATCH --tasks-per-node=1
  ##SBATCH --mem-per-cpu=32GB
  ##SBATCH --mem=0
  #
  ## Suggested batch arguments
  ##SBATCH --mail-type=ALL
  ##SBATCH --mail-user=myneme@gmail.com
  #
  ## Logging arguments (IMPORTANT)
  #SBATCH --output=slurm_%x-%j.out
  #SBATCH --error=slurm_%x-%j.err
  
  . $HOME/spack/share/spack/setup-env.sh 
  module load compiler/gcc/13.3.1
  module load mpi/openmpi/5.0.7
  module load python/311
  
  
  spack env activatefenicsx-090  
  
  srun --mpi=pmix  -n $SLURM_NTASKS python nameoffile.py
