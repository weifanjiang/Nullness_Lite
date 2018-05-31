# Automate the evaluation result on Ubuntu
#
# Author(s): XINRONG ZHAO

#----------------------------Variables & Helper Methods
RESULT=$(pwd)"/result.txt"
SEP="===================="
GET_BRANCH="git branch | grep \* | sed -r \"s/\* //g\""
GET_JAVA="find src/main | grep -e \"\.java$\""

# TODO add checkers related to the Nullness Checker here
NC_CHECKER_NAME=("Nullness_Lite Option"
		 "  Assume fields init"
		 "  No invalidation dataflow"
                 "  Assume map.get() return @NonNull"
                 "  Assume boxing of primitive is @Pure"
		 "The Nullness Checker")
NA_NC_NAME=("NullAway with the Nullness Checker Annos"
	    "NullAway with the Nullness_Lite Annos")
NA_IT_NAME=("NullAway with Infer Nullity")
INTELL_NAME=("IntelliJ without Infer Nullity"
	     "IntelliJ with Infer Nullity")
ECLIPSE_NAME=("Eclipse")
FINDBUGS_NAME=("FindBugs")

# TODO add branches related to the Nullness Checker here
# NOTE: the order should match the order in CHECKER_NAME
NC_BRANCH_NAME=("annos_nl_all"
		"annos_nl_init"
		"annos_nl_inva"
                "annos_nl_mapk"
		"annos_nl_boxp"
		"annos_nc_all")
NA_NC_BRANCH=("Nullaway_nc"
	      "Nullaway_nl")
NA_IT_BRANCH=("Nullaway_Intellij")
INTELL_BRANCH=("intellij1"
	       "intellij2")
ECLIPSE_BRANCH=("eclipse")
FINDBUGS_BRANCH=("findbugs") 

ANNOS_NAME=("@NotNull"
	    "@Nullable"
	    "@UnderInitialization"
	    "@UnknownInitialization")

countWord() {
    eval $GET_JAVA"| xargs grep -on \"$1\" | wc -l"
}

appendResult () {
    printf "$1" >> $RESULT
}

printCheckerResult() {
    arr=("$@")
    checkers=()
    branches=()

    if [ "${arr[0]}" = "NC_CHECKER_NAME" ]
    then
        checkers=("${NC_CHECKER_NAME[@]}")
        branches=("${NC_BRANCH_NAME[@]}")
    elif [ "${arr[0]}" = "NA_NC_NAME" ]
    then
        checkers=("${NA_NC_NAME[@]}")
        branches=("${NA_NC_BRANCH[@]}")
    elif [ "${arr[0]}" = "NA_IT_NAME" ]
    then
        checkers=("${NA_IT_NAME[@]}")
        branches=("${NA_IT_BRANCH[@]}")
    elif [ "${arr[0]}" = "INTELL_NAME" ]
    then
        checkers=("${INTELL_NAME[@]}")
        branches=("${INTELL_BRANCH[@]}")
    elif [ "${arr[0]}" = "ECLIPSE_NAME" ]
    then
        checkers=("${ECLIPSE_NAME[@]}")
        branches=("${ECLIPSE_BRANCH[@]}")
    else
        checkers=("${FINDBUGS_NAME[@]}")
        branches=("${FINDBUGS_BRANCH[@]}")
    fi
    
    index=0
    for i in "${checkers[@]}"
    do
        git checkout ${branches[$index]} > /dev/null 2>&1
	
        # compute
	total=0
	annosCount=()
        for (( j=1; j<${#arr[@]}; j++))
        do
	    count=$(countWord "${arr[$j]}")
            annosCount=( "${annosCount[@]}" $count)
	    total=$(( $total + $count ))
        done
	
        # result
        appendResult "$i|$(eval $GET_BRANCH)|$total|"
	for j in "${annosCount[@]}"
        do
            appendResult "|$j"
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

appendResult "$SEP"
appendResult "\n"
countSubject=1
appendResult "Experiment Subject #$countSubject:"
appendResult "\n"
appendResult "JUnit4"
appendResult "\n"

#----------------------------Annotations Added Report
appendResult "$SEP"
appendResult "\n"
appendResult "1. # of annotations:"
appendResult "\n"

appendResult "Name_of_the_Checker|Current_Branch|Total_Count"
for (( i=0; i<${#ANNOS_NAME[@]}; i++))
do
    appendResult "|${ANNOS_NAME[$i]}"
done
appendResult "\n"

printCheckerResult  "NC_CHECKER_NAME" "${ANNOS_NAME[@]}"
printCheckerResult  "NA_NC_NAME" "${ANNOS_NAME[@]}"
printCheckerResult  "NA_IT_NAME" "${ANNOS_NAME[@]}"
# printCheckerResult  "INTELL_NAME" "\\ changed"
printCheckerResult  "ECLIPSE_NAME" "${ANNOS_NAME[@]}"
printCheckerResult  "FINDBUGS_NAME" "${ANNOS_NAME[@]}"

#----------------------------Errors Analysis Report
appendResult "$SEP"
appendResult "\n"
appendResult "2. Analysis Report:"
appendResult "\n"

appendResult "Name_of_the_Checker|Current_Branch|Total_Count|TRUE_POSITIVE|FALSE_POSITIVE\n"
printCheckerResult "NC_CHECKER_NAME" "TRUE_POSITIVE" "FALSE_POSITIVE"
printCheckerResult "NA_NC_NAME" "\[TRUE_POSITIVE\]" "\[FALSE_POSITIVE\]"
printCheckerResult "NA_IT_NAME" "\[TRUE_POSITIVE\]" "\[FALSE_POSITIVE\]"
printCheckerResult "INTELL_NAME" "\[TRUE_POSITIVE\]" "\[FALSE_POSITIVE\]"
printCheckerResult "ECLIPSE_NAME" "\[TRUE_POSITIVE\]" "\[FALSE_POSITIVE\]"
printCheckerResult "FINDBUGS_NAME" "\[TRUE_POSITIVE\]" "\[FALSE_POSITIVE\]"

#----------------------------END
echo "$SEP"
printf "Finish evaluation with JUnit4! \n"
cd ../
rm -rf junit4

# print the result
column -t -s "|" $RESULT
