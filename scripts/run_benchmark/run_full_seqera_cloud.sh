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
cat > /tmp/params.yaml << 'HERE'
id: spatial_decomposition_process_datasets
input_states: s3://openproblems-data/resources/task_spatial_decomposition/datasets/**/state.yaml
settings: '{"output_scores": "scores.yaml", "output_dataset_info": "dataset_info.yaml", "output_method_configs": "method_configs.yaml", "output_metric_configs": "metric_configs.yaml", "output_task_info": "task_info.yaml"}'
rename_keys: 'input_single_cell:output_single_cell;input_spatial_masked:output_spatial_masked;input_solution:output_solution'
output_state: "$id/state.yaml"
publish_dir: "$publish_dir"
HERE

tw launch https://github.com/openproblems-bio/task_spatial_decomposition.git \
  --revision build/main \
  --pull-latest \
  --main-script target/nextflow/workflows/run_benchmark/main.nf \
  --workspace 53907369739130 \
  --compute-env 5DwwhQoBi0knMSGcwThnlF \
  --params-file /tmp/params.yaml \
  --entry-name auto \
  --config common/nextflow_helpers/labels_tw.config \
  --labels task_spatial_decomposition,full