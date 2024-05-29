#!/bin/bash

# Downloading test resources
directories=("common" "spatial_decomposition")
for dir in ${directories[@]}; do 
    viash run ../openproblems-v2/src/common/sync_test_resources/config.vsh.yaml -- \
    --input "s3://openproblems-data/resources_test/$dir/cxg_mouse_pancreas_atlas" \
    --output "../task-spatial-decomposition/resources_test/$dir/cxg_mouse_pancreas_atlas"
done