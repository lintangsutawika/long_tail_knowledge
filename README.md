# Large Language Models Struggle to Learn Long-Tail Knowledge

This repo contains the code and data used for the analysis in [Large Language Models Struggle to Learn Long-Tail Knowledge](https://arxiv.org/abs/2211.08411)

## Pre-training Dataset Entities
As part of this project, we ran the [DBPedia Spotlight](https://www.dbpedia-spotlight.org) entity linker on large-scale LM pre-training datasets such as The Pile, C4, ROOTS, OpenWebText, and Wikipedia. The entity linking data is hosted on [HuggingFace Hub](https://huggingface.co/datasets/nkandpa2/pretraining_entities). To get this data, you can either download it from their web UI, download it with Python using the instructions from [here](https://huggingface.co/docs/huggingface_hub/how-to-downstream), or run `git clone https://huggingface.co/datasets/nkandpa2/pretraining_entities` to clone the HuggingFace repo (note that this requires git lfs to be installed to actually download the data).

### Format
There are five files:
- `the_pile_entity_map.npz`
- `c4_entity_map.npz`
- `roots_entity_map.npz`
- `openwebtext_entity_map.npz`
- `wikipedia_entity_map.npz`

Each file can be loaded with `numpy.load` and is a dictionary mapping from DBPedia URI strings to numpy arrays of pre-training dataset indices where that entity occurs.

## QA Dataset Entities
To analyze the effect of pre-training entities on QA performance, we entity link Natural Questions and Trivia QA. The QA entity linking data is hosted on [HuggingFace Hub](https://huggingface.co/datasets/nkandpa2/qa_entities). To get this data, you can either download it from their web UI, download it with Python using the instructions from [here](https://huggingface.co/docs/huggingface_hub/how-to-downstream), or run `git clone https://huggingface.co/datasets/nkandpa2/qa_entities` to clone the HuggingFace repo (note that this requires git lfs to be installed to actually download the data).

### Format
There are four files:
- `nq_train_entities.jsonl`
- `nq_validation_entities.jsonl`
- `trivia_qa_unfiltered.nocontext_train_entities.jsonl`
- `trivia_qa_unfiltered.nocontext_validation_entities.jsonl`

The Natural Questions files are in the order of the [nq_open](https://huggingface.co/datasets/nq_open) dataset and the Trivia QA files are in the order of the `unfiltered.nocontext` split of the [trivia_qa](https://huggingface.co/datasets/trivia_qa) dataset.

These are each jsonlines files. Each line in the file is a dictionary with the following structure:
```
{   
    'q_entities': <list of entities found in the question>,
    'a_entities': <list of entities found in the answer aliases>
}
```
The entities in the `q_entities` and `a_entities` lists are also dictionaries with the structure:
```
{
    'URI': <dbpedia entity URI>,
    'support': <dbpedia support>,
    'types': <dbpedia types>,
    'surfaceForm': <string in Q or A that was linked to this entity>,
    'offset': <location in Q or A where surface form is found>,
    'similarityScore': <dbpedia similarity score>,
    'percentageOfSecondRank': <dbpedia percentage of second ranked entity>
}
```
## Code
- The code and instructions for running the entity linker can be found in `entity_linking/`
- The code and instructions for running the relevant document counting heuristic can be found in `relevant_docs/`


## Pythia

With a dataset in jsonl format `{'text': ...}` from `scripts/`:
1. Use `process_linking_each_step.sh` to extract entities using DBpedia Spotlight. This will result in an `npz` file that is needed for the next step.
2. Run `process_count_each_step.sh` to return a file that connects entities sampled to each trivia_qa sample.

Notes: The scripts above is meant to process each step from the Pythia training data. This can be modified to run on any range or an entire dataset like the original paper.

## Setting Up DBPediaSpotlight

An alternative to setup DBpedia endpoint for entity detection. You can run multiple server with different port value for faster processing.

```
# download main jar
wget https://repo1.maven.org/maven2/org/dbpedia/spotlight/rest/1.1/rest-1.1-jar-with-dependencies.jar
# download latest model (last checked on 10/10/2022) (assuming en model)
wget -O en.tar.gz http://downloads.dbpedia.org/repo/dbpedia/spotlight/spotlight-model/2022.03.01/spotlight-model_lang=en.tar.gz
# extract model
tar xzf en.tar.gz
# install java
sudo apt install default-jre
# run server
java -Xmx8G -jar rest-1.1-jar-with-dependencies.jar en http://localhost:2222/res

# then can access API:
curl http://localhost:2222/rest/annotate \
 --data-urlencode "text=President Obama called Wednesday on Congress to extend a tax break for students included in last year's economic stimulus package, arguing that the policy provides more generous assistance." \
 --data "confidence=0.35" \
 -H "Accept: text/turtle"
```