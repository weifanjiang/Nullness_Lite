# Automate the evaluation result on MAC

#----------------------------Variables & Helper Methods
RESULT=$(pwd)"/result.txt"
SEP="===================="
GET_BRANCH="git branch | grep \* | sed \"s/\* //g\""
GET_JAVA="find src/main | grep -e \"\.java$\""

# checkers related to the Nullness Checker
NC_CHECKER_NAME=("Nullness_Lite Option"
		 "  Assume fields init"
                 "  Assume map.get() return @NonNull"
		 "  No invalidation dataflow"
                 "  Assume boxing of primitive is @Pure"
		 "The Nullness Checker")
OTHER_CHECKER_NAME=("NullAway with Infer Nullity"
		    "NullAway with the Nullness Checker Annos"
	    	    "NullAway with the Nullness_Lite Annos"
		    "IntelliJ without Infer Nullity"
	     	    "IntelliJ with Infer Nullity"
		    "FindBugs"
		    "Eclipse")

# branches related to the Nullness Checker
# NOTE: the order should match the order in CHECKER_NAME
NC_BRANCH_NAME=("annos_nl_all"
		"annos_nl_init"
                "annos_nl_mapk"
		"annos_nl_inva"
		"annos_nl_boxp"
		"annos_nc_all")
OTHER_BRANCH_NAME=("Nullaway_Intellij"
		   "Nullaway_nc"
	           "Nullaway_nl"
		   "intellij1"
	           "intellij2"
		   "findbugs"
		   "eclipse")
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
    checkers=("${OTHER_CHECKER_NAME[@]}")
    branches=("${OTHER_BRANCH_NAME[@]}")

    if [ "${arr[0]}" = "NC_CHECKER_NAME" ]
    then
        checkers=("${NC_CHECKER_NAME[@]}")
        branches=("${NC_BRANCH_NAME[@]}")
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
        appendResult "$i|$(eval $GET_BRANCH)|$total"
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

appendResult "$SEP\n"
countSubject=1
appendResult "Experiment Subject #$countSubject:"
appendResult "\n"
appendResult "JUnit4\n"

#----------------------------Annotations Added Report
appendResult "$SEP\n"
appendResult "1. # of annotations:"
appendResult "\n"

head="Name_of_the_Checker|Current_Branch|Total_Count"
for (( i=0; i<${#ANNOS_NAME[@]}; i++))
do
    head=$head"|${ANNOS_NAME[$i]}"
done
appendResult "$head\n"

printCheckerResult  "NC_CHECKER_NAME" "${ANNOS_NAME[@]}"
printCheckerResult  "OTHER_CHECKER_NAME" "${ANNOS_NAME[@]}"

#----------------------------Errors Analysis Report
appendResult "$SEP\n"
appendResult "2. Analysis Report:"
appendResult "\n"

appendResult "Name_of_the_Checker|Current_Branch|Total_Count|TRUE_POSITIVE|FALSE_POSITIVE\n"
printCheckerResult "NC_CHECKER_NAME" "TRUE_POSITIVE" "FALSE_POSITIVE"
printCheckerResult "OTHER_CHECKER_NAME" "\[TRUE_POSITIVE\]" "\[FALSE_POSITIVE\]"

#----------------------------END
appendResult "$SEP\n"

echo "$SEP"
echo "Finish evaluation with JUnit4!"

echo "$SEP"
echo "Notes:"
echo "1. Annotations automatically added to the following checkers"
echo "   should not be recorded to the evaluation table:"
echo "   NullAway with Infer Nullity"
echo "   IntelliJ with Infer Nullity"
echo "$SEP"

cd ../
rm -rf junit4

# print the result
column -t -s "|" $RESULT
