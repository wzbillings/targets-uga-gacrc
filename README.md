# targets-uga: A template to use the {targets} R package with UGA sapelo2

<!-- badges: start -->
<!--
[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active) [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.10963005.svg)](https://doi.org/10.5281/zenodo.10963005)
-->
<!-- badges: end -->

This is a minimal example of a [`targets`](https://docs.ropensci.org/targets/) workflow that can be run on the [University of Georgia cluster computer]([https://uarizona.atlassian.net/wiki/spaces/UAHPC/overview](https://wiki.gacrc.uga.edu/wiki/Running_Jobs_on_Sapelo2)).
`targets` is an R package for workflow management that can save you time by automatically skipping code that doesn’t need to be re-run when you make changes to your data or code.
It also makes parallelization relatively easy by allowing you to define each target as a separate SLURM job with the [`crew.cluster`](https://wlandau.github.io/crew.cluster/) package.

## Prerequisites:

-   [A sapelo2 account account](https://wiki.gacrc.uga.edu/wiki/User_Accounts).
-   Some familiarity with R, RStudio, the [`renv` pacakge](https://rstudio.github.io/renv/articles/renv.html), and the [`targets` package](https://books.ropensci.org/targets/)
-   A GitHub account

## To set-up:

To get this bare-bones pipeline running on sapelo2:

1.  Click the “Use this template” button to create a repo under your own GitHub user name.
3.  [SSH into sapelo2](https://wiki.gacrc.uga.edu/wiki/Connecting).
4.  Clone this repo on the HPC, e.g. with `git clone https://github.com/your-user-name/targets-uga-gacrc.git`, or transfer with Globus.
5.  Start an interactive session on the HPC, e.g. with `interact` .
6.  Load R with `module load R/version`.
7.  Launch R from within the `targets-uga-gacrc/` directory with the `R` command
8.  The [`renv` package](https://rstudio.github.io/renv/) should install itself. After it is done, you can install all necessary R packages by running `renv::restore()`.

To modify the pipeline to run *your* code, you'll need to edit the list of targets in `_targets.R` as well as functions in the `R/` folder.
See the [targets manual](https://books.ropensci.org/targets/) for more information.

Note that use of the `renv` package for tracking dependencies isn't strictly necessary, but it does simplify package installation on sapelo2 (in most cases).
As you add R packages dependencies, you can use `targets::tar_renv()` to update the `_targets_packages.R` file and then `renv::snapshot()` to add them to `renv.lock`.
On sapelo2, running `renv::restore()` not only installs any missing R packages, it also automatically detects system dependencies and lets you know if they aren't installed.

## Running the pipeline

Unlike the template from which this is cloned, you CANNOT run a targets job from an interactive R session, on sapelo2. In my experience your jobs will get blocked with incorrect permissions if they are spawned from an interactive session. Even if that is my problem and not universally true, interactive jobs on sapelo2 have a time limit of 2 days which is often not long enough for intensive modeling pipelines. I haven't used UGA's Open OnDemand setup, even though I'm pretty sure we have this. But the easiest way to submit a targets job is to use a shell script submission.

Edit the `run.sh` file to update your group name and the wall-time for the main process.
SSH into the HPC, navigate to this project, and run `sbatch run.sh`.
You can watch progress by occasionally running `sq --me` to see the workers launch and you can peek at the `logs/` folder.
You can find the most recently modified log files with something like `ls -lt | head -n 5` and then you can read the logs with `cat targets_main_9814039.out` (or whatever file name you want to read).

## Notes:

The `_targets/` store can grow to be quite large depending on the size of data and the number of targets created. I recommend adding it to `.gitignore` on all projects.

You should always run your code from the `/scratch/$USER` directory, NOT from `/home/$USER`.

Code in `_targets.R` will attempt to detect if you are able to launch SLURM jobs and if not (e.g. you are not on the HPC or are using Open On Demand) it will fall back to using `crew::crew_controller_local()`.

sapelo2 doesn't set a default for the `ntasks` slurm parameter while most other Slurm setups do, apparently. So you must make sure your controller adds the line `"#SBATCH --ntasks=1"` to the slurm submission scripts or they will fail and hang forever. I think Will Landau (the targets developer) intends to make this a targets default but I don't know what the timeline on that is.

## Acknowledgements

This is mostly copied from Eric Scott's [UAHPC template](https://github.com/cct-datascience/targets-uahpc), he was super helpful getting things working on the targets help forum.

