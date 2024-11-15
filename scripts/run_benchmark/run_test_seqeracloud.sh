
#!/bin/bash

# get the root of the directory
REPO_ROOT=$(git rev-parse --show-toplevel)

# ensure that the command below is run from the root of the repository
cd "$REPO_ROOT"

set -e

resources_test_s3=s3://openproblems-data/resources_test/task_spatial_decomposition
publish_dir_s3="s3://openproblems-nextflow/temp/results/$(date +%Y-%m-%d_%H-%M-%S)"

# write the parameters to file
cat > /tmp/params.yaml << HERE
input_states: $resources_test_s3/mouse_brain_coronal/state.yaml
rename_keys: 'input_single_cell:output_single_cell;input_spatial_masked:output_spatial_masked;input_solution:output_solution'
output_state: "state.yaml"
publish_dir: $publish_dir_s3
settings: '{"output_scores": "scores.yaml", "output_dataset_info": "dataset_info.yaml", "output_method_configs": "method_configs.yaml", "output_metric_configs": "metric_configs.yaml", "output_task_info": "task_info.yaml"}'
HERE

tw launch https://github.com/openproblems-bio/task_spatially_variable_genes.git \
  --revision build/main \
  --pull-latest \
  --main-script target/nextflow/workflows/run_benchmark/main.nf \
  --workspace 53907369739130 \
  --compute-env 5DwwhQoBi0knMSGcwThnlF \
  --params-file /tmp/params.yaml \
  --entry-name auto \
  --config common/nextflow_helpers/labels_tw.config \
  --labels task_spatially_variable_genes,test
