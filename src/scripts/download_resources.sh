#!/bin/bash

# Downloading test resources
directories=("common" "spatial_decomposition")
for dir in ${directories[@]}; do 
    src/common/sync_resources/sync_resources \
        --input "s3://openproblems-data/resources_test/$dir/cxg_mouse_pancreas_atlas" \
        --output "resources_test/$dir/cxg_mouse_pancreas_atlas"
done