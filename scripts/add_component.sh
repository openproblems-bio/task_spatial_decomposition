#!/bin/bash

echo "This script is not supposed to be run directly."
echo "Please run the script step-by-step."
exit 1

# create a new component (types: method, metric, control_method)
type="method"
lang="python" # change this to "r" if need be

common/create_component/create_component \
  --task spatial_decomposition \
  --type $type \
  --name component_name \
  --language $lang

# TODO: fill in required fields in src/methods/foo/config.vsh.yaml
# TODO: edit src/methods/foo/script.py/R

# test the component
viash test src/$type/component_name/config.vsh.yaml
