#!/bin/bash

RAW_DATA=resources_test/common
DATASET_DIR=resources_test/spatial_decomposition
echo "Running process_dataset"
nextflow run . \
    -main-script target/nextflow/workflows/process_datasets/main.nf \
    -profile docker \
    -entry auto \
    -c common/nextflow_helpers/labels_ci.config \
    --input_states "$RAW_DATA/**/state.yaml" \
    --rename_keys 'input:output_dataset' \
    --settings '{"output_spatial_masked": "$id/spatial_masked.h5ad", "output_single_cell": "$id/single_cell_ref.h5ad", "output_solution": "$id/solution.h5ad", "alpha": 1.0, "simulated_data": "$id/simulated_dataset.h5ad"}' \
    --publish_dir "$DATASET_DIR" \
    --output_state '$id/state.yaml'