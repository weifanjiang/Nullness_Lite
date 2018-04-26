# Nullness_Lite
Project repo: <href>https://github.com/979216944/checker-framework</href>

Developer Manual: <href>https://docs.google.com/document/d/1PdAhs2E3Gq6_NSS_xdYXR_6tvGGzHpNYdIC0kB0hDDE/edit</href>

## Introduction
Nullness_Lite is a lite type checker based on Nullness Checker of [Checker Framework](https://checkerframework.org/) to detect nullness bugs in java files. It disables the following features of Nullness Checker to trade more desireable traits with soundness.

Features being disabled:
* \[Initialization Checker\] suppress value uninitialized warnings;
* \[Map Key Checker\] suppress warnings considering key is not in Map for calls of Map.get(key);
* \[Invalidation of dataflow\] 
assume all methods are @SideEffectFree;
assume no aliasing;
* \[Boxing of primitives\] 
assume boxing of primitives @Pure so that BoxedClass.valueOf() always return the same object;

### Who wants to use?
Java developers who wants to avoid NullPointerException (NPE) at runtime, but hesitate to spend time running full verification tools like Nullness Checker.

They can run Nullenss_Lite instead to get a fast glimpse on their files and more concise reports, although with fewer true positives, with fewer false positive warnings.

### Compare with other nullness bug detectors (TODO: fill out the table)

|Checkers | True Positives Reported | True Positives Not Reported | False Positives | # of Annotations used | Speed|
|-|-|-|-|-|-|
|Nullness_Lite | | | | | |
|NullAway | | | | | |
|FindBugs | | | | | | 
|IntelliJ | | | | | | 
|Eclipse | | | | | | 
|Nullness Checker| | | | | |

A more specific comparison table for developers is included in the section 6 in [week4/report](/reports/week4/report.pdf).

The table above shows the benefits using Nullness Checker: (TODO: evaluate)
* fewer annotations for users to add

* fewer false positive warning
* more true positives revealed

## Download from distribution (TODO: complete this section)
1. Download the [Nullness_Lite distribution](\link to be filled!!!!)
2. Unzip it to create a checker-framework directory.
3. Configure your IDE, build system, or command shell to include the Checker Framework on the classpath. 

## Download from source code
### Set up environment
Since Nullness_Lite depends on Nullness Checker of Checker Framework, users need to follow the instructions of Checker Framework to setup their environments following the [instructions](https://checkerframework.org/manual/#build-source) in Checker Framework manual.

Note for CSEHome VM users: please follow the instruction of Ubuntu instead.

### Obtain source code
Replace the line for git clone by the following code.
```
git clone https://github.com/979216944/checker-framework checker-framework
```
### Build the Checker Framework
Before build and test, make sure the latest version of Nullness_Lite is obtained:

```
cd $JSR308/checker-framework
git checkout zhaox29-init-inva
```

To check the version on your computer:
```
git branch # which should show zhaox29-init-inva being selected
```

Following [instructions](https://checkerframework.org/manual/#build-source) of chapter 33.3.3 in Checker Framework manual.

### Run tests (optional)
#### Test all files in Checker Framework:
The process will possibly take long time on local machine, expecially on VM with insufficient memory allocated. (4G is suggested in this case.)

Besides, if Some jtreg tests may fail for timeout, those tests do not indicate bugs in Checker Framework or Nullness_Lite.
```
cd $JSR308/checker-framework
./gradlew allTests
```
#### Test Nullness_Lite:
This single tests will be fast to test whether Nullness_Lite behave as what we want:
```
cd $JSR308/checker-framework
./gradlew NullnessLiteOptTest
```

## Compile and run Nullness Checker
Follow the [instructions](https://checkerframework.org/manual/#running) of chapter 2.2 in Checker Framework manual.

Users run Nullness_Lite by passing an extra argument when running Nullness Checker from the command line:
```
javac -processor nullness -ANullnessLite <MyFile.java>
```
Notice that the behavior is undefined if `-ANullnessLite` option is passed to a different checker.

## Analyze the report (TODO: show an example for report analysis)

