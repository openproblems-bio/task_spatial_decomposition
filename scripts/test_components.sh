#!/bin/bash

# Test all components in a namespace (refer https://viash.io/reference/cli/ns_test.html)
viash ns test --parallel

component_name="my_component_name"

# Test individual components
viash test src/methods/$component_name/config.vsh.yaml
