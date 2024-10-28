#!/bin/bash

# get the root of the directory
REPO_ROOT=$(git rev-parse --show-toplevel)

# ensure that the command below is run from the root of the repository
cd "$REPO_ROOT"

set -e

RAW_DATA=resources_test/common
DATASET_DIR=resources_test/task_spatial_decomposition

mkdir -p $DATASET_DIR

echo "Running process_datasets"
nextflow run . \
  -main-script target/nextflow/workflows/process_datasets/main.nf \
  -profile docker \
  -entry auto \
  -c common/nextflow_helpers/labels_ci.config \
  --input_states "$RAW_DATA/cxg_mouse_pancreas_atlas/state.yaml" \
  --rename_keys 'input:output_dataset' \
  --settings '{"output_spatial_masked": "$id/spatial_masked.h5ad", "output_single_cell": "$id/single_cell_ref.h5ad", "output_solution": "$id/solution.h5ad", "alpha": 1.0, "output_simulated_data": "$id/simulated_dataset.h5ad"}' \
  --publish_dir "$DATASET_DIR" \
  --output_state '$id/state.yaml'

echo "Running method"
viash run src/methods/stereoscope/config.vsh.yaml -- \
  --input_single_cell $DATASET_DIR/cxg_mouse_pancreas_atlas/single_cell_ref.h5ad \
  --input_spatial_masked $DATASET_DIR/cxg_mouse_pancreas_atlas/spatial_masked.h5ad \
  --output $DATASET_DIR/cxg_mouse_pancreas_atlas/output.h5ad

echo "Running metric"
viash run src/metrics/r2/config.vsh.yaml -- \
  --input_method $DATASET_DIR/cxg_mouse_pancreas_atlas/output.h5ad \
  --input_solution $DATASET_DIR/cxg_mouse_pancreas_atlas/solution.h5ad \
  --output $DATASET_DIR/cxg_mouse_pancreas_atlas/score.h5ad

# only run this if you have access to the openproblems-data bucket
aws s3 sync --profile op \
  "$DATASET_DIR" s3://openproblems-data/resources_test/task_spatial_decomposition \
  --delete --dryrun