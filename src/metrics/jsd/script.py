import anndata as ad
import numpy as np
from scipy.spatial.distance import jensenshannon

## VIASH START
par = {
  'input_method': 'resources_test/task_spatial_decomposition/cxg_mouse_pancreas_atlas/output.h5ad',
  'input_solution': 'resources_test/task_spatial_decomposition/cxg_mouse_pancreas_atlas/solution.h5ad',
  'output': 'score.h5ad'
}
meta = {
  'name': 'r2'
}
## VIASH END

print('Reading input files', flush=True)
input_method = ad.read_h5ad(par['input_method'])
input_solution = ad.read_h5ad(par['input_solution'])

print('Compute metrics', flush=True)
jsd = jensenshannon(input_solution.obsm['proportions_true'], input_method.obsm['proportions_pred'], axis=0)
uns_metric_ids = [ 'jsd' ]
uns_metric_values = [ np.mean(jsd) ]

print("Write output AnnData to file", flush=True)
output = ad.AnnData(
  uns={
    'dataset_id': input_method.uns['dataset_id'],
    'method_id': input_method.uns['method_id'],
    'metric_ids': uns_metric_ids,
    'metric_values': uns_metric_values
  }
)
output.write_h5ad(par['output'], compression='gzip')
