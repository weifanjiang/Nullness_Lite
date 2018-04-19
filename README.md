# Nullness_Lite

Project repo: <href>https://github.com/979216944/checker-framework</href>


## Dependency: 
- Checker Framework: 
<href>https://checkerframework.org</href>

## Installation
<href>https://checkerframework.org/manual/#installation</href>
1. Download the Checker Framework distribution: https://checkerframework.org/checker-framework-2.5.0.zip
2. Unzip it to create a checker-framework directory.
3. Configure your IDE, build system, or command shell to include the Checker Framework on the classpath. 

## Build
<href>https://checkerframework.org/manual/#build-source</href>
1. build the Checker Framework dependencies  
```
cd $JSR308/checker-framework
./gradlew cloneAndBuildDependencies
```

2. build the Checker Framework : 
```
cd $JSR308/checker-framework
./gradlew assemble
```

## Test
Test that everything works:
```
cd $JSR308/checker-framework
./gradlew allTests
```

## Run
https://checkerframework.org/manual/#running
To run a checker plugin, run the compiler javac as usual, but pass the -processor plugin_class command-line option. A concrete example (using the Nullness Checker) is:
```
javac -processor nullness -ANullnessLite MyFile.java
```
