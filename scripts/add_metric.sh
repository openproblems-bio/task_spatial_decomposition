#!/bin/bash

task_name="spatial_decomposition"
component_name="my_metric"
component_lang="python" # change this to "r" if need be

common/create_component/create_component \
  --task $task_name \
  --language "$component_lang" \
  --name "$component_name" \
  --api_file src/api/comp_metric.yaml \
  --output "src/metrics/$component_name"