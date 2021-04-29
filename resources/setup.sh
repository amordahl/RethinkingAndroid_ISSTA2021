#!/bin/bash

RESOURCES_HOME=./resources
export $RESOURCES_HOME
# Install software
echo "Installing software."
sudo apt update
yes | sudo apt install openjdk-8-jdk emacs curl git gcc g++ make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget llvm libncurses5-dev libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev python-openssl maven unzip ant

# Fix graphics packages
sudo apt install openjfx=8u161-b12-1ubuntu2 libopenjfx-jni=8u161-b12-1ubuntu2 libopenjfx-java=8u161-b12-1ubuntu2
sudo apt-mark hold openjfx libopenjfx-jni libopenjfx-java

# Set correct java version
sudo update-alternatives --set java /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java

# Get benchmark
tar xzf $RESOURCES_HOME/benchmark.tar.gz

# Get github repositories
git clone --recurse-submodules https://github.com/amordahl/AndroidTAEnvironment.git
cd AndroidTAEnvironment
git checkout ISSTA2021
cd ..

# Setup Android
mkdir Android
cd Android
wget https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip
unzip sdk-tools-linux-4333796.zip
cd tools
mkdir ~/.android
touch ~/.android/repositories.cfg
for n in {3..27}; do
    ./bin/sdkmanager "platforms;android-$n"
done

# Install pyenv
curl https://pyenv.run | bash
echo $RESOURCES_HOME/bashrc >> $HOME/.bashrc
source $HOME/.bashrc
pyenv install 3.8.0
pyenv global 3.8.0

# Build all components
# 1. Build BREW
cd ~
cd AndroidTAEnvironment/BREW
mvn -DskipTests install
# 1.1 Move Droidbench3 data.
cd target/build/data
cp $RESOURCES_HOME/data.ser .
# 1.2 Make storage directory so backup and reset doesn't fail.
mkdir storage
# 1.3. Move android jar.
cp $ANDROID_SDK_HOME/android-27/android.jar .

# 2. Build AQL
cd $ANDROID_TA_ENVIRONMENT_HOME/AQL-System
# 2.1 Make all of these directories to prevent exceptions
mkdir target/build/answers
mkdir target/build/queries
mkdir target/build/data/storage
mvn -DskipTests install
cd target/build
ln -s $ANDROID_TA_ENVIRONMENT_HOME/resources/scripts/runaql.py .
ln -s $ANDROID_TA_ENVIORNMENT_HOME/resources/scripts/run_aql.sh .
cd ../..
# 2.2. Copy scripts over
cp $RESOURCES_HOME/flushMemory.sh $RESOURCES_HOME/killpid.sh .
chmod +x ./*.sh

# 3. Build Flowdroid
cd ../tools/FlowDroid
mvn -DskipTests install
# 3.1 Copy python script that fixes output for AQL.
cp $ANDROID_TA_ENVIRONMENT_HOME/resources/manipulateOutput.py ./soot-infoflow-cmd/target/

# 4. Build Droidsafe
cd ../DroidSafe/droidsafe-src
ant compile
cd ~
