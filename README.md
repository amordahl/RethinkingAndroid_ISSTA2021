# RethinkingAndroid_ISSTA2021
This repository is our submission to the Artifact Evaluation track of ISSTA 2021.

## Getting Started
For convenience, we included a virtual machine on Zenodo that has the environment already setup. However, should you wish to setup the experimental environment yourself, please refer to the **Setup** section at the bottom of this document. The rest of these steps should be run from /home/issta2021 if you use our virtual machine, or whereever you choose to install the environment if you do not (see **INSTALLATION_LOCATION** in [Setup](#setup)).

We have provided a script that runs a small subset of our experiments. It is called *run_small_experiments.sh*. Simply open a terminal and type `./run_small_experiments.sh` (estimated time to run is about *FILL IN*).

This script produces the following outputs:

1. `flowdroid_droidbench3.csv`. This contains the results of running two configurations of Flowdroid (default and the single-option configuration that sets codeeliminationmode to REMOVECODE) on all of DroidBench. The output is in the form of a spreadsheet, where each row is one of the 204 tests that DroidBench performs.
2. A directory called `flowdroid-fossdroid`, which contains the results of running the same two configurations of Flowdroid on all 30 of our FossDroid APKs. Each execution produces one file, named in the format `apk_configuration.xml`.
3. A file called `flowdroid-fossdroid.csv`, which contains the summary data of the Fossdroid runs.
4. A file called `violations_droidbench.txt`, which contains the violations that were discovered in the DroidBench results.
5. A file called `violations_fossdroid.txt`, which contains the violations that were discovered in the FossDroid apks.

## Detailed Description
We have provided `./run_full_experiments.sh` which will run the set of experiments on Flowdroid and Droidsafe.

## Setup
We have provided a script that will setup the experimental environment at [`resources/setup.sh`](link). In order to run the script, you first need to download the [benchmark.tar.gz](linkToZenodo) file from Zenodo and place it within the `resources` directory. It is too large to include in the repository. Then, you may need to change the **RESOURCES_HOME** environmental variable at the top of the script. Please check the following things:

1. The **RESOURCES_HOME** environmental variable defined on line 3. This should point to the *resources* folder in this repository. Leave it there should you wish to build the experimental environment at the root of this repository. Otherwise, change it to where you would like the environment to be setup.
2. The bashrc file within the resources directory. Please change the **INSTALLATION_LOCATION** environmental variable to where you plan to install the environment (i.e., where you will run setup.sh from).

Once everything is ready to go, simply run [`setup.sh`](link) from whereever you wish to install the environment.
We have only evaluated this setup on an Ubuntu 18.04 system. We cannot guarantee it works for any other distribution.
