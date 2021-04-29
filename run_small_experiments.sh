#!/bin/bash
echo "Running Flowdroid default and codeelimination->REMOVECODE on Droidbench."
cd AndroidTAEnvironment/BREW/target/build
parallel --progress -j 1 python -m BrewRunner ./BREW-1.1.0-SNAPSHOT.jar ~/flowdroid_droidbench3.csv apks ::: ../../../configurations/FlowDroid/1-way/config_FlowDroid_aplength5.xml ../../../configurations/FlowDroid/1-way/config_FlowDroid_codeeliminationrc.xml

echo "Running the same configurations on Fossdroid."
cd ~
find ~/benchmark/fossdroid -type f -name '*.apk' > fossdroid_apks.txt
cd AndroidTAEnvironment/AQL-System/target/build
parallel --progress -j 1 python runaql.py --outputdir ~/flowdroid-fossdroid :::: ~/fossdroid_apks.txt ::: ../../../configurations/FlowDroid/1-way/config_FlowDroid_aplength5.xml ../../../configurations/FlowDroid/1-way/config_FlowDroid_codeeliminationrc.xml
cd ~
rm fossdroid_apks.txt
