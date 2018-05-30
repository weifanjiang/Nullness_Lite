# Automate the evaluation result on Ubuntu
#
# Author(s): XINRONG ZHAO

#----------------------------Variables & Helper Methods
RESULT=$(pwd)"/result.txt"
SEP="--------------------"
GET_BRANCH="git branch | grep \* | sed -r \"s/\* //g\""
GET_JAVA="find src/main | grep -e \"\.java$\""

# add other checkers here
declare -a NC_CHECKER_NAME=("Nullness_Lite Option"
			    "--Assume fields init"
			    "--No invalidation dataflow"
			    "The Nullness Checker")
# add other checkers branch here
# NOTE: the order should match the order in CHECKER_NAME
declare -a NC_BRANCH_NAME=("annos_nl_all_xz"
			   "annos_nl_init_xz"
			   "annos_nl_inva_xz"
			   "annos_nc_all_xz")

countWord() {
    eval $GET_JAVA"| xargs grep -on \"$1\" | wc -l"
}

appendResult () {
    printf $1 >> $RESULT
}

printCheckerResult() {
    checkers="$2"
    branches="$3"
    annos="$4"
    
    appendResult "$1" # print head
    for i in "${annos[@]}"
    do
        appendResult "$i|"
    done
    appendResult "\n"
    
    index=0
    for i in "${checkers[@]}"
    do
        git checkout ${branches[$index]} > /dev/null 2>&1
	
	total=0
	annosCount=()
        for i in "${annos[@]}"
        do
	    count=$(countWord "$i")
            annosCount+=($count)
	    total=$(( $total + $count ))
        done
	
        appendResult "$i|$(eval $GET_BRANCH)|$total|"
	for i in "${annosCount[@]}"
        do
            appendResult "$i|"
        done
        appendResult "\n"
        
        index=$(( $index + 1 ))
    done
}

#----------------------------Fetch Source Code

echo "Generating results in $RESULT"
printf "$(date +%Y-%m-%d)\n" > $RESULT

rm -rf junit4/
git clone https://github.com/NullnessLiteGroup/junit4.git junit4
cd junit4

appendResult $SEP
countSubject=1
appendResult "Experiment Subject #$countSubject:"
appendResult "JUnit4"

#----------------------------Annotations Added Report
appendResult $SEP
appendResult "1. # of annotations:\n"

head="Name of the Checker|Current Branch|Total Count|"
declare -a annos=("@Nullable"
		  "@UnderInitialization"
		  "@UnknownInitialization")
printCheckerResult $head $NC_CHECKER_NAME $NC_BRANCH_NAME $annos

#----------------------------Errors Analysis Report
appendResult $SEP
appendResult "2. Analysis Report:"
appendResult "Name of the Checker|Current Branch|True Positives|False Positives"

count=0
for i in "${CHECKER_NAME[@]}"
do
    git checkout ${BRANCH_NAME[$count]} > /dev/null 2>&1
    appendResult "$i|$(eval $GET_BRANCH)|$(countWord "TRUE_POSITIVE")|$(countWord "FALSE_POSITIVE")"
    count=$(( $count + 1 ))
done

#----------------------------END
echo $SEP
printf "Finish evaluation with JUnit4! \n"
cd ../
rm -rf junit4

# print the result
column -t -s "|" $RESULT
