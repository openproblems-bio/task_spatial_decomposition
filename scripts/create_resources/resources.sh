#!/bin/bash

# get the root of the directory
REPO_ROOT=$(git rev-parse --show-toplevel)

# ensure that the command below is run from the root of the repository
cd "$REPO_ROOT"

# Simulating spot-resolution spatial data with alpha = 1
cat > /tmp/params.yaml << 'HERE'
param_list:
  - id: spatial_decomposition_process_datasets_cellxgene_census
    input_states: s3://openproblems-data/resources/datasets/cellxgene_census/**/log_cp10k/state.yaml
  - id: spatial_decomposition_process_datasets_openproblems_v1
    input_states: s3://openproblems-data/resources/datasets/openproblems_v1/**/log_cp10k/state.yaml

settings: '{"output_spatial_masked": "$id/spatial_masked.h5ad", "output_single_cell": "$id/single_cell_ref.h5ad", "output_solution": "$id/solution.h5ad", "alpha": 1.0, "output_simulated_data": "$id/simulated_dataset.h5ad"}'
rename_keys: 'input:output_dataset'
output_state: "$id/state.yaml"
publish_dir: s3://openproblems-data/resources/task_spatial_decomposition/datasets
HERE

tw launch https://github.com/openproblems-bio/task_spatial_decomposition.git \
  --revision build/main \
  --pull-latest \
  --main-script target/nextflow/workflows/process_datasets/main.nf \
  --workspace 53907369739130 \
  --compute-env 5DwwhQoBi0knMSGcwThnlF \
  --params-file /tmp/params.yaml \
  --entry-name auto \
  --config common/nextflow_helpers/labels_tw.config \
  --labels task_spatial_decomposition,process_datasets
