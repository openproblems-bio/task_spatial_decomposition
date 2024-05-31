#!/bin/bash

# Downloading test resources
directories=("common" "spatial_decomposition")
for dir in ${directories[@]}; do 
    viash run src/common/src/sync_resources/config.vsh.yaml -- \
    --input "s3://openproblems-data/resources_test/$dir/cxg_mouse_pancreas_atlas" \
    --output "resources_test/$dir/cxg_mouse_pancreas_atlas"
done