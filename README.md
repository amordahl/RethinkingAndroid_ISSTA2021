# RethinkingAndroid_ISSTA2021
This repository is our submission to the Artifact Evaluation track of ISSTA 2021 for our paper titled "Rethinking Android Taint Analysis Evaluations: A Study on the Impact of Tool Configuration Spaces".

## Repository Structure
This repository is composed of this README, a `resources` folder, and two submodules, pointing to our experimental environment and our dataset. These submodules are included for convenience but do not need to be manually cloned for the experiments -- the virtual machine is already set up, or, if you want to set up the environment yourself, the script to setup the environment will clone the repositories themselves.

## Getting Started
For convenience, we included a virtual machine on Zenodo that has the environment already setup (see *Virtual Machine Requirements* section of this document). However, should you wish to setup the experimental environment yourself, please refer to the **Setup** section at the bottom of this document. The rest of these steps should be run from `/home/issta2021` if you use our virtual machine, or whereever you choose to install the environment if you do not (see **INSTALLATION_LOCATION** in [Setup](#setup)).

Our full experiments for FlowDroid and DroidSafe include 987 different runs of Droidbench 3.0 (211 configurations of FlowDroid + 118 configurations of DroidSafe * 3 replications), and 29610 runs on Fossdroid APKs (211 configurations of FlowDroid + 118 configurations of DroidSafe * 3 replications * 30 FossDroid APKs), and 31650 runs of Google Play APKs (211 configurations of FlowDroid x 3 replications x 50 Google Play APKs). These experiments took about 33,940 machine hours to run in our experimental environment. We have provided a script that runs a small subset of our experiments. It is called [`run_small_experiments.sh`](https://github.com/amordahl/RethinkingAndroid_ISSTA2021/blob/main/resources/run_small_experiments.sh) in the `resources` folder of this repository.

It runs two configurations of Flowdroid (default and the single-option configuration that sets codeeliminationmode to REMOVECODE) on all of Droidbench and Fossdroid. In the paper, we discovered the codeeliminationmode|->REMOVECODE setting has a bug, in that it is not sound (i.e., it sometimes removes code that it should not). Thus, although the partial order we defined says that this option should be more precise than default, in reality it is less sound.

In order to run this script, copy it to the root of the environment (i.e., `/home/issta2021` on the virtual machine or `$INSTALLATION_LOCATION` on your own environment). Then, simply invoke the script as `run_small_experiments.sh` (estimated time to run is approximately 40 minutes).

We split the script into two parts -- `run_small_experiments_droidbench.sh` only runs the Droidbench experiments (i.e., produces items 1 and 4 below), and `run_small_experiments_fossdroid.sh` only runs the FossDroid experiments (i.e., produces items 2, 3, and 5 below).

The script produces the following outputs:

1. `flowdroid_droidbench3.csv`. This contains the results of running two configurations of Flowdroid (default and the single-option configuration that sets codeeliminationmode to REMOVECODE) on all of DroidBench. The output is in the form of a CSV, where each row is one of the 204 tests that DroidBench performs. The full results of these were used to answer RQ1 (Figure 2a) and RQ2 (Table 2). 
2. A directory called `flowdroid-fossdroid`, which contains the results of running the same two configurations of Flowdroid on all 30 of our FossDroid APKs. Each execution produces one file, named in the format `apk_configuration.xml`. These files are in our augmented AQL-Answer format (we simply added time as an attribute of the `<flow>` element). The full results of these were what the student workers we hired classified (Section 3), and the classifications are included in our dataset (included in the repository as [`fossdroid_dataset`](https://github.com/amordahl/fdroid_package/tree/ISSTA2021).
3. A file called `flowdroid-fossdroid.csv`, which contains the summary data of the Fossdroid runs, as a CSV. The full results of these were used to answer RQ2 (Figure 3) and RQ3 (Table 3, Figures 4-6).
4. A file called `violations_droidbench.txt`, which contains the violations that were discovered in the DroidBench results.
5. A file called `violations_fossdroid.txt`, which contains the violations that were discovered in the FossDroid apks.

The latter two files will show precision and soundness violations, and were used to answer RQ4.

## Detailed Description
We have provided `./run_full_experiments.sh` which will run the set of experiments on Flowdroid and Droidsafe. However, as stated above, these took us 33,940 machine hours to complete. So, we also describe here how to view the data that we used to make the claims in our paper. These data are primarily located in two places.

### Dataset
Our dataset of flows classified from FossDroid are located in the [`fossdroid_package`](https://github.com/amordahl/fdroid_package/tree/ISSTA2021) submodule that is at the root of this directory. The documentation in that folder includes detailed instructions on how to read the flows, plus an example of a flow that can be tracked in code.

### Results
The results we used to create charts, tables, and make statistical claims in our paper are located in [AndroidTAEnvironment/results](https://github.com/amordahl/AndroidTAEnvironment/tree/ISSTA2021/results). There are three top level folders here, corresponding to the three different benchmarks we used, which are then further divided into tool directories. Within each tool directory is a single Excel (.xlsx) file. These contain the aggregated data across all replications for our runs. Each Excel spreadsheet contains all of the records of our runs. Of particular interest are the `oneway-charts` and `twoway-charts` sheets in each file, which include the aggregation of the `single-conf` and `two-way` configuration runs, plus the charts we used in the paper.

The statistical analysis is done by R scripts, included in [resources/scripts/r](https://github.com/amordahl/AndroidTAEnvironment/tree/ISSTA2021/resources/scripts/r). Here, the `build_linear_model.R` script built our statistical model, and our `make_plots.R` script created additional plots we used in the paper. The data that needs to be loaded in as data frames into your R environment to use these scripts are included as CSVs in this directory.

## Virtual Machine Requirements
Our virtual machine requires *how much* disk space, 4GB of RAM and 2 CPUs. We generated it with VirtualBox 6.1.

## Setup
We have provided a script that will setup the experimental environment at [`resources/setup.sh`](link). In order to run the script, you first need to download the [benchmark.tar.gz](linkToZenodo) file from Zenodo and place it within the `resources` directory. It is too large to include in the repository. Then, you may need to change the **RESOURCES_HOME** environmental variable at the top of the script. Please check the following things:

1. The **RESOURCES_HOME** environmental variable defined on line 3. This should point to the *resources* folder in this repository. Leave it there should you wish to build the experimental environment at the root of this repository. Otherwise, change it to where you would like the environment to be setup.
2. The bashrc file within the resources directory. Please change the **INSTALLATION_LOCATION** environmental variable to where you plan to install the environment (i.e., where you will run setup.sh from).

Once everything is ready to go, simply run [`setup.sh`](link) from whereever you wish to install the environment.
We have only evaluated this setup on an Ubuntu 18.04 system. We cannot guarantee it works for any other distribution.
