export FILE_PATH=...

IDX=$1
START_IDX=$((715*($IDX-1)))
END_IDX=$(((715*$IDX)-1))
for NUM in $(eval echo "{$START_IDX..$END_IDX}")
    do
    for SPLIT in "train" "validation"
        do
        FILE_NAME="${FILE_PATH}co-occurance-each-step/step_${NUM}_qa_co_occurrence_split=${SPLIT}.json"
        if [ -f $FILE_NAME ]; then
            echo "exists, ${FILE_NAME}"
        else
            echo "Does not exist, ${FILE_NAME}"
            python relevant_docs/count_relevant_docs.py  \
                "${FILE_PATH}trivia_qa/trivia_qa_unfiltered.nocontext_${SPLIT}_entities.jsonl" \
                "${FILE_PATH}entity-each-step/step_${NUM}_json_entity_map.npz" \
                "${FILE_PATH}co-occurance-each-step/" \
                --qa_split ${SPLIT} \
                --type qa_co_occurrence \
                --output_prefix "step_${NUM}_" \
                --save_examples
        fi
        done
    done
