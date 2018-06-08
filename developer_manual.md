# The Developer Manual for Nullness_Lite option
## Features in the Nullness_Lite option different from the Nullness Checker
1. Assume all values (fields & class variables) initialized
2. Assume all keys are in the map and `Map.get(key)` returns `@NonNull`
3. Assume no invalidation of dataflow
   - 3.1. Assume all methods are `@SideEffectFree` 
   - 3.2. Assume no aliasing
4. Assume the boxing of primitives return the same object and `BoxedClass.valueOf()` are `@Pure`

The implementation includes an additional command line argument `ANullnessLite` for the Nullness Checker and 4 values `ANullnessLite` option can accept for testing individual feature.

| Additional Command Line Arguments Allowed | Description |
|-|-|
|`-ANullnessLite`| all features in the Nullness_Lite is enabled |
|`-ANullnessLite=init`| feature 1 is enabled for testing purpose |
|`-ANullnessLite=mapk`| feature 2 is enabled for testing purpose |
|`-ANullnessLite=inva`| feature 3 is enabled for testing purpose |
|`-ANullnessLite=boxp`| feature 4 is enabled for testing purpose |

## Files changed in the Nullness Checker
Source file common path: [checker-framework/checker/src/main/java/org/checkerframework/checker/nullness/](https://github.com/979216944/checker-framework/tree/master/checker/src/main/java/org/checkerframework/checker/nullness)

|File Name|Changes Description|
|-|-|
|NullnessChecker.java|`ANullnessLite` option added; `initChecker()` overrided for features 1, 3.1 & 4|
|KeyForSubchecker.java|`ANullnessLite` option added|
|NullnessAnalysis.java|Instance variables `NO_ALIASING` and `ALL_KEY_EXIST` added as flags for feature 3.2 & 2|
|KeyForAnalysis.java|Instance variable `NO_ALIASING` added as a flag for feature 3.2|
|NullnessStore.java|Method `canAlias` overrided for feature 3.2|
|KeyForStore.java|Method `canAlias` overrided for feature 3.2|
|NullnessTransfer.java|Instance variable `ALL_KEY_EXIST` added as a flag and method `visitMethodInvocation` revised for feature 2|

See the source files for more details.

## Files added for testing
[issue 5](https://github.com/979216944/checker-framework/issues/5)

Test files common path: [checker-framework/checker/src/test/java/tests/](https://github.com/979216944/checker-framework/tree/master/checker/src/test/java)

Tests folders common path: [checker-framework/checker/tests/](https://github.com/979216944/checker-framework/tree/master/checker/tests)

|File Name| Folder Name | Description |
|-|-|-|
|NullnessLiteOptTest.java| nullness-liteoption/ |Initialize the spec. test for the Nullness_Lite|
|NullnessLiteOptInitTest.java| nullness-liteoption-init/ |Initialize the spec. test for feature 1|
|NullnessLiteOptMapkTest.java| nullness-liteoption-mapk/ |Initialize the spec. test for feature 2|
|NullnessLiteOptInvaTest.java| nullness-liteoption-inva/ |Initialize the spec. test for feature 3|
|NullnessLiteOptBoxpTest.java| nullness-liteoption-boxp/ |Initialize the spec. test for feature 4|
|NullnessLiteComRegTest.java| nullness-liteoption-comreg/ |Initialize the regression test of issue 5|
|NullnessLiteComRegBoxpTest.java| nullness-liteoption-comreg-boxp/ |Initialize the regression test pf issue 5 for feature 4|

To run these tests, we can pass the name without extention to `./gradlew` under the root folder of the Checker Framework.
(e.g. `./gradlew NullnessLiteOptTest`)
