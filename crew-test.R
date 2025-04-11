controller_hpc <- crew.cluster::crew_controller_slurm(
  name = "hpc",
  workers = 10,
  seconds_idle = 120,  # time until workers are shut down after idle
  options_cluster = crew.cluster::crew_options_slurm(
    script_lines = c(
      "#SBATCH --ntasks=1",
      "module load R/4.4.1-foss-2022b"
      #add additional lines to the SLURM job script as necessary here
    ),
    log_output = "logs/crew_small_log_%A.out",
    log_error = "logs/crew_small_log_%A.err",
    memory_gigabytes_per_cpu = 10,
    cpus_per_task = 2, #total 20gb RAM
    time_minutes = 1200, # wall time for each worker
    partition = "batch",
    verbose = TRUE # prints the output from system calls when submitting and terminating SLURM jobs
  )
)

controller_hpc$push(command = 1 + 1)

controller_hpc$wait()

result <- controller_hpc$pop()

result$result[[1L]] # should be 2
