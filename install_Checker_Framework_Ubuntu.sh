# Automate the installation of the Checker Framework on Ubuntu
#
# Author(s): XINRONG ZHAO


# set up environment
sudo apt-get update
sudo apt-get install --yes ant dia git hevea junit4 librsvg2-bin libcurl3-gnutls \
 make maven mercurial openjdk-8-jdk texlive-latex-base texlive-latex-recommended \
 texlive-latex-extra texlive-fonts-recommended unzip

# obtain the source
export JSR308=$(pwd)/jsr308
mkdir -p $JSR308
cd $JSR308
git clone https://github.com/979216944/checker-framework.git checker-framework

# set up JAVA_HOME
export JAVA_HOME=${JAVA_HOME:-$(dirname $(dirname $(dirname $(readlink -f $(/usr/bin/which java)))))}

# build Checker Framework
cd $JSR308/checker-framework
./gradlew cloneAndBuildDependencies
./gradlew assemble

# set javac path
export PATH=$JSR308/checker-framework/checker/bin:$JSR308/jsr308-langtools/dist/bin:${PATH}

# test the Checker Framework
./gradlew allTests
