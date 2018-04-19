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

### Compare with other checkers

|Checkers | Features | True Positives Reported | True Positives Not Reported | False Positives | # of Annotations used | Speed|
|-|-|-|-|-|-|-|
|Nullness_Lite | with no Initialization Checkers | | | | | |
| | with no Initialization Checkers | | | | | |
| | with no Map Key Checkers | | | | | |
| | with no Invalidation of dataflow | | | | | |
| | assuming boxing of primitive is @Pure | | | | | |
|NullAway | | | | | | |
|FindBugs | | | | | | |
|IntelliJ | | | | | | |
|Eclipse | | | | | | |

## Download from distribution
1. Download the [Nullness_Lite distribution](\link to be filled!!!!)
2. Unzip it to create a checker-framework directory.
3. Configure your IDE, build system, or command shell to include the Checker Framework on the classpath. 

## Download from source code
### Set up environment
Since Nullness_Lite depends on Nullness Checker of Checker Framework, users need to follow the instructions of Checker Framework to setup their environments following the [instructions](https://checkerframework.org/manual/#build-source) in Checker Framework manual.

### Obtain source code
Replace the line for git clone by the following code.
```
git clone https://github.com/979216944/checker-framework checker-framework
```

### Build the Checker Framework
Following [instructions](https://checkerframework.org/manual/#build-source) of chapter 33.3.3 in Checker Framework manual.

### Run tests (optional)
Test that everything works:
```
cd $JSR308/checker-framework
./gradlew allTests
```

## Compile
For details: <href>https://checkerframework.org/manual/#running</href>

To run a checker plugin, run the compiler javac as usual, but pass the -processor plugin_class command-line option. A concrete example (using the Nullness Checker) is:
```
javac -processor nullness -ANullnessLite MyFile.java
```
