#!/bin/bash
echo "Running Flowdroid default and codeelimination->REMOVECODE on Droidbench."
cd AndroidTAEnvironment/BREW/target/build
for n in {1..3}; do

    find $INSTALLATION_LOCATION/AndroidTAEnvironment/configurations/FlowDroid/1-way -type f -name '*.xml' > flowdroid_configs_1way.txt
    find $INSTALLATION_LOCATION/AndroidTAEnvironment/configurations/FlowDroid/2-way -type f -name '*.xml' > flowdroid_configs_2way.txt
    find $INSTALLATION_LOCATION/AndroidTAEnvironment/configurations/DroidSafe/1-way -type f -name '*.xml' > droidsafe_configs_1way.txt
    find $INSTALLATION_LOCATION/AndroidTAEnvironment/configurations/DroidSafe/2-way -type f -name '*.xml' > droidsafe_configs_2way.txt
    parallel --progress python -m BrewRunner ./BREW-1.1.0-SNAPSHOT.jar $INSTALLATION_LOCATION/flowdroid_droidbench3_1way_replication_$n.csv apks :::: flowdroid_configs_1way.txt
    parallel --progress python -m BrewRunner ./BREW-1.1.0-SNAPSHOT.jar $INSTALLATION_LOCATION/flowdroid_droidbench3_2way_replication_$n.csv apks :::: flowdroid_configs_2way.txt
    parallel --progress python -m BrewRunner ./BREW-1.1.0-SNAPSHOT.jar $INSTALLATION_LOCATION/droidsafe_droidbench3_1way_replication_$n.csv apks :::: droidsafe_configs_1way.txt
    parallel --progress python -m BrewRunner ./BREW-1.1.0-SNAPSHOT.jar $INSTALLATION_LOCATION/droidsafe_droidbench3_2way_replication_$n.csv apks :::: droidsafe_configs_2way.txt

    echo "Running the same configurations on Fossdroid."
    cd $INSTALLATION_LOCATION
    find $INSTALLATION_LOCATION/benchmark/fossdroid -type f -name '*.apk' > fossdroid_apks.txt
    cd AndroidTAEnvironment/AQL-System/target/build
    parallel --progress python runaql.py --outputdir $INSTALLATION_LOCATION/flowdroid_fossdroid_1way_replication_$n :::: flowdroid_configs_1way.txt :::: $INSTALLATION_LOCATION/fossdroid_apks.txt
    parallel --progress python runaql.py --outputdir $INSTALLATION_LOCATION/flowdroid_fossdroid_2way_replication_$n :::: flowdroid_configs_2way.txt :::: $INSTALLATION_LOCATION/fossdroid_apks.txt
    parallel --progress python runaql.py --outputdir $INSTALLATION_LOCATION/droidsafe_fossdroid_1way_replication_$n :::: droidsafe_configs_1way.txt :::: $INSTALLATION_LOCATION/fossdroid_apks.txt
    parallel --progress python runaql.py --outputdir $INSTALLATION_LOCATION/droidsafe_fossdroid_2way_replication_$n :::: droidsafe_configs_2way.txt :::: $INSTALLATION_LOCATION/fossdroid_apks.txt
    cd $INSTALLATION_LOCATION
    rm fossdroid_apks.txt
    
    echo "Processing Fossdroid data."
    cd AndroidTAEnvironment/resources/scripts/
    find $INSTALLATION_LOCATION/flowdroid_fossdroid_1way_replication_$n/ -type f -name '*.xml' | parallel --progress python deduplicate.py {} {}
    find $INSTALLATION_LOCATION/flowdroid_fossdroid_2way_replication_$n/ -type f -name '*.xml' | parallel --progress python deduplicate.py {} {}
    find $INSTALLATION_LOCATION/droidsafe_fossdroid_1way_replication_$n/ -type f -name '*.xml' | parallel --progress python deduplicate.py {} {}
    find $INSTALLATION_LOCATION/droidsafe_fossdroid_2way_replication_$n/ -type f -name '*.xml' | parallel --progress python deduplicate.py {} {}
    cd $INSTALLATION_LOCATION
    find flowdroid_fossdroid_1way_replication_$n/ -type f -name '*.xml' | parallel --xargs python AndroidTAEnvironment/resources/scripts/extract_info.py --groundtruths AndroidTAEnvironment/resources/groundtruths.xml --header --results > flowdroid_fossdroid_1way_replication_$n.csv
    find flowdroid_fossdroid_2way_replication_$n/ -type f -name '*.xml' | parallel --xargs python AndroidTAEnvironment/resources/scripts/extract_info.py --groundtruths AndroidTAEnvironment/resources/groundtruths.xml --header --results > flowdroid_fossdroid_2way_replication_$n.csv
    find droidsafe_fossdroid_1way_replication_$n/ -type f -name '*.xml' | parallel --xargs python AndroidTAEnvironment/resources/scripts/extract_info.py --groundtruths AndroidTAEnvironment/resources/groundtruths.xml --header --results > droidsafe_fossdroid_1way_replication_$n.csv
    find droidsafe_fossdroid_2way_replication_$n/ -type f -name '*.xml' | parallel --xargs python AndroidTAEnvironment/resources/scripts/extract_info.py --groundtruths AndroidTAEnvironment/resources/groundtruths.xml --header --results > droidsafe_fossdroid_2way_replication_$n.csv
    
    echo "Computing violations."
    python AndroidTAEnvironment/resources/scripts/augment_csv.py flowdroid_droidbench3_1way_replication_$n.csv AndroidTAEnvironment/tools/config/FlowDroid/flowdroid_1way.csv ./flowdroid_droidbench3_1way_replication_$n.csv
    python AndroidTAEnvironment/resources/scripts/augment_csv.py flowdroid_fossdroid_1way_replication_$n.csv AndroidTAEnvironment/tools/config/FlowDroid/flowdroid_1way.csv ./flowdroid_fossdroid_1way_replication_$n.csv
    python AndroidTAEnvironment/resources/scripts/augment_csv.py droidsafe_droidbench3_1way_replication_$n.csv AndroidTAEnvironment/tools/config/FlowDroid/flowdroid_1way.csv ./droidsafe_droidbench3_1way_replication_$n.csv
    python AndroidTAEnvironment/resources/scripts/augment_csv.py droidsafe_fossdroid_1way_replication_$n.csv AndroidTAEnvironment/tools/config/FlowDroid/flowdroid_1way.csv droidsafe_fossdroid_1way_replication_$n.csv 
    
    cd AndroidTAEnvironment/resources/checkmate
    python checkmate/validate.py flowdroid droidbench $INSTALLATION_LOCATION/flowdroid_droidbench3_1way_replication_$n.csv $INSTALLATION_LOCATION/flowdroid_droidbench3_violations_replication_$n.txt -j 1
        python checkmate/validate.py flowdroid fossdroid $INSTALLATION_LOCATION/flowdroid_fossdroid_1way_replication_$n.csv $INSTALLATION_LOCATION/flowdroid_fossdroid_violations_replication_$n.txt -j 1
    python checkmate/validate.py droidsafe droidbench $INSTALLATION_LOCATION/droidsafe_droidbench3_1way_replication_$n.csv $INSTALLATION_LOCATION/droidsafe_droidbench3_violations_replication_$n.txt -j 1
        python checkmate/validate.py droidsafe fossdroid $INSTALLATION_LOCATION/droidsafe_fossdroid_1way_replication_$n.csv $INSTALLATION_LOCATION/droidsafe_fossdroid_violations_replication_$n.txt -j 1
done
