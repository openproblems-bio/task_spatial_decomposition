#!/bin/bash

# Build all components in namespace
viash ns build --parallel --setup cb

# Building the common components if the openproblems-v2 repositpry is also cloned beside the current repository
cd ../openproblems-v2/
viash ns build -q common -t ../task-spatial-decomposition/target/
cd ../task-spatial-decomposition/