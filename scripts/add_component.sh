#!/bin/bash

echo "This script is not supposed to be run directly."
echo "Please run the script step-by-step."
exit 1

# create a new component (types: method, metric, control_method)
type="method"
lang="python" # change this to "r" if need be

viash run ../openproblems-v2/src/common/create_component/config.vsh.yaml -- \
  --task label_projection \
  --type $type \
  --name component_name \
  --language $lang

# TODO: fill in required fields in src/methods/foo/config.vsh.yaml
# TODO: edit src/methods/foo/script.py/R

# test the component
viash test src/$type/component_name/config.vsh.yaml
