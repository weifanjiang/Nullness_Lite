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
		 "The Nullness Checker")

# TODO add branches related to the Nullness Checker here
# NOTE: the order should match the order in CHECKER_NAME
NC_BRANCH_NAME=("annos_nl_all_xz"
		"annos_nl_init_xz"
		"annos_nl_inva_xz"
		"annos_nc_all_xz")

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

    if [ "${arr[0]}" = "NC_CHECKER_NAME" ]; then
        checkers=("${NC_CHECKER_NAME[@]}")
        branches=("${NC_BRANCH_NAME[@]}")
    fi

    # header
    for (( i=1; i<${#arr[@]}; i++))
    do
        appendResult "|${arr[$i]}"
    done
    appendResult "\n"
    
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

appendResult "Name of the Checker|Current Branch|Total Count"
printCheckerResult "NC_CHECKER_NAME" "@Nullable" "@UnderInitialization" "@UnknownInitialization"

#----------------------------Errors Analysis Report
appendResult "$SEP"
appendResult "\n"
appendResult "2. Analysis Report:"
appendResult "\n"

appendResult "Name of the Checker|Current Branch|Total Count"
printCheckerResult "NC_CHECKER_NAME" "TRUE_POSITIVE" "FALSE_POSITIVE"

#----------------------------END
echo "$SEP"
printf "Finish evaluation with JUnit4! \n"
cd ../
rm -rf junit4

# print the result
column -t -s "|" $RESULT
