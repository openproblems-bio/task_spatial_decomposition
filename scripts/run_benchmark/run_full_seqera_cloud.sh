#!/bin/bash

# get the root of the directory
REPO_ROOT=$(git rev-parse --show-toplevel)

# ensure that the command below is run from the root of the repository
cd "$REPO_ROOT"

set -e

# generate a unique id
RUN_ID="run_$(date +%Y-%m-%d_%H-%M-%S)"
publish_dir="s3://openproblems-data/resources/task_spatial_decomposition/results/${RUN_ID}"

# write the parameters to file
ccat > /tmp/params.yaml << 'HERE'
id: spatial_decomposition_process_datasets
input_states: s3://openproblems-data/resources/task_spatial_decomposition/datasets/**/state.yaml
settings: '{"output_spatial_masked": "$id/spatial_masked.h5ad", "output_single_cell": "$id/single_cell_ref.h5ad", "output_solution": "$id/solution.h5ad", "alpha": 1.0, "simulated_data": "$id/simulated_dataset.h5ad"}'
rename_keys: 'input:output_dataset'
output_state: "$id/state.yaml"
publish_dir: s3://openproblems-data/resources/task_spatial_decomposition/datasets
HERE

tw launch https://github.com/openproblems-bio/task_spatial_decomposition.git \
  --revision build/main \
  --pull-latest \
  --main-script target/nextflow/workflows/run_benchmark/main.nf \
  --workspace 53907369739130 \
  --compute-env 6TeIFgV5OY4pJCk8I0bfOh \
  --params-file /tmp/params.yaml \
  --entry-name auto \
  --config common/nextflow_helpers/labels_tw.config \
  --labels task_spatial_decomposition,full