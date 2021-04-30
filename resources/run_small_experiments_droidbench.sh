#!/bin/bash
echo "Running Flowdroid default and codeelimination->REMOVECODE on Droidbench."
cd AndroidTAEnvironment/BREW/target/build
parallel --progress python -m BrewRunner ./BREW-1.1.0-SNAPSHOT.jar $INSTALLATION_LOCATION/flowdroid_droidbench3.csv apks ::: ../../../configurations/FlowDroid/1-way/config_FlowDroid_aplength5.xml ../../../configurations/FlowDroid/1-way/config_FlowDroid_codeeliminationrc.xml

echo "Computing violations."
python AndroidTAEnvironment/resources/scripts/augment_csv.py flowdroid_droidbench3.csv AndroidTAEnvironment/tools/config/FlowDroid/flowdroid_1way.csv ./flowdroid_droidbench3.csv

cd AndroidTAEnvironment/resources/checkmate
python checkmate/validate.py flowdroid droidbench $INSTALLATION_LOCATION/flowdroid_droidbench3.csv $INSTALLATION_LOCATION/flowdroid_droidbench_violations.txt -j 1
