#!/bin/bash

DATASETS_DIR="resources/pancreas"
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
  -c common/nextflow_helpers/labels_ci.config \
  --input_states "$DATASETS_DIR/state.yaml" \
  --rename_keys 'input_single_cell:output_single_cell;input_spatial_masked:output_spatial_masked;input_solution:output_solution' \
  --settings '{"output_scores": "scores.yaml", "output_dataset_info": "dataset_info.yaml", "output_method_configs": "method_configs.yaml", "output_metric_configs": "metric_configs.yaml", "output_task_info": "task_info.yaml"}' \
  --publish_dir "$OUTPUT_DIR" \
  --output_state "state.yaml"