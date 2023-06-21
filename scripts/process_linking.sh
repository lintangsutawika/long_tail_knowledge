export FILE_PATH="/fsx/lintangsutawika/01-project-pythia/data/"

# python count_relevant_docs.py  \
#                               {$PATH}entity-each-step/step_{}_json_entity_map.npz \
#                               {$PATH}"co-occurance-each-step/" \
#                               --qa_split {$PATH}"trivia_qa/trivia_qa_unfiltered.nocontext_train_entities.jsonl" \
#                               --type qa_co_occurrence
#                               --save_examples

# for NUM in {0..143000}
for NUM in {0..1430}
do
    python link_pretraining_data.py "${FILE_PATH}entity-each-step/" \
                                    --dataset json \
                                    --wikipedia_path "${FILE_PATH}detokenized-each-step/detokenized_step_${NUM}.jsonl" \
                                    --nprocs 8 \
                                    --confidence 0.4 \
                                    --support 20 \
                                    --output_prefix "step_${NUM}_" &
done

# N=128
# (
# for thing in a b c d e f g; do 
#    ((i=i%N)); ((i++==0)) && wait
#    task "$thing" & 
# done
# )