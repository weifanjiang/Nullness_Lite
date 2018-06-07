# Nullness_Lite: An Unsound Option of the Nullness Checker for fewer false positives
See the implementation in https://github.com/979216944/checker-framework

See the evaluation in https://github.com/NullnessLiteGroup/junit4

Refer to `../manual.pdf` and `../manual.html#nullness-lite` for Nullness_Lite User Manual (Section 3.7) as a part of the Checker Framework User Manual.

<!---
Developer Manual: (Link to the changed developer manual)
--->

## Introduction
Nullness_Lite is a lite option of the Nullness Checker in [the Checker Framework](https://checkerframework.org/) to detect nullness bugs in java source files. It disables the following features of Nullness Checker to obtain more desireable traits. To be specific, the Nullness Checker with Nullness_Lite option enabled will be faster and easier to use by delibrately giving up soundness.

|Featrue Disabled|Substitute Behavior of the Nullness_Lite option|
|-|-|
| Initialization Checker | Assume all values (fields & class variables) initialized |
| Map Key Checker | Assume all keys are in the map and `Map.get(key)` returns `@NonNull` |
| Invalidation of dataflow | Assume no aliasing and all methods are `@SideEffectFree` |
| Boxing of primitives | Assume the boxing of primitives return the same object  and `BoxedClass.valueOf()` are `@Pure` |

### Who wants to use Nullness_Lite option?
Java developers who would like to get a trustable analysis on their source files, but hesitate to spend time running full verification tool such as Nullness Checker. They can run the Nullenss_Lite option instead to get a fast glimpse on their files before they upgrade to the Nullness Checker.

## Evaluation
Please see the week9/report for the evaluation methodology we decided.

The project we evaluate on: [JUnit4](https://github.com/junit-team/junit4)

|Checkers | True Positives Detected | True Positives Not Detected | False Positives | Annotations Added |
|-|-|-|-|-|
|Nullness_Lite |18|0|86|304|
|Nullness Checker|18|0|95|307|
|NullAway (Infer Nullity) |3|15|1|1285|
|NullAway (Nullness Checker's annotations) |3|15|0|307| 
|NullAway (NullnessLite's annotations) |3|15|0|304| 
|IntelliJ1 |0|18|1|0| 
|IntelliJ2 (Infer Nullity) |3|15|77|15*|
|FindBugs |0|18|0|0| 
|Eclipse |0|18|3|0|

\* Since we are evaluating junit4 based on the annotations added by IntelliJ's Infer Nullity, 15 is the number of annotations we changed rather than added. The number of annotations added by Infer Nullity is 1116. 

### To reproduce the evaluation result, please see the instruction in the section for reproduction in this Manual (scroll down).
### Analysis for the Table Above
![title](https://github.com/weifanjiang/Nullness_Lite/blob/master/images/figure%207.PNG)

We chose the Nullness Checker to be our ground truth because it is a sound type system for detecting the nullness bugs. Note the set of true positives the Nullness Checker reveals should be the super set of the sets of true positives by any other nullness bug detectors. Also note JUnit4 is a special case where the Nullness_Lite option reveals all 18 true positives (real bugs) even though it is unsound.

As we can see from the graph, the Nullness_Lite option shows a positive result on JUnit4. It requires fewer annotations and reports fewer false positives than the Nullness Checker. The result supported our goal for the Nullness_Lite to provide a upgrade path to graduate to the Nullness Checker.

Our evlauation result doesn't imply that one checker is definitely better than others. Users should choose the tool that fit their situtations best.

<!----
## Installation 1 - 
One way for installation is to download 
---->

## Installation - Build from Source Code
<!----
Ubuntu users can simply copy-paste the following commands to download the Checker Framework with the Nullness_Lite Option.
```
git clone https://github.com/weifanjiang/Nullness_Lite.git Nullness_Lite
cd Nullness_Lite
./install_Checker_Framework_Ubuntu.sh 
```
---->
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
Please follow the instructions for installation first. To compile the Nullness Checker, please follow the instructions in chapter 2.2 in Checker Framework [manual](https://checkerframework.org/manual/#running).

Users run Nullness_Lite by passing an extra argument when running Nullness Checker from the command line:
```
javac -processor nullness -ANullnessLite <MyFile.java>
```
Notice that the behavior is undefined if `-ANullnessLite` option is passed to a different checker.

## How to Reproduce the Evaluation Results?
To reproduce the Evaluation Table, run the following commands from terminal:
```
git clone https://github.com/weifanjiang/Nullness_Lite.git Nullness_Lite
cd Nullness_Lite

# mac users should replace the run_evaluation.sh to run_evaluation_mac.sh
chmod +x run_evaluation.sh 
./run_evaluation.sh
```
We provided most true positives with code examples running in JUnit, where the expected output of each test is an NPE.

The code examples are under `eval_test` folder in the branch `annos_nc_all`. Or you can run the following commands to test these true positives:
```
git clone https://github.com/NullnessLiteGroup/junit4/ junit4
cd junit4
git checkout annos_nc_all
cd eval_test

javac -cp ".:./junit-4.12.jar:../lib/hamcrest-core-1.3.jar" TruePositiveTest.java
java -cp ".:./junit-4.12.jar:../lib/hamcrest-core-1.3.jar" org.junit.runner.JUnitCore TruePositiveTest
```

## Additional Infomation for Evaluation: The Error Report Reproduction
### Nullness Checker, Nullness_Lite & individual feature
Please follow the instructions for installation to setup `javac` path correctly. 

The list of branches for the Nullnes Chekcer and the Nullness_Lite option: See [Note from NullnessLiteGroup](https://github.com/NullnessLiteGroup/junit4/blob/master/README.md)

To reproduce error reports, run the following commands from terminal:
```
git clone https://github.com/NullnessLiteGroup/junit4/ junit4
cd junit4
git checkout annos_nc_all # for the Nullness Checker
# git checkout annos_nl_all for the Nullness_Lite option
# or checkout with branches for individual features from the link above

find src/main | grep -e "\.java$" | xargs javac -cp "lib/hamcrest-all-1.3.jar" -processor nullness -Astubs=stubs -Xmaxerrs 1000
```
Pass `-ANullnessLite` to report errors with the Nullness_Lite option.
   
### IntelliJ (branch "intellij1")
1. download and install IntelliJ on your local machine if you don't have one yet
2. choose a workspace from your machine, move under it, and then run the following commands:
```
   $ git clone https://github.com/NullnessLiteGroup/junit4.git
   $ cd junit4
   $ git checkout intellij1
```
3. open IntelliJ and import junit4 into IntelliJ as a maven project (leave the import settings as default) (you may need to select jdk)
4.   
   choose Analyze > Inspect Code... <br /> from the main menu
   uncheck "Include test sources" and select ... under "Inspection profile" <br />
   <img src="https://github.com/weifanjiang/Nullness_Lite/blob/master/images/intellij_step1.png" width="300" height="180" /><br />
   import project settings by clicking on the "gear" icon and then click "Import Profile..." in the image below <br />
   <img src="https://github.com/weifanjiang/Nullness_Lite/blob/master/images/intellij_step2.png" width="300" height="220" /><br />
   select Project_Default.xml from junit4 directory <br />
   <img src="https://github.com/weifanjiang/Nullness_Lite/blob/master/images/intellij_step3.png" width="300" height="230" /> 
   select "OK" to apply the changes and inspect code
   
5. The inspection result will show only 1 error, and we've classified it as a false positive and have left our reasoning in the source code for the client to check. Click on the error from the "Inspection Result", and you will see it.

### IntelliJ (branch "intellij2")
(The screenshots above are taken from IntelliJ IDEA 2018.1.2 Community Edition.)

1. download and install IntelliJ on your local machine if you don't have one yet
2. choose a workspace from your machine, move under it, and then run the following commands:
```
   $ git clone https://github.com/NullnessLiteGroup/junit4.git
   $ cd junit4
   $ git checkout intellij2
```
3. open IntelliJ and import junit4 into IntelliJ as a maven project (leave the import settings as default) (you may need to select jdk for IntelliJ)
4.   
   choose Analyze > Inspect Code... <br />
   <br />
   uncheck "Include test sources" and select ... under "Inspection profile" <br />
   <img src="https://github.com/weifanjiang/Nullness_Lite/blob/master/images/intellij_step1.png" width="300" height="180" />
   <br />
   import project settings by clicking on the "gear" icon and then click "Import Profile..." in the image below <br />
   <img src="https://github.com/weifanjiang/Nullness_Lite/blob/master/images/intellij_step2.png" width="300" height="220" />
   <br />
   select Project_Default.xml from junit4 directory <br />
   <img src="https://github.com/weifanjiang/Nullness_Lite/blob/master/images/intellij_step3.png" width="300" height="230" />
   <br />
   <br />select "OK" to apply the changes and inspect code <br />
   
5. The inspection result will show 80 errors. Click on each error shown in the "Inspection Results" at the lower left corner, you will see our reasoning.

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

### FindBugs
1. Download and install [FindBugs](http://findbugs.sourceforge.net/downloads.html)

2. Have JDK 1.5.0 or later installed on your computer

3. Extract the directory findbugs-3.0.1, then go to findbugs-3.0.1/lib. Double click findbugs.

4 Click File > New Project. Add the project to the first box (Classpath for analysis), and add the class archive files to the second box (Auxillary classpath)

5. Click Analyze

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

## Frequently Asked Questions
#### 1. What if I got the following result when running the Checker Framework?
```
error: Annotation processor 'nullness' not found
1 error
```
Try `which javac` to see whether your path for javac is in `$JSR308/checker-framework/checker/bin/javac` and change if not.
You can follow the [instruction](https://checkerframework.org/manual/#build-source) in section 33.3.2 and 33.3.3 to set up path for javac.
