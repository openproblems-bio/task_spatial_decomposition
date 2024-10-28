import anndata as ad
import sys 
import numpy as np
import openproblems as op

## VIASH START
par = {
    "input": "resources_test/task_spatial_decomposition/cxg_mouse_pancreas_atlas/simulated_dataset.h5ad",
    "output_spatial_masked": "spatial_masked.h5ad",
    "output_single_cell": "single_cell_ref.h5ad",
    "output_solution": "solution.h5ad",
}
meta = {
    "name": "split_dataset",
    "resources_dir": "src/process_dataset/split_dataset",
    "config": "target/nextflow/process_dataset/split_dataset/.config.vsh.yaml"
}
## VIASH END

# read viash config
config = op.project.read_viash_config(meta["config"])

# import helper functions
sys.path.append(meta['resources_dir'])
from subset_h5ad_by_format import subset_h5ad_by_format

print(">> Load dataset", flush=True)
adata = ad.read_h5ad(par["input"])

# Non-integer values in the counts layer are detected as un-normalized data by some methods, thereby causing them to fail. Using floor() function to avoid this.
adata.layers['counts'] = adata.layers['counts'].floor()

print(">> Split dataset by modality", flush=True)
is_sp = adata.obs["modality"] == "sp"
adata_sp = adata[is_sp, :].copy()
adata_sc = adata[~is_sp, :].copy()

print(">> Create dataset for methods", flush=True)
output_spatial_masked = subset_h5ad_by_format(adata_sp, config, "output_spatial_masked")
output_single_cell = subset_h5ad_by_format(adata_sc, config, "output_single_cell")

print(">> Create solution object for metrics", flush=True)
output_solution = subset_h5ad_by_format(adata_sp, config, "output_solution")

print(">> Write to disk", flush=True)
output_spatial_masked.write_h5ad(par["output_spatial_masked"])
output_single_cell.write_h5ad(par["output_single_cell"])
output_solution.write_h5ad(par["output_solution"])
