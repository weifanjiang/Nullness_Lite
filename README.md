# Nullness_Lite
Repo of the implementation: https://github.com/979216944/checker-framework

Developer Manual: (Link to the changed developer manual)

## Introduction
Nullness_Lite is a lite option of the Nullness Checker in [the Checker Framework](https://checkerframework.org/) to detect nullness bugs in java source files. It disables the following features of Nullness Checker to obtain more desireable traits. To be specific, the Nullness Checker with Nullness_Lite option enabled will be faster and easier to use by delibrately giving up soundness.

Features disabled:
* Initialization Checker
  * suppress value uninitialized warnings;
* Map Key Checker
  * assume all keys are in the map and Map.get(key) returns @NonNull;
* Invalidation of dataflow 
  * assume all methods are @SideEffectFree;
  * assume no aliasing;
* Boxing of primitives 
  * assume the boxing of primitives is @Pure and BoxedClass.valueOf() always return the same object;

### Who wants to use?
Java developers who would like to get a trustable static analysis on their source files, but hesitate to spend time running full verification tool such as Nullness Checker.

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

A more specific comparison table for developers is included in the section 4 in [week5/report](/reports/week5/Nullness_Lite--A%20lite%20option%20of%20the%20Nullness%20Checker.pdf).

The table above shows the benefits using Nullness Checker: (TODO: evaluate)
* fewer annotations for users to add
* fewer false positive warning
* more true positives revealed

## Build from source code
### Set up environment
Since Nullness_Lite depends on Nullness Checker of Checker Framework, users need to follow the instructions of Checker Framework to setup their environments following the [instructions](https://checkerframework.org/manual/#build-source) in Checker Framework manual.

Note for Windows users: Plase download VMware and follow the Ubuntu instructions.

### Obtain source code
Obtain the latest source code from the version control repository:

```
export JSR308=$HOME/jsr308
mkdir -p $JSR308
cd $JSR308
git clone https://github.com/979216944/checker-framework checker-framework
```
You might want to add the `export JSR308=$HOME/jsr308` line to your `.bashrc` file.

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

For Build, following [instructions](https://checkerframework.org/manual/#build-source) of chapter 33.3.3 in Checker Framework manual.

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

### Run tests (optional)
#### Test all files in Checker Framework:
The process will possibly take long time on local machine, expecially on VM with insufficient memory allocated. (4G is suggested in this case.)

Besides, if Some jtreg tests fail for timeout, those tests do not indicate bugs in Checker Framework or Nullness_Lite.
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

## Analyze the report
Here is the example code we want to test:
```java
import org.checkerframework.checker.nullness.qual.NonNull;

public class MyJavaFile {
    private @NonNull Object f;

    public MyJavaFile(int x, int y) { }
    public MyJavaFile(int x) { this.f.toString(); }
}
```
Run `javac -processor nullness -ANullnessLite MyJavaFile.java` to test it with Nullness_Lite option.

Then we get the following report:
```
MyJavaFile.java:7: error: [dereference.of.nullable] dereference of possibly-null reference this.f
    public MyJavaFile(int x) { this.f.toString(); }
                                   ^
1 error
```
To be specific, the Nullness Checker with -ANullnessLite option reported one error, which is in line 7 of MyJavaFile.java, where we dereference `this.f` in the constructor before initializing it.

An error is either a true positive (indicating a real bug) or a false positive.

Developers can fix the errors by fixing the actual bugs if the errors are true positives.

They can fix the errors of false positives by suppressing these errors. It is not suggested but sometimes developers can also suppress true positives. Back to the example, we can change the source code like the following:
```java
import org.checkerframework.checker.nullness.qual.NonNull;
import org.checkerframework.checker.nullness.NullnessUtil;

public class MyJavaFile {
    private @NonNull Object f;

    public MyJavaFile(int x, int y) { }
    public MyJavaFile(int x) { NullnessUtil.castNonNull(this.f).toString(); }
}
```
Since we manually cast the field `this.f` to @NonNull, now Nullness Checker with -ANullnessLite option will not issue any error.

## Frequently Asked Questions
#### 1. If I got the following result when running the Checker Framework?
```
error: Annotation processor 'nullness' not found
1 error
```
Try `which javac` to see whether your path for javac is in `$JSR308/checker-framework/checker/bin/javac` and change if not.
You can follow the [instruction](https://checkerframework.org/manual/#build-source) in section 33.3.2 and 33.3.3 to set up path for javac.
