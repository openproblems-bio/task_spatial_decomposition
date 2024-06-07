#!/bin/bash

# Process dataset
RAW_DATA=resources_test/common
DATASET_DIR=resources_test/spatial_decomposition
echo "Running process_dataset"
nextflow run . \
    -main-script target/nextflow/workflows/process_datasets/main.nf \
    -profile docker \
    -entry auto \
    -c src/common/src/nextflow_helpers/labels_ci.config \
    --input_states "$RAW_DATA/**/state.yaml" \
    --rename_keys 'input:output_dataset' \
    --settings '{"output_spatial_masked": "$id/spatial_masked.h5ad", "output_single_cell": "$id/single_cell_ref.h5ad", "output_solution": "$id/solution.h5ad", "alpha": 1.0, "simulated_data": "$id/dataset_simulated.h5ad"}' \
    --publish_dir "$DATASET_DIR" \
    --output_state '$id/state.yaml'

# Run benchmark
DATASETS_DIR="resources_test/spatial_decomposition"
OUTPUT_DIR="output/temp"
if [ ! -d "$OUTPUT_DIR" ]; then
  mkdir -p "$OUTPUT_DIR"
fi
echo "Running the benchmark"
nextflow run . \
  -main-script target/nextflow/workflows/run_benchmark/main.nf \
  -profile docker \
  -resume \
  -entry auto \
  -c src/common/nextflow_helpers/labels_ci.config \
  --input_states "$DATASETS_DIR/**/state.yaml" \
  --rename_keys 'input_single_cell:output_single_cell,input_spatial_masked:output_spatial_masked,input_solution:output_solution' \
  --settings '{"output_scores": "scores.yaml", "output_dataset_info": "dataset_info.yaml", "output_method_configs": "method_configs.yaml", "output_metric_configs": "metric_configs.yaml", "output_task_info": "task_info.yaml"}' \
  --publish_dir "$OUTPUT_DIR" \
  --output_state "state.yaml"