#!/bin/bash
echo "Running Flowdroid default and codeelimination->REMOVECODE on Droidbench."
cd AndroidTAEnvironment/BREW/target/build
parallel -j 1 python -m BrewRunner ./BREW-1.1.0-SNAPSHOT.jar ~/flowdroid_droidbench3.csv apks ::: ../../../configurations/FlowDroid/1-way/config_FlowDroid_aplength5.xml ../../../configurations/FlowDroid/1-way/config_FlowDroid_codeeliminationrc.xml

echo "Running the same configurations on Fossdroid."
cd ~
find ~/benchmark/fossdroid -type f -name '*.apk' > fossdroid_apks.txt
cd AndroidTAEnvironment/AQL-System/target/build
parallel --progress -j 1 python runaql.py --outputdir ~/flowdroid-fossdroid ::: ../../../configurations/FlowDroid/1-way/config_FlowDroid_aplength5.xml ../../../configurations/FlowDroid/1-way/config_FlowDroid_codeeliminationrc.xml :::: ~/fossdroid_apks.txt
cd ~
rm fossdroid_apks.txt

echo "Processing Fossdroid data."
find flowdroid-fossdroid/ -type f -name '*.xml' | parallel --xargs python AndroidTAEnvironment/resources/scripts/extract_info.py --groundtruths AndroidTAEnvironment/resources/groundtruths.xml --header --results > flowdroid_fossdroid.csv

echo "Computing violations."
python AndroidTAEnvironment/resources/scripts/augment_csv.py flowdroid_droidbench3.csv AndroidTAEnvironment/tools/config/FlowDroid/flowdroid_1way.csv ./flowdroid_droidbench3.csv
python AndroidTAEnvironment/resources/scripts/augment_csv.py flowdroid_fossdroid.csv AndroidTAEnvironment/tools/config/FlowDroid/flowdroid_1way.csv ./flowdroid_fossdroid.csv

cd AndroidTAEnvironment/resources/checkmate
python checkmate/validate.py flowdroid droidbench ~/flowdroid_droidbench3.csv ~/flowdroid_droidbench_violations.txt -j 1
python checkmate/validate.py flowdroid fossdroid ~/flowdroid_fossdroid.csv ~/flowdroid_fossdroid_violations.txt -j 1
