export FILE_PATH=...

IDX=$1
START_IDX=$((715*($IDX-1)))
END_IDX=$(((715*$IDX)-1))
for NUM in $(eval echo "{$START_IDX..$END_IDX}")
do
FILE_NAME="${FILE_PATH}entity-each-step/step_${NUM}_json_entity_map.npz"
if [ -f $FILE_NAME ]; then
    echo "exists ${FILE_NAME}"
else
    echo "dont ${FILE_NAME}"
    python entitiy_linking/link_pretraining_data.py "${FILE_PATH}entity-each-step/" \
        --dataset json \
        --wikipedia_path "${FILE_PATH}detokenized-each-step/detokenized_step_${NUM}.jsonl" \
        --nprocs 96 \
        --spotlight_ports 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015 2016 2017 2018 2019 2020 2021 2022 2023 2024 2025 2026 2027 2028 2029 2030 2031 2032 2033 2034 2035 2036 2037 2038 2039 2040 2041 2042 2043 2044 2045 2046 2047 2048 \
        --confidence 0.35 \
        --support 20 \
        --output_prefix "step_${NUM}_"
fi
done
