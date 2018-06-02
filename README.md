# Nullness_Lite: An Unsound Option of the Nullness Checker for fewer false positives
See the implementation in https://github.com/979216944/checker-framework

See the evaluation in https://github.com/NullnessLiteGroup/junit4

<!---Developer Manual: (Link to the changed developer manual)--->

## Introduction
Nullness_Lite is a lite option of the Nullness Checker in [the Checker Framework](https://checkerframework.org/) to detect nullness bugs in java source files. It disables the following features of Nullness Checker to obtain more desireable traits. To be specific, the Nullness Checker with Nullness_Lite option enabled will be faster and easier to use by delibrately giving up soundness.

|Featrue Disabled|Substitute Behavior of the Nullness_Lite option|
|-|-|
| Initialization Checker | Assume all values (fields & class variables) initialized |
| Map Key Checker | Assume all keys are in the map and `Map.get(key)` returns `@NonNull` |
| Invalidation of dataflow | Assume all methods are `@SideEffectFree` and disallow aliasing |
| Boxing of primitives | Assume the boxing of primitives is `@Pure` and `BoxedClass.valueOf()` always return the same object|

### Who wants to use Nullness_Lite option?
Java developers who would like to get a trustable analysis on their source files, but hesitate to spend time running full verification tool such as Nullness Checker. They can run the Nullenss_Lite option instead to get a fast glimpse on their files and more concise reports, although with fewer true positives, with fewer false positive warnings.

## Evaluation
Please see the week9/report for the evaluation methodology we decided.

The project we evaluate on: [JUnit4](https://github.com/junit-team/junit4)

|Checkers | True Positives Detected | True Positives Not Detected | False Positives | Annotations Used |
|-|-|-|-|-|
|Nullness_Lite |20|0|80|318|
|NullAway (Infer Nullity) |3 |17|1 | 1160|
|NullAway (Nullness Checker's annotations) |3|17|0|319| 
|NullAway (NullnessLite's annotations) |3|17|0|318| 
|FindBugs |0|20|0|0| 
|IntelliJ1 |0|20|1|0| 
|IntelliJ2 (Infer Nullity) |4|16|76|changed: 16| 
|Eclipse |0|20|3|0|
|Nullness Checker|20|0|95|319|

### To reproduce the evaluation result, please see the instruction in the section for reproduction in this Manual (scroll down).
### Analysis for the Table Above
The reason we put the Nullness Checker in the last row is that we want our users to focus more on the comparison between the Nullness_Lite option and the other nullness bug detectors. Note that the Nullness Checker is a sound type system, the set of true positives it reveals should be the super set of the sets of true positives by any other nullness bug detectors. From our evaluation result, we can see the Nullness_Lite option reports all 20 true positives, which is good for JUnit4. But we should be aware that the Nullness_Lite option could suppress some true positives reported by the Nullness Checker in other projects. After all, the Nullness_Lite option is a unsound nullness bug detector by suppressing features within the Nullness Checker. 

Here is a true/false positive graph for comparing the checkers.

![title](https://github.com/weifanjiang/Nullness_Lite/blob/master/images/figure%207.PNG)

Our evlauation result doesn't imply that one checker is definitely better than others. Users should choose the tool that fit their situtations best. For example, the Nullness Checker is best when users value a good verification over the time consumed. The other bug detectors are good in the reverse situation. The Nullness_Lite option is in the middle ground of the two situations. Depending on the project, it could potentially reveal more true positives than other nullness bug detectors. But users should be aware that although the Nullness_Lite option can filter out some false positives, the amount of the remaining false positives could still be larger than that of other nullness bug detectors.

## Build from Source Code
Ubuntu users can simply copy-paste the following commands to download the Checker Framework with the Nullness_Lite Option.
```
git clone https://github.com/weifanjiang/Nullness_Lite.git Nullness_Lite
cd Nullness_Lite
./install_Checker_Framework_Ubuntu.sh 
```
### Set up Environment
Since Nullness_Lite depends on Nullness Checker of Checker Framework, users need to follow the instructions of Checker Framework to setup their environments following the [instructions](https://checkerframework.org/manual/#build-source) in Checker Framework manual.

Note for Windows users: Plase download VMware and follow the Ubuntu instructions.

### Obtain Source Code
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

### Run Tests
#### Test All Files in Checker Framework:
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

## How to use the Nullness_Lite?
Please follow the instructions in section "Build from Source Code" to download the Checker Framework first.

To compile the Nullness Checker, please follow the instructions in chapter 2.2 in Checker Framework [manual](https://checkerframework.org/manual/#running).

Users run Nullness_Lite by passing an extra argument when running Nullness Checker from the command line:
```
javac -processor nullness -ANullnessLite <MyFile.java>
```
Notice that the behavior is undefined if `-ANullnessLite` option is passed to a different checker.

## How to Analyze A Report?
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
To be specific, the Nullness Checker with `-ANullnessLite` option reported one error, which is in line 7 of MyJavaFile.java, where we dereference `this.f` in the constructor before initializing it.

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
Since we manually cast the field `this.f` to @NonNull, now Nullness Checker with `-ANullnessLite` option will not issue any error.

## How to Reproduce the Evaluation Results?
### Nullness Checker, Nullness_Lite & each feature to be tested
For ubuntu users, run the following commands in terminal:
```
git clone https://github.com/weifanjiang/Nullness_Lite.git Nullness_Lite
cd Nullness_Lite
chmod +x run_evaluation.sh
./run_evaluation.sh
```
### Eclipse
1. download and install Eclipse on your local machine if you don't have one yet

2. open Eclipse and create a workspace under directory your_workspace

3. move under your_workspace and run the following commands:
```
   $ git clone https://github.com/NullnessLiteGroup/junit4.git
   $ cd junit4
   $ git checkout eclipse
```
4. in Eclipse, import junit4 into your workspace:
```
   choose File > Import... > Maven > Existing Maven Projects from the main menu
   choose the root directory to be your_workspace/junit4
   Finish
```   
   since we've included a .setting directory in branch "eclipse", junit4 will build under our null-related settings 

5. After Eclipse builds junit4, it will show 3 null-related errors. 
   We've examined that all the 3 errors are false positives, and have attached our reasoning in comment blocks.
   If you click on each error, you will see the reasoning.
   
### FindBugs
1. Download and install [FindBugs](http://findbugs.sourceforge.net/downloads.html)

2. Have JDK 1.5.0 or later installed on your computer

3. Extract the directory findbugs-3.0.1, then go to findbugs-3.0.1/lib. Double click findbugs.

4 Click File > New Project. Add the project to the first box (Classpath for analysis), and add the class archive files to the second box (Auxillary classpath)

5. Click Analyze
   
### IntelliJ (without "Infer Nullity" before it runs code inspection)
1. download and install IntelliJ on your local machine if you don't have one yet
2. choose a workspace from your machine, move under it, and then run the following commands:
```
   $ git clone https://github.com/NullnessLiteGroup/junit4.git
   $ cd junit4
   $ git checkout intellij1
```
3. open IntelliJ, import junit4 into IntelliJ as a maven project (leave the import settings as default) (you may need to select jdk for IntelliJ)
4. ```
      choose Analyze > Inspect Code... 
      uncheck "Include test sources" 
      select ... under "Inspection profile"
   ```
      ![title](https://ibb.co/hroPDJ)
   ```
      Import Profile...
   ```
      ![title](https://ibb.co/jZXUfy)
   ```
      select Project_Default.xml from junit4 directory
   ```
      ![title](https://ibb.co/nfT20y)
   
5. It will show only 1 error, and we've classified it as a false positive and have left our reasoning in the source code for the client to check. Click on the error from the "Inspection Result", and you will see it.

### Nullaway (using annotations added by IntelliJ's "Infer Nullity")
Run the following command
```
$ git clone -b Nullaway_Intellij https://github.com/NullnessLiteGroup/junit4.git
$ cd junit4
$ mvn clean compile -P nullaway
```

### Nullaway (using annotations required by Nullness Checker)
Run the following command
```
$ git clone -b Nullaway_nc https://github.com/NullnessLiteGroup/junit4.git
$ cd junit4
$ mvn clean compile -P nullaway
```

### Nullaway (using annotations required by NullnessLite)
Run the following command
```
$ git clone -b Nullaway_nl https://github.com/NullnessLiteGroup/junit4.git
$ cd junit4
$ mvn clean compile -P nullaway
```

## Frequently Asked Questions
#### 1. What if I got the following result when running the Checker Framework?
```
error: Annotation processor 'nullness' not found
1 error
```
Try `which javac` to see whether your path for javac is in `$JSR308/checker-framework/checker/bin/javac` and change if not.
You can follow the [instruction](https://checkerframework.org/manual/#build-source) in section 33.3.2 and 33.3.3 to set up path for javac.
