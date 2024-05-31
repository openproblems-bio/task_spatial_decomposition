#!/bin/bash

viash run src/common/src/create_task_readme/config.vsh.yaml -- \
  --task "spatial_decomposition" \
  --task_dir "src/" \
  --github_url "https://github.com/openproblems-bio/task-spatial-decomposition/tree/main/" \
  --output "README.md"