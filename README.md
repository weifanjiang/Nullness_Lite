# Nullness_Lite

Project repo: <href>https://github.com/979216944/checker-framework</href>

## Introduction
Nullness_Lite is a lite type checker based on Nullness Checker of [Checker Framework](https://checkerframework.org/) to detect nullness bugs in java files. It disables the following features of Nullness Checker to trade more desireable traits with soundness.

Features being disabled:
* Initialization Checker
* Map Key Checker
* Invalidation of dataflow

### Who wants to use?
Java developers who wants to avoid NullPointerException (NPE) at runtime, but hesitate to spend time running full verification tools like Nullness Checker.

They can run Nullenss_Lite instead to get a fast glimpse on their files and more concise reports, although with fewer true positives, with fewer false positive warnings.

## Dependency: 
- Checker Framework: 
<href>https://checkerframework.org</href>

## Installation
For details: <href>https://checkerframework.org/manual/#installation</href>
1. Download the Checker Framework distribution: https://checkerframework.org/checker-framework-2.5.0.zip
2. Unzip it to create a checker-framework directory.
3. Configure your IDE, build system, or command shell to include the Checker Framework on the classpath. 

## Build
For details: <href>https://checkerframework.org/manual/#build-source</href>
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
For details: <href>https://checkerframework.org/manual/#running</href>

To run a checker plugin, run the compiler javac as usual, but pass the -processor plugin_class command-line option. A concrete example (using the Nullness Checker) is:
```
javac -processor nullness -ANullnessLite MyFile.java
```
