# Automate the evaluation result on Ubuntu
#
# Author(s): XINRONG ZHAO

RESULT=$(pwd)"/result.txt"

SEP="-------------------------------------------------"
GET_BRANCH="git branch | grep \* | sed -r \"s/\*//g\""
GET_JAVA="find src/main | grep -e \"\.java$\""

COUNT_NULLABLE=$GET_JAVA"| xargs grep -on \"@Nullable\" | wc -l"
COUNT_NULLABLE=$GET_JAVA"| xargs grep -on \"@UnderInitialization\" | wc -l"
COUNT_NULLABLE=$GET_JAVA"| xargs grep -on \"@UnknownInitialization\" | wc -l"
COUNT_TRUE_POS=$GET_JAVA"| xargs grep -on \"TRUE_POSITIVE\" | wc -l"
COUNT_FALSE_POS=$GET_JAVA"| xargs grep -on \"FALSE_POSITIVE\" | wc -l"

NULLNESS_CHECKER=analysis_3_nc_yk_xz # TODO update

echo "Generating results in $RESULT"
printf "Path: $RESULT\n\n" > $RESULT

appendResult () {
    echo $1 >> $RESULT
}

rm -rf junit4/
git clone https://github.com/NullnessLiteGroup/junit4.git junit4
cd junit4

appendResult $SEP
appendResult "Experiment Subject #1: Junit4"

appendResult $SEP
appendResult "1. # of annotations used:"
appendResult "Name of the Checker|Current Branch|@Nullable"

git checkout $NULLNESS_CHECKER > /dev/null 2>&1
git checkout fd33c3b > /dev/null 2>&1
appendResult "The Nullness Checker|$(eval $GET_BRANCH)|$(eval $COUNT_NULLABLE)"

appendResult $SEP
appendResult "2. Analysis Report:"
appendResult "Name of the Checker|Current Branch|True Positives|False Positives"

git checkout $NULLNESS_CHECKER > /dev/null 2>&1
git checkout fd33c3b > /dev/null 2>&1
appendResult "The Nullness Checker|$(eval $GET_BRANCH)|$(eval $COUNT_TRUE_POS)|$(eval $COUNT_FALSE_POS)"

echo $SEP
printf "Finish evaluation with JUnit4! \n"
cd ../
rm -rf junit4

# print the result
column -t -s "|" $RESULT
