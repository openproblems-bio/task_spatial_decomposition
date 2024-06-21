#!/bin/bash

# Test all components in a namespace (refer https://viash.io/reference/cli/ns_test.html)
viash ns test --parallel

# Test individual components
viash test src/methods/nnls/config.vsh.yaml


DATASET_DIR=resources_test/spatial_decomposition

# run one method
viash run src/methods/nnls/config.vsh.yaml -- \
    --input_single_cell $DATASET_DIR/cxg_mouse_pancreas_atlas/single_cell_ref.h5ad \
    --input_spatial_masked $DATASET_DIR/cxg_mouse_pancreas_atlas/spatial_masked.h5ad \
    --output $DATASET_DIR/cxg_mouse_pancreas_atlas/output.h5ad

# run one metric
viash run src/metrics/r2/config.vsh.yaml -- \
    --input_method $DATASET_DIR/cxg_mouse_pancreas_atlas/output.h5ad \
    --input_solution $DATASET_DIR/cxg_mouse_pancreas_atlas/solution.h5ad \
    --output $DATASET_DIR/cxg_mouse_pancreas_atlas/score.h5ad
