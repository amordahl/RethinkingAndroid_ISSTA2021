#!/bin/bash
echo "Running Flowdroid default and codeelimination->REMOVECODE on Droidbench."
cd AndroidTAEnvironment/BREW/target/build
parallel --progress python -m BrewRunner ./BREW-1.1.0-SNAPSHOT.jar $INSTALLATION_LOCATION/flowdroid_droidbench3.csv apks ::: ../../../configurations/FlowDroid/1-way/config_FlowDroid_aplength5.xml ../../../configurations/FlowDroid/1-way/config_FlowDroid_codeeliminationrc.xml

echo "Running the same configurations on Fossdroid."
cd $INSTALLATION_LOCATION
find $INSTALLATION_LOCATION/benchmark/fossdroid -type f -name '*.apk' > fossdroid_apks.txt
cd AndroidTAEnvironment/AQL-System/target/build
parallel --progress python runaql.py --outputdir $INSTALLATION_LOCATION/flowdroid_fossdroid ::: ../../../configurations/FlowDroid/1-way/config_FlowDroid_aplength5.xml ../../../configurations/FlowDroid/1-way/config_FlowDroid_codeeliminationrc.xml :::: $INSTALLATION_LOCATION/fossdroid_apks.txt
cd $INSTALLATION_LOCATION
rm fossdroid_apks.txt

echo "Processing Fossdroid data."
cd AndroidTAEnvironment/resources/scripts/
find $INSTALLATION_LOCATION/flowdroid_fossdroid/ -type f -name '*.xml' | parallel --progress python deduplicate.py {} {}
cd $INSTALLATION_LOCATION
find flowdroid_fossdroid/ -type f -name '*.xml' | parallel --xargs python AndroidTAEnvironment/resources/scripts/extract_info.py --groundtruths AndroidTAEnvironment/resources/groundtruths.xml --header --results > flowdroid_fossdroid.csv

echo "Computing violations."
python AndroidTAEnvironment/resources/scripts/augment_csv.py flowdroid_droidbench3.csv AndroidTAEnvironment/tools/config/FlowDroid/flowdroid_1way.csv ./flowdroid_droidbench3.csv
python AndroidTAEnvironment/resources/scripts/augment_csv.py flowdroid_fossdroid.csv AndroidTAEnvironment/tools/config/FlowDroid/flowdroid_1way.csv ./flowdroid_fossdroid.csv

cd AndroidTAEnvironment/resources/checkmate
python checkmate/validate.py flowdroid droidbench $INSTALLATION_LOCATION/flowdroid_droidbench3.csv $INSTALLATION_LOCATION/flowdroid_droidbench_violations.txt -j 1
python checkmate/validate.py flowdroid fossdroid $INSTALLATION_LOCATION/flowdroid_fossdroid.csv $INSTALLATION_LOCATION/flowdroid_fossdroid_violations.txt -j 1
